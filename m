Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29819 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752539AbdFMJTs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:48 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 02/19] btrfs-progs: Refactor btrfs_num_copies to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:18 +0800
Message-ID: <20170613091935.23277-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 4 ++--
 btrfs-map-logical.c   | 2 +-
 cmds-check.c          | 3 +--
 cmds-restore.c        | 6 ++----
 disk-io.c             | 3 +--
 image/main.c          | 3 +--
 volumes.c             | 3 ++-
 volumes.h             | 2 +-
 8 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 01bd1f2f..3269de5c 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -88,8 +88,8 @@ static int debug_corrupt_block(struct extent_buffer *eb,
 			fsync(eb->fd);
 		}
 
-		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
-					      eb->start, eb->len);
+		num_copies = btrfs_num_copies(root->fs_info, eb->start,
+					      eb->len);
 		if (num_copies == 1)
 			break;
 
diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index c56253cd..d752cf6a 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -149,7 +149,7 @@ static int print_mapping_info(struct btrfs_fs_info *fs_info, u64 logical,
 	int mirror_num;
 	int ret = 0;
 
-	num_copies = btrfs_num_copies(&fs_info->mapping_tree, logical, len);
+	num_copies = btrfs_num_copies(fs_info, logical, len);
 	for (mirror_num = 1; mirror_num <= num_copies; mirror_num++) {
 		ret = __print_mapping_info(fs_info, logical, len, mirror_num);
 		if (ret < 0)
diff --git a/cmds-check.c b/cmds-check.c
index 60640bc8..39a36662 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7217,8 +7217,7 @@ again:
 				fprintf(stderr, "mirror %d bytenr %llu csum %u expected csum %u\n",
 						mirror, bytenr + tmp,
 						csum, csum_expected);
-				num_copies = btrfs_num_copies(
-						&root->fs_info->mapping_tree,
+				num_copies = btrfs_num_copies(root->fs_info,
 						bytenr, num_bytes);
 				if (mirror < num_copies - 1) {
 					mirror += 1;
diff --git a/cmds-restore.c b/cmds-restore.c
index 9ee38c70..c174bdd5 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -366,8 +366,7 @@ again:
 	done = pread(dev_fd, inbuf+count, length, dev_bytenr);
 	/* Need both checks, or we miss negative values due to u64 conversion */
 	if (done < 0 || done < length) {
-		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
-					      bytenr, length);
+		num_copies = btrfs_num_copies(root->fs_info, bytenr, length);
 		mirror_num++;
 		/* mirror_num is 1-indexed, so num_copies is a valid mirror. */
 		if (mirror_num > num_copies) {
@@ -404,8 +403,7 @@ again:
 
 	ret = decompress(root, inbuf, outbuf, disk_size, &ram_size, compress);
 	if (ret) {
-		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
-					      bytenr, length);
+		num_copies = btrfs_num_copies(root->fs_info, bytenr, length);
 		mirror_num++;
 		if (mirror_num >= num_copies) {
 			ret = -1;
diff --git a/disk-io.c b/disk-io.c
index 32e2d267..9d2408c2 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -370,8 +370,7 @@ struct extent_buffer* read_tree_block(
 			ret = -EIO;
 			break;
 		}
-		num_copies = btrfs_num_copies(&fs_info->mapping_tree,
-					      eb->start, eb->len);
+		num_copies = btrfs_num_copies(fs_info, eb->start, eb->len);
 		if (num_copies == 1) {
 			ignore = 1;
 			continue;
diff --git a/image/main.c b/image/main.c
index 5fb62e77..a84b10ed 100644
--- a/image/main.c
+++ b/image/main.c
@@ -884,8 +884,7 @@ static int read_data_extent(struct metadump_struct *md,
 	int cur_mirror;
 	int ret;
 
-	num_copies = btrfs_num_copies(&root->fs_info->mapping_tree, logical,
-				      bytes_left);
+	num_copies = btrfs_num_copies(root->fs_info, logical, bytes_left);
 
 	/* Try our best to read data, just like read_tree_block() */
 	for (cur_mirror = 0; cur_mirror < num_copies; cur_mirror++) {
diff --git a/volumes.c b/volumes.c
index 1ff90f0c..89e39e43 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1215,8 +1215,9 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
+int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 {
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct cache_extent *ce;
 	struct map_lookup *map;
 	int ret;
diff --git a/volumes.h b/volumes.h
index 59e43161..26d88813 100644
--- a/volumes.h
+++ b/volumes.h
@@ -228,7 +228,7 @@ int btrfs_update_device(struct btrfs_trans_handle *trans,
 int btrfs_scan_one_device(int fd, const char *path,
 			  struct btrfs_fs_devices **fs_devices_ret,
 			  u64 *total_devs, u64 super_offset, unsigned sbflags);
-int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len);
+int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 struct list_head *btrfs_scanned_uuids(void);
 int btrfs_add_system_chunk(struct btrfs_root *root, struct btrfs_key *key,
 			   struct btrfs_chunk *chunk, int item_size);
-- 
2.13.1



