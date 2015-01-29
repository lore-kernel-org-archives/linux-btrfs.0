Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26427 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760560AbbA2JI3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:29 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0T97lZJ026093
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Jan 2015 17:07:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 02/10] btrfs-progs: Add support to suppress tree block csum error output.
Date: Thu, 29 Jan 2015 17:07:17 +0800
Message-ID: <1422522437-18886-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1422522437-18886-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1422522437-18886-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add new open ctree flag OPEN_CTREE_SUPPRESS_ERROR to suppress tree block
csum error output.

Provides the basis for new btrfs-find-root and other enhancement on
btrfs offline tools output.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
changelog:
v2:
  None
v3:
  Use 'suppress_tree_error' to replace the old name 'suppress_error' to
  avoid confusion.
---
 ctree.h   |  2 ++
 disk-io.c | 19 +++++++++++++------
 disk-io.h |  2 ++
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/ctree.h b/ctree.h
index c069a95..494c9ac 100644
--- a/ctree.h
+++ b/ctree.h
@@ -996,6 +996,7 @@ struct btrfs_fs_info {
 	unsigned int on_restoring:1;
 	unsigned int is_chunk_recover:1;
 	unsigned int quota_enabled:1;
+	unsigned int suppress_tree_err:1;
 
 	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -1004,6 +1005,7 @@ struct btrfs_fs_info {
 				int refs_to_drop);
 	struct cache_tree *fsck_extent_cache;
 	struct cache_tree *corrupt_blocks;
+
 };
 
 /*
diff --git a/disk-io.c b/disk-io.c
index e14a143..3291071 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -141,6 +141,8 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 {
 	u16 csum_size =
 		btrfs_super_csum_size(root->fs_info->super_copy);
+	if (verify && root->fs_info->suppress_tree_err)
+		return verify_tree_block_csum_silent(buf, csum_size);
 	return csum_tree_block_size(buf, csum_size, verify);
 }
 
@@ -291,8 +293,8 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 
 	while (1) {
 		ret = read_whole_eb(root->fs_info, eb, mirror_num);
-		if (ret == 0 && check_tree_block(root, eb) == 0 &&
-		    csum_tree_block(root, eb, 1) == 0 &&
+		if (ret == 0 && csum_tree_block(root, eb, 1) == 0 &&
+		    check_tree_block(root, eb) == 0 &&
 		    verify_parent_transid(eb->tree, eb, parent_transid, ignore)
 		    == 0) {
 			if (eb->flags & EXTENT_BAD_TRANSID &&
@@ -305,11 +307,14 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 			return eb;
 		}
 		if (ignore) {
-			if (check_tree_block(root, eb))
-				print_tree_block_err(root, eb,
+			if (check_tree_block(root, eb)) {
+				if (!root->fs_info->suppress_tree_err)
+					print_tree_block_err(root, eb,
 						check_tree_block(root, eb));
-			else
-				printk("Csum didn't match\n");
+			} else {
+				if (!root->fs_info->suppress_tree_err)
+					fprintf(stderr, "Csum didn't match\n");
+			}
 			break;
 		}
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
@@ -1138,6 +1143,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 	if (flags & OPEN_CTREE_RESTORE)
 		fs_info->on_restoring = 1;
+	if (flags & OPEN_CTREE_SUPPRESS_ERROR)
+		fs_info->suppress_tree_err = 1;
 
 	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
 				    (flags & OPEN_CTREE_RECOVER_SUPER));
diff --git a/disk-io.h b/disk-io.h
index f963a96..84f878a 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -33,6 +33,8 @@ enum btrfs_open_ctree_flags {
 	OPEN_CTREE_RESTORE		= (1 << 4),
 	OPEN_CTREE_NO_BLOCK_GROUPS	= (1 << 5),
 	OPEN_CTREE_EXCLUSIVE		= (1 << 6),
+	OPEN_CTREE_SUPPRESS_ERROR	= (1 << 7), /* Suppress tree block
+						       check error */
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
-- 
2.2.2

