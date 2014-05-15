Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44804 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbaEOJeM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 05:34:12 -0400
Date: Thu, 15 May 2014 10:34:10 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: staggered stripes
Message-ID: <20140515093410.GJ23212@carfax.org.uk>
References: <2751140.Zb1qMBeNgk@xev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ofZMSlrAVk9bLeVm"
In-Reply-To: <2751140.Zb1qMBeNgk@xev>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ofZMSlrAVk9bLeVm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 07:00:10PM +1000, Russell Coker wrote:
> http://www.cs.wisc.edu/adsl/Publications/corruption-fast08.html
>=20
> Page 13 of the above paper says:
>=20
> # Figure 12 presents for each block number, the number of disk drives of =
disk
> # model =E2=80=98E-1=E2=80=99 that developed a checksum mismatch at that =
block number. We see
> # in the figure that many disks develop corruption for a specific set of =
block
> # numbers. We also verified that (i) other disk models did not develop
> # multiple check-sum mismatches for the same set of block numbers (ii) the
> # disks that developed mismatches at the same block numbers belong to
> # different storage systems, and (iii) our software stack has no specific=
 data
> # structure that is placed at the block numbers of interest.
> #
> # These observations indicate that hardware or firmware bugs that affect
> # specific sets of block numbers might exist. Therefore, RAID system desi=
gners
> # may be well-advised to use staggered stripes such that the blocks that =
form
> # a stripe (providing the required redundancy) are placed at different bl=
ock
> # numbers on different disks.
>=20
> Does the BTRFS RAID functionality do such staggered stripes?  If not coul=
d it=20
> be added?

   Yes, it could, by simply shifting around the chunk locations at
allocation time. I'm working in this area at the moment, and I think
it should be feasible within the scope of what I'm doing. I'll add it
to my list of things to look at.

   Hugo.

> I guess there's nothing stopping a sysadmin from allocating an unused=20
> partition at the start of each disk and use a different size for each dis=
k. =20
> But I think it would be best to do this inside the filesystem.
>=20
> Also this is another reason for having DUP+RAID-1.
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- If you're not part of the solution, you're part ---        =20
                           of the precipiate.                           =20

--ofZMSlrAVk9bLeVm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU3SKEVheFHXiqx3kAQLiIA/9G/hPUC04hIHAwvBB5vcX++HjyjGVpaoa
3gGEKtVucBxn/vEZ3uUAwIgcwVqQbDoe8ZWt4UfSfYkwSo0eVnf5P1MF8igSAScZ
UUh8stf5dOL88/ih6Q9VIzYBGsdTctjk27Jug2VtOVnk7SznDrHlhhIpyHwwZWJi
PwDE+Z20pLkPCap5sgnFNjdV7hXsTprCwNorLfmn+SxlYH7MJ+MWDuWQkkM+8khW
LG5uiOzeKEGm6u65lyY87ijuteF61unL4QPUgHq5zgtzu7mb0bBUyMqXx0U+Okgi
CEX+0UPA8MUgkC8brpE7nDBvmSDU1ZJNqhiVBfEF2P2ZcXvWg//ZlSaxCuBqn/CF
JSUO0lG4emnQ3TJZm66H/UmOysmUDvXc77fJbY541YDLYT60FbSrfCKhIyOrFu/x
OexAQi7VnHtE4cQ4u2UQitr3bThUKoJqHsn5LLD0kH1i6mH+vXXqZ+JcEaY8oVWs
Lf6UOND15G/eCCxPvcRcF0kyAJWFzSwGwuALt2s6206Yu60HUWW93Mm0O0S3hA3i
iT9NPm3rFH6tgcw0YNT4FG+uoHFE16Q/EnOLq9mBOuLbW6uVseoyarbyQKLcqrYD
F3E+Ip/CoJ2fUfr2t83Lp3xctqysEAETJwS0JZeFRlLMF+4Eugh/Krx7DQ1/At3E
E5wDrc7LhJo=
=hLYX
-----END PGP SIGNATURE-----

--ofZMSlrAVk9bLeVm--
