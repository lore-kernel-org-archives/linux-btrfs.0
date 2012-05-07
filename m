From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs and 1 billion small files
Date: Mon, 07 May 2012 11:58:47 +0200
Message-ID: <7802030.zmTeQQDGHD@bursa01>
References: <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alessio Focardi <alessiof@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 07 of May 2012 11:28:13 Alessio Focardi wrote:
> Hi,
>=20
> I need some help in designing a storage structure for 1 billion of sm=
all
> files (<512 Bytes), and I was wondering how btrfs will fit in this
> scenario. Keep in mind that I never worked with btrfs - I just read s=
ome
> documentation and browsed this mailing list - so forgive me if my que=
stions
> are silly! :X
>=20
>=20
> On with the main questions, then:
>=20
> - What's the advice to maximize disk capacity using such small files,=
 even
> sacrificing some speed?
>=20
> - Would you store all the files "flat", or would you build a hierarch=
ical
> tree of directories to speed up file lookups? (basically duplicating =
the
> filesystem Btree indexes)
>=20
>=20
> I tried to answer those questions, and here is what I found:
>=20
> it seems that the smallest block size is 4K. So, in this scenario, if=
 every
> file uses a full block I will end up with lots of space wasted. Would=
n't
> change much if block was 2K, anyhow.
>=20
> I tough about compression, but is not clear to me the compression is =
handled
> at the file level or at the block level.
>=20
> Also I read that there is a mode that uses blocks for shared storage =
of
> metadata and data, designed for small filesystems. Haven't found any =
other
> info about it.
>=20
>=20
> Still is not yet clear to me if btrfs can fit my situation, would you
> recommend it over XFS?
>=20
> XFS has a minimum block size of 512, but BTRFS is more modern and, gi=
ven the
> fact that is able to handle indexes on his own, it could help us spee=
d up
> file operations (could it?)
>=20
> Thank you for any advice!
>=20

btrfs will inline such small files in metadata blocks.

I'm not sure about limits to size of directory, but I'd guess that goin=
g over=20
few tens of thousands of files in single flat directory will have speed=
=20
penalties.

Regards,
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
