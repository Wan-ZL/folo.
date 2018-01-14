import requests
import json
import os

url = 'http://127.0.0.1:9000/v1/building/createBuilding'
filename = 'all_building_name'

def main():
    enc = 'iso-8859-15'
    content = open(filename,'r',encoding=enc)
    while True:
        line = content.readline()
        if not line:
            break
        detail = line.split(',')
        name = detail[0]
        latitude = detail[1]
        longitude = detail[2]
        data = {'name': name, 'latitude': latitude, 'longitude': longitude}
        data = json.dumps(data)
        headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
        feedback = requests.post(url, data = data, headers= headers)
        print(feedback.json())


if __name__ == '__main__':
    main()
