Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41766 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbcBPTq0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 14:46:26 -0500
Date: Tue, 16 Feb 2016 19:46:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christian =?iso-8859-1?Q?V=F6lker?= <cvoelker@knebb.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [Docs]? Only one Subvolume with DUP (or different parameters)?
Message-ID: <20160216194625.GO30635@carfax.org.uk>
References: <56C377BB.9020101@knebb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w6U88vdWm8UqIXvc"
In-Reply-To: <56C377BB.9020101@knebb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--w6U88vdWm8UqIXvc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 16, 2016 at 08:25:47PM +0100, Christian V=F6lker wrote:
> Hi Guys,
>=20
> sorry for the simple question and I assume every developer here laughs
> about this question.
>=20
> Anyway:
>=20
> I have read loads of documents but did not find an answer for sure. Even
> though I assume I am right.
>=20
> On a btrfs filesystem created; is it possible to have subvolumes with
> data duplication and another subvolume without (resp. with just metadata
> duplication)?

   No.

   It may happen at some point, but it's not possible right now.

   Hugo.

> I have some large filesystems currently with ext4 and I am thinking of
> changing to btrfs. Some of the data is more important than others. So I
> want to have data duplication on the important files (sorted in a mount
> point) and without for the other subvolume.
>=20
> So I want to have the advantage of redundancy of important files
> combined with the flexibility of the volume manager and shared disk space.
>=20
> Possible?
>=20
>=20
> GReetings
>=20
> Christian
>=20

--=20
Hugo Mills             | "I don't like the look of it, I tell you."
hugo@... carfax.org.uk | "Well, stop looking at it, then."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             The Go=
ons

--w6U88vdWm8UqIXvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWw3yRAAoJEFheFHXiqx3kijwP/1mw/N6Vz5pG1ozS71V5cHvp
tjNvFyMrQ9JcAjngdk3Q0vOP3rTYeFLr/KOv60j7g1wWNJG1c0Jk4xYIYVJWViMv
VJZS7GeG171F1kyoCIqe5Sw4nBVIBB4GQqTmCdbA1FdZS/IFPZHeaScOX+gOBkKr
g2si6PS+v5XjuSjWB9l3zvKCZ1tUuPt2BTRz/om43JVo1vlEMybtvRDHJ0Fqbt2P
fMOpP/WJcnin/9qFigs5GthfwpatHfj7G/dILG6F1EC9wLWYEQDjOcU7s5TD+lIY
XoaUyDoJ4XqUQQGqxHHoBtjjy+rNH8pc88wK0elG9ao55tzLKHm0jSHLDoH+Was1
Knh8bEK5MAM0ROn03IBzx5s0MmbPGYg5MNhex/bPHnKa6dJzE6G5p7ac3SG3cQSy
N2OTMfxRBBMHLKTC27NmZk8Fqda1/qCMcQeuK9AUIbvIXHKiwPRkVNkF1LRs8p/r
4mp7+Avj9qrNsbXHxEFjeSS1ZMlyhHKMejcSTviqchgvksWZdvC/tDv0B63BMaQ0
TZJz01jK9waxJeS1ovLIrLr1RJuFJ8IS5sp/T3ag0OmsMKXCmoMQzWZTaogI4SYe
dnu5fHsQIEnuHOgbOAnrCXAwgMmUouwlSBR089TPf4Ag6B5IfMDinKdr10qskxbO
+u1evW6lHbC8vVC07Dvb
=bWIk
-----END PGP SIGNATURE-----

--w6U88vdWm8UqIXvc--
