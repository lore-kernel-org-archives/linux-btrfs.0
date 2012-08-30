Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:46393 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab2H3SYG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Aug 2012 14:24:06 -0400
Message-ID: <503FAFF5.80204@libero.it>
Date: Thu, 30 Aug 2012 20:24:53 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: M G Berberich <btrfs@oss.m-berberich.de>
CC: linux-btrfs@vger.kernel.org, Hubert Kario <kario@wit.edu.pl>
Subject: Re: =?UTF-8?B?4oCcQnVn4oCdLXJlcG9ydDogaW5jb25zaXN0ZW5jeSBrZXJuZWw=?=
 =?UTF-8?B?IDwtPiB0b29scw==?=
References: <20120828195244.GA15021@invalid>
In-Reply-To: <20120828195244.GA15021@invalid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/28/2012 09:52 PM, M G Berberich wrote:
> Hello,
>
> We had set up a btrfs-fs over 6 hot-plugable SAS-disks for
> testing and got it into a state where kernel and btrfs-tools do not
> agree any more about the state of the filesystem.
>
> We do not remember exaclty what we did, but roughly it was something
> like this (on the running system). THIS IS FROM MEMORY!
>
> (1) pulled out one disk
> (2) removed disk from btrfs
> (3) rebalanced btrfs
> (4) pulled out another disk
> (5) removed disk from btrfs
> (6) rebalanced btrfs
>
> This went fine sofar.
>
> (7) reinserted disk (and rebooted)
>      At some point before reboot the first 10 sectors of one disk
>      were zeroed to test if the disk gets removed from the btrfs.

