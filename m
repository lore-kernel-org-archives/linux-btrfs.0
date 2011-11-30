From: Chris Samuel <chris@csamuel.org>
Subject: [PATCH] Canonicalise BTRFS: and Btrfs: to btrfs:
Date: Wed, 30 Nov 2011 22:05:21 +1100
Message-ID: <201111302205.32712.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7652984.cph6UXWbXO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart7652984.cph6UXWbXO
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Currently there are 3 different capitalisations of btrfs: used in
printk()'s, BTRFS: (3 occurences), Btrfs: (1 occurence) and btrfs:
(77 occurences).

It's best to have them all the same for consistency, so we canonicalise
the two minority cases to btrfs:.

Signed-off-by: Chris Samuel <chris@csamuel.org>
=2D--
 fs/btrfs/disk-io.c |    4 ++--
 fs/btrfs/inode.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 94abc25..f4d419b 100644
=2D-- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2106,7 +2106,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	features =3D btrfs_super_incompat_flags(disk_super) &
 		~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
=2D		printk(KERN_ERR "BTRFS: couldn't mount because of "
+		printk(KERN_ERR "btrfs: couldn't mount because of "
 		       "unsupported optional features (%Lx).\n",
 		       (unsigned long long)features);
 		err =3D -EINVAL;
@@ -2122,7 +2122,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	features =3D btrfs_super_compat_ro_flags(disk_super) &
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
 	if (!(sb->s_flags & MS_RDONLY) && features) {
=2D		printk(KERN_ERR "BTRFS: couldn't mount RDWR because of "
+		printk(KERN_ERR "btrfs: couldn't mount RDWR because of "
 		       "unsupported option features (%Lx).\n",
 		       (unsigned long long)features);
 		err =3D -EINVAL;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8ad26b1..399da74 100644
=2D-- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5057,7 +5057,7 @@ not_found_em:
 insert:
 	btrfs_release_path(path);
 	if (em->start > start || extent_map_end(em) <=3D start) {
=2D		printk(KERN_ERR "Btrfs: bad extent! em: [%llu %llu] passed "
+		printk(KERN_ERR "btrfs: bad extent! em: [%llu %llu] passed "
 		       "[%llu %llu]\n", (unsigned long long)em->start,
 		       (unsigned long long)em->len,
 		       (unsigned long long)start,
@@ -6693,7 +6693,7 @@ void btrfs_destroy_inode(struct inode *inode)
=20
 	spin_lock(&root->orphan_lock);
 	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
=2D		printk(KERN_INFO "BTRFS: inode %llu still on the orphan list\n",
+		printk(KERN_INFO "btrfs: inode %llu still on the orphan list\n",
 		       (unsigned long long)btrfs_ino(inode));
 		list_del_init(&BTRFS_I(inode)->i_orphan);
 	}
=2D-=20
1.7.4.1


=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart7652984.cph6UXWbXO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATtYN8Y1yjaOTJg85AQLOWAf/bL/giWEfpKhTZeCsNo87OsbxMmtjAvdu
X59YIFmRHNGb2QU+AnBFjUDxiJUVIZCEAUmLoNBHxoQtVeCcgZCKSoLiPxPM4xaQ
04PUeSk1KO6RUDckyI0SEBRC/XcveIziJ81rT85H9mY5x2oJkqm+Y60ZvA2+2o/o
Bz6kFqBPWXZ/1K28k5RjXCbhhZPNYNxe+V/iLeLLAP5hg2sH66gcfLrn9kSFZ/wT
50wzyijgywXqV3L94bIWRO2aMPpyggoi+GXxSvl6mIydO3UV/oZ4IytDtBGke/Kv
p/EgORYh2Qfdbt7ut/qMzSSyQDe7TCPWaAfF/qtdU8E4W+mfUM5a6w==
=T6+u
-----END PGP SIGNATURE-----

--nextPart7652984.cph6UXWbXO--
