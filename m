From: Hullen@t-online.de (Helmut Hullen)
Subject: failed disk (was: kernel 3.3.4 damages filesystem (?))
Date: 09 May 2012 16:25:00 +0200
Message-ID: <C8XIuHi9CXB@helmut.hullen.de>
References: <20120507180047.GG8938@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120507180047.GG8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 07.05.12:

[...]

>> With a file system like ext2/3/4 I can work with several directories
>> which are mounted together, but (as said before) one broken disk
>> doesn't disturb the others.

>    mkfs.btrfs -m raid1 -d single should give you that.

Just a small bug, perhaps:

created a system with

        mkfs.btrfs -m raid1 -d single /dev/sdl1
        mount /dev/sdl1 /mnt/Scsi
        btrfs device add /dev/sdk1 /mnt/Scsi
        btrfs device add /dev/sdm1 /mnt/Scsi
        (filling with data)

and

        btrfs fi df /mnt/Scsi

now tells

Data, RAID0: total=183.18GB, used=76.60GB
Data: total=80.01GB, used=79.83GB
System, DUP: total=8.00MB, used=32.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=192.74MB
Metadata: total=8.00MB, used=0.00

--------------------------------------

"Data, RAID0" confuses me (not very much ...), and the system for  
metadata (RAID1) is not told.


Viele Gruesse!
Helmut