IIRC the superblock is not placed at the beginning of the disk. On the 
basis of [1] it should be near the 64KB (around the sector #128)


[1] 
https://btrfs.wiki.kernel.org/index.php/User:Wtachi/On-disk_Format#Superblock
>
> Now btrfs-tools showed:
>
> ---------------------------------------------------------------------------
> # btrfs fi show
> failed to read /dev/sr0
> Label: 'BTRFS_RAID'  uuid: 807193fd-17de-4088-9a54-3e7cacdc89db
>          Total devices 6 FS bytes used 3.07GB
>          devid    4 size 931.00GB used 75.00GB path /dev/sdf
>          devid    5 size 931.00GB used 324.03GB path /dev/sde
>          devid    6 size 931.00GB used 83.03GB path /dev/sdd
>          devid    3 size 931.00GB used 326.03GB path /dev/sdc
>          devid    2 size 931.00GB used 326.03GB path /dev/sdb
>          devid    1 size 931.00GB used 324.04GB path /dev/sda

"btrfs filesystem show" shows the content of the disks, which could be 
unrelated to the kernel status. Pay attention that if the data is not 
flushed to the disk the report of "btrfs fi show" could be unreliable.

I posted few days ago a patch which adds the sysfs support to btrfs. 
With this support it is possible to know the real state of the disks.

For example I have a filesystem with 4 disks (note "Total devices 4"):

   ghigo@emulato:~$ sudo btrfs fi show
   Label: 'btrfs3'  uuid: 2a66286d-63e9-4ed5-b347-5af5e4ada814
	Total devices 4 FS bytes used 284.00KB
	devid    4 size 100.00GB used 8.01GB path /dev/vdj
	devid    3 size 100.00GB used 6.04GB path /dev/vdi
	devid    5 size 100.00GB used 0.00 path /dev/vdh
	devid    1 size 100.00GB used 7.05GB path /dev/vdg

   Btrfs Btrfs v0.19

My sysfs interface says that the filesystem is composed by 4 disks:

   ghigo@emulato:~$ cat /sys/fs/btrfs/filesystems/2a66286d-
   63e9-4ed5b347-5af5e4ada814/fs_devices/open_devices
   4

Then I remove 1 disk

   ghigo@emulato:~$ sudo btrfs dev del /dev/vdi  /mnt/btrfs3/

Now the sysfs interface says:

   ghigo@emulato:~$ cat /sys/fs/btrfs/filesystems/2a66286d-
   63e9-4ed5b347-5af5e4ada814/fs_devices/open_devices
   3

But "btrfs filesystem show" says (note still "Total devices 4"):

   ghigo@emulato:~$ sudo btrfs fi show
   failed to read /dev/sr0
   Label: 'btrfs3'  uuid: 2a66286d-63e9-4ed5-b347-5af5e4ada814
	Total devices 4 FS bytes used 92.00KB
	devid    4 size 100.00GB used 7.00GB path /dev/vdj
	devid    3 size 100.00GB used 6.04GB path /dev/vdi
	devid    5 size 100.00GB used 5.06GB path /dev/vdh
	devid    1 size 100.00GB used 6.08GB path /dev/vdg

   Btrfs Btrfs v0.19

Then I do a sync

   ghigo@emulato:~$ sync
   ghigo@emulato:~$ sudo btrfs fi show
   failed to read /dev/sr0
   Label: 'btrfs3'  uuid: 2a66286d-63e9-4ed5-b347-5af5e4ada814
	Total devices 3 FS bytes used 92.00KB
	devid    4 size 100.00GB used 7.00GB path /dev/vdj
	devid    3 size 100.00GB used 6.04GB path /dev/vdi
	devid    5 size 100.00GB used 5.06GB path /dev/vdh
	devid    1 size 100.00GB used 6.08GB path /dev/vdg

   Btrfs Btrfs v0.19

(note "Total devices 3")

And magically the filesystem is now composed by three disks. However 4 
physical devices are show. This because the disk /dev/vdi superblock 
says that the disk is still valid (after the "btrfs device del" the disk 
is not touched any more)

In the past Hubert posted a patch [2] to clear a btrfs superblock. A 
further enhancement of the "btrfs device del" could be to reset 
automatically the first superblock (leaving the backup ones unaffected).



[2] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/17065
>
> Btrfs Btrfs v0.19
> ---------------------------------------------------------------------------
>
> As far as we can tell, only four of the disks are considered part of
> the btrfs by kernel. There were only four “btrfs: bdev”-lines in dmesg
> and only four disks took part in balancing. “btrfs device scan” says:
>
>    unable to scan the device '/dev/sdd' - Device or resource busy
>
> and balance does not balance theses two devices (of 6)
>
> It was neither possible to remove the disk from the btrfs via “btrfs
> device delete” nor adding them via “btrfs device add”.
>
> (8) a colleague swaped the two disk
>
> Now btrfs-tools showed:
>
> ---------------------------------------------------------------------------
> # btrfs fi show
> failed to read /dev/sr0
> Label: 'BTRFS_RAID'  uuid: 807193fd-17de-4088-9a54-3e7cacdc89db
>          Total devices 5 FS bytes used 3.01GB
>          devid    6 size 931.00GB used 83.03GB path /dev/sdf
>          devid    4 size 931.00GB used 75.00GB path /dev/sdd
>          devid    5 size 931.00GB used 325.03GB path /dev/sde
>          devid    3 size 931.00GB used 326.03GB path /dev/sdc
>          devid    2 size 931.00GB used 325.03GB path /dev/sdb
>          devid    1 size 931.51GB used 326.04GB path /dev/sda
>
> Btrfs Btrfs v0.19
> ---------------------------------------------------------------------------
>
> Claiming the btrfs has 5 disk, but listing 6 disks out of 5 (6 of 5).
>
> He finally managed to get the btrfs complete again by overwriting the
> first 100G of the two disk. After this the btrfs-tools (correctly)
> stated a filesystem with 4 disk and it was possible to add the two
> disk again.
>
>
> Assumption:
> kernel and btrfs do not share the same view of the filesystem.
>
> In this state commands to repair the filesystem do not work, because
> they are either rejected by the tools or by the kernel.
>
> A tool that allows a disk/partition to be marked as not-a-btrfs-part
> would be nice.
>
> A “/proc/btrfs” showing the kernels view of the filesystem would be
> usefull.
>
> 	MfG
> 	bmg
>

