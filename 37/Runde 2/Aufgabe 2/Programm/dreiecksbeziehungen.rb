def gleichsetzenVonGeraden(m1, n1, m2, n2)
	return (n1.to_f-n2.to_f)/(m2.to_f-m1.to_f)
end

def xDurchYBestimmen(y, m, n)
	return (y.to_f-n.to_f)/m.to_f
end

def yDurchXBestimmen(x, m, n)
	return m.to_f*x.to_f+n.to_f
end

def xDurchWinkelBestimmen(w, r)
	return Math.cos(w*Math::PI/180)*r
end

def yDurchWinkelBestimmen(w, r)
	return Math.sin(w*Math::PI/180)*r
end

def steigungDurchZweiPunkteBestimmen(x1, y1, x2, y2)
	if x1 == x2
		return nil
	else
		return (y2.to_f-y1.to_f)/(x2.to_f-x1.to_f)
	end
end

def steigungDurchWinkelBestimmen(w)
	return Math.tan(w.to_f*Math::PI/180)
end

def winkelDurchSteigungBestimmen(m)
	return Math.atan(m.to_f)*180/Math::PI
end

def yAchsenabschnittBestimmen(x, y, m)
	return y.to_f-m.to_f*x.to_f
end

def spiegelDreieck(x1, y1, x2, y2, x3, y3)
	if x1 == x2
		newX3 = x1-x3+x1
		
		return x1, y1, x2, y2, newX3, y3
	elsif y1 == y2
		newY3 = y1-y3+y1
		
		return x1, y1, x2, y2, x3, newY3	
	else
		oldM = steigungDurchZweiPunkteBestimmen(x1, y1, x2, y2)
		oldN = yAchsenabschnittBestimmen(x1, y1, oldM)
		
		m = steigungDurchWinkelBestimmen(winkelDurchSteigungBestimmen(oldM)+90)
		n = yAchsenabschnittBestimmen(x3, y3, m)
		
		xSpiegel = gleichsetzenVonGeraden(oldM, oldN, m, n)
		ySpiegel = yDurchXBestimmen(xSpiegel, m, n)
		
		newX3 = xSpiegel - x3 + xSpiegel
		newY3 = ySpiegel - y3 + ySpiegel
		
		return x1, y1, x2, y2, newX3, newY3
	end
end

def mittelpunktVonUmkreisBestimmen(x1, y1, x2, y2, x3, y3)
	x = 0.0
	y = 0.0
	
	m1 = 0.0
	m2 = 0.0
	
	n1 = 0.0
	n2 = 0.0
	
	gotX = false
	gotY = false
	
	if  x1 == x2
		gotY = true
		y = y1+(y2-y1)/2
	elsif y1 == y2
		gotX = true
		x = x1+(x2-x1)/2
	else
		m1 = steigungDurchWinkelBestimmen(winkelDurchSteigungBestimmen(steigungDurchZweiPunkteBestimmen(x1, y1, x2, y2))+90)
		n1 = yAchsenabschnittBestimmen(x1+(x2-x1)/2, y1+(y2-y1)/2, m1)
	end
	
	if x2 == x3 
		gotY = true
		y = y2+(y3-y2)/2
	elsif y2 == y3
		gotX = true
		x = x2+(x3-x2)/2
	else
		if gotX or gotY
			m1 = steigungDurchWinkelBestimmen(winkelDurchSteigungBestimmen(steigungDurchZweiPunkteBestimmen(x2, y2, x3, y3))+90)
			n1 = yAchsenabschnittBestimmen(x2+(x3-x2)/2, y2+(y3-y2)/2, m1)
		elsif not gotX and not gotY
			m2 = steigungDurchWinkelBestimmen(winkelDurchSteigungBestimmen(steigungDurchZweiPunkteBestimmen(x2, y2, x3, y3))+90)
			n2 = yAchsenabschnittBestimmen(x2+(x3-x2)/2, y2+(y3-y2)/2, m2)
		end
	end
	
	if gotX and gotY
		return x, y
	elsif gotX ^ gotY
		if gotX
			y = yDurchXBestimmen(x, m1, n1)
		else
			x = xDurchYBestimmen(y, m1, n1)
		end
		return x, y
	else
		x = gleichsetzenVonGeraden(m1, n1, m2, n2)
		y = yDurchXBestimmen(x, m1, n1)
		return x, y
	end
end

