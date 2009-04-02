From: Anupam Garg <garga@soe.ucsc.edu>
Subject: performance issues on btrfs after many snaps
Date: Thu, 2 Apr 2009 09:33:53 -0700
Message-ID: <2DE16EF0-63DB-404A-8826-AA7A6AD535C4@soe.ucsc.edu>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to do some incremental product builds on btrfs.
My general workflow is:

for CLN in CHANGES:
    (1) sync CLN in /btrfs/current
    (2) build
    (3) if btrfs_with_snapshots: snap to /btrfs/CLN

I tried 3 ways:
ext3 as baseline,
btrfs w/o snapshots,
btrfs with snapshots

And, when doing so, I get the following results (for 20 changes) --  
all data in seconds:

build#, ext3, btrfs_nosnap, btrfs_snap:
1, 1984.255,  2005.833,  1992.125
2, 352.53,  357.485,  359.08
3, 633.742,  633.571,  635.809
4, 380.11,  378.361,  380.067
5, 348.578,  354.401,  357.166
6, 344.705,  354.659,  358.569
7, 349.883,  357.084,  356.666
8, 584.673,  594.489,  596.34
9, 348.868,  356.776,  375.165
10, 503.824,  605.733,  630.257
11, 364.995,  359.486,  379.509
12, 383.263,  391.045,  408.491
13, 356.672,  361.065,  404.367
14, 352.583,  360.526,  431.902
15, 468.299,  501.173,  1046.198
16, 344.414,  356.123,  467.744
17, 353.368,  373.99,  646.753
18, 352.07,  364.163,  546.776
19., 355.426,  376.69,  995.996
20, 356.816,  390.882,  1700.374

So, btrfs without snaps and ext3 are fairly close. However, btrfs with  
snapshots has increasing degradation in build performance.
The initial build time is high because it is a fresh sync and full  
build.

I'm synced to:
commit af4176b49c5ee15a9c9b10720c92456b28e7aac7
Author: Chris Mason <chris.mason@oracle.com>
Date:   Tue Mar 24 10:24:31 2009 -0400
Btrfs: optimize fsyncs on old files

running kernel: 2.6.29-bigsmp-btrfs (bigsmp for 16 cores)


I haven't mounted btrfs with any options. Nor have I done any other  
performance tweaks.
So, my questions are:
(1) are there any tweaks I can do to increase performance when the  
number of snapshots increase?
(2) what sort of data can I collect to send to you guys to help out?


please let me know what else I can provide.
thanks much,
-anupam




