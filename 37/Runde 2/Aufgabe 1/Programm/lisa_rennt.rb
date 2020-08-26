
def gleichsetzenVonGeraden(m1, n1, m2, n2)
	if m1 == m2
		if n1 == n2
			return Float::INFINITY
		else
			return nil
		end
	else
		return (n1.to_f-n2.to_f)/(m2.to_f-m1.to_f)
	end
end

def xDurchYBestimmen(y, m, n)
	return (y.to_f-n.to_f)/m.to_f
end

def yDurchXBestimmen(x, m, n)
	return m.to_f*x.to_f+n.to_f
end

def steigungDurchZweiPunkteBestimmen(x1, y1, x2, y2)
	if x1 == x2
		return nil
	else
		return (y2.to_f-y1.to_f)/(x2.to_f-x1.to_f)
	end
end

def yAchsenabschnittBestimmen(x, y, m)
	return y.to_f-m.to_f*x.to_f
end

def schneidetInBereich(x1, y1, x2, y2, x3, y3, x4, y4)
	m1 = steigungDurchZweiPunkteBestimmen(x1, y1, x2, y2)
	m2 = steigungDurchZweiPunkteBestimmen(x3, y3, x4, y4)
	if [x1, y1] == [x3, y3] or [x2, y2] == [x3, y3] or [x1, y1] == [x4, y4] or [x2, y2] == [x4, y4]
		return nil
	end
	
	if m1 == nil
		if m2 == nil
			if x1 == x3 and (((y1..y2).cover? y3 or (y2..y1).cover? y3) or ((y3..y4).cover? y1 or (y4..y3).cover? y1))
				return true
			else
				return false
			end
		else
			n2 = yAchsenabschnittBestimmen(x3, y3, m2)
			y = yDurchXBestimmen(x1, m2, n2)
			if ((y1..y2).cover? y or (y2..y1).cover? y) and ((y3..y4).cover? y or (y4..y3).cover? y) and ((x3..x4).cover? x1 or (x4..x3).cover? x1)
				return true
			else
				return false
			end
		end
	else
		if m2 == nil
			n1 = yAchsenabschnittBestimmen(x1, y1, m1)
			y = yDurchXBestimmen(x3, m1, n1)
			if ((y1..y2).cover? y or (y2..y1).cover? y) and ((y3..y4).cover? y or (y4..y3).cover? y) and ((x1..x2).cover? x3 or (x2..x1).cover? x3)
				return true
			else
				return false
			end
		else
			n1 = yAchsenabschnittBestimmen(x1, y1, m1)
			n2 = yAchsenabschnittBestimmen(x3, y3, m2)
			x = gleichsetzenVonGeraden(m1, n1, m2, n2)
			if x == nil
				return false
			elsif x == Float::INFINITY
				if (x1..x2).cover? x3 or (x2..x1).cover? x3 or (x1..x2).cover? x4 or (x2..x1).cover? x4
					return true
				else
					return false
				end
			else
				y = yDurchXBestimmen(x, m1, n1)
				
				if ((x1..x2).cover? x or (x2..x1).cover? x) and ((x3..x4).cover? x or (x4..x3).cover? x)
					return true
				else
					return false
				end
			end
		end
	end
end

$svgPolygone = ""
def polygoneEinlesen(datei)
	liste = File.open(datei).read.force_encoding("UTF-8").split("\n")
	l = liste.length - 1
	i = 1
	knoten = Array.new
	polygonLinien = Array.new
	
	
	knoten.push([liste[-1].split(" ")[0].to_f, liste[-1].split(" ")[1].to_f, 0])
	
	while i < l
		polygon = liste[i].split(" ")
		l2 = polygon.length - 2
		i2 = 1
		$svgPolygone += "<polygon id='P#{i}' points='#{polygon[1..-1].join(" ")}' fill='#6B6B6B' stroke='#212121' stroke-width='2'/>"
		while i2 < l2
			knoten.push([polygon[i2].to_f, polygon[i2 + 1].to_f, i])
			polygonLinien.push([polygon[i2].to_f, polygon[i2 + 1].to_f, polygon[i2 + 2].to_f, polygon[i2 + 3].to_f, i.dup])
		
			i2 += 2
		end
		knoten.push([polygon[i2].to_f, polygon[i2 + 1].to_f, i])
		polygonLinien.push([polygon[i2].to_f, polygon[i2 + 1].to_f, polygon[1].to_f, polygon[2].to_f, i.dup])
		
		
		i += 1
	end
	
	return knoten, polygonLinien
