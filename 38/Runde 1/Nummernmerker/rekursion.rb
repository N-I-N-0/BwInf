nummern = Array.new
File.open("nummern.txt").read.force_encoding("UTF-8").split("\n").each do |num|
    nummern.push(num.split(""))
end

$bloecke = Array.new
def aufteilen(anfang, uebrig)
    if(uebrig == nil)
        $bloecke.push(anfang)
    else
        if(uebrig.length < 3)
            aufteilen(anfang + [uebrig[0..1].join], nil)
        elsif(uebrig.length < 4)
            aufteilen(anfang + [uebrig[0..2].join], nil)
        elsif(uebrig.length < 5)
            aufteilen(anfang + [uebrig[0..1].join], uebrig[2..3])
            aufteilen(anfang + [uebrig[0..3].join], nil)
        elsif(uebrig.length < 6)
            aufteilen(anfang + [uebrig[0..1].join], uebrig[2..4])
            aufteilen(anfang + [uebrig[0..2].join], uebrig[3..4])
        else
            aufteilen(anfang + [uebrig[0..1].join], uebrig[2..-1])
            aufteilen(anfang + [uebrig[0..2].join], uebrig[3..-1])
            aufteilen(anfang + [uebrig[0..3].join], uebrig[4..-1])
        end
    end
end

nummern.each do |num|
    $bloecke = Array.new
    aufteilen(Array.new, num)
    min = Float::INFINITY
    $reihen = Array.new
    $bloecke.each do |reihe|
        i = 0
        reihe.each do |block|
            i += 1 if block[0] == "0"
        end
        if(i<min)
            min = i
            $reihen.clear
            $reihen.push(reihe)
        elsif(i==min)
            $reihen.push(reihe)
        end
    end
    
    puts "Gegeben ist die Zahl #{num.join}; sie lässt sich zum Beispiel wie folgt zerlegen:"
    puts $reihen[0].join("-")
    if($reihen.length > 1)
        puts "Es wurden #{$reihen.length-1} weitere Lösungen mit einer minimal Anzahl von #{min} #{min == 1 ? 'Block' : 'Blöcken'} mit einer 0 am Anfang gefunden. Sollen diese ausgegeben werden? (j)"
        if(gets.chomp.downcase == "j")
            $reihen[1..-1].each do |reihe|
                puts reihe.join("-")
            end
        end
    end
    puts ""
end
