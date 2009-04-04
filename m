From: "Morten P.D. Stevens" <mstevens@win-professional.com>
Subject: btrfs vs ext4 benchmark
Date: Sat, 4 Apr 2009 15:37:54 +0200
Message-ID: <001001c9b52a$8ef00bc0$acd02340$@com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

here are some tests on an IBM server with btrfs vs. ext4.

Kernel: 2.6.29.1
Benchmark software: compilerbench with options -i 10 -r 30
CPU: Intel Xeon Quadcore E5310
Chipset: Intel 5000
Memory: 4 GB FB-DIMM DDR2-667
HDDs: 2x WD6400AAKS @ Raid0
Storage Controller: IBM Serveraid 8k

btrfs Result:

intial create total runs 10 avg 50.89 MB/s (user 0.85s sys 2.59s)
create total runs 5 avg 23.62 MB/s (user 0.82s sys 2.55s)
patch total runs 4 avg 11.35 MB/s (user 0.38s sys 2.22s)
compile total runs 7 avg 66.33 MB/s (user 0.19s sys 1.32s)
clean total runs 4 avg 195.76 MB/s (user 0.03s sys 0.50s)
read tree total runs 2 avg 11.99 MB/s (user 0.66s sys 2.59s)
read compiled tree total runs 1 avg 30.14 MB/s (user 0.88s sys 3.64s)
delete tree total runs 2 avg 10.79 seconds (user 0.43s sys 3.39s)
no runs for delete compiled tree
stat tree total runs 4 avg 9.62 seconds (user 0.41s sys 1.03s)
stat compiled tree total runs 1 avg 10.51 seconds (user 0.49s sys 1.19s)

ext4 Result:

intial create total runs 10 avg 96.09 MB/s (user 0.77s sys 1.34s)
create total runs 5 avg 50.84 MB/s (user 0.82s sys 1.20s)
patch total runs 4 avg 20.17 MB/s (user 0.28s sys 1.04s)
compile total runs 7 avg 94.39 MB/s (user 0.17s sys 1.07s)
clean total runs 4 avg 959.66 MB/s (user 0.03s sys 0.11s)
read tree total runs 2 avg 14.67 MB/s (user 0.78s sys 1.26s)
read compiled tree total runs 1 avg 31.96 MB/s (user 0.87s sys 2.31s)
delete tree total runs 2 avg 2.14 seconds (user 0.34s sys 0.81s)
no runs for delete compiled tree
stat tree total runs 4 avg 1.82 seconds (user 0.40s sys 0.35s)
stat compiled tree total runs 1 avg 1.83 seconds (user 0.35s sys 0.33s)

Best regards,

Morten

