#!/usr/bin/env python

import yaml

with open("funnier.yml", 'r') as stream:
    try:
        print(yaml.load(stream))
    except yaml.YAMLError as exc:
        print(exc)
    print (yaml.load(stream['handlers'][name]))
