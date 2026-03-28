require 'logger'
require 'socket'
require 'openssl'

# SolarWinds Observability (Papertrail) へRFC 5424形式でログを転送するカスタムLogger
# 環境変数 PAPERTRAIL_TOKEN を Heroku Config Vars に設定すること
class SolarWindsLogger < Logger
  HOST     = 'syslog.collector.na-01.cloud.solarwinds.com'
  PORT     = 6514
  FACILITY = 16 # local0

  SEVERITY_MAP = {
    'DEBUG' => 7,
    'INFO'  => 6,
    'WARN'  => 4,
    'ERROR' => 3,
    'FATAL' => 2,
    'ANY'   => 6
  }.freeze

  def initialize(token:, program: 'rails')
    @token    = token
    @program  = program
    @hostname = ENV.fetch('DYNO', Socket.gethostname)
    @mutex    = Mutex.new
    super(nil)
  end

  def add(severity, message = nil, progname = nil)
    severity ||= UNKNOWN
    return true if severity < level

    message = progname if message.nil?
    message = yield if message.nil? && block_given?

    send_log(format_severity(severity), message.to_s)
    true
  end

  private

  def send_log(severity_str, message)
    pri       = FACILITY * 8 + (SEVERITY_MAP[severity_str] || 6)
    timestamp = Time.now.utc.strftime('%Y-%m-%dT%H:%M:%S.%6NZ')
    packet    = "<%d>1 %s %s %s - - [%s@41058] %s\n" % [
      pri, timestamp, @hostname, @program, @token, message.strip
    ]

    @mutex.synchronize { connection.write(packet) }
  rescue => e
    @socket = nil
    $stderr.puts "[SolarWindsLogger] Error: #{e.message}"
  end

  def connection
    @socket ||= begin
      tcp = TCPSocket.new(HOST, PORT)
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.verify_mode = OpenSSL::SSL::VERIFY_PEER
      ssl = OpenSSL::SSL::SSLSocket.new(tcp, ctx)
      ssl.connect
      ssl
    end
  end
end
