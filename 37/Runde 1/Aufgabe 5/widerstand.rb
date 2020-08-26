puts "Gebe den Namen einer .txt-Datei mit vorhandenen Widerständen ein (z.B. widerstaende.txt)"
file = gets.chomp
$resistances = File.open(file).read.force_encoding("UTF-8").split("\n")
puts "Gebe den gesuchten Widerstandswert in Ω ein: "
$neededOhm = gets
puts "Gebe die maximal zu verwendenden Widerstände an (k = 1, ..., 4):"
k = gets
$neededOhm = $neededOhm.to_f
k = k.to_f
if k > 4.0
    k = 4.0
end
if k < 1.0
    k = 1.0
end

def seriell(r)
    i = 0
    newOhm = 0.0
    while i < r.length do
        newOhm += r[i]
        i += 1
    end
    return newOhm
end

def parallel(r)
    i = 0
    newOhm = 0.0
    while i < r.length do
        newOhm += 1.0 / r[i]
        i += 1
    end
    newOhm = 1.0 / newOhm
    return newOhm
end

def k4
    a = 0
    b = 0
    c = 0
    d = 0
    k4List1 = Array.new
    k4List2 = Array.new
    k4List3 = Array.new
    k4List4 = Array.new
    k4List5 = Array.new
    k4List6 = Array.new
    k4List7 = Array.new
    k4List8 = Array.new
    k4List9 = Array.new
    k4List = Array.new
    firstResistanceList = Array.new
    secondResistanceList = Array.new
    thirdResistanceList = Array.new
    fourthResistanceList = Array.new
    
    while a < $resistances.length do
        b = 0
        while b < $resistances.length do
            c = 0
            while c < $resistances.length do
                d = 0
                while d < $resistances.length do
                    if not a == b and not a == c and not a == d and not b == c and not b == d and not c == d
                        distance = seriell([$resistances[a].to_f, $resistances[b].to_f, $resistances[c].to_f, $resistances[d].to_f]) - $neededOhm
                        if distance < 0
                            distance = -distance
                        end
                        k4List1.push(distance)
                
                        distance = seriell([$resistances[a].to_f, $resistances[b].to_f, parallel([$resistances[c].to_f, $resistances[d].to_f])]) - $neededOhm
                        if distance < 0
                            distance = -distance
                        end
                        k4List2.push(distance)
                
                        distance = seriell([parallel([$resistances[a].to_f, $resistances[b].to_f]), parallel([$resistances[c].to_f, $resistances[d].to_f])]) - $neededOhm
                        if distance < 0
                            distance = -distance
                        end
                        k4List3.push(distance)
                    
                        distance = seriell([$resistances[a].to_f, parallel([$resistances[b].to_f, $resistances[c].to_f, $resistances[d].to_f])]) - $neededOhm
                        if distance < 0
                            distance = -distance
                        end
                        k4List4.push(distance)
                    
                        distance = parallel([$resistances[a].to_f, $resistances[b].to_f, $resistances[c].to_f, $resistances[d].to_f]) - $neededOhm
                        if distance < 0
                            distance = -distance
                        end
                        k4List5.push(distance)
                    
                        distance = parallel([$resistances[a].to_f, seriell([$resistances[b].to_f, $resistances[c].to_f, $resistances[d].to_f])]) - $neededOhm
                        if distance < 0
                            distance = -distance
                        end
                        k4List6.push(distance)
                    
                        distance = parallel([seriell([$resistances[a].to_f, $resistances[b].to_f]), seriell([$resistances[c].to_f, $resistances[d].to_f])]) - $neededOhm
                        if distance < 0
                            distance = -distance
                        end
                        k4List7.push(distance)
                    
                        distance = parallel([seriell([$resistances[a].to_f, parallel([$resistances[b].to_f, $resistances[c].to_f])]), $resistances[d].to_f]) - $neededOhm
                        if distance < 0
                        distance = -distance
                        end
                        k4List8.push(distance)
                    
                        distance = parallel([$resistances[a].to_f, $resistances[b].to_f, seriell([$resistances[c].to_f, $resistances[d].to_f])]) - $neededOhm
                        if distance < 0
                            distance = -distance
                        end
                        k4List9.push(distance)
                    
                        firstResistanceList.push(a)
                        secondResistanceList.push(b)
                        thirdResistanceList.push(c)
                        fourthResistanceList.push(d)
                    end
                    d += 1
                end
                c += 1
            end
            b += 1
        end
        a += 1
    end
    
    minInList = k4List1.min
    while not k4List1.index(minInList) == nil do
        indexOfMin = k4List1.index(minInList)
        k4List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], fourthResistanceList[indexOfMin], 1, k4List1.min])
        k4List1[indexOfMin] = minInList + 1
    end

    minInList = k4List2.min
    while not k4List2.index(minInList) == nil do
        indexOfMin = k4List2.index(minInList)
        k4List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], fourthResistanceList[indexOfMin], 2, k4List2.min])
        k4List2[indexOfMin] = minInList + 1
    end

    minInList = k4List3.min
    while not k4List3.index(minInList) == nil do
        indexOfMin = k4List3.index(minInList)
        k4List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], fourthResistanceList[indexOfMin], 3, k4List3.min])
        k4List3[indexOfMin] = minInList + 1
    end

    minInList = k4List4.min
    while not k4List4.index(minInList) == nil do
        indexOfMin = k4List4.index(minInList)
        k4List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], fourthResistanceList[indexOfMin], 4, k4List4.min])
        k4List4[indexOfMin] = minInList + 1
    end
    
    minInList = k4List5.min
    while not k4List5.index(minInList) == nil do
        indexOfMin = k4List5.index(minInList)
        k4List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], fourthResistanceList[indexOfMin], 5, k4List5.min])
        k4List5[indexOfMin] = minInList + 1
    end
    
    minInList = k4List6.min
    while not k4List6.index(minInList) == nil do
        indexOfMin = k4List6.index(minInList)
        k4List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], fourthResistanceList[indexOfMin], 6, k4List6.min])
        k4List6[indexOfMin] = minInList + 1
    end
    
    minInList = k4List7.min
    while not k4List7.index(minInList) == nil do
        indexOfMin = k4List7.index(minInList)
        k4List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], fourthResistanceList[indexOfMin], 7, k4List7.min])
        k4List7[indexOfMin] = minInList + 1
    end
    
    minInList = k4List8.min
    while not k4List8.index(minInList) == nil do
        indexOfMin = k4List8.index(minInList)
        k4List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], fourthResistanceList[indexOfMin], 8, k4List8.min])
        k4List8[indexOfMin] = minInList + 1
    end
    
    minInList = k4List9.min
    while not k4List9.index(minInList) == nil do
        indexOfMin = k4List9.index(minInList)
        k4List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], fourthResistanceList[indexOfMin], 9, k4List9.min])
        k4List9[indexOfMin] = minInList + 1
    end
        
    return k4List
