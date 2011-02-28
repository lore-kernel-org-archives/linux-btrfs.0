From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Too many links
Date: Mon, 28 Feb 2011 11:20:59 -0500
Message-ID: <ikgi1c$j83$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7542DEAE928157F5C5CFA285"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7542DEAE928157F5C5CFA285
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

In doing some btrfs testing (on 2.6.32-22-generic and 2.6.35-24-generic)
I seem to have come across a limitation in how many links I can have in
a single directory.  I hit the EMLINK trying to create the 72nd link
(with rsync, replicating from a source directory fwiw).  The source
directory of the rsync has 2400 links that need to be replicated on btrfs=
=2E

The most recent info I can find is a thread from mid-2010:

http://www.spinics.net/lists/linux-btrfs/msg05619.html

I guess this is still a limitation?  Is the future of a fix still as
unclear as it was back in July 2010?

Thanx,
b.


--------------enig7542DEAE928157F5C5CFA285
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1ry2sACgkQl3EQlGLyuXDabgCggj//Zjn/BOB3uLaONPLlKzbz
IHMAoJjfCaUOrvnk3ihTtFzWIbdRn/z/
=nheM
-----END PGP SIGNATURE-----

--------------enig7542DEAE928157F5C5CFA285--

