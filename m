From: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Subject: btrfs benchmark with 2.6.37-rc1
Date: Mon, 1 Nov 2010 15:30:05 +0100
Message-ID: <AANLkTinp=wsayqczkpDB-75MedEpC0Z49FqM2dyFGG4x@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Here is a small btrfs vs. ext4 benchmark with kernel 2.6.37-rc1.

compilebench with options -i 10 -r 30 on 2.6.37-rc1

btrfs

==========================================================================
intial create total runs 10 avg 73.11 MB/s (user 0.34s sys 1.96s)
create total runs 5 avg 49.53 MB/s (user 0.41s sys 1.62s)
patch total runs 4 avg 22.13 MB/s (user 0.09s sys 1.79s)
compile total runs 7 avg 104.55 MB/s (user 0.08s sys 1.02s)
clean total runs 4 avg 564.00 MB/s (user 0.01s sys 0.28s)
read tree total runs 2 avg 29.62 MB/s (user 0.00s sys 2.77s)
read compiled tree total runs 1 avg 31.85 MB/s (user 0.00s sys 5.03s)
delete tree total runs 2 avg 4.06 seconds (user 0.11s sys 1.92s)
no runs for delete compiled tree
stat tree total runs 4 avg 2.79 seconds (user 0.07s sys 0.79s)
stat compiled tree total runs 1 avg 2.50 seconds (user 0.10s sys 0.80s)

ext4

==========================================================================
intial create total runs 10 avg 120.03 MB/s (user 0.34s sys 1.31s)
create total runs 5 avg 69.70 MB/s (user 0.44s sys 1.09s)
patch total runs 4 avg 30.45 MB/s (user 0.05s sys 1.43s)
compile total runs 7 avg 120.22 MB/s (user 0.07s sys 1.03s)
clean total runs 4 avg 1199.56 MB/s (user 0.01s sys 0.10s)
read tree total runs 2 avg 49.29 MB/s (user 0.03s sys 2.29s)
read compiled tree total runs 1 avg 51.73 MB/s (user 0.04s sys 4.74s)
delete tree total runs 2 avg 1.13 seconds (user 0.06s sys 0.68s)
no runs for delete compiled tree
stat tree total runs 4 avg 0.83 seconds (user 0.05s sys 0.44s)
stat compiled tree total runs 1 avg 0.82 seconds (user 0.06s sys 0.45s)

Best regards,

Morten
