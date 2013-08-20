Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:38165 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3HTLUn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 07:20:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 09/12] Btrfs: Make btrfs_header_chunk_tree_uuid() return unsigned long
Date: Tue, 20 Aug 2013 13:20:15 +0200
Message-Id: <1376997618-13573-10-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
References: <1376997618-13573-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Internally, btrfs_header_chunk_tree_uuid() calculates an unsigned long, but
casts it to a pointer, while all callers cast it to unsigned long again.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/btrfs/ctree.c   |    7 +++----
 fs/btrfs/ctree.h   |    5 ++---
 fs/btrfs/disk-io.c |    5 ++---
 fs/btrfs/ioctl.c   |    2 +-
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 9e3b259..a93d0c7 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3143,8 +3143,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 			    BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
-			    (unsigned long)btrfs_header_chunk_tree_uuid(c),
-			    BTRFS_UUID_SIZE);
+			    btrfs_header_chunk_tree_uuid(c), BTRFS_UUID_SIZE);
 
 	btrfs_set_node_key(c, &lower_key, 0);
 	btrfs_set_node_blockptr(c, 0, lower->start);
@@ -3281,7 +3280,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	write_extent_buffer(split, root->fs_info->fsid,
 			    btrfs_header_fsid(split), BTRFS_FSID_SIZE);
 	write_extent_buffer(split, root->fs_info->chunk_tree_uuid,
-			    (unsigned long)btrfs_header_chunk_tree_uuid(split),
+			    btrfs_header_chunk_tree_uuid(split),
 			    BTRFS_UUID_SIZE);
 
 	tree_mod_log_eb_copy(root->fs_info, split, c, 0, mid, c_nritems - mid);
@@ -4037,7 +4036,7 @@ again:
 			    btrfs_header_fsid(right), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
-			    (unsigned long)btrfs_header_chunk_tree_uuid(right),
+			    btrfs_header_chunk_tree_uuid(right),
 			    BTRFS_UUID_SIZE);
 
 	if (split == 0) {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 509963a..f54be20 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2608,10 +2608,9 @@ static inline unsigned long btrfs_header_fsid(struct extent_buffer *eb)
 	return offsetof(struct btrfs_header, fsid);
 }
 
-static inline u8 *btrfs_header_chunk_tree_uuid(struct extent_buffer *eb)
+static inline unsigned long btrfs_header_chunk_tree_uuid(struct extent_buffer *eb)
 {
-	unsigned long ptr = offsetof(struct btrfs_header, chunk_tree_uuid);
-	return (u8 *)ptr;
+	return offsetof(struct btrfs_header, chunk_tree_uuid);
 }
 
 static inline int btrfs_is_leaf(struct extent_buffer *eb)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4b61698..4a6c0e5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1288,7 +1288,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	write_extent_buffer(leaf, fs_info->fsid, btrfs_header_fsid(leaf),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(leaf, fs_info->chunk_tree_uuid,
-			    (unsigned long)btrfs_header_chunk_tree_uuid(leaf),
+			    btrfs_header_chunk_tree_uuid(leaf),
 			    BTRFS_UUID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 
@@ -2607,8 +2607,7 @@ int open_ctree(struct super_block *sb,
 	chunk_root->commit_root = btrfs_root_node(chunk_root);
 
 	read_extent_buffer(chunk_root->node, fs_info->chunk_tree_uuid,
-	   (unsigned long)btrfs_header_chunk_tree_uuid(chunk_root->node),
-	   BTRFS_UUID_SIZE);
+	   btrfs_header_chunk_tree_uuid(chunk_root->node), BTRFS_UUID_SIZE);
 
 	ret = btrfs_read_chunk_tree(chunk_root);
 	if (ret) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 593a0ec..a39034e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -428,7 +428,7 @@ static noinline int create_subvol(struct inode *dir,
 	write_extent_buffer(leaf, root->fs_info->fsid, btrfs_header_fsid(leaf),
 			    BTRFS_FSID_SIZE);
 	write_extent_buffer(leaf, root->fs_info->chunk_tree_uuid,
-			    (unsigned long)btrfs_header_chunk_tree_uuid(leaf),
+			    btrfs_header_chunk_tree_uuid(leaf),
 			    BTRFS_UUID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 
-- 
1.7.9.5