def winkelVonZweiPunktenBestimmen(x1, y1, x2, y2)
	w = Math.atan2(y2-y1, x2-x1) / (Math::PI/180)
	while w < 0
		w += 360
	end
	return w
end

def distanzVonZweiPunktenBestimmen(x1, y1, x2, y2)
	return ((x2-x1)**2+(y2-y1)**2)**0.5
end

def innenwinkelBestimmen(a, b, c)
	alpha = Math.acos((b**2 + c**2 - a**2) / (2*b*c))*180/Math::PI
	beta = Math.acos((a**2 + c**2 - b**2) / (2*a*c))*180/Math::PI
	gamma = Math.acos((a**2 + b**2 - c**2) / (2*a*b))*180/Math::PI
	return alpha, beta, gamma
end

def koordinatenUmsortieren(x1, y1, x2, y2, x3, y3)
	arr = Array.new
	arr.push([y1, x1], [y2, x2], [y3, x3])
	arr = arr.sort
	
	return arr[0][1], arr[0][0], arr[1][1], arr[1][0], arr[2][1], arr[2][0]
end

def SVGPolygonAusKoordinaten(id, istGespiegelt, x1, y1, x2, y2, x3, y3)
	return "<polygon id='D#{id+1}' gespiegelt='#{istGespiegelt}' points='#{x1} #{y1} #{x2} #{y2} #{x3} #{y3}' fill='#ffcc99' opacity='0.5' stroke='#000000' stroke-width='1'/>"
end

def typBestimmen(x1, y1, x2, y2, x3, y3)
	typ = 0
	x1, y1, x2, y2, x3, y3 = koordinatenUmsortieren(x1, y1, x2, y2, x3, y3)
	
	if y1 == y2
		typ = 3
	elsif y2 == y3
		typ = 1
	else
		if x1 == x3
			if x2 < x1
				typ = 1
			else
				typ = 2
			end
		else
			m = steigungDurchZweiPunkteBestimmen(x1, y1, x3, y3)
			n = yAchsenabschnittBestimmen(x1, y1, m) 
	
			if y2 > yDurchXBestimmen(x2, m, n)
				if m > 0
					typ = 1
				else
					typ = 2
				end
			else
				if m > 0
					typ = 2
				else
					typ = 1
				end
			end
		end
	end
	
	return typ
end

def zweitenPunkteAufWinkelDrehen(x1, y1, r, w)
	x2 = x1 + xDurchWinkelBestimmen(w, r)
	y2 = y1 + yDurchWinkelBestimmen(w, r)
	
	return x2, y2
end

