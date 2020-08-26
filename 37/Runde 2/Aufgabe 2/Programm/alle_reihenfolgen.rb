def getNum(int)
	num = int
	int -= 1
	while int > 0
		num *= int
		int -= 1
	end
	return num
end

def naechsteZahl(benutzt, derzeitigeZahl, ende)
	gefunden = false
	while not gefunden
		if derzeitigeZahl < ende
			derzeitigeZahl += 1
		else
			derzeitigeZahl = 0
		end
		if benutzt.index(derzeitigeZahl) == nil
			gefunden = true
		end
	end
	return derzeitigeZahl
end


def vertauschen
	i = 0
    puts "Gib die Anzahl der zu vertauschenden Objekte an:"
	a = Array.new(gets.chomp.to_i)
	b = Array.new
	c = Array.new(a.length)

	while i < a.length
		a[i] = i
		c[c.length - i - 1] = getNum(i + 1) / (i + 1)
		i += 1
	end

	zaehler = Array.new(a.length, 0)
	z = 0
	while z < getNum(a.length)
		pp a
		i = 0
		b = Array.new
		while i < a.length
			if zaehler[i] == c[i] - 1
				a[i] = naechsteZahl(b, a[i], a.length - 1)
				zaehler[i] = 0
			else
				zaehler[i] += 1
			end
			
			b.push(a[i])
			i += 1
		end
		
		z += 1
	end
end
vertauschen
