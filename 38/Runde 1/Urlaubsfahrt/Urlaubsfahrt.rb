puts "Gebe den Namen der einzulesenden Datei ein (z.B. fahrt5.txt):"
file_name = gets.chomp
file = File.open(file_name).read.force_encoding("UTF-8").split("\n")
$v = file.shift.to_i        #Verbrauch in l/100km
$g = file.shift.to_i        #Tankgröße
$f = file.shift.to_i        #Tankfüllung
$l = file.shift.to_i        #Gesamtlänge
$z = file.shift.to_i + 1    #Anzahl der Tankstellen + Start + Ziel (Array Zählweise)
$d = Array.new              #Positionen der Tankstellen + Start + Ziel
$p = Array.new              #Preise der Tankstellen + Start + Ziel
puts "Gebe eine Obergrenze an, welche besagt, wie viele Tankstellen von jeder anderen aus beim Testen angefahren werden können (siehe Dokumentation):"
$grenze = gets.to_i

def aufteilen(line)
    line = line.split("")
    i = 0
    while(not line[i] == " ") do i += 1 end
    d = line[0..i].join.to_i
    i = 0 + $z
    while(not line[i] == " ") do i -= 1 end
    p = line[i..-1].join.to_i
    return d, p
end

file.each_with_index do |s, i|
    $d[i], $p[i] = aufteilen(s)
end
$d.unshift(0)
$p.unshift(Float::INFINITY)
$d.push($l)
$p.push(Float::INFINITY)

def erreichbare_tankstellen(pos_ind)
    fuellung = pos_ind == 0 ? $f.to_f : $g.to_f
    erreichbar = $d[pos_ind].to_f + fuellung / $v * 100.0
    tankstellen = Array.new
    pos_ind += 1
    while(pos_ind<=$z and $d[pos_ind] <= erreichbar) do
        if($d[pos_ind] <= erreichbar) then tankstellen << pos_ind end
        pos_ind += 1
    end
    return tankstellen
end

$tankstellen = Array.new
$shortest = Float::INFINITY
def test(ind, vorherige_tankstellen)
    if $d[ind] == $l then
        if(vorherige_tankstellen.length < $shortest)
            $shortest = vorherige_tankstellen.length
            $tankstellen.clear
            $tankstellen.push(vorherige_tankstellen + [ind])
        elsif(vorherige_tankstellen.length == $shortest)
            $tankstellen.push(vorherige_tankstellen + [ind])
        end
    else
        if(not vorherige_tankstellen.length >= $shortest)
            erreichbar = erreichbare_tankstellen(ind)
            if erreichbar.length > $grenze
                erreichbar = erreichbar.drop(erreichbar.length-$grenze)   #Zum Einhalten der Obergrenze
            end
            
            erreichbar.reverse_each do |i|
                test(i, vorherige_tankstellen + [ind])
            end
        end
    end
end

def tanken(tankstellen)
    i = 0
    fuellung = $f
    liter = Array.new
    zu_bezahlen = Array.new
    while(i < tankstellen.length - 1) do
        distanz = $d[tankstellen[i+1]].to_f - $d[tankstellen[i]].to_f
        fuellung = fuellung.round(6)
        if $p[tankstellen[i]] > $p[tankstellen[i+1]]
            zu_tanken = (($v * distanz / 100) - fuellung).round(6)
            if(zu_tanken >= 0)
                liter.push(zu_tanken + 0.0)
                zu_bezahlen.push((zu_tanken*$p[tankstellen[i]]).round)
                fuellung = 0
            else
                liter.push(0.0)
                zu_bezahlen.push(0)
                fuellung = -zu_tanken
            end
        else
            if($p[tankstellen[i+1]] == Float::INFINITY)
                liter.push((($v * distanz / 100) - fuellung).round(6))
                zu_bezahlen.push((liter[-1]*$p[tankstellen[i]]).round)
                fuellung = 0
            else
                liter.push(($g-fuellung).round(6))
                zu_bezahlen.push((liter[-1]*$p[tankstellen[i]]).round)
                fuellung = ($g - distanz / 100 * $v).round(6)
            end
        end
        i += 1
    end
    liter.push(0.0)
    zu_bezahlen.push(0)
    return liter, zu_bezahlen
end

t = Time.now
test(0, Array.new)
min = Float::INFINITY
optimaler_weg = Array.new
optimale_liter = Array.new
optimale_preise = Array.new
$tankstellen.each do |liste|
    liter, zu_bezahlen = tanken(liste)
    gesamt_kosten = zu_bezahlen.inject(:+)
    if min > gesamt_kosten
        optimaler_weg = liste
        optimale_liter = liter
        optimale_preise = zu_bezahlen
        min = gesamt_kosten
    end
end
                            
optimaler_weg.each_with_index do |tankstellen_index, i|
    puts "Position (in km): #{$d[tankstellen_index]}\nZu tankende Liter: #{optimale_liter[i]}\nPreis dieser (in Cent): #{optimale_preise[i]}\n\n"
end
puts "Anzahl an anzufahrenden Tankstellen auf dieser Route: #{optimaler_weg.length - 2}"
puts "Es müssen auf dem Weg #{optimale_liter.inject(:+)} Liter getankt werden."
puts "Insgesamt betragen die Kosten auf diesem Weg #{min} Cent."
puts "Es wurde folgende Zeit zur Berechnung der Lösung benötigt: #{Time.now-t}"
