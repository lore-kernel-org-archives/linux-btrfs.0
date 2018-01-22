Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36622 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750955AbeAVO2f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 09:28:35 -0500
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
To: Sebastian Ochmann <ochmann@cs.uni-bonn.de>, <linux-btrfs@vger.kernel.org>
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
From: Chris Mason <clm@fb.com>
Message-ID: <8f04ccba-efca-a415-3ee0-61bcf1cb3d9d@fb.com>
Date: Mon, 22 Jan 2018 09:27:03 -0500
MIME-Version: 1.0
In-Reply-To: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
Content-Type: multipart/mixed;
        boundary="------------489B9CA0E4CEFE34F5A52FC0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------489B9CA0E4CEFE34F5A52FC0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 01/20/2018 05:47 AM, Sebastian Ochmann wrote:
> Hello,
> 
> I would like to describe a real-world use case where btrfs does not 
> perform well for me. I'm recording 60 fps, larger-than-1080p video using 
> OBS Studio [1] where it is important that the video stream is encoded 
> and written out to disk in real-time for a prolonged period of time (2-5 
> hours). The result is a H264 video encoded on the GPU with a data rate 
> ranging from approximately 10-50 MB/s.
> 
> The hardware used is powerful enough to handle this task. When I use a 
> XFS volume for recording, no matter whether it's a SSD or HDD, the 
> recording is smooth and no frame drops are reported (OBS has a nice 
> Stats window where it shows the number of frames dropped due to encoding 
> lag which seemingly also includes writing the data out to disk).
> 
> However, when using a btrfs volume I quickly observe severe, periodic 
> frame drops. It's not single frames but larger chunks of frames that a 
> dropped at a time. I tried mounting the volume with nobarrier but to no 
> avail.
> 
> Of course, the simple fix is to use a FS that works for me(TM). However 
> I thought since this is a common real-world use case I'd describe the 
> symptoms here in case anyone is interested in analyzing this behavior. 
> It's not immediately obvious that the FS makes such a difference. Also, 
> if anyone has an idea what I could try to mitigate this issue (mount or 
> mkfs options?) I can try that.
> 
> I saw this behavior on two different machines with kernels 4.14.13 and 
> 4.14.5, both Arch Linux. btrfs-progs 4.14, OBS 20.1.3-241-gf5c3af1b 
> built from git.
> 

This could be a few different things, trying without the space cache was 
already suggested, and that's a top suspect.

How does the application do the writes?  Are they always 4K aligned or 
does it send them out in odd sizes?

The easiest way to nail it down is to use offcputime from the iovisor 
project:


https://github.com/iovisor/bcc/blob/master/tools/offcputime.py

If you haven't already configured this it may take a little while, but 
it's the perfect tool for this problem.

Otherwise, if the stalls are long enough you can try to catch it with 
/proc/<pid>/stack.  I've attached a helper script I often use to dump 
the stack trace of all the tasks in D state.

Just run walker.py and it should give you something useful.  You can use 
walker.py -a to see all the tasks instead of just D state.  This just 
walks /proc/<pid>/stack, so you'll need to run it as someone with 
permissions to see the stack traces of the procs you care about.

-chris



--------------489B9CA0E4CEFE34F5A52FC0
Content-Type: text/x-python; name="walker.py"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="walker.py"

#!/usr/bin/env python3
#
# this walks all the tasks on the system and prints out a stack trace
# of any tasks waiting in D state.  If you pass -a, it will print out
# the stack of every task it finds.
#
# It also makes a histogram of the common stacks so you can see where
# more of the tasks are.
#

import sys
import os

from optparse import OptionParser

usage = "usage: %prog [options]"
parser = OptionParser(usage=usage)
parser.add_option("-a", "--all_tasks", help="Dump all stacks", default=False,
                  action="store_true")
parser.add_option("-s", "--smaps", help="Dump /proc/pid/smaps", default=False,
                  action="store_true")
parser.add_option("-S", "--sort", help="/proc/pid/smaps sort key",
                  default="size", type="str")
parser.add_option("-p", "--pid", help="Filter on pid", default=None,
                 type="str")
parser.add_option("-c", "--command", help="Filter on command name",
                 default=None, type="str")
parser.add_option("-f", "--files", help="don't collapse open files",
                  default=False, action="store_true")
parser.add_option("-v", "--verbose", help="details++", default=False,
                  action="store_true")
(options, args) = parser.parse_args()

stacks = {}

maps = {}

lines = []

# parse the units from a number and normalize into KB
def parse_number(s):
    try:
        words = s.split()
        unit = words[-1].lower()
        number = int(words[1])
        tag = words[0].lower().rstrip(':')

        # we store in kb
        if unit == "mb":
            number = number * 1024
        elif unit == "gb":
            number = number * 1024 * 1024
        elif unit == "tb":
            number = number * 1024 * 1024

        return (tag, number)
    except:
        return (None, None)

