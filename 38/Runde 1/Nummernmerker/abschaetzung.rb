nummern = Array.new
File.open("nummern.txt").read.force_encoding("UTF-8").split("\n").each do |num|
    nummern.push(num.split(""))
end

$bloecke = Array.new
def aufteilen(anfang, uebrig)
    if(uebrig == nil)
        $bloecke = anfang
    else
        if(uebrig.length < 5)
            aufteilen(anfang + [uebrig[0..-1].join], nil)
        elsif(uebrig.length < 6)
            if not uebrig[3] == "0"
                aufteilen(anfang + [uebrig[0..2].join], uebrig[3..4])
            else
                aufteilen(anfang + [uebrig[0..1].join], uebrig[2..4])
            end
        else
            if not uebrig[4] == "0"
                aufteilen(anfang + [uebrig[0..3].join], uebrig[4..-1])
            elsif not uebrig[3] == "0"
                aufteilen(anfang + [uebrig[0..2].join], uebrig[3..-1])
            elsif not uebrig[2] == "0"
                aufteilen(anfang + [uebrig[0..1].join], uebrig[2..-1])
            else
                aufteilen(anfang + [uebrig[0..3].join], uebrig[4..-1])
            end
        end
    end
end

nummern.each do |num|
    $bloecke = Array.new
    aufteilen(Array.new, num)
    i = 0
    $bloecke.each do |block|
        i += 1 if block[0] == "0"
    end
    puts "#{$bloecke.join('-')}\nAnzahl der Bloecke mit 0 am Anfang: #{i}\n\n"
end
