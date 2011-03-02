From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: how to know when all space from a snapshot delete is freed?
Date: Wed, 02 Mar 2011 08:12:30 -0500
Message-ID: <iklfnu$efc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8B173F21AAA91438360320A4"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8B173F21AAA91438360320A4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

For some time after I issue a snapshot delete, the space in the volume
is freed.  It starts to free quite fast and then the progress slows and
speeds up again.

Given that the return from the snapshot delete command is immediate and
the space is freed asynchronously, how can I determine absolutely that
the snapshot has been entirely removed and the space freeing operation
is complete?

Cheers,
b.


--------------enig8B173F21AAA91438360320A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1uQj4ACgkQl3EQlGLyuXD/VACgk0GQVMkRh6bb6sPEprTzNwJY
gjkAniqXgaxPYYGgf+GR6clalzLqvKHg
=etIQ
-----END PGP SIGNATURE-----

--------------enig8B173F21AAA91438360320A4--

