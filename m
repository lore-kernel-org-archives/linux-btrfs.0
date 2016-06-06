Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42634 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750884AbcFFFoU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 01:44:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 0C2F420ABD
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Jun 2016 01:44:19 -0400 (EDT)
Message-Id: <1465191858.3381218.628872649.1C5D6003@webmail.messagingengine.com>
From: Kai Hendry <hendry@iki.fi>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: btrfs device delete /dev/sdc1 /mnt/raid1 user experience
Date: Mon, 06 Jun 2016 13:44:18 +0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,


I planned to remove one of my disks, so that I can take it from
Singapore to the UK and then re-establish another remote RAID1 store.

delete is an alias of remove, so I added a new disk (devid 3) and
proceeded to run:
btrfs device delete /dev/sdc1 /mnt/raid1 (devid 1)


nuc:~$ uname -a
Linux nuc 4.5.4-1-ARCH #1 SMP PREEMPT Wed May 11 22:21:28 CEST 2016
x86_64 GNU/Linux
nuc:~$   btrfs --version
btrfs-progs v4.5.3
nuc:~$ sudo btrfs fi show /mnt/raid1/
Label: 'extraid1'  uuid: 5cab2a4a-e282-4931-b178-bec4c73cdf77
        Total devices 2 FS bytes used 776.56GiB
        devid    2 size 931.48GiB used 778.03GiB path /dev/sdb1
        devid    3 size 1.82TiB used 778.03GiB path /dev/sdd1

nuc:~$ sudo btrfs fi df /mnt/raid1/
Data, RAID1: total=775.00GiB, used=774.39GiB
System, RAID1: total=32.00MiB, used=144.00KiB
Metadata, RAID1: total=3.00GiB, used=2.17GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


First off, I was expecting btrfs to release the drive pretty much
immediately. The command took about half a day to complete. I watched
`btrfs fi show` to see size of devid 1 (the one I am trying to remove)
to be zero and to see used space slowly go down whilst used space of
devid 3 (the new disk) slowly go up.

Secondly and most importantly my /dev/sdc1 can't be mounted now anymore.
Why?

sudo mount -t btrfs /dev/sdc1 /mnt/test/
mount: wrong fs type, bad option, bad superblock on /dev/sdc1,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

There is nothing in dmesg nor my journal. I wasn't expecting my drive to
be rendered useless on removing or am I missing something?

nuc:~$ sudo fdisk -l /dev/sdc
Disk /dev/sdc: 931.5 GiB, 1000204885504 bytes, 1953525167 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 33553920 bytes
Disklabel type: gpt
Disk identifier: 19938642-3B10-4220-BF99-3E12AF1D1CF6

Device     Start        End    Sectors   Size Type
/dev/sdc1   2048 1953525133 1953523086 931.5G Linux filesystem

On #btrfs IRC channel I'm told:

<Knorrie> hendry: breaking multi-disk filesystems in half is not a
recommended way to do "normal operations" :D

I'm still keen to take a TB on a flight with me the day after tomorrow.
What is the recommended course of action? Recreate a mkfs.btrfs on
/dev/sdc1 and send data to it from /mnt/raid1?

Still I hope the experience could be improved to remove a disk sanely.

Many thanks,
