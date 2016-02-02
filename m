Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48044 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbcBBWJx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 17:09:53 -0500
Date: Tue, 2 Feb 2016 22:09:52 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: booting from BTRFS works only with one device in the pool
Message-ID: <20160202220952.GB30635@carfax.org.uk>
References: <56AFCEC3.9050803@friedels.name>
 <20160201221120.GD8313@carfax.org.uk>
 <56B12742.9090101@friedels.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
In-Reply-To: <56B12742.9090101@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 02, 2016 at 11:01:38PM +0100, Hendrik Friedel wrote:
> Hello Hugo,
>=20
> >> Here I am stuck in a recovery prompt.
> >    By far the simplest and most reliable method of doing this is to
> >use an initramfs with the command "btrfs dev scan" in it somewhere
> >before mounting. Most of the major distributions already have an
> >initramfs set up (as does yours, I see), and will install the correct
> >commands in the initramfs if you install the btrfs-progs package
> >(btrfs-tools in Debian derivatives).
> >
> I would like to go the sensible way :-)
> But can you hint me how and where to add the btrfs device scan option to
> the initramfs?

   Like I said above, just install the distribution's own
btrfs-progs/btrfs-tools package, and it should do the right thing. You
may have to tell the distribution to rebuild the initramfs -- I find I
don't have to on Debian, and Chris just gave the recipe for
distributions using dracut.

   Hugo.

> Regards,
> Hendrik
>=20
> ---
> Diese E-Mail wurde von Avast Antivirus-Software auf Viren gepr=FCft.
> https://www.avast.com/antivirus
>=20

--=20
Hugo Mills             | I believe that it's closely correlated with the
hugo@... carfax.org.uk | aeroswine coefficient
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       Adrian Bridg=
ett

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWsSkwAAoJEFheFHXiqx3ku0cP/RrwklvGJXnB/TpLXFd0CNJS
BXowK3/K/p/Prjaq4NMqEiKsuq++nxLmazRIUTqOsEkl4EknxLlAHnSUC4UiTWaz
0Z5ZBXPoBjy0tS3kwr6LJHcNAWk+5sItKYuES7uqX2UxId9G1ICUaefU0pKQmxpR
rFTMOArk9X15egt+PXPI3bVntgYzOWoenHtFZi57AUI5eSrm1PHjjUqU1Am4lwoj
uQrEiiiKqVg8MdAKGuqsVzuk3M6Od9BsB0SI4OzTiXadW2oBEIfgUbn2DkQ9GPzM
Akl5/gUNt6jTVybeT7rPRoKGGwzCl2phTiO2irPxz4GviMiHO1RBY7mWInKAapEo
8c7dfBAIwo6K8MbRvyDijVwoJwoP0zy8D6h6XaHNrN5WzCMS9WhBZpJ3NqjS9ZZ1
Ljnm1cf3fHT661tPX3mFaPKN4+B92gYthvJKhIEHHxKDDO38lj13HmWc8NylLlDC
e+T1jiGzLRmvPL6rRcTFFKk6XW7QBseRGBXtjwJUtLeHk5Q19EvSYEuC/W2ahg+o
ph7ZRWhVFoG5UY8Na3U5H8VxiLrgY1oeSDZ7x2F9eQZVXaiSH+Q5QME9Asi0b/kK
SaGuWmGm1neZFaspvEgS2/1Ztjw5BpdZ+QgMkxneizIPmQzjTpydEgYDb1gYW17H
LZzRRZF73QGkjQqq/JA6
=VSHm
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
