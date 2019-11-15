#!/usr/bin/python3
'''
Computer Arcitecture @Fall2019 Makefile

'''


import glob
import os
import re
import sys
import subprocess
import shutil
import time
import argparse
from bullet import Bullet

# For Iverilog Compilation
IVERILOG = 'iverilog'
ICARUS_OPTIONS = '-Wall -Wno-timescale'
SUF = '.vvp'
SIMSUF = '.vcd'
SIMU = 'gtkwave'

DUMP_FN = 'cpu_dump.vcd'
TEST_FOLDER = 'modules'

possible_tests = []

# Parse command line arguments
parser = argparse.ArgumentParser()
parser.add_argument("-t", "--test", help="the name of the test you would like to run (alu.t.v)")
parser.add_argument("-w", "--gtk", help="option to run GTK wave on the generate waveform (y/n)") 

# COLORS!
RED   = "\033[1;31m"  
BLUE  = "\033[1;34m"
CYAN  = "\033[1;36m"
GREEN = "\033[0;32m"
YELLOW = '\033[1;33;40m'
iBLUE = '\033[2;34;37m'
RESET = "\033[0;0m"
BOLD    = "\033[;1m"
REVERSE = "\033[;7m"
end = '\n'

# https://stackoverflow.com/questions/287871/how-to-print-colored-text-in-terminal-in-python/3332860#3332860
class printn():

    def error_message(message):       
        sys.stdout.write(RED + message + RESET + end)
    
    def warning_message(message):
        sys.stdout.write(YELLOW + message + RESET + end)
    
    def healthy_message(message):
        sys.stdout.write(GREEN + message + RESET + end)
    
    def fun_message(message):
        sys.stdout.write(CYAN + message + RESET + end)
    

def get_input(test_list):
    args = parser.parse_args()
        
    if args.test: 
        test = args.test
    else:
        prompt = Bullet("Choose the test you would like to run: ", choices=test_list,bullet='*',margin=1)
        test = prompt.launch()
 
    if args.gtk:
        sim = "y" if args.gtk == 'y' else "n"
    else:
        sim = input("GTK Wave (y/n): ")

    return test, sim

def build_test_list(): #(boards, head):
    '''
    Goes through the base directory and adds each testbench to a list
    '''
    os.chdir(TEST_FOLDER)

    testFiles = glob.glob('*.t.v')
    # os.chdir(head)
    return testFiles

def build_test(test): #, dir, libs, head):
    '''
    builds Iverilog test
    '''
    out = IVERILOG + ' -o' + test[:-4] + SUF + ' ' + test + ' ' + ICARUS_OPTIONS 
    os.system(out)      #Write command to systems

def run_test(test):
    testName = test[:-4] + SUF
    if testName in glob.glob('*' + SUF):
        printn.healthy_message("Running Iverilog...")
        out = './' + testName
        os.system(out)
    else:
        printn.warning_message("Build failed")

def clean(test): #, dir, head):
    '''
    Goes into given directory and deletes all output files for a clean build
    '''
    files = glob.glob('*' + SUF)
    for f in files:
        os.remove(f)
    printn.healthy_message('Clean Build for %s'%(test))

def check_for_packages():
    '''
    Checks for Bullet 
    '''
    if 'bullet' not in sys.modules:
        permission = input("Download necessary packages for this Makefile? (y/n):")
        if permission:
            print("Installing libraries")
            os.system('sudo apt-get update')
            os.system('sudo apt-get install python3-pip')
            print("Installing python dependencies")
            os.system('sudo pip3 install -r bullet')

def run_simulation(test):
    wave = test[:-4] + SIMSUF
    simFiles = glob.glob('*.vcd')

    if wave in simFiles:
        os.system(SIMU + ' ' + wave)
    else:
        print("Waveform not found!") 



if __name__ == "__main__":
    '''

    '''

    # check_for_packages()

    cwd = os.getcwd() #get working directory
    possible_tests = build_test_list()    # Get a list of all tests

    test, sim = get_input(possible_tests)

    if test in possible_tests:
        # Run these commands

        printn.healthy_message("Compling Iverilog...")
        build_test(test)
        run_test(test)
        clean(test)

        #clean

        if(sim == 'y'):
                # flash_board(board, dir, libs, cwd)
                printn.fun_message("Running GTKwave...")
                run_simulation(test)
        else:
                printn.fun_message("no sim")
    else:
        
        printn.error_message("Not a possible test --%s--"%(test))
    message = "Thank you and have a nice day!"
    printn.warning_message(message)
    
