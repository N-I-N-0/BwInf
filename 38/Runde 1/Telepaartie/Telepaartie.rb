puts "Gebe eine maximale Grenze an rekursiven Aufrufen an. Diese bestimmt, wie oft maximal telepaartiert werden kann. (Für die Testfälle wurde der Wert 25 gewählt):"
$min_saved = gets.to_i
$min = $min_saved
def LLL(l1, l2, l3, i)
    if(l1 == 0 or l2 == 0 or l3 == 0)
        $min = i
    else
        if(i < $min)
            if l1 == l2
                LLL(l1+l2, 0, l3, i+1)
            elsif l2 == l3
                LLL(l1, l2+l3, 0, i+1)
            elsif l3 == l1
                LLL(0, l2, l3+l1, i+1)
            else
                if l1 > l2
                    LLL(l1-l2, l2*2, l3, i+1)
                else
                    LLL(l1*2, l2-l1, l3, i+1)
                end
                if l2 > l3
                    LLL(l1, l2-l3, l3*2, i+1)
                else
                    LLL(l1, l2*2, l3-l2, i+1)
                end
                if l3 > l1
                    LLL(l1*2, l2, l3-l1, i+1)
                else
                    LLL(l1-l3, l2, l3*2, i+1)
                end
            end
        end
    end
end

def L(n)
    max = 0
    n1 = 1
    while(n1 < n)
        n2 = 1
        while(n2 < n-n1)
            $min = $min_saved
            LLL(n1, n2, n-n1-n2, 0)
            puts "LLL für (#{n1}, #{n2}, #{n-n1-n2}): #{$min}"
            if $min > max
                max = $min
            end
            n2 += 1
        end
        n1 += 1
    end
    return max
end

def do_L
    puts "Gebe die Gesamtbiberzahl n ein:"
    input = gets.to_i
    t = Time.now
    puts "Die maximale LLL beträgt folgende Anzahl an Durchläufen: #{L(input)}"
    puts "Die Lösung wurde in folgender Zeit gefunden:"
    p Time.now - t
end

def do_LLL
    $min = $min_saved
    puts "Gib nacheinander drei Zahlen für die Startverteilung der Biber ein:"
    LLL(gets.to_i, gets.to_i, gets.to_i, 0)
    puts "Es werden für die eingegebene Startverteilung folgende Anzahl an Telepaartien mindestens benötigt: #{$min}."
end

def loop
    while true
        puts "\nGebe die Nummern ein um die entsprechenden Methoden aufzurufen:\n1 = LLL\n2 = L"
        input = gets.to_i
        case input
        when 1
            do_LLL
        when 2
            do_L
        end
    end
end

loop
