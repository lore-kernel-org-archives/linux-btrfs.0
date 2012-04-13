From: Chris Samuel <chris@csamuel.org>
Subject: Re: btr fs unmountable after disk failure
Date: Fri, 13 Apr 2012 22:00:14 +1000
Message-ID: <201204132200.20511.chris@csamuel.org>
References: <alpine.LNX.2.01.1204131252070.26191@frira.zrqbmnf.qr> <20120413105822.GF4856@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1677505.9rCFrmIuQd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120413105822.GF4856@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1677505.9rCFrmIuQd
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Friday 13 April 2012 20:58:22 Hugo Mills wrote:

>    I think you need "-o degraded" in this case.

I've always wondered why btrfs doesn't fall back to this by default if=20
it fails to find a device, would seem the obvious thing to do (we=20
don't have to tell mdadm if a disk has gone away for instance).

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1677505.9rCFrmIuQd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUAT4gVT41yjaOTJg85AQKacgf+LCcXUF9Ps+vVkJeGDdrBZUrUiCZXmkWZ
SP1KLhhV8QeHZbcoKvX6x3NhHV11+VL9NVXJmP6KCzCtbAkwyGyTC/Uo1ORd/sss
CdIdd/XLFcqPjQuRYX6AyVg+Hgv4LJB/1BHG+Y+HFVaXMG532BlkJRC4OtRvdKxv
qCkqbMHgKdATHQ4OYDm+Nxr0BwAN9TbxVgEt5EzWRxmxeiMrRLj4Gm8OKiKbBvAd
Pqz41z5+FNxkXrTy/GprLONcxFqdr4vbplvnOUOocwwzVBhLsOEQhJ2yGbGa5ZcB
jyT7En1NWfln9WVBDBPNvKzhIvCFrMEniXsZBo/dYhwGv8tKV2r1sA==
=REY8
-----END PGP SIGNATURE-----

--nextPart1677505.9rCFrmIuQd--
