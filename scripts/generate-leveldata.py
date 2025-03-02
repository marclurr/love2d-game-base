#!/bin/env python3

import sys
import os
import logging
import xml.etree.ElementTree as ET

log = logging.getLogger(__name__)



def get_level_data_for(root):
    # log.info(f"Getting level data for {tmx_path}")
    data = root.findall("./layer/data")

    if len(data) >= 0:
        text = data[0].text.replace("\n","").split(",")
        values = [ int(x) for x in text if x ]
        return values

def get_object_data_for(root):
    tilewidth = int(root.attrib["tilewidth"])
    tileheight = int(root.attrib["tileheight"])

    result = []

    objects = root.find("./objectgroup")
    if objects is not None:
        for object in objects:
            obj_res = {}
            obj_res["type"] = int(object.attrib["gid"])
            obj_res["x"] = int(int(object.attrib["x"]) / tilewidth)
            obj_res["y"] = int(int(object.attrib["y"]) / tileheight - 1 )
            result.append(obj_res)
    return result

if len(sys.argv) < 2:
    log.error(f"At least two arguments required:\n\n\t{os.path.basename(sys.argv[0])} output_filename level1 [level2 .. leveln]")

print("local levels = {}")
for file in sys.argv[1:]:
    xml_tree = ET.parse(file)
    root = xml_tree.getroot()

    file_name = os.path.basename(file)
    level_name = file_name.replace(".tmx", "")
    level_data = get_level_data_for(root)
    level_objects = get_object_data_for(root)

    if level_data:
        out_obj = {
            "width" : int(root.attrib["width"]),
            "height": int(root.attrib["height"]),
            "tiles" : level_data,
            "objects" : level_objects
        }

        formatted = str(out_obj).replace("[", "{").replace("]","}").replace("'","").replace(":", " =")

        definition = f"levels[\"{level_name}\"] = {formatted}"

        print(definition)

print("return levels")

