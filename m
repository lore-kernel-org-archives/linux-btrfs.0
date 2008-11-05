From: Josef Bacik <jbacik@redhat.com>
Subject: Systemtap script
Date: Wed, 5 Nov 2008 14:00:32 -0500
Message-ID: <20081105190032.GA18270@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Since theres a _ton_ of calls its usually better to try and focus in on a set of
functions you are looking to screw with and that will keep the overhead from
going too high.  You can fiddle with the STP_OVERLOAD_THRESHOLD and
STP_OVERLOAD_INTERVAL variables to ramp the amount of overhead systemtap will
tolerate up, a good explanation of what they do and what the defaults are are in
the stap manpage.  Below is a simple stap script that I used to try and figure
out which function in the allocator was taking up so much time as everything
went along.  It just prints out how many times the function was called, the
average call time, min call time, max call time and total time spent since the
last print.  I find this page highly helpful

http://sourceware.org/systemtap/documentation.html

for figuring out different things, backtrace() is a helpful thing for getting a
backtrace.  You can do all sorts of tricky things, for example you can do
something like this to figure out how many times a particular call trace happens

some_variable[execname(),backtrace()] <<< 1

and then get stat information on that and print out the backtrace when you
process everything.  Thanks,

Josef


#!/usr/bin/env stap

probe module("btrfs").function("*@fs/btrfs/extent-tree.c") {
        calltime[tid()] = gettimeofday_us()
}

probe module("btrfs").function("*@fs/btrfs/extent-tree.c").return {
        now = gettimeofday_us()
        c = calltime[tid()]
        if (!c) next
        ttime[probefunc()] <<< now - c
        delete calltime[tid()]
}

probe timer.s(120) { print_stats() }

probe begin { printf("starting probe\n") }

function print_stats() {
        printf("\n")
        foreach (x in ttime)
                printf("%-20s\tcalls:%6d\tavg time (ms):%5d\tmin
time(ms):%5d\tmax time(ms):%5d\ttotal(ms):%7d\n",
                        x, @count(ttime[x]), @avg(ttime[x]), @min(ttime[x]),
@max(ttime[x]), @sum(ttime[x]))
        delete ttime
}

probe end { print_stats() }
global calltime, ttime

