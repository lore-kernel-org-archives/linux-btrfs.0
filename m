From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: efficiency of btrfs cow
Date: Sun, 06 Mar 2011 11:18:55 -0500
Message-ID: <4D73B3EF.6090407@interlinx.bc.ca>
References: <il0a8d$4ev$1@dough.gmane.org>	 <AANLkTi=-bxNwFmp8GZ_Foz=CSP2kUOwqPKAaMFapGuz+@mail.gmail.com> <1299428248.15017.13.camel@ayu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig76CDED9BA960E59F088EACBF"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299428248.15017.13.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig76CDED9BA960E59F088EACBF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11-03-06 11:17 AM, Calvin Walton wrote:
>=20
> To add a bit to this: if you *do not* use the --inplace option on rsync=
,
> rsync will rewrite the entire file, instead of updating the existing
> file!

Of course.  As I mentioned to Fajar previously, I am indeed using
--inplace when copying from the existing archive to the new btrfs archive=
=2E

> This of course negates some of the benefits of btrfs's COW support when=

> doing incremental backups.

Absolutely.

b.



--------------enig76CDED9BA960E59F088EACBF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1zs+8ACgkQl3EQlGLyuXC89wCgg9pvqyi1oOxBCNQ2AF6+4Kxf
0hMAoMwsyVcca45rjpRCcC1BAI03suia
=2k9J
-----END PGP SIGNATURE-----

--------------enig76CDED9BA960E59F088EACBF--