end

def sindPunkteNachbarn(polygonLinien, id, x1, y1, x2, y2)
	if not polygonLinien.index([x1, y1, x2, y2, id]) == nil or not polygonLinien.index([x2, y2, x1, y1, id]) == nil
		return true
	else
		return false
	end
end

def punktLiegtAufLinie(x1, y1, x2, y2, x3, y3)
	m = steigungDurchZweiPunkteBestimmen(x1, y1, x2, y2)
	if m == nil
		if x1 == x3 and ((y1..y2).cover? y3 or (y2..y1).cover? y3)
			return true
		else
			return false
		end
	else
		n = yAchsenabschnittBestimmen(x1, y1, m)
		if yDurchXBestimmen(x3, m, n).round(9) == y3.round(9) and ((x1..x2).cover? x3 or (x2..x1).cover? x3)
			return true
		else
			return false
		end
	end
end

def punktVonLinieLiegtInPolygon(knoten, polygonLinien, id, x1, y1, x2, y2)
	z = 0
	i = 0
	l = knoten.length
	xArr = Array.new
	yArr = Array.new
	
	while i < l
		if id == knoten[i][2]
			xArr.push(knoten[i][0])
			yArr.push(knoten[i][1])
		end
		i += 1
	end
	
	y = (y1+y2)/2
	x = (x1+x2)/2
	if y1 == y2
		while not xArr.index(x) == nil
			x = (x+x1)/2
		end
		
		x3 = x
		y3 = yArr.max + 100
	else
		while not yArr.index(y) == nil
			y = (y+y1)/2
			x = (x+x1)/2
		end
		
		x3 = xArr.max + 100
		y3 = y
	end
	
	i = 0
	l = polygonLinien.length
	while i < l
		if polygonLinien[i][4] == id
			pX1 = polygonLinien[i][0]
			pY1 = polygonLinien[i][1]
			pX2 = polygonLinien[i][2]
			pY2 = polygonLinien[i][3]
			
			if punktLiegtAufLinie(pX1, pY1, pX2, pY2, x, y)
				return true
			end
			
			a = schneidetInBereich(pX1, pY1, pX2, pY2, x, y, x3, y3)
			if a == true
				z += 1
			end
		end
		
		i += 1
	end
	
	return !z.even?
end

def distanzVonZweiPunkten(x1, y1, x2, y2)
	return ((x2-x1)**2+(y2-y1)**2)**0.5
end

