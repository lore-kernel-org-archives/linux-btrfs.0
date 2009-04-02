From: Chris Mason <chris.mason@oracle.com>
Subject: Re: performance issues on btrfs after many snaps
Date: Thu, 02 Apr 2009 13:11:34 -0400
Message-ID: <1238692294.29739.7.camel@think.oraclecorp.com>
References: <2DE16EF0-63DB-404A-8826-AA7A6AD535C4@soe.ucsc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Anupam Garg <garga@soe.ucsc.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2DE16EF0-63DB-404A-8826-AA7A6AD535C4@soe.ucsc.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-04-02 at 09:33 -0700, Anupam Garg wrote:
> I'm trying to do some incremental product builds on btrfs.
> My general workflow is:
> 
> for CLN in CHANGES:
>     (1) sync CLN in /btrfs/current
>     (2) build
>     (3) if btrfs_with_snapshots: snap to /btrfs/CLN
> 
> I tried 3 ways:
> ext3 as baseline,
> btrfs w/o snapshots,
> btrfs with snapshots
> 
> And, when doing so, I get the following results (for 20 changes) --  
> all data in seconds:
> 
> build#, ext3, btrfs_nosnap, btrfs_snap:
> 1, 1984.255,  2005.833,  1992.125
> 2, 352.53,  357.485,  359.08
> 3, 633.742,  633.571,  635.809
> 4, 380.11,  378.361,  380.067
> 5, 348.578,  354.401,  357.166
> 6, 344.705,  354.659,  358.569
> 7, 349.883,  357.084,  356.666
> 8, 584.673,  594.489,  596.34
> 9, 348.868,  356.776,  375.165
> 10, 503.824,  605.733,  630.257
> 11, 364.995,  359.486,  379.509
> 12, 383.263,  391.045,  408.491
> 13, 356.672,  361.065,  404.367
> 14, 352.583,  360.526,  431.902
> 15, 468.299,  501.173,  1046.198
> 16, 344.414,  356.123,  467.744
> 17, 353.368,  373.99,  646.753
> 18, 352.07,  364.163,  546.776
> 19., 355.426,  376.69,  995.996
> 20, 356.816,  390.882,  1700.374
> 
> So, btrfs without snaps and ext3 are fairly close. However, btrfs with  
> snapshots has increasing degradation in build performance.
> The initial build time is high because it is a fresh sync and full  
> build.
> 

Is this a source base that I can try to reproduce these performance
problems with?

The first question would be why were the slower runs slower?  I'm
assuming they need to read more off the disk, but capturing vmstat
output during the fast and slow btrfs runs would help.

-chris


