Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30236 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbcBVHCN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 02:02:13 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/5] btrfs-progs: Allow open_ctree to return fs_info even chunk tree is corrupted
Date: Mon, 22 Feb 2016 14:59:54 +0800
Message-Id: <1456124397-21403-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current open_ctree_fs_info() won't return anything if chunk tree root is
corrupted.
This makes some function, like btrfs-find-root unable to find any older
chunk tree root, even it is possible to use system_chunk_array in super
block.

And at least two users in mail list has reported such heavily chunk
corruption.
Although we have 'btrfs rescue chunk-recovery' but it's too time
consuming and sometimes buggy.

This patch adds a new open ctree flag,
OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR, allowing fs_info to be returned from
open_ctree_fs_info() even there is no valid tree root in it.

Also adds a new close_ctree() variant, close_ctree_fs_info() to handle
possible fs_info without any root.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.h   |  1 +
 disk-io.c | 29 ++++++++++++++++++++++++-----
 disk-io.h | 18 ++++++++++++++++--
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/ctree.h b/ctree.h
index 21b0445..5ab0f4a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1029,6 +1029,7 @@ struct btrfs_fs_info {
 	unsigned int quota_enabled:1;
 	unsigned int suppress_check_block_errors:1;
 	unsigned int ignore_fsid_mismatch:1;
+	unsigned int ignore_chunk_tree_error:1;
 
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
diff --git a/disk-io.c b/disk-io.c
index bd0444b..3b5a08e 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1168,8 +1168,14 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info)
 						    btrfs_super_chunk_root(sb),
 						    blocksize, generation);
 	if (!extent_buffer_uptodate(fs_info->chunk_root->node)) {
-		fprintf(stderr, "Couldn't read chunk root\n");
-		return -EIO;
+		if (fs_info->ignore_chunk_tree_error) {
+			error("Couldn't read chunk root, continue anyway");
+			fs_info->chunk_root = NULL;
+			return 0;
+		} else {
+			error("Couldn't read chunk rootn");
+			return -EIO;
+		}
 	}
 
 	if (!(btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_METADUMP)) {
@@ -1212,6 +1218,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 		fs_info->suppress_check_block_errors = 1;
 	if (flags & OPEN_CTREE_IGNORE_FSID_MISMATCH)
 		fs_info->ignore_fsid_mismatch = 1;
+	if (flags & OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR)
+		fs_info->ignore_chunk_tree_error = 1;
 
 	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
 				    (flags & OPEN_CTREE_RECOVER_SUPER),
@@ -1260,13 +1268,18 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	if (ret)
 		goto out_chunk;
 
+	/* Chunk tree root is unable to read, return directly */
+	if (!fs_info->chunk_root)
+		return fs_info;
+
 	eb = fs_info->chunk_root->node;
 	read_extent_buffer(eb, fs_info->chunk_tree_uuid,
 			   btrfs_header_chunk_tree_uuid(eb),
 			   BTRFS_UUID_SIZE);
 
 	ret = btrfs_setup_all_roots(fs_info, root_tree_bytenr, flags);
-	if (ret && !(flags & __OPEN_CTREE_RETURN_CHUNK_ROOT))
+	if (ret && !(flags & __OPEN_CTREE_RETURN_CHUNK_ROOT) &&
+	    !fs_info->ignore_chunk_tree_error)
 		goto out_chunk;
 
 	return fs_info;
@@ -1308,6 +1321,8 @@ struct btrfs_root *open_ctree(const char *filename, u64 sb_bytenr,
 {
 	struct btrfs_fs_info *info;
 
+	/* This flags may not return fs_info with any valid root */
+	BUG_ON(flags & OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR);
 	info = open_ctree_fs_info(filename, sb_bytenr, 0, flags);
 	if (!info)
 		return NULL;
@@ -1320,6 +1335,9 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 				 enum btrfs_open_ctree_flags flags)
 {
 	struct btrfs_fs_info *info;
+
+	/* This flags may not return fs_info with any valid root */
+	BUG_ON(flags & OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR);
 	info = __open_ctree_fd(fp, path, sb_bytenr, 0, flags);
 	if (!info)
 		return NULL;
@@ -1658,14 +1676,15 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int close_ctree(struct btrfs_root *root)
+int close_ctree_fs_info(struct btrfs_fs_info *fs_info)
 {
 	int ret;
 	struct btrfs_trans_handle *trans;
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *root = fs_info->tree_root;
 
 	if (fs_info->last_trans_committed !=
 	    fs_info->generation) {
+		BUG_ON(!root);
 		trans = btrfs_start_transaction(root, 1);
 		btrfs_commit_transaction(trans, root);
 		trans = btrfs_start_transaction(root, 1);
diff --git a/disk-io.h b/disk-io.h
index d3e3aaa..c2eb1d6 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -53,7 +53,15 @@ enum btrfs_open_ctree_flags {
 	 * Like split PARTIAL into SKIP_CSUM/SKIP_EXTENT
 	 */
 
-	OPEN_CTREE_IGNORE_FSID_MISMATCH	= (1 << 10)
+	OPEN_CTREE_IGNORE_FSID_MISMATCH	= (1 << 10),
+
+	/*
+	 * Allow open_ctree_fs_info() to return a incomplete fs_info with
+	 * system chunks from super block only.
+	 * It's useful for chunk corruption case.
+	 * Makes no sense for open_ctree variants returning btrfs_root.
+	 */
+	OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR = (1 << 11)
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
@@ -101,7 +109,13 @@ struct btrfs_root *open_ctree_fd(int fp, const char *path, u64 sb_bytenr,
 struct btrfs_fs_info *open_ctree_fs_info(const char *filename,
 					 u64 sb_bytenr, u64 root_tree_bytenr,
 					 enum btrfs_open_ctree_flags flags);
-int close_ctree(struct btrfs_root *root);
+int close_ctree_fs_info(struct btrfs_fs_info *fs_info);
+static inline int close_ctree(struct btrfs_root *root)
+{
+	BUG_ON(!root);
+	return close_ctree_fs_info(root->fs_info);
+}
+
 int write_all_supers(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root);
-- 
2.7.1



