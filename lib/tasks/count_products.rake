namespace :products do
  desc "Count Products"
  task count: :environment do
    count = Product.count
    puts "Products #{count} items"
  end
end
