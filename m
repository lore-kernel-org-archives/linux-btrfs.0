From: Ian Kumlien <pomac@vapor.com>
Subject: [bug] Reclaim space.
Date: Tue, 09 Feb 2010 19:41:51 +0100
Message-ID: <1265740911.5943.7.camel@pi>
Reply-To: pomac@vapor.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5fhdhrdQdERuXqonaxyS"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--=-5fhdhrdQdERuXqonaxyS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,=20

I assume this has something to do with using updated btrfs and old btrfs
utils, but it's only the presentation that is wrong.

btrfs-show gives:
Label: none  uuid: 2332476e-ed10-44b4-844b-c85cc7388a61
	Total devices 1 FS bytes used 266.53GB
	devid    1 size 145.00GB used 145.00GB path /dev/mapper/root

But df -h gives:
/dev/mapper/root      145G  -64Z -122G 100% /

Also, following your guides i tried to do a rm -rf ext2_saved, which
didn't quite work...


rm -rf ext2_saved/
rm: cannot remove directory `ext2_saved': Directory not empty

ls -la ext2_saved/
total 4
drwxr-xr-x 1 root root   0  9 feb 13.41 .
drwxr-xr-x 1 root root 170  2 dec 21.54 ..

Any clues, ideas, suggestions?
(Remember the CC)

PS. Beyond that i really like my experiences with btrfs so far (this was
my first root filesystem migration though)
DS.

--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-5fhdhrdQdERuXqonaxyS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEABECAAYFAktxrG4ACgkQ7F3Euyc51N8MlgCdFu7j7lg7F7H2tnptbejXr5yO
BLoAn2Enos5vXN1zqS7qtR8ccJL8AADS
=vgWo
-----END PGP SIGNATURE-----

--=-5fhdhrdQdERuXqonaxyS--

