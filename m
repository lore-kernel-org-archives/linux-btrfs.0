Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60017 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751430AbbASGrU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 01:47:20 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0J6keEY022559
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 14:46:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 02/10] btrfs-progs: Add support to suppress tree block csum error output.
Date: Mon, 19 Jan 2015 14:45:04 +0800
Message-ID: <1421649912-14539-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
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
 ctree.h   |  2 ++
 disk-io.c | 18 +++++++++++++-----
 disk-io.h |  1 +
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/ctree.h b/ctree.h
index 7861940..805b64e 100644
--- a/ctree.h
+++ b/ctree.h
@@ -996,6 +996,7 @@ struct btrfs_fs_info {
 	unsigned int on_restoring:1;
 	unsigned int is_chunk_recover:1;
 	unsigned int quota_enabled:1;
+	unsigned int suppress_error:1;
 
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
index b853f66..f08f612 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -42,7 +42,8 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 	struct btrfs_fs_devices *fs_devices;
 	int ret = 1;
 
-	if (buf->start != btrfs_header_bytenr(buf)) {
+	if (buf->start != btrfs_header_bytenr(buf) &&
+	    !root->fs_info->suppress_error) {
 		printk("Check tree block failed, want=%Lu, have=%Lu\n",
 		       buf->start, btrfs_header_bytenr(buf));
 		return ret;
@@ -118,6 +119,8 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 {
 	u16 csum_size =
 		btrfs_super_csum_size(root->fs_info->super_copy);
+	if (verify && root->fs_info->suppress_error)
+		return verify_tree_block_csum_silent(buf, csum_size);
 	return csum_tree_block_size(buf, csum_size, verify);
 }
 
@@ -282,10 +285,13 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 			return eb;
 		}
 		if (ignore) {
-			if (check_tree_block(root, eb))
-				printk("read block failed check_tree_block\n");
-			else
-				printk("Csum didn't match\n");
+			if (check_tree_block(root, eb)) {
+				if (!root->fs_info->suppress_error)
+					printk("read block failed check_tree_block\n");
+			} else {
+				if (!root->fs_info->suppress_error)
+					printk("Csum didn't match\n");
+			}
 			break;
 		}
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
@@ -1112,6 +1118,8 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 	if (flags & OPEN_CTREE_RESTORE)
 		fs_info->on_restoring = 1;
+	if (flags & OPEN_CTREE_SUPPRESS_ERROR)
+		fs_info->suppress_error = 1;
 
 	ret = btrfs_scan_fs_devices(fp, path, &fs_devices, sb_bytenr,
 				    (flags & OPEN_CTREE_RECOVER_SUPER));
diff --git a/disk-io.h b/disk-io.h
index e12870e..90ede6b 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -33,6 +33,7 @@ enum btrfs_open_ctree_flags {
 	OPEN_CTREE_RESTORE		= (1 << 4),
 	OPEN_CTREE_NO_BLOCK_GROUPS	= (1 << 5),
 	OPEN_CTREE_EXCLUSIVE		= (1 << 6),
+	OPEN_CTREE_SUPPRESS_ERROR	= (1 << 7), /* Suppress csum error */
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
-- 
2.2.2

