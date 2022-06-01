# -*- coding: utf-8 -*-
"""
Created on Thu Dec 01 16:40:58 2016

@author: Dana and Anja
"""



"""-------------LINGUISTIC TRAINING (CONDITION ONE)-------------------"""

from psychopy import visual, core, event, gui
import random, os
import itertools
import time as time 
from shlex import split as splitsh
import subprocess
from multiprocessing import Process
from time import sleep


"""---------------VARIABLES-----------------"""

                                                                        #popup
popup = gui.Dlg(title = "The Color Experiment")
popup.addField("ID:")
popup.addField("Gender:", choices = ["M","F","O"])
popup.addField("Age:")
popup.addField("Condition:", choices = [1,2])
popup.show()

if popup.OK:
    ID = popup.data[0]
    Gender = popup.data[1]
    Age = popup.data[2]
    condition = popup.data[3]
else:
    core.quit()

SAVE_FOLDER = "col_data"                                                # if no folder exists, make one called "col_data" and Save to folder
if not os.path.exists(SAVE_FOLDER):
    os.makedirs(SAVE_FOLDER)

                                                                        # Making a file name with ID
filename = "col_data/{}_col_exp_{}.csv".format(condition, ID)

                                                                        # Writing columns
with open(filename, "w") as f:
    f.write("ID, Gender, Age, condition, phase, rt, accuracy, color_distance, category\n")

win=visual.Window(units="norm", color="black", fullscr= True)          #def window and clock, text
clock = core.Clock()
text = visual.TextStim(win, units='norm', color="white", height = .06, pos= [0,0], wrapWidth=999)

                                                                        #defining where text will display (below rectangles)
sinji_text = visual.TextStim(win, text = "SINIJ", units='norm', color="white", height = .06, pos= [-0.6,0.05], wrapWidth=999)
boy_text = visual.TextStim(win, text = "GOLUBOY", units='norm', color="white", height = .06, pos= [0.6,0.05], wrapWidth=999)
9
max_time = 1700                                                          #run experiment for 15 minutes(900 sec)
start_time = time.time                                                  #initialize timer

colours= []                                                             #make list of colours
for i in range(10):
    red = -1
    green = -1+((2.0/10)*i)
    blue = 1
    colours.append([red,green,blue])
colour_pairs = [i for i in itertools.permutations(colours, 2)]


target_colour = random.choice(colours)                                  #randomly pair hues within list

    
sinji=[]                                                                #make list for sinji (dark) and gouloboy (light)
for i in range(5):
    red = -1
    green = -1+((1.0/5)*i)
    blue = 1
    sinji.append([red,green,blue])

gouloboy=[]
for i in range(5):
    red = -1
    green = 0+((1.0/5)*i)
    blue = 1
    gouloboy.append([red,green,blue])
    
                                                                        #coordinates of rectangles
col1rec = visual.Rect(win, units= "norm", width=0.2, height=(1.6/4.5), pos = [-0.5,0.3])
col2rec = visual.Rect(win, units= "norm", width=0.2, height=(1.6/4.5), pos = [0.5,0.3])
col3rec = visual.Rect(win, units= "norm", width=0.2, height=(1.6/4.5), pos = [0,-0.3])
col4rec = visual.Rect(win, units= "norm", width=0.6, height=(1.8/4.7), pos = [0,0])

trial = 0                                                               #do this so when we want to take a break between trials, it counts the trials (from 0)

"""--------------------Text-----------------"""

                                                                        #for experiment 
welcome = """Welcome to The Color Experiment! Sit back, relax and enjoy. We are very thankful for your participation.
Keep in mind that you may quit the experiment at any time, if you do not want to continue, just press 'escape'."""

infot = """When the experiment starts, there will be 3 colored rectangles shown. 
The bottom middle rectangle will be matching in color to either the top left, or top right rectangle.
You have to choose which rectangle you think is the same color by pressing the left or right arrowkey accordingly."""

infot2 = """When you are done with the first phase, a training session will begin. 
After the training session, you will continue to do the experiment again.
Instructions will be given at the time. You may press 'enter' to begin when you are ready."""

break_time = """Now you may have a short break to rest your eyes. Press enter to continue."""

end_first_trial = """The first trial has ended. Please rest your eyes for a moment before you continue.
Now the training session will begin."""
                                                                        #for condition one
intro1 = """Welcome to a 5 minute training session.
There will be two colours present at all times, Sinij and Goluboy.
Sinij is on the left, Goluboy is on the right.
There will be a target colour at the bottom center of the screen.
Please press the left arrow key if the color matches Sinij,
and the right arrow key if the colour matches Goluboy.
The session will start when you press enter."""

                                                                        #for condition two
intro2 = """Welcome to a 5 minute training session.
A colour will appear on the screen.
Please press the left arrow key if the colour is lighter than the previous,
or press the right arrow key is the colour is darker than the previous.
Press either left or right for the first colour (it doesn't matter).
The session will start when you press enter."""

                                                                        #message displayed during break
break_time = """Now you may have a short break to rest your eyes. Press enter to continue."""

                                                                        #ending message
end = """You are now finished with the training session and will continue to the experiment when you are ready."""

final_goodbye = """Thank you for participating in our experiment, you are now finished. Reward yourself with cake :)"""


"""----------------FUNCTIONS------------------"""


def show_info(string):                                                #make function to show instruction text
    text.text = string
    text.draw()
    win.flip()
    if end == True:
        keys = ['escape']
    else:
        keys = ['return', 'escape']
    key=event.waitKeys(keyList = keys)[0]
    if key == ['escape']:
        core.quit()
        
        

def init():                                                             #for some reason, this define 'trial' as global. it works ok.
  global trial
  if trial is None:
     print 'Trial needs to be initialized'
 
     
key = None 

