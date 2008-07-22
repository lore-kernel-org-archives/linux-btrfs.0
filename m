From: Radoslaw Szkodzinski <astralstorm@gen2.org>
Subject: [PATCH] btrfs-convert: Iterate correctly using libext2fs functions
Date: Tue, 22 Jul 2008 18:48:48 +0200
Message-ID: <20080722184848.0504a0f1@gen2.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Please CC me with comments, as I'm not yet subscribed to the list.

This fairly trivial patch fixes a compile error I stumbled upon. The
error only happens with new e2fsprogs, as inode_map has become private.
Ignoring the warning would most likely cause a segfault.

# HG changeset patch
# User Rados=C5=82aw Szkodzi=C5=84ski <astralstorm@gen2.org>
# Date 1216744630 -7200
# Node ID 9725a82ac98f460f2a7d4e211cfe4ec88aed4b8a
# Parent  1aa4b32e3efd452531cb0b883edfcc3761487fca
btrfs-convert: Iterate correctly using libext2fs functions

This patch corrects open-coded inode_map iteration, which happens to be
illegal in new libext2fs due to inode_map being private, causing warnin=
g,
which becomes a compile error.

diff -r 1aa4b32e3efd -r 9725a82ac98f convert.c
--- a/convert.c	Tue Jun 10 10:09:18 2008 -0400
+++ b/convert.c	Tue Jul 22 18:37:10 2008 +0200
@@ -952,31 +952,26 @@
 static int copy_single_inode(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 objectid,
 			     ext2_filsys ext2_fs, ext2_ino_t ext2_ino,
+			     struct ext2_inode *ext2_inode,
 			     int datacsum, int packing, int noxattr)
 {
 	int ret;
-	errcode_t err;
-	struct ext2_inode ext2_inode;
 	struct btrfs_key inode_key;
 	struct btrfs_inode_item btrfs_inode;
=20
-	err =3D ext2fs_read_inode(ext2_fs, ext2_ino, &ext2_inode);
-	if (err)
-		goto error;
-
-	if (!ext2_inode.i_links_count &&
-	    (!ext2_inode.i_mode || ext2_inode.i_dtime)) {
+	if (!ext2_inode->i_links_count &&
+	    (!ext2_inode->i_mode || ext2_inode->i_dtime)) {
 		printf("skip inode %u\n", ext2_ino);
 		return 0;
 	}
-	copy_inode_item(&btrfs_inode, &ext2_inode);
-	if (!datacsum && S_ISREG(ext2_inode.i_mode)) {
+	copy_inode_item(&btrfs_inode, ext2_inode);
+	if (!datacsum && S_ISREG(ext2_inode->i_mode)) {
 		u32 flags =3D btrfs_stack_inode_flags(&btrfs_inode) |
 			    BTRFS_INODE_NODATASUM;
 		btrfs_set_stack_inode_flags(&btrfs_inode, flags);
 	}
=20
-	switch (ext2_inode.i_mode & S_IFMT) {
+	switch (ext2_inode->i_mode & S_IFMT) {
 	case S_IFREG:
 		ret =3D create_file_extents(trans, root, objectid, &btrfs_inode,
 					ext2_fs, ext2_ino, datacsum, packing);
@@ -987,7 +982,7 @@
 		break;
 	case S_IFLNK:
 		ret =3D create_symbol_link(trans, root, objectid, &btrfs_inode,
-					 ext2_fs, ext2_ino, &ext2_inode);
+					 ext2_fs, ext2_ino, ext2_inode);
 		break;
 	default:
 		ret =3D 0;
@@ -1007,9 +1002,6 @@
 	btrfs_set_key_type(&inode_key, BTRFS_INODE_ITEM_KEY);
 	ret =3D btrfs_insert_inode(trans, root, objectid, &btrfs_inode);
 	return ret;
-error:
-	fprintf(stderr, "ext2fs_read_inode: %s\n", error_message(err));
-	return -1;
 }
=20
 static int copy_disk_extent(struct btrfs_root *root, u64 dst_bytenr,
@@ -1042,6 +1034,9 @@
 		       int datacsum, int packing, int noxattr)
 {
 	int ret;
+	errcode_t err;
+	ext2_inode_scan ext2_scan;
+	struct ext2_inode ext2_inode;
 	ext2_ino_t ext2_ino;
 	u64 objectid;
 	struct btrfs_trans_handle *trans;
@@ -1049,27 +1044,37 @@
 	trans =3D btrfs_start_transaction(root, 1);
 	if (!trans)
 		return -ENOMEM;
-	ext2_ino =3D ext2_fs->inode_map->start;
-	for (; ext2_ino <=3D ext2_fs->inode_map->end; ext2_ino++) {
-		if (ext2fs_fast_test_inode_bitmap(ext2_fs->inode_map,
-						  ext2_ino)) {
-			/* skip special inode in ext2fs */
-			if (ext2_ino < EXT2_GOOD_OLD_FIRST_INO &&
-			    ext2_ino !=3D EXT2_ROOT_INO)
-				continue;
-			objectid =3D ext2_ino + INO_OFFSET;
-			ret =3D copy_single_inode(trans, root,
-						objectid, ext2_fs, ext2_ino,
-						datacsum, packing, noxattr);
-			if (ret)
-				return ret;
-		}
+	err =3D ext2fs_open_inode_scan(ext2_fs, 0, &ext2_scan);
+	if (err) {
+		fprintf(stderr, "ext2fs_open_inode_scan: %s\n", error_message(err));
+		return -1;
+	}
+	while (!(err =3D ext2fs_get_next_inode(ext2_scan, &ext2_ino,
+					     &ext2_inode))) {
+		/* no more inodes */
+		if (ext2_ino =3D=3D 0)
+			break;
+		/* skip special inode in ext2fs */
+		if (ext2_ino < EXT2_GOOD_OLD_FIRST_INO &&
+		    ext2_ino !=3D EXT2_ROOT_INO)
+			continue;
+		objectid =3D ext2_ino + INO_OFFSET;
+		ret =3D copy_single_inode(trans, root,
+					objectid, ext2_fs, ext2_ino,
+					&ext2_inode, datacsum, packing,
+					noxattr);
+		if (ret)
+			return ret;
 		if (trans->blocks_used >=3D 4096) {
 			ret =3D btrfs_commit_transaction(trans, root);
 			BUG_ON(ret);
 			trans =3D btrfs_start_transaction(root, 1);
 			BUG_ON(!trans);
 		}
+	}
+	if (err) {
+		fprintf(stderr, "ext2fs_get_next_inode: %s\n", error_message(err));
+		return -1;
 	}
 	ret =3D btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
