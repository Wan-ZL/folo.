import urllib
import re
import xml.etree.ElementTree as ET
import time


subject_code = []
# read file
thefile = open('subject_code', 'r')
for line in thefile:
    subject_code.append(line[:-1])



course_number = []
# read URL1
for x in range(0, len(subject_code)):
    time.sleep(1)
    URL = "https://ws.uits.arizona.edu/UA_Courses/courses?subject_code="+subject_code[x]+"&term_code=2181"
    urlOpen = urllib.urlopen(URL)
    urlContent = urlOpen.read()
    urlRoot = ET.fromstring(urlContent)
    eachCourse = subject_code[x]
    for y in range(0, len(urlRoot)):
        eachCourse = eachCourse+","+urlRoot[y][2].text
    print eachCourse
    course_number.append(eachCourse)

#save to file
saveFile = open('course_number','w')
for item in course_number:
    saveFile.write("%s\n" % item)