end

def k3
    a = 0
    b = 0
    c = 0
    k3List1 = Array.new
    k3List2 = Array.new
    k3List3 = Array.new
    k3List4 = Array.new
    k3List = Array.new
    firstResistanceList = Array.new
    secondResistanceList = Array.new
    thirdResistanceList = Array.new
    
    while a < $resistances.length do
        b = 0
        while b < $resistances.length do
            c = 0
            while c < $resistances.length do
                if not a == b and not a == c and not b == c
                    
                    distance = seriell([$resistances[a].to_f, $resistances[b].to_f, $resistances[c].to_f]) - $neededOhm
                    if distance < 0
                        distance = -distance
                    end
                    k3List1.push(distance)
                
                    distance = seriell([$resistances[a].to_f, parallel([$resistances[b].to_f, $resistances[c].to_f])]) - $neededOhm
                    if distance < 0
                        distance = -distance
                    end
                    k3List2.push(distance)
                
                    distance = parallel([$resistances[a].to_f, $resistances[b].to_f, $resistances[c].to_f]) - $neededOhm
                    if distance < 0
                        distance = -distance
                    end
                    k3List3.push(distance)
                    
                    distance = parallel([$resistances[a].to_f, seriell([$resistances[b].to_f, $resistances[c].to_f])]) - $neededOhm
                    if distance < 0
                        distance = -distance
                    end
                    k3List4.push(distance)
                
                    firstResistanceList.push(a)
                    secondResistanceList.push(b)
                    thirdResistanceList.push(c)
                end
                c += 1
            end
            b += 1
        end
        a += 1
    end
    
    minInList = k3List1.min
    while not k3List1.index(minInList) == nil do
        indexOfMin = k3List1.index(minInList)
        k3List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], 1, k3List1.min])
        k3List1[indexOfMin] = minInList + 1
    end
    
    minInList = k3List2.min
    while not k3List2.index(minInList) == nil do
        indexOfMin = k3List2.index(minInList)
        k3List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], 2, k3List2.min])
        k3List2[indexOfMin] = minInList + 1
    end
    
    minInList = k3List3.min
    while not k3List3.index(minInList) == nil do
        indexOfMin = k3List3.index(minInList)
        k3List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], 3, k3List3.min])
        k3List3[indexOfMin] = minInList + 1
    end
    
    minInList = k3List4.min
    while not k3List4.index(minInList) == nil do
        indexOfMin = k3List4.index(minInList)
        k3List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], thirdResistanceList[indexOfMin], 4, k3List4.min])
        k3List4[indexOfMin] = minInList + 1
    end
    
    return k3List
