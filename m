Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from capsec.org ([46.4.123.73]:37123 "EHLO mail.capsec.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752376AbdBCWUV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Feb 2017 17:20:21 -0500
Received: from www.capsec.org (unknown [172.17.0.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mail.capsec.org (Postfix) with ESMTPSA id BE329281C
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Feb 2017 22:13:31 +0000 (UTC)
Mime-Version: 1.0
Date: Fri, 03 Feb 2017 22:13:31 +0000
Content-Type: text/plain; charset="utf-8"
Message-ID: <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
From: jb@capsec.org
Subject: Very slow balance / btrfs-transaction
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 


I'm currently running a balance (without any filters) on a 4 drives raid1 filesystem. The array contains 3 3TB drives and one 6TB drive; I'm running the rebalance because the 6TB drive recently replaced a 2TB drive. 


I know that balance is not supposed to be a fast operation, but this one is now running for ~6 days and it managed to balance ~18% (754 out of about 4250 chunks balanced (755 considered),  82% left) -- so I expect it to take another ~4 weeks. 

That seems excessively slow for ~8TiB of data.


Is this expected behavior? In case it's not: Is there anything I can do to help debug it?


The 4 individual devices are bcache devices with currently no ssd cache partition attached; the bcache backing devices sit ontop of luks encrypted devices. Maybe a few words about the history of this fs: It used to be a 1 drive btrfs ontop of a bcache partition with a 30GiB SSD cache (actively used for >1 year). During the last month, I gradually added devices (always with active bcaches). At some point, after adding the 4th device, I deactivated (detached) the bcache caching device and instead activated raid1 for data and metadata and ran a rebalance (which was reasonably fast -- I don't remember how fast exactly, but probably <24h). The finaly steps that lead to the current situation: I activated "nossd" and replaced the smallest device with "btrfs dev replace" (which was also reasonabley fast, <12h).

 

Best & thanks, 

   j


--
[joerg@dorsal ~]$ lsblk
NAME            MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda               8:0    0 111.8G  0 disk
├─sda1            8:1    0     1G  0 part  /boot
└─sda2            8:2    0 110.8G  0 part
  └─crypted     254:0    0 110.8G  0 crypt
    ├─ssd-root  254:1    0  72.8G  0 lvm   /
    ├─ssd-swap  254:2    0     8G  0 lvm   [SWAP]
    └─ssd-cache 254:3    0    30G  0 lvm
sdb               8:16   0   2.7T  0 disk
└─sdb1            8:17   0   2.7T  0 part
  └─crypted-sdb 254:7    0   2.7T  0 crypt
    └─bcache2   253:2    0   2.7T  0 disk
sdc               8:32   0   2.7T  0 disk
└─sdc1            8:33   0   2.7T  0 part
  └─crypted-sdc 254:4    0   2.7T  0 crypt
    └─bcache1   253:1    0   2.7T  0 disk
sdd               8:48   0   2.7T  0 disk
└─sdd1            8:49   0   2.7T  0 part
  └─crypted-sdd 254:6    0   2.7T  0 crypt
    └─bcache0   253:0    0   2.7T  0 disk
sde               8:64   0   5.5T  0 disk
└─sde1            8:65   0   5.5T  0 part
  └─crypted-sde 254:5    0   5.5T  0 crypt
    └─bcache3   253:3    0   5.5T  0 disk  /storage
--

joerg@dorsal ~]$ sudo btrfs  fi usage -h /storage/
Overall:
    Device size:                  13.64TiB
    Device allocated:              8.35TiB
    Device unallocated:            5.29TiB
    Device missing:                  0.00B
    Used:                          8.34TiB
    Free (estimated):              2.65TiB      (min: 2.65TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 15.77MiB)

Data,RAID1: Size:4.17TiB, Used:4.16TiB
   /dev/bcache0    2.38TiB
   /dev/bcache1    2.37TiB
   /dev/bcache2    2.38TiB
   /dev/bcache3    1.20TiB

Metadata,RAID1: Size:9.00GiB, Used:7.49GiB
   /dev/bcache1    8.00GiB
   /dev/bcache2    1.00GiB
   /dev/bcache3    9.00GiB

System,RAID1: Size:32.00MiB, Used:624.00KiB
   /dev/bcache1   32.00MiB
   /dev/bcache3   32.00MiB

Unallocated:
   /dev/bcache0  355.52GiB
   /dev/bcache1  356.49GiB
   /dev/bcache2  355.52GiB
   /dev/bcache3    4.25TiB
  
--
[joerg@dorsal ~]$ ps -xal | grep btrfs
1     0   227     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-worker]
1     0   229     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-worker-hi]
1     0   230     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-delalloc]
1     0   231     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-flush_del]
1     0   232     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-cache]
1     0   233     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-submit]
1     0   234     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-fixup]
1     0   235     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio]
1     0   236     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio-met]
1     0   237     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio-met]
1     0   238     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio-rai]
1     0   239     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio-rep]
1     0   240     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-rmw]
1     0   241     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio-wri]
1     0   242     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-freespace]
1     0   243     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-delayed-m]
1     0   244     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-readahead]
1     0   245     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-qgroup-re]
1     0   246     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-extent-re]
1     0   247     2  20   0      0     0 -      S    ?          0:00 [btrfs-cleaner]
1     0   248     2  20   0      0     0 -      S    ?          0:30 [btrfs-transacti]
1     0  2283     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-worker]
1     0  2285     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-worker-hi]
1     0  2286     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-delalloc]
1     0  2287     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-flush_del]
1     0  2288     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-cache]
1     0  2289     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-submit]
1     0  2290     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-fixup]
1     0  2291     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio]
1     0  2292     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio-met]
1     0  2293     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio-met]
1     0  2294     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio-rai]
1     0  2295     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio-rep]
1     0  2296     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-rmw]
1     0  2297     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-endio-wri]
1     0  2298     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-freespace]
1     0  2299     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-delayed-m]
1     0  2300     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-readahead]
1     0  2301     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-qgroup-re]
1     0  2302     2   0 -20      0     0 -      S<   ?          0:00 [btrfs-extent-re]
1     0  2303     2  20   0      0     0 -      D    ?          0:10 [btrfs-cleaner]
1     0  2304     2  20   0      0     0 -      D    ?        3247:49 [btrfs-transacti]
4     0 10316  9321  20   0  83604  4868 -      S+   pts/1      0:00 sudo btrfs balance start /storage/
4     0 10317 10316  20   0  15788  1044 -      R+   pts/1    5352:22 btrfs balance start /storage/
0  1000 17901 13293  20   0  12288  2136 -      R+   pts/5      0:00 grep --color=auto btrfs
