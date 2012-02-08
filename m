From: Chris Samuel <chris@csamuel.org>
Subject: Re: Btrfs out of inodes becomes corrupt
Date: Wed, 8 Feb 2012 17:41:12 +1100
Message-ID: <201202081741.13243.chris@csamuel.org>
References: <b0ee762c11692ea16e81a34469311c14@localhost> <20120205195742.GC19330@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7075353.3Klqrd7c5y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120205195742.GC19330@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart7075353.3Klqrd7c5y
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Monday 06 February 2012 06:57:42 Hugo Mills wrote:

> > This al under debian  with kernel 2.6.32-5.
>=20
>    Aargh.
>=20
>    You are aware that this is an insanely old version of the brtfs
> code, and it has major flaws in it?

As someone who runs his work laptop with a 2.6.32 laptop and btrfs for=20
/home I'll bite at this one - I've held off updating after reading the=20
issues people were reporting on the list with newer kernels that did=20
not appear to be present in 2.6.32 (indeed IIRC a particular problem=20
from that time could only be solved at the time be remounting the=20
filesystem with 2.6.32, at which point newer kernels could access it=20
again).   It's served me very well, it "just works" (so far at least).

It's now sounding that 3.2 is probably stable enough for me to=20
consider updating to the next KUbuntu release when it comes out.

NB:  Yes, I do make nightly backups, and no, I don't run the=20
filesystem at anything close to even a quarter full (not that that=20
guarantees anything, or is even particularly deliberate).

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart7075353.3Klqrd7c5y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATzIZCY1yjaOTJg85AQJMmwf/RcP6XTIA05CC4Sld3JpHFURlQG5s0iOy
FNZeK/IjrTdANB5Otg8yKtDvBZaElH5haKPxIQYasR3WwI62j6Q/cGwCX4A2iD9U
/HQ9ZbBiY50+f4+RvkPVNy2Jt2n0WmdoHO7eH3tOIrRwbwKZzF3Sk+y2EL7htDtf
S2r7CRUmxwQbpPJflHboXJ53YiTPtdHOU53Iy6lfZL00WFgc8YWuj0MXy+/JLj4C
CRFWO2/ZepdgbAePquYU8rBcNnfUTcJ0NZE5TeTqA/MaKsgtjMov+bZfdUZSUL02
4tqQGVhLJhzpsDLY7etv1m85eEXhddO86QR2BbATtNO5/gxU5qXZ2g==
=xAPR
-----END PGP SIGNATURE-----

--nextPart7075353.3Klqrd7c5y--
