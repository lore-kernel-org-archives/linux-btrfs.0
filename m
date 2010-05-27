From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: A couple of questions
Date: Thu, 27 May 2010 16:56:00 +0200
Message-ID: <201005271656.00398.hka@qbs.com.pl>
References: <201005271539.55644.paul.millar@desy.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Paul Millar <paul.millar@desy.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201005271539.55644.paul.millar@desy.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 27 May 2010 15:39:54 Paul Millar wrote:
> Hi,
>=20
> I've been looking at Btrfs and have a couple of naive questions that =
don't
> seem to be answered on the wiki or in the articles I've read on the
> filesystem.
>=20
>=20
> First: discovering a file's checksum value.
>=20
> Here's the scenario: software is writing some data as a fresh file.  =
This
> software happens to know (a priori) the checksum of this data; for ex=
ample,
> a storage server receives the file's data and checksum independently.
>=20
> I've some confidence that, once the data is stored in btrfs, any corr=
uption
> (from the storage fabric) will be spotted; however, the data may have
> became corrupt before being stored (e.g., from the network).  To catc=
h
> this, the checksum of the stored data needs to be calculated and chec=
ked.
>=20
> One approach is to calculate the checksum (in user-space) after the d=
ata is
> stored.  This adds extra IO- and CPU-load and there's also the possib=
ility
> of false-negative results due to the filesystem cache (although btrfs=
 may
> remove this risk).
>=20
> Another approach would be to ask btrfs for the checksum.  It seems th=
at
> it's possible to combine multiple CRC-32C values to figure out the
> checksum of the combined data [e.g., zlib's crc32_combine() function]=
=2E=20
> So, obtaining a file's checksum might be a light-weight operation.
>=20
> Yet another possibility would be to push the desired checksum value (=
via
> fcntl?) and have btrfs compare the desired checksum with the file's a=
ctual
> checksum on close(2), failing that call if the checksums don't match.
>=20
> Would any of this be possible (without an awful lot of work)?

IMO, if an application recieves data with checksum it can calculate the=
=20
checksum of data on the fly, as it writes it to the disk. It won't add =
any=20
additional IO to storage subsystem. It won't detect in-memory corruptio=
n=20
though, but if you want to be resilant to this, you should be looking a=
t ECC=20
RAM as subsequent checks can be affected by it to.

Second, you shouldn't tie application or network protocol to a CRC sche=
me used=20
by filesystem on server! Especially when there can be other CRC algorit=
hms=20
used, not only CRC-32C.

If the checksum algorithm used by FS was set in stone, then userspace c=
ould=20
employ it somehow, but if there can be different CRCs used, I see no re=
ason to=20
allow the userspace to read them.


--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl

System Zarz=C4=85dzania Jako=C5=9Bci=C4=85
zgodny z norm=C4=85 ISO 9001:2000
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
