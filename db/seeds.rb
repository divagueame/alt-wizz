require 'faker'
# Path to the folder containing images
image_folder = Rails.root.join('db', 'seed_images')

# Ensure the folder exists
unless Dir.exist?(image_folder)
  puts "Image folder not found: #{image_folder}"
  exit
end

Dir[image_folder.join('*')].each do |image_path|
  Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    alt: Faker::Lorem.sentence(word_count: 3),
    created_at: Time.now,
    updated_at: Time.now,
    image: File.open(image_path) # Attach the image in order
  )
end
