Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34509 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030233AbaLLQpq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 11:45:46 -0500
Date: Fri, 12 Dec 2014 11:45:44 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Robert White <rwhite@pobox.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: mkfs.btrfs limits "odd" [and maybe a "failed" phantom device?]
Message-ID: <20141212164544.GB25614@hungrycats.org>
References: <5488C6CF.1080608@pobox.com>
 <20141212035651.GD22023@hungrycats.org>
 <548A84A2.4000501@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
In-Reply-To: <548A84A2.4000501@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2014 at 10:01:06PM -0800, Robert White wrote:
> So RAID5 with three media M is
>=20
> M    MM   MMM
> D1   D2   P(a)
> D3   P(b) D4
> P(c) D5   D6

RAID5 with two media is well defined, and looks like this:

M    MM
D1   P(a)
P(b) D2
D3   P(c)

With even parity and N disks

	P(a) ^ D1 [^ D2 ^ ... ^ DN] =3D 0

Simplifying for one data disk and one parity stripe:

	P(a) ^ D1 =3D 0

therefore

	P(a) =3D D1

which is effectively (and, in practice, literally) mirroring.


--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSLG7cACgkQgfmLGlazG5xcFgCgmvjhgpGQFENaRQBKWTjJBR9J
mlUAoLDSUrnEfajRr8PNUZrzkVymdXjZ
=Winj
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
