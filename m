From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: efficiency of btrfs cow
Date: Sun, 06 Mar 2011 11:17:13 -0500
Message-ID: <4D73B389.1010803@interlinx.bc.ca>
References: <il0a8d$4ev$1@dough.gmane.org> <1299427596.15017.8.camel@ayu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC2411EC402FBCAA0FEA27151"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1299427596.15017.8.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC2411EC402FBCAA0FEA27151
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11-03-06 11:06 AM, Calvin Walton wrote:
>=20
> There actually is such a periodic jump in overhead,

Ahh.  So my instincts were correct.

> caused by the way
> which btrfs dynamically allocates space for metadata as needed by the
> creation of new files, which it does whenever the free metadata space
> ratio reaches a threshold (it's probably more complicated than that, bu=
t
> close enough for now).

Sounds fair enough.

> To see exactly what's going on, you should use the "btrfs filesystem df=
"
> command to see how space is being allocated for data and metadata
> separately:
>=20
> ayu ~ # btrfs fi df /
> Data: total=3D266.01GB, used=3D249.35GB
> System, DUP: total=3D8.00MB, used=3D36.00KB
> Metadata, DUP: total=3D3.62GB, used=3D1.93GB
> ayu ~ # df -h /
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda4             402G  254G  145G  64% /
>=20
> If you use the btrfs tool's df command to account for space in your
> testing, you should get much more accurate results.

Indeed!  Unfortunately that tool seems to be completely silent on my syst=
em:

# btrfs filesystem df /mnt/btrfs-test/
# btrfs filesystem df /mnt/btrfs-test

Where /mnt/btrfs-test is where I have the device that I created the
btrfs filesystem on mounted.  i.e.:

# grep btrfs /proc/mounts
/dev/mapper/btrfs--test-btrfs--test /mnt/btrfs-test btrfs rw,relatime 0 0=


My btrfs-tools appears to be from 20101101.  The changelog says:

  * Merging upstream version 0.19+20101101.

Cheers,
b.


--------------enigC2411EC402FBCAA0FEA27151
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1zs4kACgkQl3EQlGLyuXC3PQCeK1J4Mt9/InGvYfTxiPxApLDQ
uOAAnirdacWVLRnpc1P0Fa8ldZJwaEId
=4MHo
-----END PGP SIGNATURE-----

--------------enigC2411EC402FBCAA0FEA27151--
