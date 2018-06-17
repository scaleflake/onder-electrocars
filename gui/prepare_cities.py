import json

# data = {
# 	"country1": {
# 		"city1": [0.0, 0.0],
# 		"city2": [0.1, 0.1]
# 	},
# 	"country2": {
# 		"city3": [0.2, 0.2],
# 		"city4": [0.3, 0.3]
# 	}
# }
cities = {}
countries = []

infile = open('cities.csv', 'rb')
lines = infile.readlines()
for line in lines:
	items = line.replace('"', '').replace('\n', '').split(';')
	if not items[1] in cities:
	 	cities[items[1]] = { items[2]: [items[3], items[4]] }
	 	countries.append(items[1])
	else:
	 	cities[items[1]][items[2]] = [items[3], items[4]]

outfile = open("cities.json", "w")
outfile.write(json.dumps(cities, sort_keys=False, indent=4, separators=(',', ': '), ensure_ascii=False))
outfile = open("countries.json", "w")
outfile.write(json.dumps(countries, sort_keys=False, indent=4, separators=(',', ': '), ensure_ascii=False))