Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:54792 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaLHPAv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 10:00:51 -0500
Received: by mail-qg0-f48.google.com with SMTP id f51so677827qge.35
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Dec 2014 07:00:50 -0800 (PST)
Message-ID: <5485BCED.1060705@ubuntu.com>
Date: Mon, 08 Dec 2014 09:59:57 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Konstantin <newsbox1026@web.de>, MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com> <547CE175.6060409@web.de> <547E10BA.6000707@ubuntu.com> <5484F198.3070206@web.de>
In-Reply-To: <5484F198.3070206@web.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/7/2014 7:32 PM, Konstantin wrote:
>> I'm guessing you are using metadata format 0.9 or 1.0, which put
>> the metadata at the end of the drive and the filesystem still
>> starts in sector zero.  1.2 is now the default and would not have
>> this problem as its metadata is at the start of the disk ( well,
>> 4k from the start ) and the fs starts further down.
> I know this and I'm using 0.9 on purpose. I need to boot from
> these disks so I can't use 1.2 format as the BIOS wouldn't
> recognize the partitions. Having an additional non-RAID disk for
> booting introduces a single point of failure which contrary to the
> idea of RAID>0.

The bios does not know or care about partitions.  All you need is a
partition table in the MBR and you can install grub there and have it
boot the system from a mdadm 1.1 or 1.2 format array housed in a
partition on the rest of the disk.  The only time you really *have* to
use 0.9 or 1.0 ( and you really should be using 1.0 instead since it
handles larger arrays and can't be confused vis. whole disk vs.
partition components ) is if you are running a raid1 on the raw disk,
with no partition table and then partition inside the array instead,
and really, you just shouldn't be doing that.

> Anyway, to avoid a futile discussion, mdraid and its format is not
> the problem, it is just an example of the problem. Using dm-raid
> would do the same trouble, LVM apparently, too. I could think of a
> bunch of other cases including the use of hardware based RAID
> controllers. OK, it's not the majority's problem, but that's not
> the argument to keep a bug/flaw capable of crashing your system.

dmraid solves the problem by removing the partitions from the
underlying physical device ( /dev/sda ), and only exposing them on the
array ( /dev/mapper/whatever ).  LVM only has the problem when you
take a snapshot.  User space tools face the same issue and they
resolve it by ignoring or deprioritizing the snapshot.

> As it is a nice feature that the kernel apparently scans for drives
> and automatically identifies BTRFS ones, it seems to me that this
> feature is useless. When in a live system a BTRFS RAID disk fails,
> it is not sufficient to hot-replace it, the kernel will not
> automatically rebalance. Commands are still needed for the task as
> are with mdraid. So the only point I can see at the moment where
> this auto-detect feature makes sense is when mounting the device
> for the first time. If I remember the documentation correctly, you
> mount one of the RAID devices and the others are automagically
> attached as well. But outside of the mount process, what is this
> auto-detect used for?
> 
> So here a couple of rather simple solutions which, as far as I can
> see, could solve the problem:
> 
> 1. Limit the auto-detect to the mount process and don't do it when 
> devices are appearing.
> 
> 2. When a BTRFS device is detected and its metadata is identical to
> one already mounted, just ignore it.

That doesn't really solve the problem since you can still pick the
wrong one to mount in the first place.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUhbztAAoJENRVrw2cjl5RomkH/26Q3M6LXVaF0qEcEzFTzGEL
uVAOKBY040Ui5bSK0WQYnH0XtE8vlpLSFHxrRa7Ygpr3jhffSsu6ZsmbOclK64ZA
Z8rNEmRFhOxtFYTcQwcUbeBtXEN3k/5H49JxbjUDItnVPBoeK3n7XG4i1Lap5IdY
GXyLbh7ogqd/p+wX6Om20NkJSx4xzyU85E4ZvDADQA+2RIBaXva5tDPx5/UD4XBQ
h8ai+wS1iC8EySKxwKBEwzwb7+Z6w7nOWO93v/lL34fwTg0OIY9uEfTaAy5KcDjz
z6QXWTmvrbiFpyy/qyGSqBGlPjZ+r98mVEDbYWCVfK8AoD6UmteD7R8WAWkWiWY=
=PJww
-----END PGP SIGNATURE-----
