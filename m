From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: Re: Understanding DF, etc.
Date: Sun, 15 May 2011 19:48:51 +0200
Message-ID: <1305481731.3667.4.camel@tethys>
References: <BlvXUBvD1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BlvXUBvD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Le dimanche 15 mai 2011 =C3=A0 19:28 +0200, Helmut Hullen a =C3=A9crit =
:
> shows that that device with brutto 150 GByte is nearly full with its
> 78 GByte (or 73 GByte) data because it uses this kind of RAID1?=20

No. Here's the current situation on same machine :

# btrfs fi df /
Data: total=3D85.01GB, used=3D84.56GB
System, DUP: total=3D8.00MB, used=3D16.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D1.75GB, used=3D1.01GB
Metadata: total=3D8.00MB, used=3D0.00

As far as I understood, only metadata (not data) are DUPed, and the DAT=
A
zone is allocated as needed by 1GB chunks. So I currently use 84.5 GB
and the system has thus allocated 85 GB of filesystem DATA space. When
they get full, the system will allocate 1 more GB, etc. Until the devic=
e
itself gets full, of course.

You notice here that there's no indication about the device actual size
(this df gives developper-useful data, not sysadmin-useful data ;-)) bu=
t
this file system resides in :=20

# mount
/dev/mapper/VG1-TETHYS on / type btrfs
(rw,relatime,subvol=3DUBUNTU,compress=3Dzlib)
[...]

# lvs VG1/TETHYS
  LV     VG   Attr   LSize   Origin Snap%  Move Log Copy%  Convert
  TETHYS VG1  -wi-ao 145,66g



--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
