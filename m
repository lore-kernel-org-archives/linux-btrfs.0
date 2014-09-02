Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37809 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaIBMNw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 08:13:52 -0400
Date: Tue, 2 Sep 2014 13:13:49 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-progs-3.16: fs metadata is both single and dup?
Message-ID: <20140902121349.GF18897@carfax.org.uk>
References: <pan.2014.09.02.12.05.33@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YkJPYEFdoxh/AXLE"
In-Reply-To: <pan.2014.09.02.12.05.33@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--YkJPYEFdoxh/AXLE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 02, 2014 at 12:05:33PM +0000, Holger Hoffst=E4tte wrote:
>=20
> I updated to progs-3.16 and noticed during testing:
>=20
> root>losetup=20
> NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE
> /dev/loop0         0      0         0  0 /tmp/img
>=20
> root>mkfs.btrfs -f /dev/loop0
> Btrfs v3.16
> See http://btrfs.wiki.kernel.org for more information.
>=20
> Performing full device TRIM (8.00GiB) ...
> Turning ON incompat feature 'extref': increased hardlink limit per file=
=20
> to 65536
> fs created label (null) on /dev/loop0
> 	nodesize 16384 leafsize 16384 sectorsize 4096 size 8.00GiB
> root>mkdir /tmp/btrfs
> root>mount /dev/loop0 /tmp/btrfs=20
>=20
> All fine until here..
>=20
> root>btrfs filesystem df /tmp/btrfs=20
> Data, single: total=3D8.00MiB, used=3D64.00KiB
> System, DUP: total=3D8.00MiB, used=3D16.00KiB
> System, single: total=3D4.00MiB, used=3D0.00
> Metadata, DUP: total=3D409.56MiB, used=3D112.00KiB
> Metadata, single: total=3D8.00MiB, used=3D0.00

   Note that the "single" chunks are empty, and will remain so.

[snip]
> So where does the confusing initial display come from? I'm running this=
=20
> against a (very patched) 3.14.17, but don't remember ever seeing this=20
> with btrfs-progs-3.14.2.

   Your memory is faulty, I'm afraid. It's always done that -- at
least since I started using btrfs, several years ago.

   I believe it comes from mkfs creating a trivial basic filesystem
(with the single profiles), and then setting enough flags on it that
the kernel can bootstrap it with the desired chunks in it -- but I may
be wrong about that.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Normaliser unix c'est comme pasteuriser le Camembert ---      =20

--YkJPYEFdoxh/AXLE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVAW0fFheFHXiqx3kAQItwA//bp8CRj+9sZeCCb33a3DIHffoPZrYRs5q
huE9KrJaUFAfiHTpnBEGLWqwLTLVDTs5voK5b5p9jwiWouC9d991vkbnf7zqJAv+
XGs4gUzsjivzpC+BqjnIGlLPB4Z/N//Bc60CKpc+mEEDdePZojJQDgm1VPp1PCN+
ZwQaAw5VSet2fhkT0IS0Lf+DyaOvHHbPDWUTCR6SEBpP9me1NzUU4stOXjuE6UhL
Ob8wUA6YrOtrWideX/T1bGr6EvQwyTYZFAUvNBtt6d6gQKTJFYerTzV7q392tBBC
sU3CpEYd3nmaheMDFUg/b11fGCralE7xXM6VzQt7jg3V1JSi7m9d0Hq/cO/OPpQh
szDY2eq8tg1jAFsS4RPLzb0GG7nKDlBn+97QRquFfFokgtucEVgniAG5v9/um18Q
dKvHlyUx0H3YWMZO6QZAeFCZCkGBRfRgkpn4FcY64hlqTxkhM7Bis9cTLwUMFQ56
oOe/gZwMs4vWhbcEWwlRwVTcXtK7aRewKyW4aIWza5yFutFeYXRaI3XG3XIPgU4W
5/z2VAiIERmaSar+8ju+LNMpGEhZeHLLIJPMH6lqu9JSYOYyUYJQZpbltQ1hSRKY
7xpvzVqpUExiEZOoLrGXBUnGRnbRtVEF7/dBSJljX2MOmbEKr6dFTN4aNPtUyvx+
k/UgX5/uYss=
=mfIA
-----END PGP SIGNATURE-----

--YkJPYEFdoxh/AXLE--
