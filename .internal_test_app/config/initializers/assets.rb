# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('node_modules/openseadragon/build/openseadragon/images')
Rails.application.config.assets.paths << Rails.root.join('node_modules/openseadragon/build/openseadragon')

Rails.application.config.assets.precompile += %w( application_modern.css )

# Make the openseadragon 0.9 gem assests load correctly in this version of spotlight.
# Find the images directory from the osd gem
openseadragon_images_dir = File.join(Gem.loaded_specs.fetch('openseadragon').full_gem_path, 'vendor/assets/images')
# Precompile the PNGs
Rails.application.config.assets.precompile += Dir.glob('openseadragon/*.png', base: openseadragon_images_dir)
