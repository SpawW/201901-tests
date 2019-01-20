#!/usr/bin/env python3

import requests, datetime, json, argparse, re

parser=argparse.ArgumentParser()
parser.add_argument("--file", help="JSON file to convert.")
args=parser.parse_args()

import json, urllib, dicttoxml
page = urllib.urlopen('http://quandyfactory.com/api/example')
content = page.read()
obj = json.loads(content)
print(obj)
xml = dicttoxml.dicttoxml(obj)
print(xml)
