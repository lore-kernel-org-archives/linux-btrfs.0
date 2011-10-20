From: "Nikos Voutsinas" <nvoutsin@noc.edunet.gr>
Subject: BTRFS thinks that a device is mounted
Date: Fri, 21 Oct 2011 00:39:05 +0300
Message-ID: <a46ac41f14ba1581cb554a0f26463859.squirrel@webmail01.edunet.gr>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

What went wrong in the following scenario? BTRFS thinks that a device is
mounted while it is not.

BTRFS tools ver: Btrfs v0.19-101-g3891d2d
Uname: 3.1.0-rc7-686-pae


## Comment: Initially we had only root (/) mounted as btrfs
mount |grep btrfs
/dev/sdc2 on / type btrfs (rw,autodefrag)

## Comment: Create a new btrfs fs on /dev/sdg /dev/sdh /dev/sdl
mkfs.btrfs -m raid1 -d raid1 /dev/sdg /dev/sdh /dev/sdl

btrfs filesystem show
Label: none  uuid: f0425f63-e486-4c10-adab-47a23085c8db
        Total devices 3 FS bytes used 28.00KB
        devid    3 size 2.00GB used 200.00MB path /dev/sdl
        devid    2 size 1.00GB used 200.00MB path /dev/sdh
        devid    1 size 768.00MB used 404.00MB path /dev/sdg

Label: none  uuid: cc8211ba-6f62-46d6-ba17-49250f06a941
        Total devices 1 FS bytes used 512.98MB
        devid    1 size 6.09GB used 1.75GB path /dev/sdc2

## Comment: unorthodox, but looks possible, add one of the devices from
the newly created fs to root (/)
btrfs device add /dev/sdh /

## Comment: Remove it back.
btrfs device delete /dev/sdh /


## Comment: We ended up with "*** Some devices missing" on both devices
btrfs filesystem show
Label: none  uuid: 5910f378-0784-4e7f-b918-de35067252e9
        Total devices 3 FS bytes used 28.00KB
        devid    3 size 2.00GB used 200.00MB path /dev/sdl
        devid    1 size 768.00MB used 404.00MB path /dev/sdg
        *** Some devices missing

Label: none  uuid: cc8211ba-6f62-46d6-ba17-49250f06a941
        Total devices 2 FS bytes used 512.59MB
        devid    1 size 6.09GB used 1.50GB path /dev/sdc2
        *** Some devices missing

## Comment: Use btrfs balance to fix root (/)
btrfs filesystem balance /

btrfs filesystem show
Label: none  uuid: 5910f378-0784-4e7f-b918-de35067252e9
        Total devices 3 FS bytes used 28.00KB
        devid    3 size 2.00GB used 200.00MB path /dev/sdl
        devid    1 size 768.00MB used 404.00MB path /dev/sdg
        *** Some devices missing

Label: none  uuid: cc8211ba-6f62-46d6-ba17-49250f06a941
        Total devices 1 FS bytes used 513.40MB
        devid    1 size 6.09GB used 1.75GB path /dev/sdc2

## Comment: try to mount the initially created fs on /mnt. It fails
mount -t btrfs /dev/sdg /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sdg,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

## Comment: See if device scan can do the trick. Nope...
btrfs device scan /dev/sdh
Scanning for Btrfs filesystems in '/dev/sdh'
ERROR: unable to scan the device '/dev/sdh' - Invalid argument

## Comment: OK, we give up. Try to recreate btrfs from scratch
mkfs.btrfs -m raid1 -d raid1 /dev/sdg /dev/sdh /dev/sdl

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

/dev/sdh is mounted

## Comment: Of course /dev/sdh is not mounted.
mount |grep /dev/sdh
root@lxc:~#


Thanks,
Nikos

