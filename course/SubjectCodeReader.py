import urllib
import re
import xml.etree.ElementTree as ET

# read URL
URL = "https://ws.uits.arizona.edu/UA_Courses/subjects?term_code=2181"
urlOpen = urllib.urlopen(URL)
urlContent = urlOpen.read()

urlRoot = ET.fromstring(urlContent)

subject_code = []

for x in range(0,len(urlRoot)):
    thecode = urlRoot[x][0].text
    if thecode[-1:] is not 'V':
        subject_code.append(thecode)

# save to file
thefile = open('subject_code','w')
for item in subject_code:
    thefile.write("%s\n" % item)
