From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: btrfs fi df returns nothing
Date: Wed, 09 Mar 2011 06:20:28 -0500
Message-ID: <il7npu$5lh$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB0EF254AD517B873E604C3C0"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB0EF254AD517B873E604C3C0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I am using btrfs on Ubuntu's LTS kernel (2.6.32-22-generic) and have
updated the btrfs-tools to 0.19+20101101-1~lucid1.  I have also built
the latest from
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.=
git.

The problem is that I don't get anything from btrfs fi df $mountpoint.
i.e., for the btrfs filesystem mounted at /mnt/btrfs-test/

# ./btrfs fi df /mnt/btrfs-test/
#

See, no output.  Is my kernel module too old for that feature?  Maybe it =
is:

stat64("/mnt/btrfs-test/", {st_mode=3DS_IFDIR|0755, st_size=3D72, ...}) =3D=
 0
open("/mnt/btrfs-test/",
O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) =3D 3
fcntl64(3, F_GETFD)                     =3D 0x1 (flags FD_CLOEXEC)
ioctl(3, 0xc0109414, 0x999c320)         =3D -1 ENOTTY (Inappropriate ioct=
l
for device)
exit_group(-1)                          =3D ?

If my kernel module is too old, anyone know of a successful backport of
a newer btrfs for Ubuntu Lucid?  In a PPA or otherwise?

Cheers,
b.



--------------enigB0EF254AD517B873E604C3C0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk13YnwACgkQl3EQlGLyuXBbKgCg+/faZ4Wqr6yXCwGu7BTKgOX/
M8IAoJxZKZ95y/dGiJvQZXLvIcaNR5Np
=wqzl
-----END PGP SIGNATURE-----

--------------enigB0EF254AD517B873E604C3C0--

