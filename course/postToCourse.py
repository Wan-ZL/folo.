import requests
import json
import os

url = 'http://127.0.0.1:9000/v1/course/createCourse'
filename = 'course_detail_without_none'

def main():
    enc = 'iso-8859-15'
    content = open(filename,'r',encoding=enc)
    while True:
        line = content.readline()
        if not line:
            break
        detail = line.split(',')
        subject = detail[0]
        catalogNumber = detail[1]
        section = detail[2]
        number = detail[3]
        courseType = detail[4]
        instructor = detail[5]
        room = detail[6]
        location = detail[7]
        data = {
            'subject': subject,
            'catalogNumber': catalogNumber,
            'section': section,
            'number': number,
            'courseType': courseType,
            'instructor': instructor,
            'room': room,
            'location': location
        }
        data = json.dumps(data)
        headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
        feedback = requests.post(url, data = data, headers= headers)
        print(feedback.json())


if __name__ == '__main__':
    main()
