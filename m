From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Bug in mkfs.btrfs?!
Date: Mon, 24 Jan 2011 13:13:41 +0000
Message-ID: <20110124131341.GA3403@carfax.org.uk>
References: <20110122144513.GA2539@scooter>
 <20110122145222.GB2539@scooter>
 <20110122151124.GC29985@carfax.org.uk>
 <20110122155612.GA3664@scooter>
 <20110123181827.GF29985@carfax.org.uk>
 <4D3CA568.7050506@libero.it>
 <20110124130104.GA7354@scooter>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Cc: kreijack@inwind.it, Hugo Mills <hugo-lkml@carfax.org.uk>,
	linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110124130104.GA7354@scooter>
List-ID: <linux-btrfs.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 24, 2011 at 02:01:04PM +0100, Felix Blanke wrote:
> Hi,
>=20
> you were talking about the LOOP_GET_STATUS function. I'm not quite sure w=
here does it
> came from. Is it part of the kernel? Or does it come from the util-linux =
package?

   It's an ioctl (number 0x4c03) that works on loop devices, and
returns information about the loop device. Being an ioctl, it's
implemented in the kernel. Unfortunately, since it's part of the
kernel API, the size of the name field is probably fixed for the rest
of time, and so the bug can't be fixed.

> I'm searching for the right location where do report that bug :)

   linux-kernel mailing list, I think.

> Btw: I tested it with util-linux-2.19-rc1. The strace still contains
> the truncated path, and no '*'. Therefore I think that ioctl is from
> the kernel.

   Indeed.

   What I find interesting is that my copy of losetup follows symlinks
=66rom the /dev/disk/by-id/... path back to the original device node
(/dev/dm-7 in my test case) before setting up the loop, whereas yours
seems not to.

   I think that that's probably the easiest solution to this problem:
modify losetup to use realpath(3) on the device node it's given.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                      --- make bzImage, not war ---                     =20

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNPXsFIKyzvlFcI40RAnCBAJ9S2oLoyUxSLq0vyUT6boJR+Q2aVQCgiM/C
TPNhvWfia3kVhJRrXBqRNHM=
=wISZ
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
