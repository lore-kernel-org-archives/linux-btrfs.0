Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29819 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752549AbdFMJTu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:50 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 08/19] btrfs-progs: Refactor read_extent_data to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:24 +0800
Message-ID: <20170613091935.23277-9-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-map-logical.c |  2 +-
 cmds-check.c        | 18 ++++++++++--------
 disk-io.c           |  8 ++++----
 disk-io.h           |  2 +-
 file.c              | 15 ++++++++-------
 image/main.c        |  3 ++-
 6 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index d752cf6a..9d049955 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -169,7 +169,7 @@ static int write_extent_content(struct btrfs_fs_info *fs_info, int out_fd,
 
 	while (cur_offset < length) {
 		cur_len = min_t(u64, length - cur_offset, BUFFER_SIZE);
-		ret = read_extent_data(fs_info->tree_root, buffer,
+		ret = read_extent_data(fs_info, buffer,
 				       logical + cur_offset, &cur_len, mirror);
 		if (ret < 0) {
 			fprintf(stderr,
diff --git a/cmds-check.c b/cmds-check.c
index 39a36662..fb4b468d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -7169,8 +7169,9 @@ static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 			u64 num_bytes, unsigned long leaf_offset,
 			struct extent_buffer *eb) {
 
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 offset = 0;
-	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
 	char *data;
 	unsigned long csum_offset;
 	u32 csum;
@@ -7182,7 +7183,7 @@ static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 	int mirror;
 	int num_copies;
 
-	if (num_bytes % root->fs_info->sectorsize)
+	if (num_bytes % fs_info->sectorsize)
 		return -EINVAL;
 
 	data = malloc(num_bytes);
@@ -7194,7 +7195,7 @@ static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
 again:
 		read_len = num_bytes - offset;
 		/* read as much space once a time */
-		ret = read_extent_data(root, data + offset,
+		ret = read_extent_data(fs_info, data + offset,
 				bytenr + offset, &read_len, mirror);
 		if (ret)
 			goto out;
@@ -7205,11 +7206,11 @@ again:
 			tmp = offset + data_checked;
 
 			csum = btrfs_csum_data((char *)data + tmp,
-					       csum, root->fs_info->sectorsize);
+					       csum, fs_info->sectorsize);
 			btrfs_csum_final(csum, (u8 *)&csum);
 
 			csum_offset = leaf_offset +
-				 tmp / root->fs_info->sectorsize * csum_size;
+				 tmp / fs_info->sectorsize * csum_size;
 			read_extent_buffer(eb, (char *)&csum_expected,
 					   csum_offset, csum_size);
 			/* try another mirror */
@@ -7224,7 +7225,7 @@ again:
 					goto again;
 				}
 			}
-			data_checked += root->fs_info->sectorsize;
+			data_checked += fs_info->sectorsize;
 		}
 		offset += read_len;
 	}
@@ -12083,13 +12084,14 @@ static int populate_csum(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *csum_root, char *buf, u64 start,
 			 u64 len)
 {
+	struct btrfs_fs_info *fs_info = csum_root->fs_info;
 	u64 offset = 0;
 	u64 sectorsize;
 	int ret = 0;
 
 	while (offset < len) {
-		sectorsize = csum_root->fs_info->sectorsize;
-		ret = read_extent_data(csum_root, buf, start + offset,
+		sectorsize = fs_info->sectorsize;
+		ret = read_extent_data(fs_info, buf, start + offset,
 				       &sectorsize, 0);
 		if (ret)
 			break;
diff --git a/disk-io.c b/disk-io.c
index 9fccd75e..8b5139f5 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -384,17 +384,17 @@ struct extent_buffer* read_tree_block(
 	return ERR_PTR(ret);
 }
 
-int read_extent_data(struct btrfs_root *root, char *data,
-			   u64 logical, u64 *len, int mirror)
+int read_extent_data(struct btrfs_fs_info *fs_info, char *data, u64 logical,
+		     u64 *len, int mirror)
 {
 	u64 offset = 0;
 	struct btrfs_multi_bio *multi = NULL;
-	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_device *device;
 	int ret = 0;
 	u64 max_len = *len;
 
-	ret = btrfs_map_block(info, READ, logical, len, &multi, mirror, NULL);
+	ret = btrfs_map_block(fs_info, READ, logical, len, &multi, mirror,
+			      NULL);
 	if (ret) {
 		fprintf(stderr, "Couldn't map the block %llu\n",
 				logical + offset);
diff --git a/disk-io.h b/disk-io.h
index 601cd2c4..97a74993 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -119,7 +119,7 @@ struct extent_buffer* read_tree_block(
 		struct btrfs_fs_info *fs_info, u64 bytenr, u32 blocksize,
 		u64 parent_transid);
 
-int read_extent_data(struct btrfs_root *root, char *data, u64 logical,
+int read_extent_data(struct btrfs_fs_info *fs_info, char *data, u64 logical,
 		     u64 *len, int mirror);
 void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			  u64 parent_transid);
diff --git a/file.c b/file.c
index 028bfba8..f5e645c4 100644
--- a/file.c
+++ b/file.c
@@ -183,20 +183,21 @@ out:
 int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 		    char *dest)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key key;
 	struct btrfs_path path;
 	struct extent_buffer *leaf;
 	struct btrfs_inode_item *ii;
 	u64 isize;
-	int no_holes = btrfs_fs_incompat(root->fs_info, NO_HOLES);
+	int no_holes = btrfs_fs_incompat(fs_info, NO_HOLES);
 	int slot;
 	int read = 0;
 	int ret;
 
-	if (!IS_ALIGNED(start, root->fs_info->sectorsize) ||
-	    !IS_ALIGNED(len, root->fs_info->sectorsize)) {
+	if (!IS_ALIGNED(start, fs_info->sectorsize) ||
+	    !IS_ALIGNED(len, fs_info->sectorsize)) {
 		warning("@start and @len must be aligned to %u for function %s",
-			root->fs_info->sectorsize, __func__);
+			fs_info->sectorsize, __func__);
 		return -EINVAL;
 	}
 
@@ -260,7 +261,7 @@ int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 				goto next;
 			read_extent_buffer(leaf, dest,
 				btrfs_file_extent_inline_start(fi), extent_len);
-			read += round_up(extent_len, root->fs_info->sectorsize);
+			read += round_up(extent_len, fs_info->sectorsize);
 			break;
 		}
 
@@ -283,7 +284,7 @@ int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
 		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi) +
 			      btrfs_file_extent_offset(leaf, fi);
 		read_len_ret = read_len;
-		ret = read_extent_data(root, dest + read_start - start, disk_bytenr,
+		ret = read_extent_data(fs_info, dest + read_start - start, disk_bytenr,
 				       &read_len_ret, 0);
 		if (ret < 0)
 			break;
@@ -319,7 +320,7 @@ next:
 		ii = btrfs_item_ptr(path.nodes[0], path.slots[0],
 				    struct btrfs_inode_item);
 		isize = round_up(btrfs_inode_size(path.nodes[0], ii),
-				 root->fs_info->sectorsize);
+				 fs_info->sectorsize);
 		read = min_t(u64, isize - start, len);
 	}
 out:
diff --git a/image/main.c b/image/main.c
index a84b10ed..e49430db 100644
--- a/image/main.c
+++ b/image/main.c
@@ -876,6 +876,7 @@ static int read_data_extent(struct metadump_struct *md,
 			    struct async_work *async)
 {
 	struct btrfs_root *root = md->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 bytes_left = async->size;
 	u64 logical = async->start;
 	u64 offset = 0;
@@ -890,7 +891,7 @@ static int read_data_extent(struct metadump_struct *md,
 	for (cur_mirror = 0; cur_mirror < num_copies; cur_mirror++) {
 		while (bytes_left) {
 			read_len = bytes_left;
-			ret = read_extent_data(root,
+			ret = read_extent_data(fs_info,
 					(char *)(async->buffer + offset),
 					logical, &read_len, cur_mirror);
 			if (ret < 0)
-- 
2.13.1



