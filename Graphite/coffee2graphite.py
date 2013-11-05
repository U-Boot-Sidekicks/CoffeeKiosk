#!/usr/bin/python

import sys
import time
import os
import platform
import subprocess
import requests
from socket import socket

COFFEE_USER_ENDPOINT = 'http://coffee01.fit.fraunhofer.de/api/users'
CARBON_SERVER = '127.0.0.1'
CARBON_PORT = 2003
GRAPHITE_PREFIX = 'U-Boot.Coffee'

EXCLUDE_USERS = (
    #'5101120bb37ca8a620000001',  # Demo User
    #'5215e9480d7c31de08000106',  # Bring Your Own Coffee User
    #'51113ee41af5951b51000037',  # Tee Drinker (consume only host water)
)


delay = 60
if len(sys.argv) > 1:
    delay = int(sys.argv[1])


def get_loadavg():
    # For more details, "man proc" and "man uptime"
    if platform.system() == "Linux":
        return open('/proc/loadavg').read().strip().split()[:3]
    else:
        command = "uptime"
        process = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
        os.waitpid(process.pid, 0)
        output = process.stdout.read().replace(',', ' ').strip().split()
        length = len(output)
        return output[length - 3:length]


def get_users():
    r = requests.get(COFFEE_USER_ENDPOINT)
    return r.json()


def should_include(user):
    return user['_id'] not in EXCLUDE_USERS


def get_data():
    users = get_users()
    cups = sum(user['totalCups'] for user in users if should_include(user))
    dept = sum(user['balance'] for user in users if should_include(user) and user['balance'] < 0)
    debit = sum(user['balance'] for user in users if should_include(user) and user['balance'] > 0)
    return cups, debit, dept


def main():
    sock = socket()
    try:
        sock.connect((CARBON_SERVER, CARBON_PORT))
    except:
        print "Couldn't connect to %(server)s on port %(port)d, is carbon agent running?" % {'server': CARBON_SERVER, 'port': CARBON_PORT}
        sys.exit(1)

    while True:
        now = int(time.time())
        lines = []

        data = get_data()
        lines.append("%s.cups %s %d" % (GRAPHITE_PREFIX, data[0], now))
        lines.append("%s.debit %s %d" % (GRAPHITE_PREFIX, data[1], now))
        lines.append("%s.debt %s %d" % (GRAPHITE_PREFIX, data[2], now))
        message = '\n'.join(lines) + '\n'  # all lines must end in a newline
        print "sending message\n"
        print '-' * 80
        print message
        print
        sock.sendall(message)
        time.sleep(delay)

if __name__ == '__main__':
    main()
