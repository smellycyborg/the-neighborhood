local List = {
	"K",
	"M",
	"B",
	"T",
	"Qd",
	"Qn",
	"Sx",
	"Sp",
	"O",
	"N" 
}

return function(number)
    local ListCount = 0
	
    while number / 1000 >= 1 do
        ListCount = ListCount + 1 
        number = number / 1000 
	end
	
	if ListCount == 0 then 
		return number end 
    return math.floor(number*10)/10 ..List[ListCount]
end