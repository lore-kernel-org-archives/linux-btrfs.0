From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: BTRFS thinks that a device is mounted
Date: 21 Oct 2011 03:33:00 +0200
Message-ID: <BwGkwFbT1uB@helmut.hullen.de>
References: <a46ac41f14ba1581cb554a0f26463859.squirrel@webmail01.edunet.gr>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a46ac41f14ba1581cb554a0f26463859.squirrel@webmail01.edunet.gr>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Nikos,

Du meintest am 21.10.11:

> What went wrong in the following scenario? BTRFS thinks that a device
> is mounted while it is not.

[...]

> btrfs device scan /dev/sdh
> Scanning for Btrfs filesystems in '/dev/sdh'
> ERROR: unable to scan the device '/dev/sdh' - Invalid argument

> ## Comment: OK, we give up. Try to recreate btrfs from scratch
> mkfs.btrfs -m raid1 -d raid1 /dev/sdg /dev/sdh /dev/sdl

> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using

> /dev/sdh is mounted

> ## Comment: Of course /dev/sdh is not mounted.
> mount |grep /dev/sdh
> root@lxc:~#

Two days ago I've seen a perhaps similar problem with an ext3 disk:

Connected via USB
running fsck (with some options)

   mount /dev/$disk $mountpoint

also told that the disk was mounted (it wasn't really).

Maybe some other operation (like - in this case - fsck) on/with the disk  
leads to this wrong message.

Viele Gruesse!
Helmut
