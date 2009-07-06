From: "Morten P.D. Stevens" <mstevens@win-professional.com>
Subject: new benchmark btrfs 0.19 vs. ext4
Date: Mon, 6 Jul 2009 14:45:06 +0200
Message-ID: <520B2A28AACEE94388C511BBB834933707AA86AEA3@IGR-IMC-01.corp.win-professional.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "chris.mason@oracle.com" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris and all btrfs users,

here is a new benchmark with the newest btrfs version 0.19 vs. ext4.

Linux lenny 2.6.31-rc2 #1 SMP Mon Jul 6 11:36:22 CEST 2009 x86_64 GNU/Linux

lenny:/# btrfsctl -A /dev/sdb
operation complete
Btrfs Btrfs v0.19

btrfs:

./compilebench -D /btrfs/compilebench -i 90 -r 150


run complete:
==========================================================================
intial create total runs 90 avg 57.27 MB/s (user 0.44s sys 2.47s)
create total runs 20 avg 30.30 MB/s (user 0.51s sys 1.74s)
patch total runs 24 avg 9.98 MB/s (user 0.08s sys 2.17s)
compile total runs 23 avg 64.19 MB/s (user 0.08s sys 0.94s)
clean total runs 14 avg 323.74 MB/s (user 0.01s sys 0.38s)
read tree total runs 17 avg 18.81 MB/s (user 0.11s sys 3.75s)
read compiled tree total runs 8 avg 25.30 MB/s (user 0.13s sys 4.82s)
delete tree total runs 14 avg 7.34 seconds (user 0.19s sys 2.49s)
delete compiled tree total runs 6 avg 12.32 seconds (user 0.20s sys 2.93s)
stat tree total runs 14 avg 3.56 seconds (user 0.14s sys 0.93s)
stat compiled tree total runs 10 avg 4.06 seconds (user 0.14s sys 1.04s)


and ext4:

./compilebench -D /ext4/compilebench -i 90 -r 150


run complete:
==========================================================================
intial create total runs 90 avg 80.66 MB/s (user 0.44s sys 1.75s)
create total runs 20 avg 34.31 MB/s (user 0.52s sys 1.25s)
patch total runs 24 avg 17.42 MB/s (user 0.06s sys 1.44s)
compile total runs 23 avg 86.51 MB/s (user 0.06s sys 1.10s)
clean total runs 14 avg 1378.57 MB/s (user 0.01s sys 0.15s)
read tree total runs 17 avg 30.97 MB/s (user 0.04s sys 2.83s)
read compiled tree total runs 8 avg 35.61 MB/s (user 0.04s sys 4.33s)
delete tree total runs 14 avg 1.32 seconds (user 0.10s sys 0.92s)
delete compiled tree total runs 6 avg 1.71 seconds (user 0.11s sys 1.06s)
stat tree total runs 14 avg 0.93 seconds (user 0.08s sys 0.62s)
stat compiled tree total runs 10 avg 1.09 seconds (user 0.09s sys 0.68s)


and here the old benchmark:

> On Tue, 2009-04-07 at 13:47 +0200, Morten P.D. Stevens wrote:
>
> linux 2.6.29.1
>
> btrfs: (btrfs 0.18)
> 
> ./compilebench -D /btrfs/work2 -i 90 -r 150
> 
> run complete:
> ==========================================================================
> intial create total runs 90 avg 45.18 MB/s (user 0.84s sys 2.89s)
> create total runs 20 avg 13.30 MB/s (user 0.88s sys 2.93s)
> patch total runs 24 avg 5.94 MB/s (user 0.34s sys 2.56s)
> compile total runs 23 avg 37.04 MB/s (user 0.19s sys 1.60s)
> clean total runs 14 avg 71.36 MB/s (user 0.03s sys 0.83s)
> read tree total runs 17 avg 7.02 MB/s (user 0.75s sys 3.26s)
> read compiled tree total runs 8 avg 16.27 MB/s (user 0.86s sys 4.83s)
> delete tree total runs 14 avg 21.51 seconds (user 0.45s sys 4.07s)
> delete compiled tree total runs 6 avg 29.23 seconds (user 0.57s sys 4.66s)
> stat tree total runs 14 avg 15.99 seconds (user 0.41s sys 1.31s)
> stat compiled tree total runs 10 avg 19.68 seconds (user 0.41s sys 1.51s)
> 
> 
> ext4:
> 
> ./compilebench -D /mnt/work2 -i 90 -r 150
> 
> 
> run complete:
> ==========================================================================
> intial create total runs 90 avg 92.42 MB/s (user 0.76s sys 1.38s)
> create total runs 20 avg 52.06 MB/s (user 0.73s sys 1.26s)
> patch total runs 24 avg 17.28 MB/s (user 0.37s sys 0.96s)
> compile total runs 23 avg 85.64 MB/s (user 0.17s sys 1.05s)
> clean total runs 14 avg 887.53 MB/s (user 0.02s sys 0.11s)
> read tree total runs 17 avg 13.60 MB/s (user 0.79s sys 1.34s)
> read compiled tree total runs 8 avg 24.65 MB/s (user 0.95s sys 2.07s)
> delete tree total runs 14 avg 2.26 seconds (user 0.39s sys 0.78s)
> delete compiled tree total runs 6 avg 2.82 seconds (user 0.43s sys 0.91s)
> stat tree total runs 14 avg 1.71 seconds (user 0.38s sys 0.33s)
> stat compiled tree total runs 10 avg 1.99 seconds (user 0.42s sys 0.33s)