def init2():                                                            #for some reason, this define 'key' as global. it works ok.
  global key
  if key is None:
     print 'key needs to be initialized'
     
stopwatch = None 

def init2():                                                            #for some reason, this define 'stopwatch' as global. it works ok.
  global stopwatch
  if key is None:
     print 'stopwatch needs to be initialized'

def make_scale_display(category):                                     #this is the loop for the coordinates for the 10 squares displayed
    for i, colour in enumerate(category):                               #enumerate calls the item in the list, and the item number, so we can loop
        y = 0.5
        start = -.9 if category == sinji else .3                        #position on screen for both colours
        x = start + i*.15                                                #start at -.9 and add incrimants of 0.15
        sted = [x,y]
        col_guide=visual.Rect(win, units= "norm", width=0.1, height=0.3, pos = sted, fillColor=colour)
        col_guide.draw()

#EXPERIMENT TRIALS
                                                                         # Function to run one colour discrimination trial
def choice_trial(colours):                                             #this function take a list of colors as input
                                                                         # prepares the function
    global trial
    trial += 1
    test_colour = random.choice(colours)                                 #randomizes the choice of colors
    col1rec.setFillColor(colours[0]) 
    col2rec.setFillColor(colours[1])
    col3rec.setFillColor(test_colour)
    col1rec.draw()
    col2rec.draw()
    col3rec.draw()
    test_start = win.flip()
    clock.reset()                                                       # Loop though that list + records the keypress + time
    key, test_answer = event.waitKeys(keyList=['right', 'left', 'escape'], timeStamped = True)[0]
    for colour_pair in colour_pairs:
        if test_colour == colours[0] and key == "left":
            accuracy = 1
        elif test_colour== colours[1] and key == "right":
            accuracy = 1
        elif key == 'escape':
            core.quit() 
        else: accuracy = 0
    rt = (test_answer - test_start)*1000                                # records time in ms
    return accuracy, rt
     
                                                                        # Run trials
def choice_trial_block(phase):
    for rep in range(2):                                               #repeat 2 times
        random.shuffle(colour_pairs)
    for colour_pair in colour_pairs:                                   #for item in list
        accuracy, rt = choice_trial(colour_pair)                       #record accuracy and rt 
        color_distance = abs(colour_pair[0][1]-colour_pair[1][1])
        col1_name = "sinji" if colour_pair[0] in sinji else "gouloboy"#tell python to name 'sinji' and 'gouloboy'
        col2_name = "sinji" if colour_pair[1] in sinji else "gouloboy"
        if col1_name == col2_name:                                     #tell python if colour categories are within or across
            category = """within"""
        else:
            category = """across"""
        with open(filename, "a") as f:                                #record variables in dataframe
            f.write("{},{},{},{},{},{},{},{},{}\n".format(ID, Gender, Age, condition, phase, rt, accuracy, color_distance,category))
        if trial % 10 == 0 and not trial % 180 == 0:                 #on every 10th trial, let them have a little break
           show_info(break_time)
           
#LINGUISTIC TRAINING
    
def con1_trial(self):                                                #make a function for one trial of colour practice
    global trial
    global key
    trial += 1
    target_colour = random.choice(colours) 
    make_scale_display(sinji)
    make_scale_display(gouloboy)                                       #show one square with sinji colour in top left corner of screen
    col3rec.setFillColor(target_colour)                                #show one square with gouloboy colour in top right corner of screen
    col3rec.draw()
    sinji_text.draw()
    boy_text.draw()
    win.flip()                                                         #draw and flip
    key = event.waitKeys(keyList=['right', 'left', 'escape'], timeStamped = True)[0]  
    if key[0] == 'escape':                                            #have specific list of accepted keys
        core.quit()
        

def block_trials():      
    start_time = clock.getTime()                                      #have function to run block of trials
    for rep in range(4):                                             #repeat 2 times
        random.shuffle(colours)
        for colour_pair in colour_pairs:
            con1_trial(colours)                                       #record variables in dataframe
            if trial % 10 == 0 and not trial % 180 == 0:            #on every 10th trial, let them have a little break
                show_info(break_time)
            if key == 'escape':
                core.quit()
            elif clock.getTime()- start_time > max_time:             #set time limit of 15 minutes
                break                                                #break moves on to the next called function
                                                                      #return to main experiment

#PERCEPTION TRAINING

def con2_trials(self):                                             #function for one trial
    global trial
    global key
    global colour_pairs
    trial += 1                                                       #count the number of trials (0 +1)
    target_colour = random.choice(colours)                           #randomizes the choice of colors 
    col4rec.setFillColor(target_colour)    
    col4rec.draw()                                                   # draw and flip
    win.flip()
    key, test_answer = event.waitKeys(keyList=['right', 'left', 'escape'], timeStamped = True)[0]
    if key == 'escape':
        core.quit()
        
def block_trials2():                                               #have function to run block of trials
    start_time = clock.getTime()
    for rep in range(37):
        random.shuffle(colours)
        for color in colours:
            con2_trials(colour_pairs)
            if trial % 10 == 0 and not trial % 180 == 0: 
                show_info(break_time)
            if key == 'escape':
                core.quit()
            elif clock.getTime()- start_time > max_time:             #set time limit of 15 minutes
                break                                                                      #return to main experiment

"""-------------------------RUNNING-----------------------------"""

show_info(welcome)
show_info(infot)
show_info(infot2)
choice_trial_block("pre-training")
show_info(end_first_trial)

if condition == 1 and not condition == 2:
    show_info(intro1)
    block_trials()
elif condition == 2 and not condition == 1: 
    show_info(intro2)
    block_trials2()
    
    
show_info(end)
choice_trial_block("post-training")
show_info(final_goodbye)


"""---------------------------------------------------------------"""