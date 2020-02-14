import json
import datetime

def parse_json (file_in, file_out):

  templ_eql = open (file_out, 'a')

  new_str = ''

  json_data = open (file_in)
  data = json.load (json_data)
#  print row_descr

  for nodes in data:
    new_str = ''

    nid = (nodes['date']).encode('cp1251')
    title = (nodes['title']).encode('cp1251')

    new_str = '"' +nid+'"'+';'+'"'+title+'"'

    templ_eql.write (new_str+"\n");

  json_data.close ()
  templ_eql.close ()

def parse_json_blcks (file_in, file_out):

  templ_blc_eql = open (file_out, 'a')

  new_strng = ''

  json_data_bl = open (file_in)
  data_bl = json.load (json_data_bl)

  for nodes_bl in data_bl:
    tpl = str(nodes_bl)
    for blck in data_bl[nodes_bl]:
      new_strng = '"' + str(tpl)+ '"' + ';' +'"'+str(blck)+'"'
      templ_blc_eql.write (new_strng+"\n");

  json_data_bl.close ()
  templ_blc_eql.close ()

def keyCheck(key, arr, default):
    if key in arr.keys():
        return arr[key]
    else:
        return default

def parse_json_blcks_sets (eql_tpl_name, file_in, file_out):

  templ_blc_sets_eql = open (file_out, 'a')

  new_strng = ''

  json_data_bl_sets = open(file_in)
  data_bl = json.load(json_data_bl_sets)

  for nodes in data_bl:
     new_strng = '"'+ str(nodes['id'])+ '"' + ';'+ eql_tpl_name + ';'+'"' + nodes['name'].encode('cp1251') + '"' + ';'+'"' + str(nodes['regions']['r1']) + '"' + ';'+'"' + str(keyCheck('r2', nodes['regions'], '')) + '"' + ';'+'"' + str(keyCheck('r3',nodes['regions'], '')) + '"' + ';'+'"' + str(keyCheck('r4', nodes['regions'], '')) + '"' + ';'+'"' + str(keyCheck('r5', nodes['regions'], '')) + '"'
     print new_strng
     templ_blc_sets_eql.write (new_strng+"\n");

  json_data_bl_sets.close ()
  templ_blc_sets_eql.close ()
