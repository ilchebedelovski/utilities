#!/usr/bin/python

# Script for tracking running Linux process and receiving info for resources usage

import time
import string
import sys
import commands
import csv
import xlwt
from subprocess import Popen, PIPE
from re import split
from sys import stdout

class Proc(object):

    def __init__(self, procInfo):
        self.user = procInfo[0]
        self.pid = procInfo[1]
        self.cpu = procInfo[2]
        self.mem = procInfo[3]
        
    def pidToStr(self):
        return '%s' % self.pid
    
    def cpuToStr(self):
        return '%s' % self.cpu
    
    def memToStr(self):
        return '%s' % self.mem

def getCpuMem(pid):
    d = [i for i in commands.getoutput("ps aux").split("\n")
        if i.split()[1] == str(pid)]
    return (float(d[0].split()[2]), float(d[0].split()[3])) if d else None

# for getting resources by process
def getProcessIds():
    procList = []
    subProc = Popen(['ps', 'aux'], shell=False, stdout=PIPE)
    subProc.stdout.readline()
    for line in subProc.stdout:
        procInfo = split(' *', line.strip())
        procList.append(Proc(procInfo))
    return procList

def getListOfProcesses():
    
    procList = []
    processes = Popen(['ps', 'aux'], shell=False, stdout=PIPE)
    processes.stdout.readline()
    
    for line in processes.stdout:
        processLine = split(' *', line.strip())  
        procList.append(Proc(processLine))
        
    apacheProcList = [ x for x in procList if x.user == 'apache']
    
    return apacheProcList

def getCpuForApache():
    
    result = 0
    apacheProcList = getListOfProcesses()
    
    for cpu in apacheProcList:
        cpuValue = float(cpu.cpuToStr())
        result = result + cpuValue
        
    return result

def getMemForApache():
    
    result = 0
    apacheProcList = getListOfProcesses()
    
    for mem in apacheProcList:
        memValue = float(mem.memToStr())
        result = result + memValue
    
    return result

def saveDataToExcel(fileName, cpuArray, memArray, sheetname):

    workbook = xlwt.Workbook()
    worksheet = workbook.add_sheet(sheetname)

    row = 0 
    for cpuValue in cpuArray:
        worksheet.write(row, 0, cpuValue)
        row = row + 1
    row = 0
    for memValue in memArray:
        worksheet.write(row, 1, memValue)
        row = row + 1
        
    workbook.save(fileName)
	
def listProcesses(procList):

    apacheProcList = [ x for x in procList if x.user == 'apache']
    print('processIds:')
    for proc in apacheProcList:
        #stdout.write(proc.pidToStr() + '\n')
        currentProc = proc.pidToStr()
        print("%CPU\t%MEM for: " + currentProc)
        
        try: 
            while True:
                count = 0
                cpuArray = []
                memArray = []
                
                processID = currentProc         # system process id
                processType = sys.argv[2]       # mconnect process type
                period = sys.argv[3]            # period between each vaules
                repetition = int(sys.argv[4])   # repetition
                sheetname = currentProc
                
                filename = 'process-' + processID + '-' + processType + '-' + period + '.xls'
                
                while (count < repetition):
                    
                    x = getCpuMem(processID)    
                    
                    if not x:
                        print("no process")
                        exit(1)                                         
    				
                    entries = ("%.2f#%.2f" % x)
                    entriesSplit = entries.split('#')
                    cpu = entriesSplit[0]
                    mem = entriesSplit[1]
                    
                    print(cpu + '\t' + mem)
                    
                    cpuArray.append(cpu)
                    memArray.append(mem)
                    
                    time.sleep(float(period))
                    count = count + 1 
                    
                break
                    
        except KeyboardInterrupt:
            print
            exit(0)
            
        saveDataToExcel(filename, cpuArray, memArray, sheetname) 

def getCpuMemForProcess():

    counter = 0        
    cpuArray = []
    memArray = []
                    
    processID = sys.argv[1]         # system process id
    processType = sys.argv[2]       # mconnect process type
    period = sys.argv[3]            # period between each vaules
    repetition = int(sys.argv[4])   # repetition
    sheetname = processID
                       
    filename = 'process-' + processID + '-' + processType + '-' + period + '.xls'
    
    print("%CPU\t%MEM for: " + processID)
                       
    while (counter < repetition):          
       	x = getCpuMem(processID)    
        if not x:
    		print("no process")
        	exit(1)
            	                    
        entries = ("%.2f#%.2f" % x)
        entriesSplit = entries.split('#')
        
        cpu = entriesSplit[0]
        mem = entriesSplit[1]
                                
        print(cpu + '\t' + mem)
                                
        cpuArray.append(cpu)
        memArray.append(mem)
                
        counter = counter + 1       
        time.sleep(float(period))
                                    
    #saveDataToExcel(filename, cpuArray, memArray, sheetname)
    exit(0)

def getResourcesByUser():
	 
     counter = 0
     cpuArray = []
     memArray = []
     sheetname = 'apache'
     processType = sys.argv[1]
     period = sys.argv[2]
     repetition = int(sys.argv[3]) 
     currentTime = time.strftime("%y%m%d%H%M")
     
     filename = 'mconnect-' + currentTime + '-' + processType + '.xls'
     
     print("%CPU\t%MEM for apache user")
     
     cpuArray.append('CPU')
     memArray.append('MEM')
     
     while (counter < repetition):
         
         cpuArray.append(getCpuForApache())
         memArray.append(getMemForApache())
         
         cpu = str(getCpuForApache())
         mem = str(getMemForApache())
         
         print(cpu + '\t' + mem)
         
         counter = counter + 1
         time.sleep(float(period))
     
     saveDataToExcel(filename, cpuArray, memArray, sheetname)
     exit(0)
     
if __name__ == '__main__':

    if not len(sys.argv) == 4 or not all(i in string.digits for i in sys.argv[1]) or not all(i in string.digits for i in sys.argv[2]) or not all(i in string.digits for i in sys.argv[3]):
        print("3 INTEGER variables are required: processType period repetition")
        exit(2)        

    print(getResourcesByUser())

    #procList = getProcessIds() 
    #print(getCpuMemForProcess())
   
