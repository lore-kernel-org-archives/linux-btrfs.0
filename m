From: Chris Samuel <chris@csamuel.org>
Subject: [RESEND] [PATCH] Canonicalise BTRFS: and Btrfs: to btrfs:
Date: Wed, 30 Nov 2011 22:27:45 +1100
Message-ID: <201111302227.46216.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently there are 3 different capitalisations of btrfs: used in
printk()'s, BTRFS: (3 occurences), Btrfs: (1 occurence) and btrfs:
(77 occurences).

It's best to have them all the same for consistency, so we canonicalise
the two minority cases to btrfs:.

Signed-off-by: Chris Samuel <chris@csamuel.org>
---
 fs/btrfs/disk-io.c |    4 ++--
 fs/btrfs/inode.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 94abc25..f4d419b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2106,7 +2106,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	features = btrfs_super_incompat_flags(disk_super) &
 		~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (features) {
-		printk(KERN_ERR "BTRFS: couldn't mount because of "
+		printk(KERN_ERR "btrfs: couldn't mount because of "
 		       "unsupported optional features (%Lx).\n",
 		       (unsigned long long)features);
 		err = -EINVAL;
@@ -2122,7 +2122,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	features = btrfs_super_compat_ro_flags(disk_super) &
 		~BTRFS_FEATURE_COMPAT_RO_SUPP;
 	if (!(sb->s_flags & MS_RDONLY) && features) {
-		printk(KERN_ERR "BTRFS: couldn't mount RDWR because of "
+		printk(KERN_ERR "btrfs: couldn't mount RDWR because of "
 		       "unsupported option features (%Lx).\n",
 		       (unsigned long long)features);
 		err = -EINVAL;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8ad26b1..399da74 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5057,7 +5057,7 @@ not_found_em:
 insert:
 	btrfs_release_path(path);
 	if (em->start > start || extent_map_end(em) <= start) {
-		printk(KERN_ERR "Btrfs: bad extent! em: [%llu %llu] passed "
+		printk(KERN_ERR "btrfs: bad extent! em: [%llu %llu] passed "
 		       "[%llu %llu]\n", (unsigned long long)em->start,
 		       (unsigned long long)em->len,
 		       (unsigned long long)start,
@@ -6693,7 +6693,7 @@ void btrfs_destroy_inode(struct inode *inode)
 
 	spin_lock(&root->orphan_lock);
 	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
-		printk(KERN_INFO "BTRFS: inode %llu still on the orphan list\n",
+		printk(KERN_INFO "btrfs: inode %llu still on the orphan list\n",
 		       (unsigned long long)btrfs_ino(inode));
 		list_del_init(&BTRFS_I(inode)->i_orphan);
 	}
-- 
1.7.4.1


-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP
