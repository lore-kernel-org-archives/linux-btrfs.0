From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: efficiency of btrfs cow
Date: Sun, 06 Mar 2011 11:11:59 -0500
Message-ID: <4D73B24F.6090806@interlinx.bc.ca>
References: <il0a8d$4ev$1@dough.gmane.org> <AANLkTi=-bxNwFmp8GZ_Foz=CSP2kUOwqPKAaMFapGuz+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD04B86FCAA4EC31C4970886C"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=-bxNwFmp8GZ_Foz=CSP2kUOwqPKAaMFapGuz+@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD04B86FCAA4EC31C4970886C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11-03-06 11:02 AM, Fajar A. Nugraha wrote:
>=20
> If you have snapshots anyway, why not :
> - create a snapshot before each backup run
> - use the same directory (e.g. just /backup), no need to "cp" anything
> - add "--inplace" to rsync

Which is exactly what I am doing.  There is no "cp" involved in making
the btrfs copies of the existing backup.  It's simply "rsync -aAXH ...
--inplace" from the existing backup archive to the new, btrfs archive.

Cheers,
b.



--------------enigD04B86FCAA4EC31C4970886C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1zsk8ACgkQl3EQlGLyuXDxngCg6gjEeSPk3sUmTyrlVvGpdeeI
0xAAnRoLud2EDzkZm2fGXKkqorB0fy2n
=FmdE
-----END PGP SIGNATURE-----

--------------enigD04B86FCAA4EC31C4970886C--
