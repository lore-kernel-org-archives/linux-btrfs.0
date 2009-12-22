From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Subject: btrfs compilebench 2.6.32 vs 2.6.31
Date: Tue, 22 Dec 2009 15:14:05 +0000
Message-ID: <7A0DA8A6E4A5364C99FEB08C2A145FA817B082@EXCH-CCR-2010.corp.imt-systems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here are my new compilebench results:

btrfs with 2.6.32
Linux ubuntu 2.6.32-9-server #13-Ubuntu SMP Thu Dec 17 17:01:59 UTC 2009 x86_64 GNU/Linux

run complete:
==========================================================================
intial create total runs 90 avg 59.54 MB/s (user 0.40s sys 2.31s)
create total runs 20 avg 30.94 MB/s (user 0.48s sys 1.87s)
patch total runs 24 avg 10.10 MB/s (user 0.09s sys 2.57s)
compile total runs 23 avg 67.62 MB/s (user 0.08s sys 1.04s)
clean total runs 14 avg 318.18 MB/s (user 0.01s sys 0.40s)
read tree total runs 17 avg 16.22 MB/s (user 0.13s sys 4.18s)
read compiled tree total runs 8 avg 25.70 MB/s (user 0.14s sys 6.59s)
delete tree total runs 14 avg 6.33 seconds (user 0.18s sys 2.59s)
delete compiled tree total runs 6 avg 13.76 seconds (user 0.18s sys 3.13s)
stat tree total runs 14 avg 4.18 seconds (user 0.11s sys 1.04s)
stat compiled tree total runs 10 avg 4.44 seconds (user 0.08s sys 1.14s)

btrfs with 2.6.31
Linux lenny 2.6.31-rc2 #1 SMP Mon Jul 6 11:36:22 CEST 2009 x86_64 GNU/Linux

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


--
Morten