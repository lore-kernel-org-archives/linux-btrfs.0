From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sun, 26 Feb 2012 14:48:54 -0500
Message-ID: <jie2b6$nla$1@dough.gmane.org>
References: <jic3e1$gpe$1@dough.gmane.org> <4F4A8A13.2070305@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig79D5A3B35928FFF51A119151"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F4A8A13.2070305@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig79D5A3B35928FFF51A119151
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-02-26 02:37 PM, Daniel Lee wrote:
> 3.22GB + (896MB * 2) =3D 5GB
>=20
> There's no mystery here, you're simply out of space.

Except the mystery that I had to expand the filesystem to something
between 20GB and 50GB in order to complete the operation, after which I
could reduce it back down to 5GB.

Cheers,
b.



--------------enig79D5A3B35928FFF51A119151
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9KjKYACgkQl3EQlGLyuXCX+QCgr0+TY51MjUlNsSHlzUM7duXc
AtUAmgJ1lEEcFFD7oV7+3GNKRAyGP2NV
=NZbf
-----END PGP SIGNATURE-----

--------------enig79D5A3B35928FFF51A119151--

