Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43366 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932198AbdERDja (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:30 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 30/32] btrfs-progs: Refactor btrfs_root paramters in btrfs-corrupt-block.c
Date: Thu, 18 May 2017 11:38:55 +0800
Message-ID: <20170518033857.15002-31-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Refactor the following functions and its callers to get rid of
incorrectly passed btrfs_root parameters:

1) corrupt_keys()
2) corrupt_metadata_block()

The only reason passing btrfs_root for them is to get block sizes.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-corrupt-block.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 20a4c1df..5649a00e 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -126,7 +126,7 @@ static void print_usage(int ret)
 }
 
 static void corrupt_keys(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root,
+			 struct btrfs_fs_info *fs_info,
 			 struct extent_buffer *eb)
 {
 	int slot;
@@ -158,22 +158,22 @@ static void corrupt_keys(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(eb);
 	if (!trans) {
 		u16 csum_size =
-			btrfs_super_csum_size(root->fs_info->super_copy);
+			btrfs_super_csum_size(fs_info->super_copy);
 		csum_tree_block_size(eb, csum_size, 0);
 		write_extent_to_disk(eb);
 	}
 }
 
 
-static int corrupt_keys_in_block(struct btrfs_root *root, u64 bytenr)
+static int corrupt_keys_in_block(struct btrfs_fs_info *fs_info, u64 bytenr)
 {
 	struct extent_buffer *eb;
 
-	eb = read_tree_block(root, bytenr, root->fs_info->nodesize, 0);
+	eb = read_tree_block_fs_info(fs_info, bytenr, fs_info->nodesize, 0);
 	if (!extent_buffer_uptodate(eb))
 		return -EIO;;
 
-	corrupt_keys(NULL, root, eb);
+	corrupt_keys(NULL, fs_info, eb);
 	free_extent_buffer(eb);
 	return 0;
 }
@@ -745,10 +745,11 @@ static void shift_items(struct btrfs_root *root, struct extent_buffer *eb)
 	}
 }
 
-static int corrupt_metadata_block(struct btrfs_root *root, u64 block,
+static int corrupt_metadata_block(struct btrfs_fs_info *fs_info, u64 block,
 				  char *field)
 {
 	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root;
 	struct btrfs_path *path;
 	struct extent_buffer *eb;
 	struct btrfs_key key, root_key;
@@ -764,7 +765,7 @@ static int corrupt_metadata_block(struct btrfs_root *root, u64 block,
 		return -EINVAL;
 	}
 
-	eb = read_tree_block(root, block, root->fs_info->nodesize, 0);
+	eb = read_tree_block_fs_info(fs_info, block, fs_info->nodesize, 0);
 	if (!extent_buffer_uptodate(eb)) {
 		fprintf(stderr, "Couldn't read in tree block %s\n", field);
 		return -EINVAL;
@@ -781,7 +782,7 @@ static int corrupt_metadata_block(struct btrfs_root *root, u64 block,
 	root_key.type = BTRFS_ROOT_ITEM_KEY;
 	root_key.offset = (u64)-1;
 
-	root = btrfs_read_fs_root(root->fs_info, &root_key);
+	root = btrfs_read_fs_root(fs_info, &root_key);
 	if (IS_ERR(root)) {
 		fprintf(stderr, "Couldn't find owner root %llu\n",
 			key.objectid);
@@ -1295,7 +1296,8 @@ int main(int argc, char **argv)
 	if (metadata_block) {
 		if (*field == 0)
 			print_usage(1);
-		ret = corrupt_metadata_block(root, metadata_block, field);
+		ret = corrupt_metadata_block(root->fs_info, metadata_block,
+					     field);
 		goto out_close;
 	}
 	if (corrupt_di) {
@@ -1358,7 +1360,7 @@ int main(int argc, char **argv)
 
 	while (bytes > 0) {
 		if (corrupt_block_keys) {
-			corrupt_keys_in_block(root, logical);
+			corrupt_keys_in_block(root->fs_info, logical);
 		} else {
 			struct extent_buffer *eb;
 
-- 
2.13.0



