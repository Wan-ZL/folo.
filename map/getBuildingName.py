import urllib
import re
import xml.etree.ElementTree as ET


URL = "http://map.arizona.edu/json/buildings.json"
content = urllib.urlopen(URL)
word = content.read()

#word = '"Name": "Al-Marah - Caretaker Residence","AliasName": " "'

building_list= re.findall(r'"Name":"[^"]+',word)

my_dict = {}
for x in range(0,len(building_list)):   #add all building to dictionary
    building_switch = building_list[x][8:]
    building_switch = building_switch.replace("("," ")  #replace ( to space
    building_switch = building_switch.replace(")"," ")  #replace ) to space
    building_switch = building_switch.replace("\\"," ")  #replace \ to space
    building_switch = building_switch.replace("-"," ")  #replace - to space
    my_dict[building_switch] = 0;

key_list = my_dict.keys()

map_file = open("map.osm","r")
map_content = map_file.read()
root = ET.fromstring(map_content)
#for way in root.findall('way'):
    #for building_name in way.findall('tag'):
        #print building_name.get('v')

#for x in range(0, len(key_list)):
for x in range(0, 2):
    search_words = key_list[x].split()
    print key_list[x]

    for y in range(0, len(search_words)):
        if(len(search_words[y]) > 2):       #only search words at least 3 lenght

            print 'searching: '+search_words[y]
            coodination = re.search(r'\b'+search_words[y],map_content)
            if coodination is not None: # find the word
                coodination = coodination.group(0)
                print coodination
                for way in root.findall('way'):
                    for building_name in way.findall('tag'):
                        origin_building_name = building_name.get('v')




                #print coodination

    #coodination = re.search(r'key_list[x]',map_content)
    #print key_list[x]



#print word_list
