puts "Gebe den Namen der .txt-Datei einer Gruppe an (z.B. superstar4.txt)"
file = gets.chomp
$List = File.open(file).read.force_encoding("UTF-8").split("\n")

def isYfollowingZ(y, z)
    i = 1
    follows = false
    while i < $List.length do
        firstName = $List[i].split(" ")[0]
        secondName = $List[i].split(" ")[1]
        if firstName == y and secondName == z 
            follows = true
        end
        i += 1
    end
    return follows
end

requests = 0
membersOfGroup = Array.new
membersOfGroup = $List[0].split(" ")
puts "Die Gruppe besteht aus #{membersOfGroup.length} Mitgliedern.\n\n"
possibleSuperstars = Array.new
possibleSuperstars = membersOfGroup.dup
followingList = Array.new(membersOfGroup.length)
i = 0
while i < membersOfGroup.length
    followingList[i] = Array.new(membersOfGroup.length, nil)
    i += 1
end

while possibleSuperstars.length > 1 do
    if isYfollowingZ(possibleSuperstars[0], possibleSuperstars[1])
        followingList[membersOfGroup.index(possibleSuperstars[0])][membersOfGroup.index(possibleSuperstars[1])] = true
        puts "Anfrage: Folgt #{possibleSuperstars[0]} #{possibleSuperstars[1]}?\nAntwort: True\n\n"
        possibleSuperstars.delete_at(0)
        possibleSuperstars.push(possibleSuperstars.shift)
    else
        followingList[membersOfGroup.index(possibleSuperstars[0])][membersOfGroup.index(possibleSuperstars[1])] = false
        puts "Anfrage: Folgt #{possibleSuperstars[0]} #{possibleSuperstars[1]}?\nAntwort: False\n\n"
        possibleSuperstars.push(possibleSuperstars.shift)
        possibleSuperstars.delete_at(0)
    end
    requests += 1
end

puts "Lediglich #{possibleSuperstars[0]} könnte der Superstar der Gruppe sein. Bisher wurden #{requests} Anfragen gestellt. Es ist möglich, dass die Gruppe keinen Superstar hat. Soll kontrolliert werden, ob #{possibleSuperstars[0]} wirklich ein Superstar ist? (ja / beliebige andere Eingabe)"
x = gets.chomp.downcase
if x == "ja"
    indexOfPossibleStar = membersOfGroup.index(possibleSuperstars[0])
    canBeAStar = true
    i = 0
    while i < membersOfGroup.length and canBeAStar do
        if not membersOfGroup[i] == possibleSuperstars[0]
            if followingList[indexOfPossibleStar][i] == nil
                if isYfollowingZ(possibleSuperstars[0], membersOfGroup[i])
                    canBeAStar = false
                    puts "Anfrage: Folgt #{possibleSuperstars[0]} #{membersOfGroup[i]}?\nAntwort: True\n\n"
                else
                    puts "Anfrage: Folgt #{possibleSuperstars[0]} #{membersOfGroup[i]}?\nAntwort: False\n\n"
                end
                requests += 1
            end
            if followingList[i][indexOfPossibleStar] == nil
                if not isYfollowingZ(membersOfGroup[i], possibleSuperstars[0])
                    canBeAStar = false
                    puts "Anfrage: Folgt #{membersOfGroup[i]} #{possibleSuperstars[0]}?\nAntwort: False\n\n"
                else
                    puts "Anfrage: Folgt #{membersOfGroup[i]} #{possibleSuperstars[0]}?\nAntwort: True\n\n"
                end
                requests += 1
            end
        end
        i += 1
    end
    if canBeAStar
        puts "#{possibleSuperstars[0]} ist mit Gewissheit ein Superstar! Es wurden insgesamt #{requests} Anfragen benötigt, um dies herauszufinden."
    else
        puts "#{possibleSuperstars[0]} ist kein Superstar. Die Gruppe scheint keinen Superstar zu haben. Es wurden #{requests} Anfragen gestellt."
    end
else
    puts "Superstar Suche beendet ..."
end
