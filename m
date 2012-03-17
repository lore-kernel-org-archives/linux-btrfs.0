From: "Helmut Hullen" <Hullen@t-online.de>
Subject: "not enough space" with "data raid0"
Date: 17 Mar 2012 13:01:00 +0100
Message-ID: <C52pxfli1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

I've (once more) created my test system:

  mkfs.btrfs -d raid0 -m raid1 /dev/sdb1 /dev/sdc1

73 GB + 146 GB.

Then I mounted it and copied about 150 GByte onto it. But copying was  
incomplete, the job ended with "no space on ..."


# btrfs fi show

Label: 'Scsi'  uuid: e30586e9-a903-4d17-8ec0-1781457212c6
	Total devices 2 FS bytes used 134.86GB
	devid    1 size 68.37GB used 68.37GB path /dev/sdb1
	devid    2 size 136.73GB used 68.35GB path /dev/sdc1

Btrfs Btrfs v0.19

# btrfs fi df <mountpoint>

Data, RAID0: total=134.68GB, used=134.67GB
Data: total=8.00MB, used=8.00MB
System, RAID1: total=8.00MB, used=16.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.00GB, used=185.39MB
Metadata: total=8.00MB, used=0.00

# df <mountpoint>

Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/sdc1      215059324 141597364      8724 100% /mnt/btr

# fdisk -l

Disk /dev/sdb: 73.4 GB, 73407868928 bytes
Disk /dev/sdc: 146.8 GB, 146814976000 bytes

-----------------------------------

Where is the problem, how can I use the full space?

Viele Gruesse!
Helmut
