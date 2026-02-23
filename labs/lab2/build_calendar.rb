require 'date'
input_file = ARGV[0]
start_str = ARGV[1]
end_str = ARGV[2]
output_file = ARGV[3]
if ARGV.length < 4
  puts "Ошибка! Использование: ruby build_calendar.rb <файл_команд> <дата_начала> <дата_конца> <выходной_файл>"
  exit
end
team_names = []
File.readlines(input_file, encoding: 'utf-8').each do |line|
  name_part = line.split(" — ").first
  team_name = name_part.split(". ").last
  team_names << team_name
end
puts team_names
games = team_names.combination(2).to_a
puts games

start_date = Date.strptime(start_str, '%d.%m.%Y')
end_date   = Date.strptime(end_str, '%d.%m.%Y')

times = ["12:00", "15:00", "18:00"]
calendar = {}

(start_date..end_date).each do |date|
  if date.friday? || date.saturday? || date.sunday?
    times.each do |time|
      key = "#{date.strftime('%d.%m.%Y')} #{time}"
      calendar[key] = [] 
    end
  end
end

slot_keys = calendar.keys

#Счетчик текущего слота
current_slot_index = 0

#Проходим по всем парам игр
games.each_slice(2) do |pair_of_games|
  if current_slot_index >= slot_keys.length
    puts "Внимание: не хватило дат для всех игр!"
    break
  end

  current_key = slot_keys[current_slot_index]
  
  calendar[current_key] = pair_of_games
  
  current_slot_index += 1
end

File.open(output_file, 'w:utf-8') do |file|
  calendar.each do |datetime, matches|
    next if matches.empty? # Пропускаем пустые слоты, если игр меньше чем дат
    
    matches.each do |game|
      file.puts "#{datetime}: #{game[0]} — #{game[1]}"
    end
  end
end

puts "Календарь успешно сформирован в файле #{output_file}"