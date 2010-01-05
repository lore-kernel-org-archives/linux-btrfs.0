From: ra <r_a@lavabit.com>
Subject: btrfsctl return values
Date: Tue, 5 Jan 2010 18:32:59 +0100
Message-ID: <201001051833.34856.r_a@lavabit.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2003694.UJ1u7vx891";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2003694.UJ1u7vx891
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi!

btrfsctl returns 1 on success and 0 if an error occurs.=20
This has already been reported[0]. Has the patch not been applied=20
intentionally or did it just slip through?

Cheers,
Robert


[0] http://article.gmane.org/gmane.comp.file-systems.btrfs/3878

=2D-=20
plain text within encrypted emails preferred

--nextPart2003694.UJ1u7vx891
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEABECAAYFAktDd+4ACgkQ9eiEAFCVEWTyrACfR4ljFEIP/giJG3x6c2DowkPC
ZgYAoNkB6yxYRkM2Y3PsmSQwL+6BF5Sd
=vmqd
-----END PGP SIGNATURE-----

--nextPart2003694.UJ1u7vx891--