def dreieckeAneinanderLegen(x1, y1, x2, y2, x3, y3, num, dreieck)
	a = dreieck[6]
	b = dreieck[7]
	c = dreieck[8]
	alpha = dreieck[9]
	beta = dreieck[10]
	gamma = dreieck[11]
	
	case num
	when 0
		w = winkelVonZweiPunktenBestimmen(x1, y1, x3, y3)
		x4 = x1
		y4 = y1
		x5, y5 = zweitenPunkteAufWinkelDrehen(x4, y4, b, w)
		winkelVonC = w - alpha
		x6, y6 = zweitenPunkteAufWinkelDrehen(x4, y4, c, winkelVonC)
	when 1
		w = winkelVonZweiPunktenBestimmen(x1, y1, x3, y3)
		x4 = x1
		y4 = y1
		x5, y5 = zweitenPunkteAufWinkelDrehen(x4, y4, c, w)
		winkelVonA = w - beta
		x6, y6 = zweitenPunkteAufWinkelDrehen(x4, y4, a, winkelVonA)
	when 2
		w = winkelVonZweiPunktenBestimmen(x1, y1, x3, y3)
		x4 = x1
		y4 = y1
		x5, y5 = zweitenPunkteAufWinkelDrehen(x4, y4, a, w)
		winkelVonB = w - gamma
		x6, y6 = zweitenPunkteAufWinkelDrehen(x4, y4, b, winkelVonB)
	when 3
		w = winkelVonZweiPunktenBestimmen(x1, y1, x2, y2)
		x4 = x1
		y4 = y1
		x5, y5 = zweitenPunkteAufWinkelDrehen(x4, y4, b, w)
		winkelVonC = w - alpha
		x6, y6 = zweitenPunkteAufWinkelDrehen(x4, y4, c, winkelVonC)
	when 4
		w = winkelVonZweiPunktenBestimmen(x1, y1, x2, y2)
		x4 = x1
		y4 = y1
		x5, y5 = zweitenPunkteAufWinkelDrehen(x4, y4, c, w)
		winkelVonA = w - beta
		x6, y6 = zweitenPunkteAufWinkelDrehen(x4, y4, a, winkelVonA)
	when 5
		w = winkelVonZweiPunktenBestimmen(x1, y1, x2, y2)
		x4 = x1
		y4 = y1
		x5, y5 = zweitenPunkteAufWinkelDrehen(x4, y4, a, w)
		winkelVonB = w - gamma
		x6, y6 = zweitenPunkteAufWinkelDrehen(x4, y4, b, winkelVonB)
	when 6
		w = winkelVonZweiPunktenBestimmen(x2, y2, x3, y3)
		x4 = x2
		y4 = y2
		x5, y5 = zweitenPunkteAufWinkelDrehen(x4, y4, b, w)
		winkelVonC = w - alpha
		x6, y6 = zweitenPunkteAufWinkelDrehen(x4, y4, c, winkelVonC)
	when 7
		w = winkelVonZweiPunktenBestimmen(x2, y2, x3, y3)
		x4 = x2
		y4 = y2
		x5, y5 = zweitenPunkteAufWinkelDrehen(x4, y4, c, w)
		winkelVonA = w - beta
		x6, y6 = zweitenPunkteAufWinkelDrehen(x4, y4, a, winkelVonA)
	when 8
		w = winkelVonZweiPunktenBestimmen(x2, y2, x3, y3)
		x4 = x2
		y4 = y2
		x5, y5 = zweitenPunkteAufWinkelDrehen(x4, y4, a, w)
		winkelVonB = w - gamma
		x6, y6 = zweitenPunkteAufWinkelDrehen(x4, y4, b, winkelVonB)
	end
	
	yVerschiebung = [y4, y5, y6].min
	y4 -= yVerschiebung
	y5 -= yVerschiebung
	y6 -= yVerschiebung
	
	m = steigungDurchWinkelBestimmen(w)
	xVerschiebung = yVerschiebung/m
	x4 -= xVerschiebung
	x5 -= xVerschiebung
	x6 -= xVerschiebung
	
	x4, y4, x5, y5, x6, y6 = koordinatenUmsortieren(x4, y4, x5, y5, x6, y6)
	return x4, y4, x5, y5, x6, y6
end

def linienZusammenSchieben(x1, y1, x2, y2, x3, y3, x4, y4)
	m1 = steigungDurchZweiPunkteBestimmen(x1, y1, x2, y2)
	m2 = steigungDurchZweiPunkteBestimmen(x3, y3, x4, y4)
	
	if y2 < y3 or y1 > y4
		return Float::INFINITY
	end
	
	if m1 == nil and m2 == nil
		return x3 - x1
	elsif m1 == nil and not m2 == nil
		n2 = yAchsenabschnittBestimmen(x3, y3, m2)
		if m2 > 0
			if y1 <= y3
				return x3 - x1
			else
				return xDurchYBestimmen(y1, m2, n2) - x1
			end
		else
			if y2 >= y4
				return x4 - x2
			else
				return xDurchYBestimmen(y2, m2, n2) - x1
			end
		end
	elsif not m1 == nil and m2 == nil
		n1 = yAchsenabschnittBestimmen(x1, y1, m1)
		if m1 > 0
			if y2 <= y4
				return x4 - x2
			else
				return x4 - xDurchYBestimmen(y4, m1, n1)
			end
		else
			if y1 >= y3
				return x3 - x1
			else
				return x3 - xDurchYBestimmen(y3, m1, n1)
			end
		end
	else
		n1 = yAchsenabschnittBestimmen(x1, y1, m1)
		n2 = yAchsenabschnittBestimmen(x3, y3, m2)
		
		if m1 == m2
			return x3 - xDurchYBestimmen(y3, m1, n1)
		elsif (m1 > 0 and m2 > 0) or (m1 < 0 and m2 < 0)
			if m1 > m2
				if y1 >= y3
					return xDurchYBestimmen(y1, m2, n2) - x1
				else
					return x3 - xDurchYBestimmen(y3, m1, n1)
				end
			else
				if y2 <= y4
					return xDurchYBestimmen(y2, m2, n2) - x2
				else
					return x4 - xDurchYBestimmen(y4, m1, n1)
				end
			end
		elsif m1 < 0 and m2 > 0
			if y1 >= y3
				return xDurchYBestimmen(y1, m2, n2) - x1
			else
				return x3 - xDurchYBestimmen(y3, m1, n1)
			end
		elsif m1 > 0 and m2 < 0
			if y2 <= y4
				return xDurchYBestimmen(y2, m2, n2) - x2
			else
				return x4 - xDurchYBestimmen(y4, m1, n1)
			end
		end
	end
