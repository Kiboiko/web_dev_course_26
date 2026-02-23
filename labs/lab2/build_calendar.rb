team_names = []

File.readlines("teams.txt", encoding: 'utf-8').each do |line|
  name_part = line.split(" — ").first
  team_name = name_part.split(". ").last
  team_names << team_name
end
puts team_names
games = team_names.combination(2).to_a
puts games