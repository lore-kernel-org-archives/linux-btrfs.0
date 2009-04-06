From: Steven Pratt <slpratt@austin.ibm.com>
Subject: New performance results
Date: Mon, 06 Apr 2009 17:01:11 -0500
Message-ID: <49DA7BA7.7010607@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I am continuing to do runs to provide more data on the random write 
issues with btrfs. I have just posted 2 sets of runs here:
http://btrfs.boxacle.net/repository/raid/longrun/

these are on a pull of the btrfs-unstable experimental branch from 4/3.

These are 100 minute runs of the 128 thread random write workload on the 
raid system (1 for btrfs and 1 for ext3).  Included in these runs are 
graphs of all the iostat, sar and mpstat data (see analysis directories).

A couple of interesting things. First, we see the choppiness of the IO 
in btrfs compared to ext3.
http://btrfs.boxacle.net/repository/raid/longrun/btrfs-longrun/btrfs1.ffsb.random_writes__threads_0128.09-04-06_10.25.03/analysis/iostat-processed.001/chart.html 

http://btrfs.boxacle.net/repository/raid/longrun/ext3-longrun/btrfs1.ffsb.random_writes__threads_0128.09-04-06_13.44.49/analysis/iostat-processed.001/chart.html 


In particular look at graphs 7 and 11 which show write iops and 
throughput.  Ext3 is nice and smooth, while btrfs has a repeating 
pattern of dips and spikes, with IO going to 0 on  a regular basis.

Another interesting observation is what looks a lot like a memory leak.  
Looking at chart 6 Memory at :
http://btrfs.boxacle.net/repository/raid/longrun/btrfs-longrun/btrfs1.ffsb.random_writes__threads_0128.09-04-06_10.25.03/analysis/sar-processed.001/chart.html 

we see that the amount of page cache drops slowly throughout the entire 
run.  Starting up around 3.5GB and dropping to about 2.3GB by the end of 
the run.  The memory seems to have moved to the slab which grew to 
1.5GB.  Doing a repeat of the run while watching slabtop, we see that 
size-2048 is responsible for the majority of the slab usage (over 1GB).

We do not see this behavior under ext3.


Steve
