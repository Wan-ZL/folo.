dict = {}

thefile = open('location','r')
for line in thefile:
    dict[line] = 0

saveFile = open('all_building_name','a')
for key in dict.keys():
    saveFile.write(key)
