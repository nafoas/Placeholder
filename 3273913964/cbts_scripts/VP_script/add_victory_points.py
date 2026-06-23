import os
import codecs
import pathlib
import numpy as np
import pandas as pd



#get path
path = ''
if 'states' in str(pathlib.Path(__file__).parent.absolute()):
    path = '.'

elif 'VP_script' in str(pathlib.Path(__file__).parent.absolute()):
    path = '../../history/states'

else:
    print('Error: unknown directory!')
    exit()



# read csv
vp_list = pd.read_csv("./vp.csv", engine='python', dtype={'name':str,'province_id':np.int32,'vp_value':np.int32}, na_values = ['ERROR: na'])
#vp_list_len = len(vp_list['name'])

print('Creating new VPs...')
loc_output = []
# go through all states
for file in os.listdir(path):
    if file.endswith('.txt'):

        with open(path + '/' + file, "r") as f:
            state_content = f.readlines()


        # get state provinces
        provinces_in_state = []
        get_provinces = False
        for line in state_content:
            # get provinces in state to match new VP destination
            if 'provinces' in line and get_provinces == False:
                get_provinces = True
                continue
            elif '}' in line and get_provinces == True:
                get_provinces = False
                break
            elif get_provinces == True:
                provinces_in_state += line.split()


        # insert new VPs
        j = 0
        for line in state_content:
            # inject new VPs
            if 'history' in line:
                line_content = line

                i = 0
                for vp_id in vp_list['province_id']:
                    if str(vp_id) in provinces_in_state:

                        if '{' in line:
                            line_content += '\t\tvictory_points = {\n\t\t\t' + str(vp_list['province_id'][i]) + ' ' + str(vp_list['vp_value'][i]) + '\n\t\t}\n'
                            state_content[j] = line_content
                        else:
                            line_content = state_content[j+1] + '\t\tvictory_points = {\n\t\t\t' + str(vp_list['province_id'][i]) + ' ' + str(vp_list['vp_value'][i]) + '\n\t\t}\n'
                            state_content[j+1] = line_content

                        loc_output.append(' VICTORY_POINTS_' + str(vp_list['province_id'][i]) + ':0 "' + str(vp_list['name'][i]) + '"\r\n')

                    i += 1
            j += 1


        with open(path + '/' + file, "w") as f:
            f.writelines(state_content)



# write new loc
print('Writing localization...')


path = ''
if 'states' in str(pathlib.Path(__file__).parent.absolute()):
    path = '..\\..\\'

elif 'VP_script' in str(pathlib.Path(__file__).parent.absolute()):
    path = '..\\..\\'


old_loc = []
with codecs.open(path + 'localisation\\victory_points_l_english.yml', encoding='utf-8') as f:
    old_loc = f.readlines()

with codecs.open(path + 'localisation\\victory_points_l_english.yml', 'w', encoding='utf-8') as f:
    f.writelines(old_loc + loc_output)



print('All done!')
