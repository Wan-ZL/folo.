# clean saveFile
saveFile = open('course_detail_without_none','w')
saveFile.write("")


theFile = open('course_detail', 'r')
saveFile = open('course_detail_without_none','a')

for line in theFile:
    print line[-5:]
    if "None\n" != line[-5:]:
        saveFile.write(line)