# pretty print a number in KB with units
def print_number(num):
    # we store the number in kb
    units = ['KB', 'MB', 'GB', 'TB']
    index = 0

    while num > 1024:
        num /= 1024
        index += 1

    final = float(num + num / 1024)
    return (final, units[index])

# find a given line in the record and pretty print it
def print_line(header, record, tag):
    num, unit = print_number(record[tag])

    if options.verbose:
        header = header + " "
    else:
        header = ""

    print("\t%s%s: %.2f %s" % (header, tag.capitalize(), num, unit))


# print all the lines we care about in a given record
def print_record(record):
    tag = record['tag']

    print(tag)
    print_line(tag, record, "size")
    print_line(tag, record, "rss")
    print_line(tag, record, "pss")
    print_line(tag, record, "anonymous")
    print_line(tag, record, "swap")
    print_line(tag, record, "locked")

# stuff a record with a group of lines from /proc/pid/smaps
# into the smaps hash.  This does all the collapsing by cmd name
# unless we're in -a mode
#
def add_record(cmd, pid, record):
    global maps

    if not record:
        return

    val = record["tag"]

    if val[0] != '[':
        if val.find('/') < 0:
            val = "[anonymous]"
        elif options.files:
            val = "[files:%s]" % val
        else:
            val = "[files]"

    if not options.verbose and val.startswith('[stack:'):
        val = val[0:6] + "]"
    if options.all_tasks:
        val = "%s:%s:%s" % (cmd, pid, val)
    else:
        val = "%s:%s" % (cmd, val)
    proc = maps.setdefault(val, {"tag": val})

    for x in record:
        if x != "tag":
            e = proc.get(x, 0)
            proc[x] = e + record[x]

# open the smap file for a given pid and collect all the records
def add_smap(path, pid, cmd):
    try:
        fd = open(os.path.join(path, "smaps"), "r")
    except:
        return

    record = {}

    while True:
        l = fd.readline()
        if not l:
            break
        l = l.lstrip().rstrip()

        if l.find('-') >= 0:
            add_record(cmd, pid, record)
            record = {}
            words = l.split()

            # if the tag includes information about filenames
            # add them in
            #
            if len(words) > 5:
                record['tag'] = " ".join(words[5:])
            else:
                record['tag'] = words[-1]

            continue

        tag, number = parse_number(l)
        if tag:
            record[tag] = number

    add_record(cmd, pid, record)

# read /proc/pid/stack and add it to the hashes
def add_stack(path, pid, cmd, status):
    global stacks

    try:
        stack = open(os.path.join(path, "stack"), "r").read()
    except:
        return

    if (status != "D" and not options.all_tasks):
        return

    print("%s %s %s" % (pid, cmd, status))
    print(stack)
    v = stacks.get(stack)
    if v:
        v += 1
    else:
        v = 1
    stacks[stack] = v


# worker to read all the files for one individual task
def run_one_task(path):

    try:
        stat = open(os.path.join(path, "stat"), "r").read()
    except:
        pass

    words = stat.split()
    pid, cmd, status = words[0:3]

    cmd = cmd.lstrip('(')
    cmd = cmd.rstrip(')')

    if options.command and options.command != cmd:
        return

    if options.smaps:
        add_smap(path, pid, cmd)
    else:
        add_stack(path, pid, cmd, status)

def print_usage():
    sys.stderr.write("Usage: %s [-a]\n" % sys.argv[0])
    sys.exit(1)

# for a given pid in string form, read the files from proc
def run_pid(name):
    try:
        pid = int(name)
    except:
        return

    if options.smaps:
        p = os.path.join("/proc", name)
        try:
            run_one_task(p)
        except:
            pass
    else:
        p = os.path.join("/proc", name, "task")
        if not os.path.exists(p):
            return

        try:
            for t in os.listdir(p):
                run_one_task(os.path.join(p, t))
        except:
            raise

if options.pid:
    run_pid(options.pid)
else:
    for name in os.listdir("/proc"):
        run_pid(name)

if options.smaps:
    key = options.sort.lower()
    sort = {}

    for x in maps:
        record = maps[x]
        val = record.get(key, 0)
        sort.setdefault(val, []).append(x)

    ar = list(sort.keys())
    ar.sort()
    for x in ar:
        bucket = sort[x]
        for x in bucket:
            print_record(maps[x])
else:
    values = {}
    for stack, count in stacks.items():
        l = values.setdefault(count, [])
        l.append(stack)

    counts = list(values.keys())
    counts.sort(reverse=True)
    if counts:
            print("-----\nstack summary\n")

    for x in counts:
        if x == 1:
            print("1 hit:")
        else:
            print("%d hits: " % x)

        l = values[x]
        for stack in l:
            print(stack)
            print("-----")

--------------489B9CA0E4CEFE34F5A52FC0--
