# in repo root, run:
# rails runner db/export_points_to_old_db.rb

require 'json'

filepath_points = "../tosdr-build/src/points/"

puts "Exporting points..."
Point.all.each do |point|
  puts point.to_json
  puts point.service.to_json
  if (point.oldId.nil?) then 
    point['oldId'] = point.id.to_s
  end
  puts point.to_json
  filename = point.id.to_s + '.json'
  begin
    file = File.read(filepath_points + filename)
    data = JSON.parse(file)
  rescue
    begin
      filename = point.oldId + '-' + point.service.slug + '.json'
      file = File.read(filepath_points + filename)
      data = JSON.parse(file)
    rescue
      begin
        filename = point.oldId + '.json'
        file = File.read(filepath_points + filename)
        data = JSON.parse(file)
      rescue
        data = {}
        data['tosdr'] = {}
        puts 'new file ' + filename
      end
    end
  end
  data['id'] = point.oldId
  data['title'] = point.title
  data['tosdr']['tldr'] = point.analysis
  # data['tosdr']['tmp_rating'] = point.rating
  if (data['services'].nil?) then
    data['services'] = [ point.service.slug ]
  end

  puts "Writing " + filepath_points + filename
  File.write(filepath_points + filename, JSON.pretty_unparse(data))
end
puts "Finishing exporting points"
puts "Done!"
