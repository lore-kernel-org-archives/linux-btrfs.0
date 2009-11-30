From: Andi Drebes <lists-receive@programmierforen.de>
Subject: Re: Unable to mount loopback devices in RAID mode
Date: Mon, 30 Nov 2009 20:25:22 +0100
Message-ID: <200911302025.22773.lists-receive@programmierforen.de>
References: <200911192026.04694.lists-receive@programmierforen.de> <20091130042851.GG25509@jsoft.dyndns.org> <4B13C408.10606@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B13C408.10606@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

> So I do not understand why it does not work correctly for
> him to mount either device.  Maybe this problem is not
> what I see in my testing (using 32) with disk partitions
> instead of loop.
>=20
> With partitions, I only see the mount problem on raid0,
> not on raid1.
Without having looked at the code:
It seems as if this is a problem in mkfs. The first time, I mount the f=
resh image I have to search the correct device. After having mounted it=
 at least once, I can use both devices interchangeably:

$ dd if=3D/dev/zero of=3Draid1_0.img bs=3D1M count=3D500
$ dd if=3D/dev/zero of=3Draid1_1.img bs=3D1M count=3D500
$ mkfs.btrfs -m raid1 -d raid1 raid1_0.img raid1_1.img
$ losetup /dev/loop0 raid1_0.img
$ losetup /dev/loop1 raid1_1.img
$ mount -t btrfs /dev/loop0 /mnt/btrfs
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
=A0 =A0 =A0 =A0missing codepage or helper program, or other error
=A0 =A0 =A0 =A0In some cases useful info is found in syslog - try
=A0 =A0 =A0 =A0dmesg | tail =A0or so
$ mount -t btrfs /dev/loop1 /mnt/btrfs
#OK
$ umount /mnt/btrfs
$ mount -t btrfs -o ro /dev/loop0 /mnt/btrfs
#OK
$ umount /mnt/btrfs
$ mount -t btrfs -o ro /dev/loop1 /mnt/btrfs
#OK

So my guess is, that there's something wrong with mkfs.

	Cheers,
		Andi
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