end

def k2
    a = 0
    b = 0
    k2List1 = Array.new
    k2List2 = Array.new
    k2List = Array.new
    firstResistanceList = Array.new
    secondResistanceList = Array.new
    
    while a < $resistances.length do
        b = 0
        while b < $resistances.length do
            if not a == b
                distance = seriell([$resistances[a].to_f, $resistances[b].to_f]) - $neededOhm
                if distance < 0
                    distance = -distance
                end
                k2List1.push(distance)
                distance = parallel([$resistances[a].to_f, $resistances[b].to_f]) - $neededOhm
                if distance < 0
                    distance = -distance
                end
                k2List2.push(distance)
            
                firstResistanceList.push(a)
                secondResistanceList.push(b)
            end
            b += 1
        end
        a += 1
    end
    
    minInList = k2List1.min
    while not k2List1.index(minInList) == nil do
        indexOfMin = k2List1.index(minInList)
        k2List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], 1, k2List1.min])
        k2List1[indexOfMin] = minInList + 1
    end
    
    minInList = k2List2.min
    while not k2List2.index(minInList) == nil do
        indexOfMin = k2List2.index(minInList)
        k2List.push([firstResistanceList[indexOfMin], secondResistanceList[indexOfMin], 2, k2List2.min])
        k2List2[indexOfMin] = minInList + 1
    end
    
    return k2List
end

def k1
    i = 0
    k1List1 = Array.new
    k1List = Array.new
    while i < $resistances.length do
        distance = $resistances[i].to_f - $neededOhm
        if distance < 0
            distance = -distance
        end
        k1List1.push(distance)
        i += 1
    end
    
    minInList = k1List1.min
    while not k1List1.index(minInList) == nil do
        indexOfMin = k1List1.index(minInList)
        k1List.push([indexOfMin, 1, k1List1.min])
        k1List1[indexOfMin] = minInList + 1
    end
    
    return k1List
end

outputList = Array.new
ListForK1 = k1
min = ListForK1[0][2].to_f + 1.0

i = 0
while i < ListForK1.length do
    if ListForK1[i][2].to_f < min
        min = ListForK1[i][2].to_f
        outputList.clear
        outputList.push(ListForK1[i])
    elsif ListForK1[i][2].to_f == min
        outputList.push(ListForK1[i])
    end
    i += 1
end
if k >= 2
    ListForK2 = k2
    
    i = 0
    while i < ListForK2.length do
        if ListForK2[i][3].to_f < min
            min = ListForK2[i][3].to_f
            outputList.clear
            outputList.push(ListForK2[i])
        elsif ListForK2[i][3].to_f == min
            outputList.push(ListForK2[i])
        end
        i += 1
    end
end
if k >= 3
    ListForK3 = k3
    
    i = 0
    while i < ListForK3.length do
        if ListForK3[i][4].to_f < min
            min = ListForK3[i][4].to_f
            outputList.clear
            outputList.push(ListForK3[i])
        elsif ListForK3[i][4].to_f == min
            outputList.push(ListForK3[i])
        end
        i += 1
    end
