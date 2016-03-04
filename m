Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:54562 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760317AbcCDWtS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Mar 2016 17:49:18 -0500
Date: Sat, 5 Mar 2016 03:49:10 +0500
From: Roman Mamedov <rm@romanrm.net>
To: nexus@smoula.net
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC while creating snapshot
Message-ID: <20160305034910.576d2230@natsu>
In-Reply-To: <c2e396477401f3441bdc364456b399f4@smoula.net>
References: <c2e396477401f3441bdc364456b399f4@smoula.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/80wb8Sx0kXsF1R9kG2LCtlU"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/80wb8Sx0kXsF1R9kG2LCtlU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 04 Mar 2016 22:10:57 +0100
nexus@smoula.net wrote:

> Hello,
>=20
> I'm encountering weird enospc problem while writing to filesystem and=20
> creating snapshot at a same time:
>=20
> Steps to reproduce:
>=20
> start writing data to filesystem:
>=20
> # LC_ALL=3DC dd if=3D/dev/zero of=3D/foobar
> dd: writing to '/foobar': No space left on device
> 3003803+0 records in
> 3003802+0 records out
> 1537946624 bytes (1.5 GB, 1.4 GiB) copied, 10.8072 s, 142 MB/s
>=20
> in other terminal create read-only (or r/w - results are the same)
> # btrfs sub snap -r / /.snap1
> Create a readonly snapshot of '/' in '//.snap1'
>=20
> while creating this snapshot, ENOSPC is produced.
>=20
> Interesting is that I can reproduce this on some filesystems but not on=20
> others while all of available information are the same. There IS free=20
> space in data, metadata and global reserve.
>=20
> I've tried balancing and defragmenting with no success. I've tried=20
> debugging by using enospc_debug but nothing is written to dmesg or any=20
> system log
>=20
> Does anybody have a clue what may be the cause?
>=20
> # uname -a
> Linux interceptor 4.4.3-1-ARCH #1 SMP PREEMPT Fri Feb 26 15:09:29 CET=20
> 2016 x86_64 GNU/Linux

As you use the nodatacow mount option, this seems to be another case of
http://www.spinics.net/lists/linux-btrfs/msg51276.html
http://www.spinics.net/lists/linux-btrfs/msg51819.html

and is fixed by=20
https://patchwork.kernel.org/patch/7967161/

Unfortunately the bug is known since the start of the 4.4 series and the pa=
tch
is out for 2 months, but it didn't get included into even 4.4.4 released
recently. You have to apply it by yourself and recompile the kernel.

--=20
With respect,
Roman

--Sig_/80wb8Sx0kXsF1R9kG2LCtlU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbaEOkACgkQTLKSvz+PZwipVQCfcClUYV4arYRzRGc4bZ7t69Gr
q8QAnR61E01ZmOUth/rR2KFOtKXOKJCj
=rb2I
-----END PGP SIGNATURE-----

--Sig_/80wb8Sx0kXsF1R9kG2LCtlU--
