From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Adding a disk fails
Date: Fri, 21 Jan 2011 11:41:17 +0100
Message-ID: <201101211141.17846.hka@qbs.com.pl>
References: <201101201318.40686.CACook@quantum-sci.com> <201101210755.54750.hka@qbs.com.pl> <201101210216.49389.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101210216.49389.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, January 21, 2011 11:16:49 CACook@quantum-sci.com wrote:
> On Thu 20 January 2011 22:55:54 Hubert Kario wrote:
> > You still have a btrfs on /dev/sdc, do a
> > dd if=3D/dev/zero of=3D/dev/sdc bs=3D8192
> > (overkill, but I don't remember which blocks have to be zeroed to d=
estroy
> > btrfs superblock)
>=20
> I gave up and started over.  Maybe it should be clarified in the wiki=
 that
> no mkfs should be done on additional volumes, as it's counterintuitiv=
e to
> some.
>=20
> > yes. rc.local is too late, unless you will also mount the volume fr=
om
> > there and not using /etc/fstab
>=20
> How and when then?

in, or before /etc/rcS.d/S35mountall.sh

>=20
> > That depends - it has to be done before mounting. And if the device=
 is
> > part of the boot partition then you may put the "scan" command into=
 an
> > init-ramdisk.
>=20
> This does not seem to have been sent to the listserv, as I only got i=
t in a
> reply.  This is likely incomplete.

It was sent to list, your MUA may have merged messages with identical M=
essage-
ID.

>=20
> > Using something like "device=3D/dev/sdb,device=3D/dev/sdc" on fstab=
 mount
> > options should also work.
>=20
> You mean as a substitute for a scan?

Would seem so, but I haven't tried this

>=20
> On my other server the btrfs array seems to mount just fine without a=
ny
> measures to scan.  I don't understand this,  nor why no specific advi=
ce is
> given about scanning on boot in the wiki.

your distro may have alredy put it in initrd or initramfs (for example =
fedora=20
and archlinux do)

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
