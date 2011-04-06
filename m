From: Sergei Trofimovich <slyich@gmail.com>
Subject: [patch] trivial: fix 'btrfS' spelling on error
Date: Wed, 6 Apr 2011 22:31:57 +0300
Message-ID: <20110406223157.48557556@sf.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.eZiG4c4n/E5FrJTvnQNF=w"; protocol="application/pgp-signature"
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/.eZiG4c4n/E5FrJTvnQNF=w
Content-Type: multipart/mixed; boundary="MP_/NvRlyevhBxet5hAhkGZeo6d"

--MP_/NvRlyevhBxet5hAhkGZeo6d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

noticed on horribly broken btrfs image.
Patch is against 2.6.39-rc2.

--=20

  Sergei

--MP_/NvRlyevhBxet5hAhkGZeo6d
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=0003-btrfs-typo-btrfS-btrfs.patch

=46rom 95b9e84c22bcc31d1f42d62c5956083f6c39eb2b Mon Sep 17 00:00:00 2001
From: Sergei Trofimovich <st@anti-virus.by>
Date: Wed, 6 Apr 2011 16:49:17 +0300
Subject: [PATCH 3/4] btrfs: typo: 'btrfS' -> 'btrfs'

Signed-off-by: Sergei Trofimovich <st@anti-virus.by>
---
 fs/btrfs/dir-item.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index c62f02f..dec9348 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -452,7 +452,7 @@ int verify_dir_item(struct btrfs_root *root,
 		namelen =3D XATTR_NAME_MAX;
=20
 	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
-		printk(KERN_CRIT "btrfS: invalid dir item name len: %u\n",
+		printk(KERN_CRIT "btrfs: invalid dir item name len: %u\n",
 		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
 		return 1;
 	}
--=20
1.7.3.4


--MP_/NvRlyevhBxet5hAhkGZeo6d--

--Sig_/.eZiG4c4n/E5FrJTvnQNF=w
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2cv7IACgkQcaHudmEf86rfGgCfYVaaaYVFnoIjinhauYL7L5sW
pzEAnjAqHoCjd0mquJVlBEY3IMJPtCrw
=45/U
-----END PGP SIGNATURE-----

--Sig_/.eZiG4c4n/E5FrJTvnQNF=w--