def netzLegen(unverbundeneKnoten, polygonLinien)
	i1 = i2 = i3 = 0
	l1 = unverbundeneKnoten.length
	l2 = polygonLinien.length
	knoten = Array.new(l1) {Array.new(l1)}
	zielKnoten = Array.new
	linien = ""
	
	while i1 < l1
		i2 = 0
		
		x1, y1 = unverbundeneKnoten[i1][0], unverbundeneKnoten[i1][1]
		while i2 < l1
			i3 = 0
			keineHindernisse = true
			x2, y2 = unverbundeneKnoten[i2][0], unverbundeneKnoten[i2][1]
			if not i1 == i2
				if not sindPunkteNachbarn(polygonLinien, unverbundeneKnoten[i1][2], x1, y1, x2, y2)
					while i3 < l2 and keineHindernisse
						a = schneidetInBereich(x1, y1, x2, y2, polygonLinien[i3][0], polygonLinien[i3][1], polygonLinien[i3][2], polygonLinien[i3][3])
						if a == true
							keineHindernisse = false
						end
						i3 += 1
					end
					if unverbundeneKnoten[i1][2] == unverbundeneKnoten[i2][2] and punktVonLinieLiegtInPolygon(unverbundeneKnoten, polygonLinien, unverbundeneKnoten[i1][2], x1, y1, x2, y2)
						keineHindernisse = false
					end
				end
				
				if keineHindernisse
					linien += "<line stroke='#FF0000' opacity='0.25' x1='#{x1}' y1='#{y1}' x2='#{x2}' y2='#{y2}' stroke-width='1'/>"
				end
				
				knoten[i1][i2] = [keineHindernisse, distanzVonZweiPunkten(x1, y1, x2, y2)]
			else
				knoten[i1][i2] = [false]
			end
			
			i2 += 1
		end
		
		keineHindernisse = true
		
		x1, y1, x2 = unverbundeneKnoten[i1][0], unverbundeneKnoten[i1][1], 0
		y2 = yAchsenabschnittBestimmen(x1, y1, -((1.0/3)**0.5))
		i3 = 0
		while i3 < l2 and keineHindernisse
			a = schneidetInBereich(x1, y1, x2, y2, polygonLinien[i3][0], polygonLinien[i3][1], polygonLinien[i3][2], polygonLinien[i3][3])
			if a == true
				keineHindernisse = false
			end
			i3 += 1
		end
		
		if keineHindernisse
			linien += "<line stroke='#FF0000' opacity='0.25' x1='#{x1}' y1='#{y1}' x2='#{x2}' y2='#{y2}' stroke-width='1'/>"
			zielKnoten.push([y2, i1, distanzVonZweiPunkten(x1, y1, x2, y2)])
		end
		
		i1 += 1
	end
	
	return linien, knoten, zielKnoten
end




def dijkstra(knoten, unverbundeneKnoten, zielKnoten)
	abstaende = Array.new(knoten.length) {Float::INFINITY}
	abstaende[0] = 0.0
	besterVorherigerKnoten = Array.new(knoten.length) {nil}
	uebrigeKnoten = Array.new(knoten.length) {|i| i}
	
	while uebrigeKnoten.length > 0
		i = 0
		min = Float::INFINITY
		ind = nil
		while i < uebrigeKnoten.length
			if abstaende[uebrigeKnoten[i]] < min
				min = abstaende[uebrigeKnoten[i]]
				ind = uebrigeKnoten[i]
			end
			i += 1
		end
		uebrigeKnoten.delete_at(uebrigeKnoten.index(ind))
		c = 0
		while c < knoten[ind].length
			if knoten[ind][c][0] == true
				if abstaende[c] == Float::INFINITY
					abstaende[c] = abstaende[ind] + knoten[ind][c][1]
					besterVorherigerKnoten[c] = ind
				else
					neuerAbstand = abstaende[ind] + knoten[ind][c][1]
					if abstaende[c] > neuerAbstand
						abstaende[c] = neuerAbstand
						besterVorherigerKnoten[c] = ind
						uebrigeKnoten.push(c)
					end
				end
			end
			c += 1
		end
	end
	
	
	
	
	wege = Array.new
	gelbeLinien = ""
	v = 0
	while v < zielKnoten.length
		grueneLinie = ""
		strecke = abstaende[zielKnoten[v][1]] + zielKnoten[v][2]
		benoetigteZeitBisZielKnoten = (strecke/(15/3.6))
		zeitBisBusAnZielKnotenAnkommt = (zielKnoten[v][0]/(30/3.6))
		weg = Array.new
		
		zeitAbstand = (zeitBisBusAnZielKnotenAnkommt - benoetigteZeitBisZielKnoten)
		
		index = zielKnoten[v][1]
		grueneLinie += "<line stroke='#FFFF00' opacity='1' x1='#{0.0}' y1='#{zielKnoten[v][0]}' x2='#{unverbundeneKnoten[index][0]}' y2='#{unverbundeneKnoten[index][1]}' stroke-width='1'/>"
		weg.push([0.0, zielKnoten[v][0], "Treffpunkt mit Bus"])
		while not index == 0
			vorherigerIndex = besterVorherigerKnoten[index]
			grueneLinie += "<line stroke='#FFFF00' opacity='1' x1='#{unverbundeneKnoten[index][0]}' y1='#{unverbundeneKnoten[index][1]}' x2='#{unverbundeneKnoten[vorherigerIndex][0]}' y2='#{unverbundeneKnoten[vorherigerIndex][1]}' stroke-width='1'/>"
			weg.push([unverbundeneKnoten[index][0], unverbundeneKnoten[index][1], "P#{unverbundeneKnoten[index][2]}"])
			index = vorherigerIndex
		end
		weg.push([unverbundeneKnoten[0][0], unverbundeneKnoten[0][1], "L"])
		wege.push([zeitAbstand, grueneLinie, strecke, benoetigteZeitBisZielKnoten, zeitBisBusAnZielKnotenAnkommt, weg.reverse])
		gelbeLinien += grueneLinie
		
		v += 1
	end
	
	
	
	zeitAbstand = wege.max[0].round(0) + 27000
	stunden, minuten, sekunden = zeitInStundenMinutenUndSekunden(zeitAbstand)
	
	puts "Um den Bus noch zu erreichen muss Lisa spätestens um #{stunden}:#{minuten}:#{sekunden} los laufen auf der folgenden Strecke:"
	i = 0
	weg = wege.max[5]
	puts "\nx | y | id des Polygons, welches berührt wird"
	while i < weg.length
		puts weg[i].join(" | ")
		
		i += 1
	end
	
	zeitBisBusAnZielKnotenAnkommt = wege.max[4]
	stunden, minuten, sekunden = zeitInStundenMinutenUndSekunden(zeitBisBusAnZielKnotenAnkommt.round(0)+27000)
	puts "\nLisa erreicht auf diesem Weg den Bus um #{stunden}:#{minuten}:#{sekunden}"
	benoetigteZeitBisZielKnoten = wege.max[3]
	stunden, minuten, sekunden = zeitInStundenMinutenUndSekunden(benoetigteZeitBisZielKnoten.round(0))
	puts "\nSie benötigt dafür eine Zeit von #{stunden}h #{minuten}min #{sekunden}sek"
	
	return gelbeLinien + wege.max[1].gsub!("#FFFF00", "#00FF00")
