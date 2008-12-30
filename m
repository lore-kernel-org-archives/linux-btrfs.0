From: Chris Samuel <chris@csamuel.org>
Subject: Re: A bug with multiple devices?
Date: Tue, 30 Dec 2008 23:03:47 +1100
Message-ID: <200812302303.49677.chris@csamuel.org>
References: <49597D06.1050806@cn.fujitsu.com> <200812302145.25796.chris@csamuel.org> <3d0408630812300335s4e7c6cf1x9a45ff187b80f83@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7607557.msVOvQf0ov";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630812300335s4e7c6cf1x9a45ff187b80f83@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart7607557.msVOvQf0ov
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, 30 Dec 2008 10:35:17 pm Yan Zheng wrote:

> This is a known bug. In btrfs, chunks are created dynamically and may have
> different RAID configurations. =A0So it's difficult to compute the space
> in advance.

Thanks Yan!

So mkfs.btrfs -d raid1 just sets the default value ?

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP


--nextPart7607557.msVOvQf0ov
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUASVoOJY1yjaOTJg85AQKSfggAguA0C+y9huh+Cjazz/pY37MApiDjgz2r
ymxJ0INkQ2pyG4kn36HsHcKWHAuJ0v08lHfbJgZDutHNSGzIio5qS95utrhcVGrC
pWoJV24VT6TMwNKSzs+TeBiHS6Sx7yoo4+4IiTfuvD6BIVtUdIURTKKor/XgKOXp
qHAinWpjRE/BoBbBSzVYx0p6tdyB08PN0+OWeXndXee+KsmOf4NjJAeX88AKLNH+
1TfGubDDGcCqgWyG7lkyQKS29fnm2kkL4/o2hZ0VMRHasDzh5bpJLOHuBUhitdne
s0mbD0eSqBrimqTAtMfdVYc7jEwIOGGbJCf4lJjrWmdykq7rEKG93A==
=Dw16
-----END PGP SIGNATURE-----

--nextPart7607557.msVOvQf0ov--
