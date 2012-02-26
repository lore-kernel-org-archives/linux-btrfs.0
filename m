From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sun, 26 Feb 2012 15:05:53 -0500
Message-ID: <jie3b2$v5d$1@dough.gmane.org>
References: <jic3e1$gpe$1@dough.gmane.org> <4F4A8A13.2070305@gmail.com> <jie2b6$nla$1@dough.gmane.org> <4F4A8D7A.5070605@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9009F9A4C46FE9D40445E469"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F4A8D7A.5070605@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9009F9A4C46FE9D40445E469
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-02-26 02:52 PM, Daniel Lee wrote:
> What's mysterious about that?

What's mysterious about needing to grow the filesystem to over 20GB to
unpack 10MB of (small, so yes, many) files?

> When you shrink it btrfs is going to throw
> away unused data to cram it all in the requested space and you had empt=
y
> space that was taken up by the metadata allocation.

The shrinking is secondary mystery.  It's the need for more than 20GB of
space for less than 3GB of files that's the major mystery.

> Did you compare
> btrfs fi df after you shrank it with before?

I didn't unfortunately.

b.


--------------enig9009F9A4C46FE9D40445E469
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9KkKEACgkQl3EQlGLyuXD/OgCgmn7Z02PmnyHxBNx40MqYQWSQ
eXAAoJARnILfALSPo6oonF8uT8jFetJN
=hff6
-----END PGP SIGNATURE-----

--------------enig9009F9A4C46FE9D40445E469--