end
if k == 4
    ListForK4 = k4
    
    i = 0
    while i < ListForK4.length do
        if ListForK4[i][5].to_f < min
            min = ListForK4[i][5].to_f
            outputList.clear
            outputList.push(ListForK4[i])
        elsif ListForK4[i][5].to_f == min
            outputList.push(ListForK4[i])
        end
        i += 1
    end
end

puts "\nMit den Widerstandswerten aus der Liste lässt sich der gesucht Widerstand von #{$neededOhm} Ω mit einem Abstand von #{min} Ω auf folgende Arten erreichen:"
i = 0
while i < outputList.length do
    if outputList[i].length == 3
        puts $resistances[outputList[i][0]].to_s
    elsif outputList[i].length == 4
        if outputList[i][2] == 1
            puts $resistances[outputList[i][0].to_i].to_s + " seriell " + $resistances[outputList[i][1].to_i].to_s + " = " + seriell([$resistances[outputList[i][0].to_i].to_f, $resistances[outputList[i][1].to_i].to_f]).to_s
        elsif outputList[i][2] == 2
            puts $resistances[outputList[i][0].to_i].to_s + " parallel " + $resistances[outputList[i][1].to_i].to_s + " = " + parallel([$resistances[outputList[i][0].to_i].to_f, $resistances[outputList[i][1].to_i].to_f]).to_s
        end
    elsif outputList[i].length == 5
        if outputList[i][3] == 1
            puts $resistances[outputList[i][0].to_i].to_s + " seriell " + $resistances[outputList[i][1].to_i].to_s + " seriell " + $resistances[outputList[i][2].to_i].to_s + " = " + seriell([$resistances[outputList[i][0].to_i].to_f, $resistances[outputList[i][1].to_i].to_f, $resistances[outputList[i][2].to_i].to_f]).to_s
        elsif outputList[i][3] == 2
            puts $resistances[outputList[i][0].to_i].to_s + " seriell (" + $resistances[outputList[i][1].to_i].to_s + " parallel " + $resistances[outputList[i][2].to_i].to_s + ") = " + seriell([$resistances[outputList[i][0].to_i].to_f, parallel([$resistances[outputList[i][1].to_i].to_f, $resistances[outputList[i][2].to_i].to_f])]).to_s
        elsif outputList[i][3] == 3
            puts $resistances[outputList[i][0].to_i].to_s + " parallel " + $resistances[outputList[i][1].to_i].to_s + " parallel " + $resistances[outputList[i][2].to_i].to_s + " = " + parallel([$resistances[outputList[i][0].to_i].to_f, $resistances[outputList[i][1].to_i].to_f, $resistances[outputList[i][2].to_i].to_f]).to_s
        elsif outputList[i][3] == 4
            puts $resistances[outputList[i][0].to_i].to_s + " parallel (" + $resistances[outputList[i][1].to_i].to_s + " seriell " + $resistances[outputList[i][2].to_i].to_s + ") = " + parallel([$resistances[outputList[i][0].to_i].to_f, seriell([$resistances[outputList[i][1].to_i].to_f, $resistances[outputList[i][2].to_i].to_f])]).to_s
        end
    elsif outputList[i].length == 6
        if outputList[i][4] == 1
            puts $resistances[outputList[i][0].to_i].to_s + " seriell " + $resistances[outputList[i][1].to_i].to_s + " seriell " + $resistances[outputList[i][2].to_i].to_s + " seriell " + $resistances[outputList[i][3].to_i].to_s + " = " + seriell([$resistances[outputList[i][0].to_i].to_f, $resistances[outputList[i][1].to_i].to_f, $resistances[outputList[i][2].to_i].to_f, $resistances[outputList[i][3].to_i].to_f]).to_s
        elsif outputList[i][4] == 2
            puts $resistances[outputList[i][0].to_i].to_s + " seriell " + $resistances[outputList[i][1].to_i].to_s + " seriell (" + $resistances[outputList[i][2].to_i].to_s + " parallel " + $resistances[outputList[i][3].to_i].to_s + ") = " + seriell([$resistances[outputList[i][0].to_i].to_f, $resistances[outputList[i][1].to_i].to_f, parallel([$resistances[outputList[i][2].to_i].to_f, $resistances[outputList[i][3].to_i].to_f])]).to_s
        elsif outputList[i][4] == 3
            puts "(" + $resistances[outputList[i][0].to_i].to_s + " parallel " + $resistances[outputList[i][1].to_i].to_s + ") seriell (" + $resistances[outputList[i][2].to_i].to_s + " parallel " + $resistances[outputList[i][3].to_i].to_s + ") = " + seriell([parallel([$resistances[outputList[i][0].to_i].to_f, $resistances[outputList[i][1].to_i].to_f]), parallel([$resistances[outputList[i][2].to_i].to_f, $resistances[outputList[i][3].to_i].to_f])]).to_s
        elsif outputList[i][4] == 4
            puts $resistances[outputList[i][0].to_i].to_s + " seriell (" + $resistances[outputList[i][1].to_i].to_s + " parallel " + $resistances[outputList[i][2].to_i].to_s + " parallel " + $resistances[outputList[i][3].to_i].to_s + ") = " + seriell([$resistances[outputList[i][0].to_i].to_f, parallel([$resistances[outputList[i][1].to_i].to_f, $resistances[outputList[i][2].to_i].to_f, $resistances[outputList[i][3].to_i].to_f])]).to_s
        elsif outputList[i][4] == 5
            puts $resistances[outputList[i][0].to_i].to_s + " parallel " + $resistances[outputList[i][1].to_i].to_s + " parallel " + $resistances[outputList[i][2].to_i].to_s + " parallel " + $resistances[outputList[i][3].to_i].to_s + " = " + parallel([$resistances[outputList[i][0].to_i].to_f, $resistances[outputList[i][1].to_i].to_f, $resistances[outputList[i][2].to_i].to_f, $resistances[outputList[i][3].to_i].to_f]).to_s
        elsif outputList[i][4] == 6
            puts $resistances[outputList[i][0].to_i].to_s + " parallel (" + $resistances[outputList[i][1].to_i].to_s + " seriell " + $resistances[outputList[i][2].to_i].to_s + " seriell " + $resistances[outputList[i][3].to_i].to_s + ") = " + parallel([$resistances[outputList[i][0].to_i].to_f, seriell([$resistances[outputList[i][1].to_i].to_f, $resistances[outputList[i][2].to_i].to_f, $resistances[outputList[i][3].to_i].to_f])]).to_s
        elsif outputList[i][4] == 7
            puts "(" + $resistances[outputList[i][0].to_i].to_s + " seriell " + $resistances[outputList[i][1].to_i].to_s + ") parallel (" + $resistances[outputList[i][2].to_i].to_s + " seriell " + $resistances[outputList[i][3].to_i].to_s + ") = " + parallel([seriell([$resistances[outputList[i][0].to_i].to_f, $resistances[outputList[i][1].to_i].to_f]), seriell([$resistances[outputList[i][2].to_i].to_f, $resistances[outputList[i][3].to_i].to_f])]).to_s
        elsif outputList[i][4] == 8
            puts "(" + $resistances[outputList[i][0].to_i].to_s + " seriell [" + $resistances[outputList[i][1].to_i].to_s + " parallel " + $resistances[outputList[i][2].to_i].to_s + "]) parallel " + $resistances[outputList[i][3].to_i].to_s + " = " + parallel([seriell([$resistances[outputList[i][0].to_i].to_f, parallel([$resistances[outputList[i][1].to_i].to_f, $resistances[outputList[i][2].to_i].to_f])]), $resistances[outputList[i][3].to_i].to_f]).to_s
        elsif outputList[i][4] == 9
            puts $resistances[outputList[i][0].to_i].to_s + " parallel " + $resistances[outputList[i][1].to_i].to_s + " parallel (" + $resistances[outputList[i][2].to_i].to_s + " seriell " + $resistances[outputList[i][3].to_i].to_s + ") = " + parallel([$resistances[outputList[i][0].to_i].to_f, $resistances[outputList[i][1].to_i].to_f, seriell([$resistances[outputList[i][2].to_i].to_f, $resistances[outputList[i][3].to_i].to_f])]).to_s
        end
    end
    i += 1
end
