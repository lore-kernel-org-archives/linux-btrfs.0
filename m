From: Michael Kofler <michael.kofler@gmx.com>
Subject: how to find out total capacity and raid level of btrfs file system
Date: Sat, 31 Jul 2010 13:59:35 +0200
Message-ID: <4C541027.3020105@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I know df does not report the correct size for btrfs raid systems. Is 
there any other way to find out the total capacity of a btrfs file 
system? Or at least the raid level for data / metadata?

My test system is Ubuntu 10.10 alpha with btrfs 0.19 and a 2.6.35 kernel 
(don't know which rc).

# uname -a
Linux ubuntu 2.6.35-12-generic #17-Ubuntu SMP Mon Jul 26 18:48:06 UTC 
2010 x86_64 GNU/Linux


I created a raid1 system consisting of two 8GB devices (so total 
capacity would be 8 GB for system + metadata + data)

# mkfs.btrfs -d raid1 -m raid1 /dev/sdb1 /dev/sdc1
# mount /dev/sdb1 /media/btrfs

Now I gather all information I can with btrfs:

# btrfs filesystem show /dev/sdb1
Label: none  uuid: dc691a5d-187e-4cb4-a94a-d12dabdffde4
	Total devices 2 FS bytes used 28.00KB
	devid    1 size 8.00GB used 2.03GB path /dev/sdb1
	devid    2 size 8.00GB used 2.01GB path /dev/sdc1
# btrfs filesystem df /media/btrfs/
Data:     total=1.01GB, used=0.00
Metadata: total=1.01GB, used=24.00KB
System:   total=12.00MB, used=4.00KB

Is there a way to find out how devid 1 and devid 2 are used (i.e. which 
raid level)?

Is there a btrfs command to get the total capacity of my filesystem? (In 
my case, it should report total 8 GB, of which 2.03 GB have already been 
claimed for data + metadata, another 5.97 GB are free. It might also say 
6,97 GB for data are still available.)

Thank you,


	Michael Kofler
