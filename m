From: "Helmut Hullen" <Hullen@t-online.de>
Subject: btrfs crashes
Date: 29 Jan 2011 20:30:00 +0100
Message-ID: <BemzWR+y1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

for some hours I was happy ...

   mkfs.btrfs /dev/sde1
   mount /dev/sde1 /mnt/btr
   <copy about 1.5 TByte>
   btrfs device add /dev/sdd1
   <copy about 0.8 TByte>

led to


# btrfs filesystem show
Label: 'MM2'  uuid: 7400b83c-f3dd-477c-bbf4-7429863a7ef9
	Total devices 2 FS bytes used 2.25TB
	devid    1 size 1.81TB used 1.51TB path /dev/sde1
	devid    2 size 1.82TB used 760.50GB path /dev/sdd1

Btrfs Btrfs v0.19

# btrfs filesystem df /srv/MM
Data: total=2.25TB, used=2.24TB
System, DUP: total=8.00MB, used=260.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=5.00GB, used=3.53GB
Metadata: total=8.00MB, used=0.00

# df -t btrfs
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sde1    btrfs   3898172184 2416726548 1478325628  63% /srv/MM

# fdisk -l
/dev/sde1               1      242600  1948684468+  83  Linux
/dev/sdd1               1      242700  1949487718+  83  Linux

# --------------------------------------

All seemed to work well. No "no space left ...".

Then I shut down the machine and started it again the next day.

        btrfs filesystem show

showed the 2 devices.

        mount LABEL=MM2 /mnt/btr

and the system crashed with blinkenlights.

What goes wrong?

How can I restore the data?
I have a backup, but I prefer reanimating the 2 btrfs partitions.

Kernel 2.6.37

Viele Gruesse!
Helmut
