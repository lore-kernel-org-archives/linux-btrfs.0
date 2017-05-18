Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46077 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932161AbdERDjV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:21 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 11/32] btrfs-progs: Refactor nodesize users in image/main.c
Date: Thu, 18 May 2017 11:38:36 +0800
Message-ID: <20170518033857.15002-12-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 image/main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/image/main.c b/image/main.c
index f1c28de1..6a4ccfaf 100644
--- a/image/main.c
+++ b/image/main.c
@@ -919,7 +919,7 @@ static int flush_pending(struct metadump_struct *md, int done)
 {
 	struct async_work *async = NULL;
 	struct extent_buffer *eb;
-	u64 blocksize = md->root->nodesize;
+	u64 blocksize = md->root->fs_info->nodesize;
 	u64 start = 0;
 	u64 size;
 	size_t offset;
@@ -1083,7 +1083,8 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 	int i = 0;
 	int ret;
 
-	ret = add_extent(btrfs_header_bytenr(eb), root->nodesize, metadump, 0);
+	ret = add_extent(btrfs_header_bytenr(eb), root->fs_info->nodesize,
+			 metadump, 0);
 	if (ret) {
 		error("unable to add metadata block %llu: %d",
 				btrfs_header_bytenr(eb), ret);
@@ -1102,7 +1103,8 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 				continue;
 			ri = btrfs_item_ptr(eb, i, struct btrfs_root_item);
 			bytenr = btrfs_disk_root_bytenr(eb, ri);
-			tmp = read_tree_block(root, bytenr, root->nodesize, 0);
+			tmp = read_tree_block(root, bytenr,
+					      root->fs_info->nodesize, 0);
 			if (!extent_buffer_uptodate(tmp)) {
 				error("unable to read log root block");
 				return -EIO;
@@ -1113,7 +1115,8 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 				return ret;
 		} else {
 			bytenr = btrfs_node_blockptr(eb, i);
-			tmp = read_tree_block(root, bytenr, root->nodesize, 0);
+			tmp = read_tree_block(root, bytenr,
+					      root->fs_info->nodesize, 0);
 			if (!extent_buffer_uptodate(tmp)) {
 				error("unable to read log root block");
 				return -EIO;
@@ -1260,7 +1263,7 @@ static int copy_from_extent_tree(struct metadump_struct *metadump,
 
 		bytenr = key.objectid;
 		if (key.type == BTRFS_METADATA_ITEM_KEY) {
-			num_bytes = extent_root->nodesize;
+			num_bytes = extent_root->fs_info->nodesize;
 		} else {
 			num_bytes = key.offset;
 		}
-- 
2.13.0



