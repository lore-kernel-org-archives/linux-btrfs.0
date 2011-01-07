From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Synching a Backup Server
Date: Fri, 7 Jan 2011 17:14:17 +0100
Message-ID: <201101071714.23121.hka@qbs.com.pl>
References: <201101060935.14059.CACook@quantum-sci.com> <201101061426.30791.CACook@quantum-sci.com> <201101061507.37698.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101061507.37698.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, January 07, 2011 00:07:37 Carl Cook wrote:
> On Thu 06 January 2011 14:26:30 Carl Cook wrote:
> > According To Doyle...
>=20
> Er, Hoyle...
>=20
> I am trying to create a multi-device BTRFS system using two identical
> drives. I want them to be raid 0 for no redunancy, and a total of 4TB=
=2E
> But in the wiki it says nothing about using fdisk to set up the drive
> first.  It just basically says for me to: mkfs.btrfs -m raid0 /dev/sd=
c
> /dev/sdd

I'd suggest at least=20
mkfs.btrfs -m raid1 -d raid0 /dev/sdc /dev/sdd
if you really want raid0

>=20
> Seems to me that for mdadm I had to set each drive as a raid member,
> assemble the array, then format.  Is this not the case with BTRFS?
>=20
> Also in the wiki it says "After a reboot or reloading the btrfs modul=
e,
> you'll need to use btrfs device scan to discover all multi-device
> filesystems on the machine".  Is this not done automatically?  Do I h=
ave
> to set up some script to do this?
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
