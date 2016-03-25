Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36448 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbcCYWbi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 18:31:38 -0400
Received: by mail-io0-f179.google.com with SMTP id 124so124711156iov.3
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 15:31:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAafysEhGJi5jYxHooV4h1tD3pqnc-brbB9k4prS9yK0P5PGdg@mail.gmail.com>
References: <CAAafysGTQucscr-8sTuT2c4BpdAovq0w9UbehRYDrSH71CLF-A@mail.gmail.com>
	<CAPmG0jbXcqfB1jG7WFriMhicdsoZ+pbD_uUBu7v9YiD-ey=jDw@mail.gmail.com>
	<CAAafysEhGJi5jYxHooV4h1tD3pqnc-brbB9k4prS9yK0P5PGdg@mail.gmail.com>
Date: Fri, 25 Mar 2016 18:31:37 -0400
Message-ID: <CAAafysEuE0CXZ2fyY2ybnff3=XLEdGirCU9BJf9mhLE0xFTTrQ@mail.gmail.com>
Subject: Re: RAID Assembly with Missing Empty Drive
From: John Marrett <johnf@zioncluster.ca>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Continuing with my recovery efforts I've built overlay mounts of each
of the block devices supporting my btrfs filesystem as well as the new
disk I'm trying to introduce. I have patched the kernel to disable the
check for multiple missing devices. I then exported the overlayed
devices using iSCSI to a second system to attempt the recovery.

I am able to mount the device rw, then I can remove missing devices
which removes the missing empty disk. I can add in a new device to the
filesystem and then attempt to remove the second missing disk (which
has 2.7 TB of content on it).

Unfortunately this removal fails as follows:

ubuntu@btrfs-recovery:~$ sudo btrfs device delete missing /mnt
ERROR: error removing the device 'missing' - Input/output error

The kernel shows:

[ 2772.000680] BTRFS warning (device sdd): csum failed ino 257 off
695730176 csum 2566472073 expected csum 2706136415
[ 2772.000724] BTRFS warning (device sdd): csum failed ino 257 off
695734272 csum 2566472073 expected csum 2558511802
[ 2772.000736] BTRFS warning (device sdd): csum failed ino 257 off
695746560 csum 2566472073 expected csum 3360772439
[ 2772.000742] BTRFS warning (device sdd): csum failed ino 257 off
695750656 csum 2566472073 expected csum 1205516886
[...]

Can anyone offer any advice as to how I should proceed from here?

One safe option is recreating the array. Now that I have discovered I
can mount the filesystem in degraded,ro mode I could purchase another
new disk, this will give me enough free disk space to copy all the
data off this array and onto a new non-redundant array. I can then add
all the drives in to the new array and convert it back to RAID1.

Here's a full breakdown of the commands that I ran in the process I
describe above; my patch only allows a remount with a missing device,
it's not very significant:

ubuntu@btrfs-recovery:~$ sudo mount -o degraded,ro /dev/sda /mnt
ubuntu@btrfs-recovery:~$ sudo mount -o remount,rw /mnt

Here we see the two missing devices:

ubuntu@btrfs-recovery:~$ sudo btrfs filesystem show
Label: none  uuid: 67b4821f-16e0-436d-b521-e4ab2c7d3ab7
    Total devices 7 FS bytes used 5.47TiB
    devid    1 size 1.81TiB used 1.71TiB path /dev/sde
    devid    2 size 1.81TiB used 1.71TiB path /dev/sda
    devid    3 size 1.82TiB used 1.72TiB path /dev/sdc
    devid    4 size 1.82TiB used 1.72TiB path /dev/sdd
    devid    5 size 2.73TiB used 2.62TiB path /dev/sdf
    devid    6 size 2.73TiB used 2.62TiB path
    devid    7 size 2.73TiB used 0.00 path

I remove the first missing device:

ubuntu@btrfs-recovery:~$ sudo btrfs device delete missing /mnt

The unused missing device is removed:

ubuntu@btrfs-recovery:~$ sudo btrfs filesystem show
Label: none  uuid: 67b4821f-16e0-436d-b521-e4ab2c7d3ab7
    Total devices 6 FS bytes used 5.47TiB
    devid    1 size 1.81TiB used 1.71TiB path /dev/sde
    devid    2 size 1.81TiB used 1.71TiB path /dev/sda
    devid    3 size 1.82TiB used 1.72TiB path /dev/sdc
    devid    4 size 1.82TiB used 1.72TiB path /dev/sdd
    devid    5 size 2.73TiB used 2.62TiB path /dev/sdf
    devid    6 size 2.73TiB used 2.62TiB path

