Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47617 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2J3Pj2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 11:39:28 -0400
Date: Tue, 30 Oct 2012 15:39:22 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: =?iso-8859-1?Q?G=E1bor?= Nyers <gnyers@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to find (out if) files sharing content?
Message-ID: <20121030153922.GA11422@carfax.org.uk>
References: <20121030162005.0308d5a2@lupus.demo.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
In-Reply-To: <20121030162005.0308d5a2@lupus.demo.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 30, 2012 at 04:20:05PM +0100, G=E1bor Nyers wrote:
> Hi,
>=20
> How could one find out if 2 files share any extents on a btrfs file syste=
m?
>=20
> A more generic variation of the above: How to list files on the same
> file system/subvolume sharing content?

   You have direct (read-only) access to the metadata trees through
the TREE_SEARCH ioctl. It should be possible to walk through the
extents of a given file, and (I think) follow back-refs from the
extent back to the other files that share it.

   There's no simple code to do that right now, though.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- And what rough beast,  its hour come round at last / slouches --- =20
                     towards Bethlehem,  to be born?                    =20

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUI/0qr9z9OVl50rAAQK+tg//W11Csc4H4v3FpEsr+oBhw3yUXCbjhgM8
YigEkOQIJZFrLGVjdY9PMl3revdhjl6aPHwwCAPheBF/dX+OtpgTBEPeTAOlOQlf
WxfosKJkotuHzTAnnqOKnBE1CSaIE4p270MjDWMG7WytSn1oxCFeJsFBz7Llkmwe
w8Um+kX0LFNQb+iPrEBA7M2lHfzin5ad3tpyzghvTVdr+H3t29iwcpLgRznj81Hl
mhmnYM7Lp7JzMImcaQlWTu3IjjYNpcv9/24D0gxQ8cvtpA3Ub8fzCrCxxRmijLa8
m+CZwTkZTQcgNHm0bCGyIH3I8blesaSmvDgpPp47LFOq88EKbUe4xBxQqT+87Y+v
+7oiYkmmNVrYQWMvhMz5VI/YfLr0jB9B7u/inceHrgfCorTHPJS2yAaMl8+mOVKy
ztuZ5kiMzimxWeV8VkyF8aBFG/gC1KNB5DTlJS8YZjYOAwjZFw05X0WXwVRusKbj
0EbcLJCezfwvSHRNSZimQOVsq5j7NeJBZuubWq+d89DHmEyUZIQK1u/kF1iIdGp4
3Ox1Es/138BTn9Wa0EMrO1OHyvdMPIpCCsPqXsp3FgYGev4oDV20zlVhTPaOY/I2
ZU4yPExX1DUXIZlmc0GS2FSG6nZhrEOHMAWf+jJc9YoHSFdX522S9cQeeX7zbKIc
Lbp40ZW3udI=
=GNmX
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
