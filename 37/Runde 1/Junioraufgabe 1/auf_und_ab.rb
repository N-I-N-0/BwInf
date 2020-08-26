def start(z)
    i=0
    s=0
	$benutzteFelder = Array.new(100, 0)
    while i < 100 && zielErreichbar(i) do
		i+=z
        i = leiterBenutzen(i)
		i = zuruecklaufen(i)
		s=s+1
	end	
	if i==100
	    puts "Mit der Würfelzahl #{z} muss man #{s} mal würfeln, um das Ziel zu erreichen."
	else
	    puts "Mit der Würfelzahl #{z} scheint es nicht möglich zu sein, in das Ziel zu gelangen."
	end
end

def leiterBenutzen(i)
    if i==6
        i=27
	elsif i==27
	    i=6
	elsif i==14
	    i=19
	elsif i==19
	    i=14
	elsif i==21
	    i=53
	elsif i==53
	    i=21
	elsif i==31
	    i=42
	elsif i==42
	    i=31
	elsif i==33
	    i=38
	elsif i==38
	    i=33
	elsif i==46
	    i=62
	elsif i==62
	    i=46
	elsif i==51
	    i=59
	elsif i==59
	    i=51
	elsif i==57
	    i=96
	elsif i==96
	    i=57
	elsif i==65
	    i=85
	elsif i==85
	    i=65
	elsif i==68
	    i=80
	elsif i==80
	    i=68
	elsif i==70
	    i=76
	elsif i==76
	    i=70
	elsif i==92
	    i=98
	elsif i==98
	    i=92
	end
	return i
end

def zuruecklaufen(i)
    if i>100
	    i=i-100
		i=100-i
	end
	return i
end

def zielErreichbar(i)
    if $benutzteFelder[i] > 2
		return false
	else
		$benutzteFelder[i] = $benutzteFelder[i] + 1
		return true
	end
end

start(1)
start(2)
start(3)
start(4)
start(5)
start(6)
