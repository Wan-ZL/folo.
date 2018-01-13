import urllib
import re

URL = "http://map.arizona.edu/json/buildings.json"
content = urllib.urlopen(URL)
word = content.read()

#word = '"Name": "Al-Marah - Caretaker Residence","AliasName": " "'

building_list= re.findall(r'"Name":"[^"]+',word)

my_dict = {}
for x in range(0,len(building_list)):
    my_dict[building_list[x][8:]] = 0;

for value in my_dict.iteritems():
    print value



#print word_list
