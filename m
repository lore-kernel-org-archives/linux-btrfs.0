Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from efeu.mur.at ([89.106.208.66]:40889 "EHLO efeu.mur.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab3IQPbb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Sep 2013 11:31:31 -0400
Message-ID: <523873FC.20504@mur.at>
Date: Tue, 17 Sep 2013 17:23:40 +0200
From: =?UTF-8?B?Sm9naSBIb2Ztw7xsbGVy?= <jogi@mur.at>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: sander@humilis.net
Subject: Re: rootfs crash
References: <5236E1FF.4080900@mur.at> <5238343F.3020802@mur.at> <20130917111809.GA16032@panda> <52384A08.40404@mur.at>
In-Reply-To: <52384A08.40404@mur.at>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig914B62B81E2B182E5EFF430D"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig914B62B81E2B182E5EFF430D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Am 2013-09-17 14:24, schrieb Jogi Hofm=C3=BCller:

> Yes, did so.  It stopped with an error.  I will send the error
> message later since it resides on a different machine that I cannot
> access from where I am now.

This is the promised output of

btrfs chunk-recover -y -v /dev/sda3

[ 1090.896935] device fsid f75ca841-f09b-4341-8b59-8fcab921d8ce devid 2
transid 103536 /dev/sdb3
[ 1090.900656] device fsid f75ca841-f09b-4341-8b59-8fcab921d8ce devid 1
transid 103536 /dev/sda3
[ 1090.905844] device fsid f75ca841-f09b-4341-8b59-8fcab921d8ce devid 2
transid 103536 /dev/sdb3
[ 1090.909114] device fsid f75ca841-f09b-4341-8b59-8fcab921d8ce devid 1
transid 103536 /dev/sda3

All Devices:
    Device: id =3D 2, name =3D /dev/sdb3
    Device: id =3D 1, name =3D /dev/sda3

btrfs: cmds-chunk.c:125: process_extent_buffer: Assertion
`!(exists->nmirrors >=3D2)=C2=B4 failed.

Regards!
--=20
j.hofm=C3=BCller                                http://users.mur.at/thesi=
x/


--------------enig914B62B81E2B182E5EFF430D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREIAAYFAlI4c/wACgkQkaXhaapqItlVygEA6jJ7D/xMZy++tlw1OoSpaS8m
pSckycvMMeMRRVU4R2MA/0x5LDiUG+tx8tQ2jn2PrC5odQ1Atwb4sWY2vvmJvhK7
=LkN/
-----END PGP SIGNATURE-----

--------------enig914B62B81E2B182E5EFF430D--