end

def verschiebungBestimmen(x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6)
	x1, y1, x2, y2, x3, y3 = koordinatenUmsortieren(x1, y1, x2, y2, x3, y3)
	x4, y4, x5, y5, x6, y6 = koordinatenUmsortieren(x4, y4, x5, y5, x6, y6)
	verschiebung = [linienZusammenSchieben(x1, y1, x2, y2, x4, y4, x5, y5), linienZusammenSchieben(x1, y1, x2, y2, x5, y5, x6, y6), linienZusammenSchieben(x1, y1, x2, y2, x4, y4, x6, y6), linienZusammenSchieben(x2, y2, x3, y3, x4, y4, x5, y5), linienZusammenSchieben(x2, y2, x3, y3, x5, y5, x6, y6), linienZusammenSchieben(x2, y2, x3, y3, x4, y4, x6, y6), linienZusammenSchieben(x1, y1, x3, y3, x4, y4, x5, y5), linienZusammenSchieben(x1, y1, x3, y3, x5, y5, x6, y6), linienZusammenSchieben(x1, y1, x3, y3, x4, y4, x6, y6)]
	verschiebung -= [nil]
	verschiebung.reject! &:nan?
	return verschiebung.min
end

def naechstesDreieckBestimmen(uebrigeDreiecke, dreiecke, derzeitigerWinkel)
	nochPassendeDreiecke = Array.new
	i = 0
	while i < uebrigeDreiecke.length
		minWinkel = dreiecke[uebrigeDreiecke[i]][9 + dreiecke[uebrigeDreiecke[i]][12]]
		maxKante = dreiecke[uebrigeDreiecke[i]][6 + dreiecke[uebrigeDreiecke[i]][13]]
		
		if minWinkel <= derzeitigerWinkel
			nochPassendeDreiecke.push([maxKante, uebrigeDreiecke[i]])
		end
		i += 1
	end
	nochPassendeDreiecke.sort!
	if nochPassendeDreiecke.length == 0
		return nil
	end
	
	if derzeitigerWinkel >= 45
		return nochPassendeDreiecke[-1][1]
	else
		return nochPassendeDreiecke[0][1]
	end
end

def dreieckAufBodenStellen(num, dreieck)
	a = dreieck[6]
	b = dreieck[7]
	c = dreieck[8]
	alpha = dreieck[9]
	beta = dreieck[10]
	gamma = dreieck[11]
	
	case num
	when 0
		x1 = 0.0
		y1 = 0.0
		x2 = a
		y2 = 0.0
		x3, y3 = zweitenPunkteAufWinkelDrehen(x1, y1, c, beta)
	when 1
		x1 = 0.0
		y1 = 0.0
		x2 = b
		y2 = 0.0
		x3, y3 = zweitenPunkteAufWinkelDrehen(x1, y1, a, gamma)
	when 2
		x1 = 0.0
		y1 = 0.0
		x2 = c
		y2 = 0.0
		x3, y3 = zweitenPunkteAufWinkelDrehen(x1, y1, b, alpha)
	end
	return x1, y1, x2, y2, x3, y3
end

