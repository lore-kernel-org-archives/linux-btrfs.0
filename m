From: Thomas Kuther <gimpel@sonnenkinder.org>
Subject: How do I boot a system root on a multidevice BTRFS subvol?
Date: Sat, 14 Mar 2009 21:05:45 +0100
Message-ID: <20090314210545.773b1d89@gimpel.ath.cx>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fL03_0E1QKsUHbMz2blq3EN";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/fL03_0E1QKsUHbMz2blq3EN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

recently I installed a distribution I want to look at via chroot into a
btrfs subvolume on a multidevice btrfs.

Now I tried to boot this, the kernel command line in GRUB looks as
follows so far:

/kernel-2.6.29-rc7-git3 root=3D/dev/sdb7 rootfstype=3Dbtrfs
rootflags=3Ddevice=3D/dev/sda1,subvol=3Darchroot

This gives "VFS: cannot find sdb7 or bad block", like it would when
trying to mount via fstab without -o device=3Dfoo

The fstab line for / looks like:
/dev/sdb7  /  btrfs  device=3D/dev/sda1,subvol=3Darchroot  1 1

Is this possible already, or am I doing something wrong?

Many thanks in advance!

Thomas

--Sig_/fL03_0E1QKsUHbMz2blq3EN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkm8DiIACgkQMQFfAqZTGfyMuwCeNLjZwYWoICxwvjuz32jagJaw
Td8An3p9J+W/95MwqU0MIhmPAkjHK5f1
=/rbi
-----END PGP SIGNATURE-----

--Sig_/fL03_0E1QKsUHbMz2blq3EN--
