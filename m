Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29819 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752539AbdFMJTp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:45 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 04/19] btrfs-progs: Refactor csum_tree_block to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:20 +0800
Message-ID: <20170613091935.23277-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 disk-io.c | 14 ++++----------
 utils.h   |  4 ++--
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 9d2408c2..bf00e195 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -164,8 +164,8 @@ int verify_tree_block_csum_silent(struct extent_buffer *buf, u16 csum_size)
 	return __csum_tree_block_size(buf, csum_size, 1, 1);
 }
 
-static int csum_tree_block_fs_info(struct btrfs_fs_info *fs_info,
-				   struct extent_buffer *buf, int verify)
+int csum_tree_block(struct btrfs_fs_info *fs_info,
+		    struct extent_buffer *buf, int verify)
 {
 	u16 csum_size =
 		btrfs_super_csum_size(fs_info->super_copy);
@@ -174,12 +174,6 @@ static int csum_tree_block_fs_info(struct btrfs_fs_info *fs_info,
 	return csum_tree_block_size(buf, csum_size, verify);
 }
 
-int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
-			   int verify)
-{
-	return csum_tree_block_fs_info(root->fs_info, buf, verify);
-}
-
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize)
 {
@@ -345,7 +339,7 @@ struct extent_buffer* read_tree_block(
 
 	while (1) {
 		ret = read_whole_eb(fs_info, eb, mirror_num);
-		if (ret == 0 && csum_tree_block_fs_info(fs_info, eb, 1) == 0 &&
+		if (ret == 0 && csum_tree_block(fs_info, eb, 1) == 0 &&
 		    check_tree_block(fs_info, eb) == 0 &&
 		    verify_parent_transid(eb->tree, eb, parent_transid, ignore)
 		    == 0) {
@@ -468,7 +462,7 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 		BUG();
 
 	btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
-	csum_tree_block(root, eb, 0);
+	csum_tree_block(root->fs_info, eb, 0);
 
 	return write_and_map_eb(root, eb);
 }
diff --git a/utils.h b/utils.h
index 24d0a200..bf8eb1ed 100644
--- a/utils.h
+++ b/utils.h
@@ -115,8 +115,8 @@ u64 btrfs_device_size(int fd, struct stat *st);
 int get_label_mounted(const char *mount_path, char *labelp);
 int get_label_unmounted(const char *dev, char *label);
 int group_profile_max_safe_loss(u64 flags);
-int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
-			   int verify);
+int csum_tree_block(struct btrfs_fs_info *root, struct extent_buffer *buf,
+		    int verify);
 int ask_user(const char *question);
 int lookup_path_rootid(int fd, u64 *rootid);
 int btrfs_scan_devices(void);
-- 
2.13.1



