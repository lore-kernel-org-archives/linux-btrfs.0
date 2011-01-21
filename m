From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Adding a disk fails
Date: 21 Jan 2011 14:23:00 +0100
Message-ID: <BeHd0LYD1uB@helmut.hullen.de>
References: <4D38B382.1050709@libero.it>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D38B382.1050709@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Goffredo,

Du meintest am 20.01.11:

> To add another disk you don't have to run mkfs.btrfs. For example:

> # add the first disk
> mkfs.btrfs /dev/sdb
> # mount the disk
> mount /dev/sdb /media/backups

> # add another disk to the first one
> btrfs device add /dev/sdc /media/backup

> Note1: the filesystem has to be mounted
> Note2: the medatada will be in raid1, the data in raid0

I've just tried ...

creating /dev/sde with 2 TByte
adding /dev/sdf with 60 GByte (it's easier to check "ENOSPACE" with such  
a small device)

copying 94 Gbyte

and then

  btrfs filesystem balance /mnt/btr

(needed about 40 minutes for 94 GByte)
leads to


# btrfs filesystem show
Label: none  uuid: 121ae2ed-f572-43e6-8855-cd66ad534401
	Total devices 2 FS bytes used 94.68GB
	devid    2 size 37.27GB used 37.00GB path /dev/sdf
	devid    1 size 1.82TB used 63.04GB path /dev/sde

Label: 'MM2'  uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
	Total devices 2 FS bytes used 1.15TB
	devid    1 size 1.81TB used 591.14GB path /dev/sde2
	*** Some devices missing

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data, RAID0: total=4.00GB, used=2.00GB
Data: total=94.01GB, used=92.58GB
System, DUP: total=8.00MB, used=16.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=111.87MB
Metadata: total=8.00MB, used=0.00

# df -t btrfs
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sde     btrfs   1992597264  99396500 1891304076   5% /mnt/btr

# fdisk -l

# btrfs filesystem show
Label: none  uuid: 121ae2ed-f572-43e6-8855-cd66ad534401
	Total devices 2 FS bytes used 93.68GB
	devid    2 size 37.27GB used 36.12GB path /dev/sdf
	devid    1 size 1.82TB used 93.16GB path /dev/sde

Label: 'MM2'  uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
	Total devices 2 FS bytes used 1.15TB
	devid    1 size 1.81TB used 591.14GB path /dev/sde2
	*** Some devices missing

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data, RAID0: total=64.00GB, used=31.90GB
Data: total=63.01GB, used=61.67GB
System, DUP: total=8.00MB, used=20.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=128.00MB, used=104.71MB
Metadata, DUP: total=1.00GB, used=6.15MB
Metadata: total=8.00MB, used=0.00

# df -t btrfs
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sde     btrfs   1992597264  98348716 1892087652   5% /mnt/btr


# -----------------------------------------

Look especially to "btrfs filesystem df /mnt/btr", it shows

  Data, RAID0: total=64.00GB, used=31.90GB
  Data: total=63.01GB, used=61.67GB

and that will lead to "no space left on device ...".

Viele Gruesse!
Helmut
