#!/usr/bin/env python3
#
# Change all UUIDs in all Postman files
#
# Use this WHEN EVER you copy contents of one postman collection or
# environment to another or copy any of these files to another project
#

import os, re
from glob import glob
from uuid import uuid4

# ensure we are in the 'postman' directory
os.chdir(os.path.dirname(__file__))

# Create a new output directory so we can review changes
OUT_DIR = 'updated'
if not os.path.exists(OUT_DIR):
    os.mkdir(OUT_DIR)

# Postman exports environments with space indention
# match:   "id": "ebee9025-11b4-417d-b47b-9ca1e6d69b91",
pattern1 = re.compile('[ \t]*"id": "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",')
# Postman exports collections with tab indention
# match: 		"_postman_id": "f5dc5056-3b28-446b-ab1c-1dd2e5cf46a3",
pattern2 = re.compile('[ \t]*"_postman_id": "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",')

for file in glob('*.json'):
    print(file)

    infile = open(file, 'r')
    outfile = open(os.path.join(OUT_DIR, file), 'w')

    for line in infile:
        if pattern1.match(line) or pattern2.match(line):
            print("  old: {}".format(line), end='')
            line = "{} \"{}\",\n".format(line[0:line.find(':')+1], uuid4())
            print("  new: {}".format(line), end='')
        outfile.write(line)

    infile.close()
    outfile.close()
