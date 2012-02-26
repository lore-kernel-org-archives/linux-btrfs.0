From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: filesystem full when it's not?  out of inodes?  huh?
Date: Sat, 25 Feb 2012 21:16:40 -0500
Message-ID: <jic4m8$j6g$1@dough.gmane.org>
References: <jic3e1$gpe$1@dough.gmane.org> <4F499498.1040006@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig647DB433F6873D37D503C4C7"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F499498.1040006@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig647DB433F6873D37D503C4C7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-02-25 09:10 PM, Fahrzin Hemmati wrote:
> btrfs is horrible for small filesystems (like a 5GB drive). df -h says
> you have 967MB available,

So does dd.  It manages to write that 967MB before getting an ENOSPC.

> but btrfs (at least by default) allocates 1GB
> at a time to data/metadata.

Bleah.

> This means that your 10MB file

It's a package of kernel headers so not a 10MB file but 10MB of lots of
small files, so heavy metadata allocation.

> is too big
> for the current allocation and requires a new data chunk, or another
> 1GB, which you don't have.

I see.

> Others might know of a way of changing the allocation size to less than=

> 1GB, but otherwise I recommend switching to something more stable like
> ext4/reiserfs/etc.

So btrfs is still not yet suitable to be a root/usr/var filesystem, even
in kernel 3.0.0?

b.


--------------enig647DB433F6873D37D503C4C7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9JlggACgkQl3EQlGLyuXCS7gCeOLN8x/Xa3t2lgvfkFUWhgW/X
A2gAnA8njqd3VNU9qWVAUdqjnlu2TOx6
=oX95
-----END PGP SIGNATURE-----

--------------enig647DB433F6873D37D503C4C7--

