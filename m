Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47015 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaJVUZV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 16:25:21 -0400
Date: Wed, 22 Oct 2014 20:25:19 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: NOCOW and Swap Files?
Message-ID: <20141022202519.GC18164@carfax.org.uk>
References: <54480ED0.9070703@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
In-Reply-To: <54480ED0.9070703@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 01:08:48PM -0700, Robert White wrote:
> So the documentation is clear that you can't mount a swap file
> through BTRFS (unless you use a loop device).
>=20
> Why isn't a NOCOW file that has been fully pre-allocated -- as with
> fallocate(1) -- not suitable for swapping?
>=20
> I found one reference to an unimplemented feature necessary for
> swap, but wouldn't it be reasonable for that feature to exist for
> NOCOW files? (or does this relate to my previous questions about the
> COW operation that happens after a snapshot?)

   The original swap implementation worked by determining a list of
blocks (well, I guess extents) using fiemap, and passing that to the
swap code for it to use. This is fine, as long as (a) nobody else
writes to the file, and (b) the blocks comprising the file don't move
elsewhere.

   Part (a) can be done with normal permissions, so that's not a
problem.

   Part (b) is more tricky -- not because of CoW (because the writes
=66rom the swap code go directly to the device, ignoring the FS), but
because the FS's idea of where the file lives on the device can move
-- balance will do this, for example. So you can't balance a
filesystem with any active swapfiles on it. This is the main reason
that swapfiles aren't allowed on btrfs, as far as I know.

   The new code is the swap-on-NFS infrastructure, which indirects
swapfile accesses through the filesystem code. The reason you have to
do that with NFS is because NFS doesn't expose a block device at all,
so you can't get a list of blocks on an underlying device because
there isn't one. Indirecting the accesses through the filesystem,
however, allows us to side-step btrfs's problems with part (b) above,
and in theory gives us swapfile capability.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Great oxymorons of the world, no. 7: The Simple Truth ---     =20

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUSBKuAAoJEFheFHXiqx3k3vIP/0+T9E8PTIs8MRObiZN1Kz1d
GxunPVAU4CqsfQHzaYYr9S+57+hOGUy/hdhvmxGhWIudjF3nNd9LlsIp2tB7dkhB
8NS+BcD2d4cCx56f8f3OEMrAvwYrMev1OPnSMdN9f7E7UquY+LjyHTxc83+UZ0XK
nxLJEe/ZGbir/BN1RUOmsAhSnrbojEaYIiWkQTNHRuGpbsnoIsrGYSj96ERkjPdK
iPZNozk0lJdF6eoUv/+NVLkeXFwzsP0855h398k7yHQstt5IXR6mPiN5A2I6J2zv
gM3NrZtZwQdSWmph7b9bmo25b0HfR+pBV1Mj4FFhasO0mvNOK883h+OsuHQxiA9A
SeYZ7JzXHnbJtO7+U5mbJ1c/3m3+2h4KhHmRZetD8JpLdu/qmRirotEEsiUcUe3f
onposzLq0u6JhO2diqwqKVK3pj8RYhUhb8sz9AzArEBKN/hftXwV2oftGlDouSaw
rBXt3pWE8//QF3Qu/8F6LBRm/vTx3wliIWLIu/TFNS4OZn97BGrS44n7Q7MjsA/f
v+DdM/nMkiX8Pu7yNE8OTUVooLw6sJ12OI7XJnY+GR0QKEgA8cNw+IbGdjLHZGhl
GR3+VRVuBERlDaTRh4tj7s+ur9EHjoZVJ6W4yvB9yU4quB0DzzY7xIVlqBFQ9UqB
jsGmQ5iyE4L+GeEOf5oy
=UEIk
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
