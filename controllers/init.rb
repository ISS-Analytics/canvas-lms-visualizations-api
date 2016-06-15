Dir.glob('controllers/**/*.rb').each do |file|
  require_relative "../#{file}" unless "#{file}" == 'controllers/init.rb'
end
