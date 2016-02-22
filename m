Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30236 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbcBVHCP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 02:02:15 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/5] btrfs-progs: Add support for tree block operations on fs_info without roots.
Date: Mon, 22 Feb 2016 14:59:55 +0800
Message-Id: <1456124397-21403-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1456124397-21403-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since open_ctree_fs_info() now may return a fs_info even without any
roots, modify functions like read_tree_block() to operate with such
fs_info.

This provides the basis for btrfs-find-root to operate on chunk tree
corrupted fs.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c |  2 +-
 disk-io.c             | 70 +++++++++++++++++++++++++++++----------------------
 disk-io.h             | 17 ++++++++++---
 extent-tree.c         |  3 ++-
 volumes.c             |  3 ++-
 5 files changed, 58 insertions(+), 37 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index c908b7e..be5cd7e 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -45,7 +45,7 @@ static struct extent_buffer *debug_corrupt_block(struct btrfs_root *root,
 	int num_copies;
 	int mirror_num = 1;
 
-	eb = btrfs_find_create_tree_block(root, bytenr, blocksize);
+	eb = btrfs_find_create_tree_block(root->fs_info, bytenr, blocksize);
 	if (!eb)
 		return NULL;
 
diff --git a/disk-io.c b/disk-io.c
index 3b5a08e..51a4930 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -51,10 +51,12 @@ static u32 max_nritems(u8 level, u32 nodesize)
 		sizeof(struct btrfs_key_ptr));
 }
 
-static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
+static int check_tree_block(struct btrfs_fs_info *fs_info,
+			    struct extent_buffer *buf)
 {
 
 	struct btrfs_fs_devices *fs_devices;
+	u32 leafsize = btrfs_super_leafsize(fs_info->super_copy);
 	int ret = BTRFS_BAD_FSID;
 
 	if (buf->start != btrfs_header_bytenr(buf))
@@ -62,12 +64,12 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 	if (btrfs_header_level(buf) >= BTRFS_MAX_LEVEL)
 		return BTRFS_BAD_LEVEL;
 	if (btrfs_header_nritems(buf) > max_nritems(btrfs_header_level(buf),
-						    root->nodesize))
+						    leafsize))
 		return BTRFS_BAD_NRITEMS;
 
-	fs_devices = root->fs_info->fs_devices;
+	fs_devices = fs_info->fs_devices;
 	while (fs_devices) {
-		if (root->fs_info->ignore_fsid_mismatch ||
+		if (fs_info->ignore_fsid_mismatch ||
 		    !memcmp_extent_buffer(buf, fs_devices->fsid,
 					  btrfs_header_fsid(),
 					  BTRFS_FSID_SIZE)) {
@@ -79,7 +81,7 @@ static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 	return ret;
 }
 
-static void print_tree_block_error(struct btrfs_root *root,
+static void print_tree_block_error(struct btrfs_fs_info *fs_info,
 				struct extent_buffer *eb,
 				int err)
 {
@@ -92,7 +94,7 @@ static void print_tree_block_error(struct btrfs_root *root,
 		read_extent_buffer(eb, buf, btrfs_header_fsid(),
 				   BTRFS_UUID_SIZE);
 		uuid_unparse(buf, found_uuid);
-		uuid_unparse(root->fs_info->fsid, fs_uuid);
+		uuid_unparse(fs_info->fsid, fs_uuid);
 		fprintf(stderr, "fsid mismatch, want=%s, have=%s\n",
 			fs_uuid, found_uuid);
 		break;
@@ -157,16 +159,22 @@ int verify_tree_block_csum_silent(struct extent_buffer *buf, u16 csum_size)
 	return __csum_tree_block_size(buf, csum_size, 1, 1);
 }
 
-int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
-			   int verify)
+static int csum_tree_block_fs_info(struct btrfs_fs_info *fs_info,
+				   struct extent_buffer *buf, int verify)
 {
 	u16 csum_size =
-		btrfs_super_csum_size(root->fs_info->super_copy);
-	if (verify && root->fs_info->suppress_check_block_errors)
+		btrfs_super_csum_size(fs_info->super_copy);
+	if (verify && fs_info->suppress_check_block_errors)
 		return verify_tree_block_csum_silent(buf, csum_size);
 	return csum_tree_block_size(buf, csum_size, verify);
 }
 
+int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
+			   int verify)
+{
+	return csum_tree_block_fs_info(root->fs_info, buf, verify);
+}
+
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize)
 {
@@ -174,11 +182,11 @@ struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 				  bytenr, blocksize);
 }
 
-struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
-						 u64 bytenr, u32 blocksize)
+struct extent_buffer *
+btrfs_find_create_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
+			     u32 blocksize)
 {
-	return alloc_extent_buffer(&root->fs_info->extent_cache, bytenr,
-				   blocksize);
+	return alloc_extent_buffer(&fs_info->extent_cache, bytenr, blocksize);
 }
 
 void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
@@ -294,8 +302,9 @@ int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirr
 	return 0;
 }
 
-struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
-				     u32 blocksize, u64 parent_transid)
+struct extent_buffer *
+read_tree_block_fs_info(struct btrfs_fs_info *fs_info, u64 bytenr, u32 blocksize,
+			u64 parent_transid)
 {
 	int ret;
 	struct extent_buffer *eb;
@@ -305,7 +314,7 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	int num_copies;
 	int ignore = 0;
 
-	eb = btrfs_find_create_tree_block(root, bytenr, blocksize);
+	eb = btrfs_find_create_tree_block(fs_info, bytenr, blocksize);
 	if (!eb)
 		return ERR_PTR(-ENOMEM);
 
@@ -313,33 +322,33 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 		return eb;
 
 	while (1) {
-		ret = read_whole_eb(root->fs_info, eb, mirror_num);
-		if (ret == 0 && csum_tree_block(root, eb, 1) == 0 &&
-		    check_tree_block(root, eb) == 0 &&
+		ret = read_whole_eb(fs_info, eb, mirror_num);
+		if (ret == 0 && csum_tree_block_fs_info(fs_info, eb, 1) == 0 &&
+		    check_tree_block(fs_info, eb) == 0 &&
 		    verify_parent_transid(eb->tree, eb, parent_transid, ignore)
 		    == 0) {
 			if (eb->flags & EXTENT_BAD_TRANSID &&
 			    list_empty(&eb->recow)) {
 				list_add_tail(&eb->recow,
-					      &root->fs_info->recow_ebs);
+					      &fs_info->recow_ebs);
 				eb->refs++;
 			}
 			btrfs_set_buffer_uptodate(eb);
 			return eb;
 		}
 		if (ignore) {
-			if (check_tree_block(root, eb)) {
-				if (!root->fs_info->suppress_check_block_errors)
-					print_tree_block_error(root, eb,
-						check_tree_block(root, eb));
+			if (check_tree_block(fs_info, eb)) {
+				if (!fs_info->suppress_check_block_errors)
+					print_tree_block_error(fs_info, eb,
+						check_tree_block(fs_info, eb));
 			} else {
-				if (!root->fs_info->suppress_check_block_errors)
+				if (!fs_info->suppress_check_block_errors)
 					fprintf(stderr, "Csum didn't match\n");
 			}
 			ret = -EIO;
 			break;
 		}
-		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
+		num_copies = btrfs_num_copies(&fs_info->mapping_tree,
 					      eb->start, eb->len);
 		if (num_copies == 1) {
 			ignore = 1;
@@ -431,8 +440,9 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 		     struct btrfs_root *root,
 		     struct extent_buffer *eb)
 {
-	if (check_tree_block(root, eb)) {
-		print_tree_block_error(root, eb, check_tree_block(root, eb));
+	if (check_tree_block(root->fs_info, eb)) {
+		print_tree_block_error(root->fs_info, eb,
+				check_tree_block(root->fs_info, eb));
 		BUG();
 	}
 
@@ -938,7 +948,7 @@ static int setup_root_or_create_block(struct btrfs_fs_info *fs_info,
 		 * million of places that assume a root has a valid ->node
 		 */
 		info_root->node =
-			btrfs_find_create_tree_block(info_root, 0, leafsize);
+			btrfs_find_create_tree_block(fs_info, 0, leafsize);
 		if (!info_root->node)
 			return -ENOMEM;
 		clear_extent_buffer_uptodate(NULL, info_root->node);
diff --git a/disk-io.h b/disk-io.h
index c2eb1d6..d12e222 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -75,14 +75,23 @@ static inline u64 btrfs_sb_offset(int mirror)
 struct btrfs_device;
 
 int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirror);
-struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
-				      u32 blocksize, u64 parent_transid);
+struct extent_buffer *
+read_tree_block_fs_info(struct btrfs_fs_info *fs_info, u64 bytenr, u32 blocksize,
+			u64 parent_transid);
+static inline struct extent_buffer *
+read_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
+		u64 parent_transid)
+{
+	return read_tree_block_fs_info(root->fs_info, bytenr, blocksize,
+			parent_transid);
+}
 int read_extent_data(struct btrfs_root *root, char *data, u64 logical,
 		     u64 *len, int mirror);
 void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			  u64 parent_transid);
-struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
-						   u64 bytenr, u32 blocksize);
+struct extent_buffer *
+btrfs_find_create_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
+			     u32 blocksize);
 
 int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
                         u32 stripesize, struct btrfs_root *root,
diff --git a/extent-tree.c b/extent-tree.c
index 1650bdb..b9b00f0 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2822,7 +2822,8 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 		return ERR_PTR(ret);
 	}
 
-	buf = btrfs_find_create_tree_block(root, ins.objectid, blocksize);
+	buf = btrfs_find_create_tree_block(root->fs_info, ins.objectid,
+					   blocksize);
 	if (!buf) {
 		btrfs_free_extent(trans, root, ins.objectid, ins.offset,
 				  0, root->root_key.objectid, level, 0);
diff --git a/volumes.c b/volumes.c
index 059c4f4..cc3e6b7 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1840,7 +1840,8 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	u32 cur_offset;
 	struct btrfs_key key;
 
-	sb = btrfs_find_create_tree_block(root, BTRFS_SUPER_INFO_OFFSET,
+	sb = btrfs_find_create_tree_block(root->fs_info,
+					  BTRFS_SUPER_INFO_OFFSET,
 					  BTRFS_SUPER_INFO_SIZE);
 	if (!sb)
 		return -ENOMEM;
-- 
2.7.1