I add a new device:

ubuntu@btrfs-recovery:~$ sudo btrfs device add /dev/sdb /mnt
ubuntu@btrfs-recovery:~$ sudo btrfs filesystem show
Label: none  uuid: 67b4821f-16e0-436d-b521-e4ab2c7d3ab7
    Total devices 7 FS bytes used 5.47TiB
    devid    1 size 1.81TiB used 1.71TiB path /dev/sde
    devid    2 size 1.81TiB used 1.71TiB path /dev/sda
    devid    3 size 1.82TiB used 1.72TiB path /dev/sdc
    devid    4 size 1.82TiB used 1.72TiB path /dev/sdd
    devid    5 size 2.73TiB used 2.62TiB path /dev/sdf
    devid    6 size 2.73TiB used 2.62TiB path
    devid    7 size 2.73TiB used 0.00 path /dev/sdb

Here's some more details on the techniques necessary to get to this
point, in the hopes that others can benefit from them. I will also
update the apparently broken parallels scripts on the mdadm wiki.

To create overlay mounts use the following script; it will create
overlays for each device in the device list, using a sparse overlay
file located in /home/ubuntu/$device-overlay, each overlay will be
performed using a 512 MB file (the size passed to truncate).

for device in sda3 sdb3 sdc1 sdd1 sde1 sdf1; do
  dev=/dev/$device
  ovl=/home/ubuntu/$device-overlay
  truncate -s512M $ovl
  newdevname=$device
  size=$(blockdev --getsize "$dev")
  loop=$(losetup -f --show -- "$ovl")
  echo Setting up loop for $dev using overlay $ovl on loop $loop for
target $newdevname
  printf '%s\n' "0 $size snapshot $dev $loop P 8" | dmsetup create "$newdevname"
done

I used iscsitarget to export the block devices from the server,
configuration files are as follows (on ubuntu):

Install

sudo apt install iscsitarget

Enable

/etc/default/iscsitarget
ISCSITARGET_ENABLE=true

Exports

/etc/iet/ietd.conf

Target iqn.2001-04.com.example:storage.lun1
        IncomingUser
        OutgoingUser
        Lun 0 Path=/dev/mapper/sda3,Type=fileio
        Alias LUN1

Target iqn.2001-04.com.example:storage.lun2
        IncomingUser
        OutgoingUser
        Lun 0 Path=/dev/mapper/sdb3,Type=fileio
        Alias LUN2

Target iqn.2001-04.com.example:storage.lun3
        IncomingUser
        OutgoingUser
        Lun 0 Path=/dev/mapper/sdc1,Type=fileio
        Alias LUN3

Target iqn.2001-04.com.example:storage.lun4
        IncomingUser
        OutgoingUser
        Lun 0 Path=/dev/mapper/sdd1,Type=fileio
        Alias LUN4

Target iqn.2001-04.com.example:storage.lun5
        IncomingUser
        OutgoingUser
        Lun 0 Path=/dev/mapper/sde1,Type=fileio
        Alias LUN5

Target iqn.2001-04.com.example:storage.lun6
        IncomingUser
        OutgoingUser
        Lun 0 Path=/dev/mapper/sdf1,Type=fileio
        Alias LUN6

Start the service:

/etc/init.d/iscsitarget start

On the client I accessed these exports using open-iscsi as follows:

Install

sudo apt install open-iscsi

Discover LUNs (on host carbon):

sudo iscsiadm -m discovery -t st -p carbon

Add nodes:

sudo iscsiadm -m node

The exported disks will appear as new block devices as /dev/sd*

ubuntu@btrfs-recovery:~$ ls -l /dev/sd*
brw-rw---- 1 root disk 8,  0 Mar 25 21:18 /dev/sda
brw-rw---- 1 root disk 8, 16 Mar 25 21:21 /dev/sdb
brw-rw---- 1 root disk 8, 32 Mar 25 21:18 /dev/sdc
brw-rw---- 1 root disk 8, 48 Mar 25 21:18 /dev/sdd
brw-rw---- 1 root disk 8, 64 Mar 25 21:18 /dev/sde
brw-rw---- 1 root disk 8, 80 Mar 25 21:18 /dev/sdf
