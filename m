From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: btrfs fi df units
Date: Sat, 19 Mar 2011 13:17:21 -0400
Message-ID: <im2ofa$5fi$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDED8A0D1343B510F6522E496"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDED8A0D1343B510F6522E496
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I notice when I issue a btrfs fi df the result is in units of GB (for a
large filesystem -- maybe it's smaller for smaller filesystems).  Is
there any way to force the units?  I'd like to see the granularity of
KBs if possible.

Cheers,
b.


--------------enigDED8A0D1343B510F6522E496
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2E5SoACgkQl3EQlGLyuXADywCg9ZUHdkctdY1l8NkgBDPlT2Za
6MsAoOMIAdn96NTAuL36QwP7twKRJdD3
=Otxc
-----END PGP SIGNATURE-----

--------------enigDED8A0D1343B510F6522E496--

