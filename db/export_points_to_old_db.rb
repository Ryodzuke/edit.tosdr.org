# in repo root, run:
# rails runner db/export_points_to_old_db.rb

require 'json'

filepath_points = "old_db/points/"
counter = Date.today.to_time.to_i * 1000

puts "Exporting points..."
Point.all.each do |point|
  puts point.to_json
  puts point.service.to_json
  if (point.oldId.nil?) then 
    puts 'yes!'
    puts counter
    puts point.to_json
    point.oldId = counter
    counter = counter + 1
  end
  filename = point.oldId + '.json'
  File.write(filepath_points + filename, JSON.pretty_unparse({
    id: point.oldId,
    title: point.title,
    tosdr: {
      tldr: point.analysis,
      tmp_rating: point.rating
    },
    services: [
      point.service.slug
    ]
  }))
end
puts "Finishing exporting points"
puts "Done!"
