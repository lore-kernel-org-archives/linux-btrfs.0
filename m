From: Henning Rohlfs <x+btrfs@xehonk.de>
Subject: raid1 write performanc
Date: Tue, 25 Jan 2011 00:44:57 +0200
Message-ID: <c2a54d7bea60b5e343dfbfafbe29a763@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Hello,

 I recently migrated my system to btrfs on two drives (spinning) 
 configured as raid1. When writing to this filesystem, the system shows 
 some weird behaviour: it starts off with writing to both drives 
 simultaneously for a few seconds, but after that it starts writing to 
 the drives one after another: the system writes first to one drive while 
 the second is idle and then it writes to the second drive while the 
 first is idle.

 During this time all IO to the filesystem seems to hang. This means the 
 system is unusably unresponsive during large writes and the overall 
 write speed averages out at about 30MB/s.

 Any help is appreciated,
 Henning


 server ~ # uname -a
 Linux server 2.6.38-rc2-git1 #1 SMP Mon Jan 24 21:27:58 CET 2011 x86_64 
 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux

 server ~ # btrfs fi df /mnt/pool/
 Data, RAID1: total=832.00GB, used=801.43GB
 System, RAID1: total=8.00MB, used=124.00KB
 System: total=4.00MB, used=0.00
 Metadata, RAID1: total=4.25GB, used=2.50GB

 server ~ # btrfs fi show
 Label: none  uuid: 7676eb78-e411-4505-ac51-ccd12aa5a6b6
 	Total devices 2 FS bytes used 803.94GB
 	devid    1 size 931.28GB used 836.26GB path /dev/sda2
 	devid    3 size 931.27GB used 836.26GB path /dev/sdb2