def naechstesDreieckBestimmen2(x1, y1, x2, y2, x3, y3, uebrigeDreiecke, dreiecke, spiegelDreiecke)
	maxKanten = Array.new
	i = 0
	while i < uebrigeDreiecke.length
		maxKanten.push([dreiecke[uebrigeDreiecke[i]][6 + dreiecke[uebrigeDreiecke[i]][12]], uebrigeDreiecke[i]])
		i += 1
	end
	maxKanten.sort!
	dreieck = dreiecke[maxKanten[-1][1]]
	spiegelDreieck = spiegelDreiecke[maxKanten[-1][1]]
	
	x4, y4, x5, y5, x6, y6 = dreieckAufBodenStellen(dreieck[12], dreieck)
	spiegelX4, spiegelY4, spiegelX5, spiegelY5, spiegelX6, spiegelY6 = dreieckAufBodenStellen(spiegelDreieck[12], spiegelDreieck)
	
	verschiebung = Array.new
	spiegelVerschiebung = Array.new
	i = 0
	while i < x1.length
		verschiebung.push(verschiebungBestimmen(x1[i], y1[i], x2[i], y2[i], x3[i], y3[i], x4, y4, x5, y5, x6, y6))
		spiegelVerschiebung.push(verschiebungBestimmen(x1[i], y1[i], x2[i], y2[i], x3[i], y3[i], spiegelX4, spiegelY4, spiegelX5, spiegelY5, spiegelX6, spiegelY6))
		i += 1
	end
	
	min = verschiebung.min
	x4 -= min
	x5 -= min
	x6 -= min
	spiegelMin = spiegelVerschiebung.min
	spiegelX4 -= spiegelMin
	spiegelX5 -= spiegelMin
	spiegelX6 -= spiegelMin
	
	if [x4, x5, x6].max > [spiegelX4, spiegelX5, spiegelX6].max
		return x4, y4, x5, y5, x6, y6, false, maxKanten[-1][1]
	else
		return spiegelX4, spiegelY4, spiegelX5, spiegelY5, spiegelX6, spiegelY6, true, maxKanten[-1][1]
	end
end

def dreieckeLegen(dreiecke, spiegelDreiecke)
	alleDreiecke = dreiecke + spiegelDreiecke
	l = dreiecke.length
	i = 0
	alleKombinationen = Array.new
	
	while i < alleDreiecke.length
		erstesDreieck = alleDreiecke[i]
		
		num = 0
		while num < 3
			idListe = Array.new
			uebrigeDreiecke = Array.new(l) {|a| a}
			if i > l
				idListe.push([i.dup-l, true])
				uebrigeDreiecke.delete_at(i-l)
			else
				idListe.push([i.dup, false])
				uebrigeDreiecke.delete_at(i)
			end
			
			x1 = Array.new
			y1 = Array.new
			x2 = Array.new
			y2 = Array.new
			x3 = Array.new
			y3 = Array.new
			erstesX1, erstesY1, erstesX2, erstesY2, erstesX3, erstesY3 = dreieckAufBodenStellen(num, erstesDreieck)
			
			x1[0], y1[0], x2[0], y2[0], x3[0], y3[0] = koordinatenUmsortieren(erstesX1, erstesY1, erstesX2, erstesY2, erstesX3, erstesY3)
			
			while uebrigeDreiecke.length > 0
				if y1[-1] == y2[-1]
					dw = winkelVonZweiPunktenBestimmen(x2[-1], y2[-1], x3[-1], y3[-1])
				else
					dw = [winkelVonZweiPunktenBestimmen(x1[-1], y1[-1], x2[-1], y2[-1]), winkelVonZweiPunktenBestimmen(x1[-1], y1[-1], x3[-1], y3[-1])].min
				end
				
				naechstesDreieck = naechstesDreieckBestimmen(uebrigeDreiecke, dreiecke, dw)
				
				if naechstesDreieck == nil
					x4, y4, x5, y5, x6, y6, istGespiegelt, id = naechstesDreieckBestimmen2(x1, y1, x2, y2, x3, y3, uebrigeDreiecke, dreiecke, spiegelDreiecke)
					idListe.push([id, istGespiegelt])
					uebrigeDreiecke.delete_at(uebrigeDreiecke.index(id))
				else
					dreieck = dreiecke[naechstesDreieck]
					spiegelDreieck = spiegelDreiecke[naechstesDreieck]
					
					derzeitigerTyp = typBestimmen(x1[-1], y1[-1], x2[-1], y2[-1], x3[-1], y3[-1])
					case derzeitigerTyp
					when 1
						x4, y4, x5, y5, x6, y6 = dreieckeAneinanderLegen(x1[-1], y1[-1], x2[-1], y2[-1], x3[-1], y3[-1], dreieck[12], dreieck)
						spiegelX4, spiegelY4, spiegelX5, spiegelY5, spiegelX6, spiegelY6 = dreieckeAneinanderLegen(x1[-1], y1[-1], x2[-1], y2[-1], x3[-1], y3[-1], spiegelDreieck[12], spiegelDreieck)
					when 2
						x4, y4, x5, y5, x6, y6 = dreieckeAneinanderLegen(x1[-1], y1[-1], x2[-1], y2[-1], x3[-1], y3[-1], dreieck[12] + 3, dreieck)
						spiegelX4, spiegelY4, spiegelX5, spiegelY5, spiegelX6, spiegelY6 = dreieckeAneinanderLegen(x1[-1], y1[-1], x2[-1], y2[-1], x3[-1], y3[-1], spiegelDreieck[12] + 3, spiegelDreieck)
					when 3
						x4, y4, x5, y5, x6, y6 = dreieckeAneinanderLegen(x2[-1], y2[-1], x1[-1], y1[-1], x3[-1], y3[-1], dreieck[12], dreieck)
						spiegelX4, spiegelY4, spiegelX5, spiegelY5, spiegelX6, spiegelY6 = dreieckeAneinanderLegen(x2[-1], y2[-1], x1[-1], y1[-1], x3[-1], y3[-1], spiegelDreieck[12], spiegelDreieck)
					end
					
					verschiebung = Array.new
					spiegelVerschiebung = Array.new
					z = 0
					while z < x1.length
						verschiebung.push(verschiebungBestimmen(x1[z], y1[z], x2[z], y2[z], x3[z], y3[z], x4, y4, x5, y5, x6, y6))
						spiegelVerschiebung.push(verschiebungBestimmen(x1[z], y1[z], x2[z], y2[z], x3[z], y3[z], spiegelX4, spiegelY4, spiegelX5, spiegelY5, spiegelX6, spiegelY6))
						z += 1
					end
					min = verschiebung.min
					spiegelMin = spiegelVerschiebung.min
					x4 -= min
					x5 -= min
					x6 -= min
					spiegelMin = spiegelVerschiebung.min
					spiegelX4 -= spiegelMin
					spiegelX5 -= spiegelMin
					spiegelX6 -= spiegelMin
					
					if [x4, x5, x6].max > [spiegelX4, spiegelX5, spiegelX6].max
						x4, y4, x5, y5, x6, y6 = spiegelX4, spiegelY4, spiegelX5, spiegelY5, spiegelX6, spiegelY6
						idListe.push([naechstesDreieck, true])
					else
						idListe.push([naechstesDreieck, false])
					end
					uebrigeDreiecke.delete_at(uebrigeDreiecke.index(naechstesDreieck))
				end
				
				x1.push(x4)
				y1.push(y4)
				x2.push(x5)
				y2.push(y5)
				x3.push(x6)
				y3.push(y6)
			end
			
			distanz = x1[-1] - x2[0]
			alleKombinationen.push([distanz, x1, y1, x2, y2, x3, y3, idListe])
			
			num += 1
		end
		
		i += 1
	end
	return alleKombinationen.min
