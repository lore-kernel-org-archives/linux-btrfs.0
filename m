From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: "not enough space" with "data raid0"
Date: 17 Mar 2012 14:46:00 +0100
Message-ID: <C52qGigT1uB@helmut.hullen.de>
References: <20120317122522.GD3172@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120317122522.GD3172@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 17.03.12:

[no space left on device ...]

>>> Where is the problem, how can I use the full space?

>> Effectively it's missing the trigger to rebalance when the 'primary'
>> device starts to get full, or just to randomly spread the data
>> between the devices.

>    No, a balance isn't going to help here. RAID-0 requires a minimum
> of 2 chunks in a block group. With two disks, you're only going to be
> able to fill the smallest one before you run out of space.

Ok - it happens only with 2 disks/Partitions?

I've continued playing; added a 3rd partition/device and then balanced:


# btrfs device add /dev/sdd1 /mnt/btr
## 73 + 146 + 146 GByte

# df

Filesystem             1K-blocks       Used  Available Use% Mounted on
/dev/sdc1              358432300  225400136   59842800  80% /mnt/btr

# added about 70 GByte (all together more than 3 times the smallest partition)

# btrfs fi show

Label: 'Scsi'  uuid: e30586e9-a903-4d17-8ec0-1781457212c6
	Total devices 3 FS bytes used 214.67GB
	devid    1 size 68.37GB used 68.37GB path /dev/sdb1
	devid    3 size 136.73GB used 41.01GB path /dev/sdd1
	devid    2 size 136.73GB used 109.36GB path /dev/sdc1

Btrfs Btrfs v0.19

# btrfs fi df /mnt/btr

Data, RAID0: total=216.71GB, used=214.38GB
System, RAID1: total=8.00MB, used=24.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=1.00GB, used=295.13MB

=================================================================

# btrfs fi balance /mnt/btr

# btrfs fi show

Label: 'Scsi'  uuid: e30586e9-a903-4d17-8ec0-1781457212c6
	Total devices 3 FS bytes used 214.67GB
	devid    1 size 68.37GB used 67.34GB path /dev/sdb1
	devid    3 size 136.73GB used 40.85GB path /dev/sdd1
	devid    2 size 136.73GB used 107.85GB path /dev/sdc1

Btrfs Btrfs v0.19

# btrfs fi df /mnt/btr

Data, RAID0: total=215.01GB, used=214.38GB
System, RAID1: total=8.00MB, used=24.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=512.00MB, used=294.88MB

----------------------------------------------------------------------

Looks as desired, the 3-disks-system contains more than 3 times the  
smallest disk.

Balancing hasn't redistributed the contents - no problem.

By the way: you should name the prefixes in the NIST way for powers of  
2: KiB, MiB, GiB. Or change to decimal prefixes.

Viele Gruesse!
Helmut
