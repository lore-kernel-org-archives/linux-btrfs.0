From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: subvolume nomenclature
Date: Fri, 02 Mar 2012 08:31:33 -0500
Message-ID: <jiqi3l$d4k$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig839D1CA65CA2116A43B2E315"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig839D1CA65CA2116A43B2E315
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I seem to have the following subvolumes of my filesystem:

# btrfs sub li /
ID 256 top level 5 path @
ID 257 top level 5 path @home
ID 258 top level 5 path @/etc/apt/oneiric

I *think* the last one is there due to a:

# btrfsctl -s oneiric /

that I did prior to doing an upgrade.  I can't seem to figure out the
nomenclature to delete it though:

# btrfs sub de /@/etc/apt/oneiric
ERROR: error accessing '/@/etc/apt/oneiric'

I've tried lots of other combinations with no luck.

Can anyone give me a hint (or the answer :-) )?

Cheers,
b.


--------------enig839D1CA65CA2116A43B2E315
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9Qy7UACgkQl3EQlGLyuXBAawCeOTVaVK2To8As0rl20qBKLFf2
ce8AoJ787oew8DwS6hn0fu6buoFdHFJE
=p7Vp
-----END PGP SIGNATURE-----

--------------enig839D1CA65CA2116A43B2E315--