end

def dreieckeEinlesen(datei)
	dreiecke = Array.new
	spiegelDreiecke = Array.new
	
	liste = File.open(datei).read.force_encoding("UTF-8").split("\n")
	
	i = 1
	while i < liste.length
		zeile = liste[i].split(" ")
		
		x1 = zeile[1].to_f
		y1 = zeile[2].to_f
		x2 = zeile[3].to_f
		y2 = zeile[4].to_f
		x3 = zeile[5].to_f
		y3 = zeile[6].to_f
		
		spiegelX1, spiegelY1, spiegelX2, spiegelY2, spiegelX3, spiegelY3 = spiegelDreieck(x1, y1, x2, y2, x3, y3)
		
		xMitte, yMitte = mittelpunktVonUmkreisBestimmen(x1, y1, x2, y2, x3, y3)
		
		spiegelXMitte, spiegelYMitte = mittelpunktVonUmkreisBestimmen(spiegelX1, spiegelY1, spiegelX2, spiegelY2, spiegelX3, spiegelY3)
		
		w1 = winkelVonZweiPunktenBestimmen(xMitte, yMitte, x1, y1)
		w2 = winkelVonZweiPunktenBestimmen(xMitte, yMitte, x2, y2)
		w3 = winkelVonZweiPunktenBestimmen(xMitte, yMitte, x3, y3)
		
		spiegelW1 = winkelVonZweiPunktenBestimmen(spiegelXMitte, spiegelYMitte, spiegelX1, spiegelY1)
		spiegelW2 = winkelVonZweiPunktenBestimmen(spiegelXMitte, spiegelYMitte, spiegelX2, spiegelY2)
		spiegelW3 = winkelVonZweiPunktenBestimmen(spiegelXMitte, spiegelYMitte, spiegelX3, spiegelY3)
		
		r = distanzVonZweiPunktenBestimmen(xMitte, yMitte, x1, y1)
		
		a = distanzVonZweiPunktenBestimmen(x2, y2, x3, y3)
		b = distanzVonZweiPunktenBestimmen(x3, y3, x1, y1)
		c = distanzVonZweiPunktenBestimmen(x1, y1, x2, y2)
		spiegelA = distanzVonZweiPunktenBestimmen(spiegelX1, spiegelY1, spiegelX3, spiegelY3)
		spiegelB = distanzVonZweiPunktenBestimmen(spiegelX3, spiegelY3, spiegelX2, spiegelY2)
		spiegelC = distanzVonZweiPunktenBestimmen(spiegelX2, spiegelY2, spiegelX1, spiegelY1)
		
		alpha, beta, gamma = innenwinkelBestimmen(a, b, c)
		spiegelAlpha, spiegelBeta, spiegelGamma = innenwinkelBestimmen(spiegelA, spiegelB, spiegelC)
		
		min = [alpha, beta, gamma].index([alpha, beta, gamma].min)
		max = [alpha, beta, gamma].index([alpha, beta, gamma].max)
		spiegelMin = [spiegelAlpha, spiegelBeta, spiegelGamma].index([spiegelAlpha, spiegelBeta, spiegelGamma].min)
		spiegelMax = [spiegelAlpha, spiegelBeta, spiegelGamma].index([spiegelAlpha, spiegelBeta, spiegelGamma].max)
		
		dreiecke.push([xMitte, yMitte, w1, w2, w3, r, a, b, c, alpha, beta, gamma, min, max])
		
		spiegelDreiecke.push([spiegelXMitte, spiegelYMitte, spiegelW1, spiegelW2, spiegelW3, r, spiegelA, spiegelB, spiegelC, spiegelAlpha, spiegelBeta, spiegelGamma, spiegelMin, spiegelMax])
		
		i += 1
	end
	return dreiecke, spiegelDreiecke
