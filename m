Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17180 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752019AbdFMJTr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:47 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 06/19] btrfs-progs: Refactor write_tree_block to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:22 +0800
Message-ID: <20170613091935.23277-7-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c |  6 +++---
 disk-io.c   | 17 +++++++++--------
 disk-io.h   |  2 +-
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index b5a1c2fe..580fb401 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -111,7 +111,7 @@ static int change_header_uuid(struct btrfs_root *root, struct extent_buffer *eb)
 		write_extent_buffer(eb, fs_info->new_chunk_tree_uuid,
 				    btrfs_header_chunk_tree_uuid(eb),
 				    BTRFS_UUID_SIZE);
-	ret = write_tree_block(NULL, root, eb);
+	ret = write_tree_block(NULL, fs_info, eb);
 
 	return ret;
 }
@@ -193,7 +193,7 @@ static int change_device_uuid(struct btrfs_root *root, struct extent_buffer *eb,
 	write_extent_buffer(eb, fs_info->new_fsid,
 			    (unsigned long)btrfs_device_fsid(di),
 			    BTRFS_FSID_SIZE);
-	ret = write_tree_block(NULL, root, eb);
+	ret = write_tree_block(NULL, fs_info, eb);
 
 	return ret;
 }
@@ -251,7 +251,7 @@ static int change_fsid_prepare(struct btrfs_fs_info *fs_info)
 	write_extent_buffer(tree_root->node, fs_info->new_chunk_tree_uuid,
 			    btrfs_header_chunk_tree_uuid(tree_root->node),
 			    BTRFS_UUID_SIZE);
-	return write_tree_block(NULL, tree_root, tree_root->node);
+	return write_tree_block(NULL, fs_info, tree_root->node);
 }
 
 static int change_fsid_done(struct btrfs_fs_info *fs_info)
diff --git a/disk-io.c b/disk-io.c
index 88e7c3f7..9fccd75e 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -449,12 +449,12 @@ int write_and_map_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
 }
 
 int write_tree_block(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root,
+		     struct btrfs_fs_info *fs_info,
 		     struct extent_buffer *eb)
 {
-	if (check_tree_block(root->fs_info, eb)) {
-		print_tree_block_error(root->fs_info, eb,
-				check_tree_block(root->fs_info, eb));
+	if (check_tree_block(fs_info, eb)) {
+		print_tree_block_error(fs_info, eb,
+				check_tree_block(fs_info, eb));
 		BUG();
 	}
 
@@ -462,9 +462,9 @@ int write_tree_block(struct btrfs_trans_handle *trans,
 		BUG();
 
 	btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
-	csum_tree_block(root->fs_info, eb, 0);
+	csum_tree_block(fs_info, eb, 0);
 
-	return write_and_map_eb(root->fs_info, eb);
+	return write_and_map_eb(fs_info, eb);
 }
 
 void btrfs_setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
@@ -548,8 +548,9 @@ static int __commit_transaction(struct btrfs_trans_handle *trans,
 {
 	u64 start;
 	u64 end;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *eb;
-	struct extent_io_tree *tree = &root->fs_info->extent_cache;
+	struct extent_io_tree *tree = &fs_info->extent_cache;
 	int ret;
 
 	while(1) {
@@ -560,7 +561,7 @@ static int __commit_transaction(struct btrfs_trans_handle *trans,
 		while(start <= end) {
 			eb = find_first_extent_buffer(tree, start);
 			BUG_ON(!eb || eb->start != start);
-			ret = write_tree_block(trans, root, eb);
+			ret = write_tree_block(trans, fs_info, eb);
 			BUG_ON(ret);
 			start += eb->len;
 			clear_extent_buffer_dirty(eb);
diff --git a/disk-io.h b/disk-io.h
index 96133d32..601cd2c4 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -189,7 +189,7 @@ int csum_tree_block_size(struct extent_buffer *buf, u16 csum_sectorsize,
 int verify_tree_block_csum_silent(struct extent_buffer *buf, u16 csum_size);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
 int write_tree_block(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root,
+		     struct btrfs_fs_info *fs_info,
 		     struct extent_buffer *eb);
 int write_and_map_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb);
 
-- 
2.13.1



