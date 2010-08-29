From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs under xen domU
Date: Sun, 29 Aug 2010 15:06:05 +0200
Message-ID: <201008291506.06173.hka@qbs.com.pl>
References: <1281600005.5454.7.camel@vase.work>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: v.tolstov@selfip.ru
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1281600005.5454.7.camel@vase.work>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 12 of August 2010 10:00:05 Vasiliy G Tolstov wrote:
> Hello. I want to use btrfs on root fs under xen domU.
>=20
> Fs can grow in dom0 by dd if=3D/dev/zero of=3Dimage.img bs=3D1M count=
=3D0
> seek=3Dxxxx
>=20
> I want to grow fs under domU after that automatically. Can i do mount=
 -o
> remount,rw,maxsize / on already mounted root fs with rw ?
>=20
> Thank You for answer.

As far as i know, Xen won't update the size of block device until the D=
omU has=20
been restarted. After that "mount -o rw,maxsize /" should work as adver=
tised.

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
