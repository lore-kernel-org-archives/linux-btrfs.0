From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Filesystem acting up during balance
Date: Thu, 8 Dec 2011 10:35:29 -0500
Message-ID: <20111208153529.GK8971@shiny>
References: <CA+NZatJO2U8PhQC_xK9O0uAb9jbVTpfNwuPj-14rffbXhBfu2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Ricardo =?iso-8859-1?Q?B=E1nffy?= <rbanffy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+NZatJO2U8PhQC_xK9O0uAb9jbVTpfNwuPj-14rffbXhBfu2Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 08, 2011 at 09:12:34AM -0200, Ricardo B=E1nffy wrote:
> Hi folks.
>=20
> Last night one of the USB attached disks malfunctioned during a
> balance. I strongly suspect the drive will die soon. A couple hours
> later, with the drive cold, I got a
>=20
> Dec  8 07:34:49 adams kernel: [84890.433235] device label quatrocenta=
o
> devid 1 transid 1659 /dev/sde1
> Dec  8 07:34:49 adams kernel: [84890.460448] btrfs: open_ctree failed
>=20
> I ran btrfsck on it and got
>=20
> root@adams:~# btrfsck /dev/sde1
> found 396558811136 bytes used err is 0
> total csum bytes: 385961240
> total tree bytes: 1334501376
> total fs tree bytes: 756809728
> btree space waste bytes: 346120636
> file data blocks allocated: 396065329152
>  referenced 396065329152
> Btrfs Btrfs v0.19
>=20
> But, when I tried to mount it, I got the much feared:
>=20
> root@adams:~# mount /dev/sde1 /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/sde1,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
>=20
> Running Ubuntu 11.04 here.
>=20
> Now would be a terrific time to have a "salvage broken filesystem"
> utiliy so I could move the data to another disk. Are we there yet?

But the btrfsck passes, so something else must be going on here.  Could
you please send the full kernel dmesg output after the mount?

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
