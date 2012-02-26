From: "Helmut Hullen" <Hullen@t-online.de>
Subject: "device delete" kills contents
Date: 26 Feb 2012 17:39:00 +0100
Message-ID: <C3b15X3D1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, linux-btrfs,

I've (once again) tried "add" and "delete".

First, with 3 devices (partitions):

  mkfs.btrfs -d raid0 -m raid1 /dev/sdk1 /dev/sdl1 /dev/sdm1


Mounted (to /mnt/btr), filled with about 100 GByte data.

Then

  btrfs device add /dev/sdj1 /mnt/btr

results in

# show
Label: none  uuid: 6bd7d4df-e133-47d1-9b19-3c7565428770
	Total devices 4 FS bytes used 100.44GB
	devid    3 size 68.37GB used 44.95GB path /dev/sdm1
	devid    2 size 136.73GB used 43.95GB path /dev/sdl1
	devid    1 size 16.96GB used 16.96GB path /dev/sdk1
	devid    4 size 136.73GB used 0.00 path /dev/sdj1

Btrfs Btrfs v0.19

# df
Data, RAID0: total=103.81GB, used=100.30GB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.00GB, used=136.29MB
Metadata: total=8.00MB, used=0.00

---------------------------------------------

#

Then

   mkfs filesystem balance /mnt/btr

# show

Label: none  uuid: 6bd7d4df-e133-47d1-9b19-3c7565428770
	Total devices 4 FS bytes used 100.44GB
	devid    3 size 68.37GB used 42.94GB path /dev/sdm1
	devid    2 size 136.73GB used 43.20GB path /dev/sdl1
	devid    1 size 16.96GB used 16.94GB path /dev/sdk1
	devid    4 size 136.73GB used 2.20GB path /dev/sdj1

Btrfs Btrfs v0.19
# df
Data, RAID0: total=104.75GB, used=100.30GB
System, RAID1: total=8.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=256.00MB, used=136.23MB

---------------------------------------------

#########################

Next step:

   btrfs device delete /dev/sdk1 /mnt/btr

# show
Label: none  uuid: 6bd7d4df-e133-47d1-9b19-3c7565428770
	Total devices 4 FS bytes used 100.43GB
	devid    3 size 68.37GB used 43.00GB path /dev/sdm1
	devid    2 size 136.73GB used 43.26GB path /dev/sdl1
	devid    4 size 136.73GB used 17.26GB path /dev/sdj1
	*** Some devices missing

Btrfs Btrfs v0.19
# df
Data, RAID0: total=103.00GB, used=100.30GB
System, RAID1: total=8.00MB, used=12.00KB
Metadata, RAID1: total=256.00MB, used=131.62MB

---------------------------------------------------------

All commands seemed to work well, without any error message.

"blkid" showed the expected data, especially

        blkid /dev/sdk1

shows nothing - the partitions seems to be really empty.

Unmounted, mounted again:

# show
Btrfs Btrfs v0.19

# df
Data: total=8.00MB, used=64.00KB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=24.00KB
Metadata: total=8.00MB, used=0.00

------------------------------------------------

"show" doesn't show any part of the bundle of 3 partitions.

That's more than I've expected from the option "delete" ...

-------------------------------------------------

Famous last words from "dmesg":

device fsid 6bd7d4df-e133-47d1-9b19-3c7565428770 devid 3 transid 437 /dev/sdm1
device fsid 6bd7d4df-e133-47d1-9b19-3c7565428770 devid 2 transid 437 /dev/sdl1
device fsid 6bd7d4df-e133-47d1-9b19-3c7565428770 devid 4 transid 437 /dev/sdj1
device label SCSI devid 1 transid 7 /dev/sdj1
btrfs: disk space caching is enabled
device label SCSI devid 1 transid 10 /dev/sdj1
btrfs: disk space caching is enabled
device label SCSI devid 1 transid 13 /dev/sdj1
btrfs: disk space caching is enabled
device fsid 6bd7d4df-e133-47d1-9b19-3c7565428770 devid 3 transid 437 /dev/sdm1
btrfs: disk space caching is enabled
btrfs: failed to read chunk tree on sdm1
btrfs: open_ctree failed
device fsid 6bd7d4df-e133-47d1-9b19-3c7565428770 devid 2 transid 437 /dev/sdl1
btrfs: disk space caching is enabled
btrfs: failed to read chunk tree on sdm1
btrfs: open_ctree failed
device label SCSI devid 1 transid 16 /dev/sdj1
btrfs: disk space caching is enabled
end_request: I/O error, dev fd0, sector 0
end_request: I/O error, dev fd0, sector 0


--------------------------

My "dmesg" doesn't write time stamps, there may be some lines from  
previous tests.

---------------------------

Kernel 3.2.5 (self made), btrfs from darksatanic.net, "bztfs-progs- 
unstable".

Viele Gruesse!
Helmut
