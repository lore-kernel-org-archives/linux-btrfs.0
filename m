From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2299
Date: Sun, 18 Sep 2011 02:08:31 +0200
Message-ID: <1316304525.7194.1.camel@picard>
References: <1314582311.2724.4.camel@picard>
	 <1316283907.3253.8.camel@picard> <1316284222.3253.10.camel@picard>
Reply-To: uzytkownik2@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-ripemd160";
	protocol="application/pgp-signature"; boundary="=-5vgtvRNFFRacwLVU+GGd"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1316284222.3253.10.camel@picard>
List-ID: <linux-btrfs.vger.kernel.org>


--=-5vgtvRNFFRacwLVU+GGd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-09-17 at 20:30 +0200, Maciej Marcin Piechotka wrote:
> On Sat, 2011-09-17 at 20:25 +0200, Maciej Marcin Piechotka wrote:
> > 1. Once the blank screen happened ot 23:00 UTC instead of 03:00 UTC
> > 2. I tried to disable the caches
> > 3. I tried to rsync via ext3 + btrfs-convert. I noticed something - in
> > old fs the df looked like:
> >=20
> > Data: total=3D30.01GB, used=3D28.42GB
> > System, DUP: total=3D8.00MB, used=3D4.00KB
> > System: total=3D4.00MB, used=3D0.00
> > Metadata, DUP: total=3D1.00GB, used=3D199.47MB
> > Metadata: total=3D8.00MB, used=3D0.00
> >=20
> > on new one (with ext3 image):
> > Data: total=3D33.33GB, used=3D20.52GB
> > System: total=3D32.00MB, used=3D4.00KB
> > Metadata: total=3D16.64GB, used=3D11.36GB
> >=20
> > and without:
> > Data: total=3D33.33GB, used=3D20.04GB
> > System: total=3D32.00MB, used=3D4.00KB
> > Metadata: total=3D16.64GB, used=3D10.88GB
> >=20
> > Given that lzo compression was used about 4 GB data difference was
> > expected (difference depending on mount options on rsynbc). However:
> >=20
> > 1. What is DUP?

Ok.After some digging I found out.

> > 2. Why metadata is so big on convertion from ext3 while data is small
> > (the sum is about right - 31GB vs 28.5GB)?
> >=20

After rebalancing I got:

Data: total=3D32.00GB, used=3D30.83GB
System: total=3D32.00MB, used=3D12.00KB
Metadata: total=3D1.00GB, used=3D227.16MB =20

>=20
> That should be a) b)
>=20
> 4. I think it triggered a bug with data loss - the new data was not
> written to disk despite being visible from userspace after mount during
> the same mount.
>=20
> > Regards
>=20
>=20



--=-5vgtvRNFFRacwLVU+GGd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAABAwAGBQJOdTaNAAoJEJIdee2Vr4aPwHcQAKsqbRBMbPg15nWZRoq3vAO9
IAr3+E0EBVbggeRQZXPMs+6vsIgc0fRPoR2FVcs7hwoasHF8qYukd6mVrvVW7UiU
geT+Ju0OVU6PP7xZmkfPKu8HdK2FRIiCuLnfhor2pqQaVzKkFre8TLuBUjVzFxdL
3V+hYYCK2qgq2NhZx3z67pr02LTVWj0p8qQUP/FyXsAazlHLXspGVZ2bIYEAgvAI
izahiKGkQ8KVF0YPkphbshW+0Tau2MMq6MXPrnGxGkZLjde0WXeNk7+sWzCLclMF
vkXZutIltnDGdI2j33kyVT5HoJnUPuXWXfxZU+2ovXEUvhs48uiLzy2NwNfOC2su
5nPsU4OGhvqp6+ah7wqqjI4D6ElDTi5Qk2JltpFIt1IdAHj5LRPYQJxMR+who9lU
K+CtcP/flXaU/HVWohuFjCWcgACOIEBrCq/hA4m103acm8ILR3mTBr63QK5Rjhj9
egFkUPc+JxqTbZiD/TLZRt8jCcSC8VW+xkHfwfA1EEBruTcTw87wn7oDHOW7oSef
34EZE7wJX16YIeBtRZ5iYZmEq/ZP6vVwimF5N7FWZ5gIGSyAMsXMmdVKepggrgHe
owrkzvt19ZhDpMBOG0yAj6bAc89rMqA1aPyW32mQj2j5qvY+BTqzDg4sEGRV2fQU
Lx0D1Qgl7fA/DJe9fx5j
=DwbA
-----END PGP SIGNATURE-----

--=-5vgtvRNFFRacwLVU+GGd--


