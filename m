From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Adding a disk fails
Date: Fri, 21 Jan 2011 07:55:54 +0100
Message-ID: <201101210755.54750.hka@qbs.com.pl>
References: <201101201318.40686.CACook@quantum-sci.com> <4D38B382.1050709@libero.it> <201101201510.54418.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Carl Cook <CACook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101201510.54418.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 21 of January 2011 00:10:54 Carl Cook wrote:
> On Thu 20 January 2011 14:13:22 Goffredo Baroncelli wrote:
> > To add another disk you don't have to run mkfs.btrfs. For example:
> >=20
> > # add the first disk
> > mkfs.btrfs /dev/sdb
> > # mount the disk
> > mount /dev/sdb /media/backups
> >=20
> > # add another disk to the first one
> > btrfs device add /dev/sdc /media/backup
>=20
> Thanks Goffredo but as I say, I did this and it responds with
>  "ERROR: error adding the device '/dev/sdc'"
> ... it doesn't give a clue.

You still have a btrfs on /dev/sdc, do a=20
dd if=3D/dev/zero of=3D/dev/sdc bs=3D8192
(overkill, but I don't remember which blocks have to be zeroed to destr=
oy=20
btrfs superblock)
Then
btrfs dev add /dev/sdc /media backup

>=20
> > Note1: the filesystem has to be mounted
> > Note2: the medatada will be in raid1, the data in raid0
> > If you shutdown the system, at the reboot you should "scan" all the
> > device in order to find the btrfs ones
> >=20
> > # find the btrfs device
> > btrfs device scan
>=20
> This must be done at every boot?  If so, where is recommended, in rc.=
local?

yes. rc.local is too late, unless you will also mount the volume from t=
here=20
and not using /etc/fstab

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