end

def zeitInStundenMinutenUndSekunden(sekunden)
	stunden = sekunden / 3600
	minuten = (sekunden / 60) % 60
	sekunden = sekunden % 60
	return stunden, minuten, sekunden
end

puts "Gebe den Namen der einzulesenen .txt Datei ein:"
unverbundeneKnoten, polygonLinien = polygoneEinlesen(gets.chomp)
svgLinien, knoten, zielKnoten = netzLegen(unverbundeneKnoten, polygonLinien)

svgLinien += dijkstra(knoten, unverbundeneKnoten, zielKnoten)
startPunkt = "<circle xmlns='http://www.w3.org/2000/svg' id='L' cx='#{unverbundeneKnoten[0][0]}' cy='#{unverbundeneKnoten[0][1]}' r='10' fill='#F42121' stroke='#000080' stroke-width='1'/>"
newSVGName = "#{Time.now.to_s[0..-7].gsub!(":", "-")}.svg"
puts "\nLisas Strecke wurde in folgender Datei abgespeichert: #{newSVGName}\nDie roten Linien stellen alle Wege zwischen den Ecken der Polygone dar, die gelben Linien alle direkten Wege zum Rand und die grüne Linie zeigt den besten gefunden Weg an, den Lisa laufen kann."
newSVG = File.new(newSVGName, "w+")
newSVG.write("<svg version='1.1' viewBox='0 0 1024 1400' xmlns='http://www.w3.org/2000/svg'><g transform='scale(1 -1)'><g transform='translate(0 -1200)'><line xmlns='http://www.w3.org/2000/svg' id='y' x1='0' x2='0' y1='0' y2='1200' fill='none' stroke='#212121' stroke-width='3'/>#{$svgPolygone}#{startPunkt}#{svgLinien}</g></g></svg>")
newSVG.close
