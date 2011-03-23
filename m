From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: efficiency of btrfs cow
Date: Wed, 23 Mar 2011 12:19:39 -0400
Message-ID: <4D8A1D9B.7060706@interlinx.bc.ca>
References: <il0a8d$4ev$1@dough.gmane.org> <1299427596.15017.8.camel@ayu> <4D89EA17.20506@interlinx.bc.ca> <AANLkTikF3e2X=UK2pJmNgaTAJqR0DXymKfzr=drhC5S=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFF892F542D28022111B7C751"
Cc: linux-btrfs@vger.kernel.org
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikF3e2X=UK2pJmNgaTAJqR0DXymKfzr=drhC5S=@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFF892F542D28022111B7C751
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11-03-23 11:53 AM, Chester wrote:
> I'm not a developer, but I think it goes something like this:
> btrfs doesn't write the filesystem on the entire device/partition at
> format time, rather, it dynamically increases the size of the
> filesystem as data is used. That's why formating a disk in btrfs can
> be so fast.

Indeed, this much is understood, which is why I am using btrfs fi df to
try to determine how much of the increase in raw device usage is the
dynamic allocation of metadata.

Cheers,
b.


--------------enigFF892F542D28022111B7C751
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2KHZwACgkQl3EQlGLyuXBHIgCglRj6j6hC9OYGiaUE7T8gktW+
MboAoIqtZ1COAzCGAV+V6uPFF67t/lg+
=5K00
-----END PGP SIGNATURE-----

--------------enigFF892F542D28022111B7C751--