end

puts "Gebe den Namen der einzulesenen .txt Datei ein:"
dreiecke, spiegelDreiecke = dreieckeEinlesen(gets.chomp)
t = Time.now
ergebnis = dreieckeLegen(dreiecke, spiegelDreiecke)
svg = ""
puts "Es wurde der folgende minimale Gesamtabstand berechnet: #{ergebnis[0]} Meter\nEs handelt sich bei dieser Lösung nicht zwangsweise um die optimalste Lösung, sondern ausschließlich um eine Annäherung an diese."
x1 = ergebnis[1].min
x2 = ergebnis[3].min
x3 = ergebnis[5].min
verschiebung = [x1, x2, x3].min
i = 0
puts "ID	|ist Gespiegelt	| x1|y1 | x2|y2 | x3|y3\n\n"
while i < ergebnis[1].length
	svg += SVGPolygonAusKoordinaten(ergebnis[7][i][0], ergebnis[7][i][1], ergebnis[1][i] - verschiebung, ergebnis[2][i], ergebnis[3][i] - verschiebung, ergebnis[4][i], ergebnis[5][i] - verschiebung, ergebnis[6][i])
	puts "D#{ergebnis[7][i][0]+1}	|#{ergebnis[7][i][1]}		| #{ergebnis[1][i] - verschiebung}|#{ergebnis[2][i]} | #{ergebnis[3][i] - verschiebung}|#{ergebnis[4][i]} | #{ergebnis[5][i] - verschiebung}|#{ergebnis[6][i]}"
	i += 1
end

newSVGName = "#{Time.now.to_s[0..-7].gsub!(":", "-")}.svg"
newSVG = File.new(newSVGName, "w+")
newSVG.write("<svg version='1.1' viewBox='0 0 1800 620' xmlns='http://www.w3.org/2000/svg'><g transform='scale(1 -1)'><g transform='translate(0 -600)'><line xmlns='http://www.w3.org/2000/svg' id='y' x1='0' x2='1800' y1='0' y2='0' fill='none' stroke='#000000' stroke-width='1'/>#{svg}</g></g></svg>")
newSVG.close
puts "Die Lösung wurde in folgender Datei visuell gespeichert: #{newSVGName}"
t2 = Time.now
puts "Die Lösung wurde in folgender Zeit berechnet:\nStartzeit: #{t}\nEndzeit: #{t2}\nDifferenz: #{t2-t}"