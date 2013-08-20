Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:32861 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab3HTLUb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:31 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 08/12] Btrfs: Make btrfs_header_fsid() return unsigned long
Date: Tue, 20 Aug 2013 13:20:14 +0200
Message-Id: <1376997618-13573-9-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Internally, btrfs_header_fsid() calculates an unsigned long, but casts
it to a pointer, while all callers cast it to unsigned long again.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/ctree.c   |   15 +++++----------
 fs/btrfs/ctree.h   |    5 ++---
 fs/btrfs/disk-io.c |    9 +++------
 fs/btrfs/ioctl.c   |    3 +--
 4 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b208df3..9e3b259 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -274,8 +274,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, new_root_objectid);
 
-	write_extent_buffer(cow, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(cow),
+	write_extent_buffer(cow, root->fs_info->fsid, btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
@@ -1046,8 +1045,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, root->root_key.objectid);
 
-	write_extent_buffer(cow, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(cow),
+	write_extent_buffer(cow, root->fs_info->fsid, btrfs_header_fsid(cow),
 			    BTRFS_FSID_SIZE);
 
 	ret = update_ref_for_cow(trans, root, buf, cow, &last_ref);
@@ -3141,8 +3139,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(c, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(c, root->root_key.objectid);
 
-	write_extent_buffer(c, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(c),
+	write_extent_buffer(c, root->fs_info->fsid, btrfs_header_fsid(c),
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
@@ -3282,8 +3279,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(split, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(split, root->root_key.objectid);
 	write_extent_buffer(split, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(split),
-			    BTRFS_FSID_SIZE);
+			    btrfs_header_fsid(split), BTRFS_FSID_SIZE);
 	write_extent_buffer(split, root->fs_info->chunk_tree_uuid,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
 			    BTRFS_UUID_SIZE);
@@ -4038,8 +4034,7 @@ again:
 	btrfs_set_header_owner(right, root->root_key.objectid);
 	btrfs_set_header_level(right, 0);
 	write_extent_buffer(right, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(right),
-			    BTRFS_FSID_SIZE);
+			    btrfs_header_fsid(right), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(right),
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 21f9632..509963a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2603,10 +2603,9 @@ static inline void btrfs_set_header_backref_rev(struct extent_buffer *eb,
 	btrfs_set_header_flags(eb, flags);
 }
 
-static inline u8 *btrfs_header_fsid(struct extent_buffer *eb)
+static inline unsigned long btrfs_header_fsid(struct extent_buffer *eb)
 {
-	unsigned long ptr = offsetof(struct btrfs_header, fsid);
-	return (u8 *)ptr;
+	return offsetof(struct btrfs_header, fsid);
 }
 
 static inline u8 *btrfs_header_chunk_tree_uuid(struct extent_buffer *eb)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e5a68d2..4b61698 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -494,8 +494,7 @@ static int check_tree_block_fsid(struct btrfs_root *root,
 	u8 fsid[BTRFS_UUID_SIZE];
 	int ret = 1;
 
-	read_extent_buffer(eb, fsid, (unsigned long)btrfs_header_fsid(eb),
-			   BTRFS_FSID_SIZE);
+	read_extent_buffer(eb, fsid, btrfs_header_fsid(eb), BTRFS_FSID_SIZE);
 	while (fs_devices) {
 		if (!memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE)) {
 			ret = 0;
@@ -1286,8 +1285,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	btrfs_set_header_owner(leaf, objectid);
 	root->node = leaf;
 
-	write_extent_buffer(leaf, fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(leaf),
+	write_extent_buffer(leaf, fs_info->fsid, btrfs_header_fsid(leaf),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(leaf, fs_info->chunk_tree_uuid,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(leaf),
@@ -1374,8 +1372,7 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 	root->node = leaf;
 
 	write_extent_buffer(root->node, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(root->node),
-			    BTRFS_FSID_SIZE);
+			    btrfs_header_fsid(root->node), BTRFS_FSID_SIZE);
 	btrfs_mark_buffer_dirty(root->node);
 	btrfs_tree_unlock(root->node);
 	return root;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 514b833..593a0ec 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -425,8 +425,7 @@ static noinline int create_subvol(struct inode *dir,
 	btrfs_set_header_backref_rev(leaf, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(leaf, objectid);
 
-	write_extent_buffer(leaf, root->fs_info->fsid,
-			    (unsigned long)btrfs_header_fsid(leaf),
+	write_extent_buffer(leaf, root->fs_info->fsid, btrfs_header_fsid(leaf),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(leaf, root->fs_info->chunk_tree_uuid,
 			    (unsigned long)btrfs_header_chunk_tree_uuid(leaf),
-- 
1.7.9.5

