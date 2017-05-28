#!/usr/bin/python

# Composer: Ilche Bedelovski
# Version: 1.0
# Last update: 18-10-2014

# Script for collecting details about specific environments and presenting the results on web

import subprocess
import os
import cgi
import cgitb; cgitb.enable()

print "Content-type: text/html"
print
print "<html>"
print ""
print "</head></head>"
print "<body style='font-family: Arial'>"

print "<p style='width: 100%; height: 30px; font-weight: bold; padding-top: 10px; text-align: center; background-color: #B5B5B5; color: white'>Client Environments</p>"

for dir in os.listdir("/home/html/clients"):
	if os.path.isdir(os.path.join("/home/html/clients", dir)):
		for subdir in os.listdir("/home/html/clients/" + dir):
			if os.path.isdir(os.path.join("/home/html/clients/" + dir, subdir)):
				if subdir == ".git":
					print "<p style='color: #575757; font-weight: bold; font-size: 20px'>Environment: " + dir + "</p>"
					fullPath = "/home/html/clients/" + dir
					git = os.popen('cd ' + fullPath + ' && /usr/bin/git branch').read()
					for row in git.split("\n"):
						if "*" in row:
							print "<p style='color: #43CD80; font-size: 14px'>" + row + "</p"
						else:
							print "<p style='color: black; font-size: 14px'>&nbsp"  + row + "</p>"

print "<p style='width: 100%; height: 30px; font-weight: bold; padding-top: 10px; text-align: center; background-color: #B5B5B5; color: white'>Development Environments</p>"

for dir in os.listdir("/home/html/development"):
        if os.path.isdir(os.path.join("/home/html/development", dir)):
                for subdir in os.listdir("/home/html/development/" + dir):
                        if os.path.isdir(os.path.join("/home/html/development/" + dir, subdir)):
                                if subdir == ".git":
                                        print "<p style='color: #575757; font-weight: bold; font-size: 20px'>Environment: " + dir + "</p>"
                                        fullPath = "/home/html/development/" + dir
                                        git = os.popen('cd ' + fullPath + ' && /usr/bin/git branch').read()
                                        for row in git.split("\n"):
                                                if "*" in row:
                                                        print "<p style='color: #43CD80; font-size: 14px'>" + row + "</p"
                                                else:
                                                        print "<p style='color: black; font-size: 14px'>&nbsp"  + row + "</p>"

print "<p style='width: 100%; height: 30px; font-weight: bold; padding-top: 10px; text-align: center; background-color: #B5B5B5; color: white'>Extensions Environments</p>"

for dir in os.listdir("/home/html/extensions"):
        if os.path.isdir(os.path.join("/home/html/extensions", dir)):
                for subdir in os.listdir("/home/html/extensions/" + dir):
                        if os.path.isdir(os.path.join("/home/html/extensions/" + dir, subdir)):
                                if subdir == ".git":
                                        print "<p style='color: #575757; font-weight: bold; font-size: 20px'>Environment: " + dir + "</p>"
                                        fullPath = "/home/html/extensions/" + dir
                                        git = os.popen('cd ' + fullPath + ' && /usr/bin/git branch').read()
                                        for row in git.split("\n"):
                                                if "*" in row:
                                                        print "<p style='color: #43CD80; font-size: 14px'>" + row + "</p"
                                                else:
                                                        print "<p style='color: black; font-size: 14px'>&nbsp"  + row + "</p>"


print "</body>"
print "</html>"



#for dir in filter(os.path.isdir, os.listdir("/home/html/clients")):
#	subdirs = '/home/html/clients/' + dir
#	for subdir in os.listdir(subdirs):
#		if subdir == 'git':
#			print dir

#def index():
#	f = os.popen("bash /home/html/scripts/findGit.sh")
#	result = f.read()
#	return result
	
	
	
