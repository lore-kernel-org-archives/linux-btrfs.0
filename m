From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: BTRFS, encrypted LVM and disk write cache ?
Date: Fri, 13 May 2011 16:43:00 +0700
Message-ID: <BANLkTinRZGbqqXsme0gMbtxkdUpFwmYMbQ@mail.gmail.com>
References: <1305179125.3106.3.camel@tethys>
	<20110512154224.GD19041@dhcp231-156.rdu.redhat.com>
	<1305236204.3277.1.camel@tethys>
	<BANLkTimQVkzzhaQiur92KxQ2yBgGap5eRA@mail.gmail.com>
	<1305277193.3052.24.camel@tethys>
	<BANLkTi=CF--tqdo0AtnFYbaepMP=-_ZKuw@mail.gmail.com>
	<1305279210.3052.28.camel@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305279210.3052.28.camel@tethys>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 13, 2011 at 4:33 PM, Sw=E2mi Petaramesh <swami@petaramesh.o=
rg> wrote:
> # uname -a
> Linux tethys 2.6.38-8-generic #42-Ubuntu SMP Mon Apr 11 03:31:50 UTC
> 2011 i686 i686 i386 GNU/Linux
>
> # mount | grep btrfs
> /dev/mapper/VG1-TETHYS on / type btrfs
> (rw,relatime,subvol=3DUBUNTU,compress=3Dzlib)
> /dev/mapper/VG1-TETHYS on /tmp type btrfs
> (rw,relatime,subvol=3DTMP,compress=3Dzlib)
> /dev/mapper/VG1-TETHYS on /home type btrfs
> (rw,relatime,subvol=3DHOME,compress=3Dzlib)
> /dev/mapper/VG1-TETHYS on /var type btrfs
> (rw,relatime,subvol=3DVAR,compress=3Dzlib)
> /dev/sda2 on /boot type btrfs (rw,relatime,compress=3Dzlib)
>

Weird.

$ sudo btrfs su li /
ID 256 top level 5 path natty
ID 258 top level 5 path home

$ sudo mount /dev/sda2 -o subvol=3Dhome /mnt/tmp

$ ls /mnt/tmp

$ sudo umount /mnt/tmp

$ sudo mount /dev/sda2 -o subvolid=3D258 /mnt/tmp

$ ls /mnt/tmp
user

$ sudo umount /mnt/tmp

$ uname -a
Linux HP 2.6.38-9-generic #43-Ubuntu SMP Thu Apr 28 15:25:15 UTC 2011
i686 i686 i386 GNU/Linux

I don't even know what got mounted when I use "-o subvol=3Dhome" since
all of my subvolumes have some files/directory on it, while the mount
shows nothing on it :P

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
