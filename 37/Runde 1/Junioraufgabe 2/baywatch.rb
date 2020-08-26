puts "Gebe den Namen einer .txt-Datei mit Landzungenlisten ein (z.B. baywatch6.txt)"
file = gets.chomp
lists = File.open(file).read.force_encoding("UTF-8").split("\n")
list1 = lists[0].split(" ")
list2 = lists[1].split(" ")
i = 0
a = 0
searching = true
finalList = ""
while i < list1.length && searching do
    matches = true
	while a < list1.length do
	    if not list1[a] == list2[a]
		    if not list2[a] == "?"
			    matches = false
			end
		end
		finalList = finalList + list1[a].to_s + " "
		a = a + 1
	end
	a = 0
	if matches
	    puts "Vollständige Liste mit unbekannten Startpunkt:\n" + lists[0].to_s + "\nUnvollständige Liste mit Startpunkt im Norden:\n" + lists[1].to_s + "\nVollständige Liste mit Startpunkt im Norden:\n" + finalList
		finalList.gsub!("1", "Wald")
		finalList.gsub!("2", "Wiese")
		finalList.gsub!("3", "Häuser")
		finalList.gsub!("4", "Wüste")
		finalList.gsub!("5", "See")
		finalList.gsub!("6", "Sumpf")
		finalList.gsub!("7", "Reisfeld")
		finalList.gsub!("8", "Berg")
		finalList.gsub!("9", "Vulkankrater")
		puts "\nVollständige Liste mit Startpunkt im Norden und Ortsbezeichnungen statt Zahlen:\n" + finalList
	    searching = false
	else
	    list1.push(list1.shift)
		finalList = ""
	end
	i = i + 1
end
if finalList == ""
    puts "Die Listen haben keine Übereinstimmungen. Eine der Listen scheint fehlerhaft zu sein."
end