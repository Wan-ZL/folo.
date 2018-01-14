import urllib
import re
import xml.etree.ElementTree as ET
import time


# empty file
emptyFile = open('course_detail','w')
emptyFile.write("")

course_number = []
#read file
thefile = open('course_number','r')
for line in thefile:
    course_number.append(line[:-1].split(","))


# read URL
#for subject in range(0, 1):
    #for number in range(1, 2):
for subject in range(0, len(course_number)):
    for number in range(1, len(course_number[subject])):
        time.sleep(0.1)
        URL = "https://ws.uits.arizona.edu/UA_Courses/crsdetail?subject_code="+course_number[subject][0]+"&catalog_nbr="+course_number[subject][number]+"&term_code=2181"
        urlOpen = urllib.urlopen(URL)
        urlContent = urlOpen.read()
        urlRoot = ET.fromstring(urlContent)

        # courseDetail
        courseDetail = []

        if len(urlRoot) is 0:
            print "urlRoot is 0, new loop"
            continue
        # subject is all same
        for courseSize in range(0, len(urlRoot[0])-1):
            courseDetail.append(course_number[subject][0])


        # catalogNumber is all same
        for courseSize in range(0, len(urlRoot[0])-1):
            courseDetail[courseSize] = courseDetail[courseSize]+","+course_number[subject][number]

        # add section
        for courseSize in range(0, len(urlRoot[0])-1):
            tempCheck = urlRoot[0][courseSize+1].find('{http://uamobile.arizona.edu/schema/UA_Courses}section')
            if tempCheck is not None:
                courseDetail[courseSize] = courseDetail[courseSize]+","+tempCheck.text


        # add class number
        for courseSize in range(0, len(urlRoot[0])-1):
            tempCheck = urlRoot[0][courseSize+1].find('{http://uamobile.arizona.edu/schema/UA_Courses}class_nbr')
            if tempCheck is not None:
                courseDetail[courseSize] = courseDetail[courseSize]+","+tempCheck.text


        # add course type
        for courseSize in range(0, len(urlRoot[0])-1):
            tempCheck = urlRoot[0][courseSize+1].find('{http://uamobile.arizona.edu/schema/UA_Courses}course_type')
            if tempCheck is not None:
                courseDetail[courseSize] = courseDetail[courseSize]+","+tempCheck.text


        # add course instructor
        for courseSize in range(0, len(urlRoot[0])-1):
            tempCheck = urlRoot[0][courseSize+1].find('{http://uamobile.arizona.edu/schema/UA_Courses}MeetingCollection')
            if tempCheck is not None:
                tempCheck2 =  tempCheck[0].find('{http://uamobile.arizona.edu/schema/UA_Courses}InstructorCollection')
                if tempCheck2 is not None:
                    tempCheck3 = tempCheck2[0].find('{http://uamobile.arizona.edu/schema/UA_Courses}fullname')
                    if tempCheck3 is not None:
                        courseDetail[courseSize] = courseDetail[courseSize]+","+tempCheck3.text


        # add locationi
        for courseSize in range(0, len(urlRoot[0])-1):
            tempCheck = urlRoot[0][courseSize+1].find('{http://uamobile.arizona.edu/schema/UA_Courses}MeetingCollection')
            if tempCheck is not None:
                tempCheck2 =  tempCheck[0].find('{http://uamobile.arizona.edu/schema/UA_Courses}location')
                if tempCheck2 is not None:
                    if tempCheck2.text is not None:
                        tempSplit = tempCheck2.text.split(",")
                        if len(tempSplit) is 1:
                            courseDetail[courseSize] = courseDetail[courseSize]+","+tempSplit[0]+","+tempSplit[0]
                        else:
                            courseDetail[courseSize] = courseDetail[courseSize]+","+tempSplit[0]+","+tempSplit[1][1:]
                    else:
                        courseDetail[courseSize] = courseDetail[courseSize]+","+"None"+","+"None"


        # write to file
        saveFile = open('course_detail','a')
        for item in courseDetail:
            saveFile.write("%s\n" % item)
            print item
