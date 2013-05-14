Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23646 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab3ENLu0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 07:50:26 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r4EBoPrO004031
	for <linux-btrfs@vger.kernel.org>; Tue, 14 May 2013 19:50:25 +0800
Message-ID: <51922504.4020505@cn.fujitsu.com>
Date: Tue, 14 May 2013 19:50:28 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix missing recow roots when making btrfs filesystem
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When making btrfs filesystem. we firstly write root leaf to
specified filed, and then we recow the root. If we don't recow,
some trees are not in the correct block group.

Steps to reproduce:
	dd if=/dev/zero of=test.img bs=1M count=100
	mkfs.btrfs -f test.img
	btrfs-debug-tree test.img

extent tree key (EXTENT_TREE ROOT_ITEM 0) 
leaf 4210688 items 10 free space 3349 generation 4 owner 2
fs uuid 2e08fd93-f24d-4f44-a226-e2116fcd544f
chunk uuid dc482988-6246-46ce-9329-68bcf6d3683c
	item 0 key (0 BLOCK_GROUP_ITEM 4194304) itemoff 3971 itemsize 24
		block group used 12288 chunk_objectid 256 flags 2
	[..snip..]
	item 3 key (1138688 EXTENT_ITEM 4096) itemoff 3827 itemsize 42
		extent refs 1 gen 1 flags 2
		tree block key (0 UNKNOWN.0 0) level 0
	item 4 key (1138688 TREE_BLOCK_REF 7) itemoff 3827 itemsize 0
		tree block backref
	[..snip..]

checksum tree key (CSUM_TREE ROOT_ITEM 0) 
leaf 1138688 items 0 free space 3995 generation 1 owner 7
fs uuid 2e08fd93-f24d-4f44-a226-e2116fcd544f
chunk uuid dc482988-6246-46ce-9329-68bcf6d3683c

For the above example, csum root leaf comes into system block group which
is wrong,csum root leaf should be in metadata block group.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 mkfs.c | 71 ++++++++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 26 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 7ff60e5..9cd93e4 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -151,37 +151,55 @@ static int recow_roots(struct btrfs_trans_handle *trans,
 	int ret;
 	struct extent_buffer *tmp;
 	struct btrfs_fs_info *info = root->fs_info;
+	u64 generation;
 
-	ret = __btrfs_cow_block(trans, info->fs_root, info->fs_root->node,
-				NULL, 0, &tmp, 0, 0);
-	BUG_ON(ret);
-	free_extent_buffer(tmp);
+	generation = btrfs_root_generation(&info->fs_root->root_item);
+	if (generation != trans->transid) {
+		ret = __btrfs_cow_block(trans, info->fs_root,
+				info->fs_root->node, NULL, 0, &tmp, 0, 0);
+		BUG_ON(ret);
+		free_extent_buffer(tmp);
+	}
 
-	ret = __btrfs_cow_block(trans, info->tree_root, info->tree_root->node,
-				NULL, 0, &tmp, 0, 0);
-	BUG_ON(ret);
-	free_extent_buffer(tmp);
+	generation = btrfs_root_generation(&info->tree_root->root_item);
+	if (generation != trans->transid) {
+		ret = __btrfs_cow_block(trans, info->tree_root,
+				info->tree_root->node, NULL, 0, &tmp, 0, 0);
+		BUG_ON(ret);
+		free_extent_buffer(tmp);
+	}
 
-	ret = __btrfs_cow_block(trans, info->extent_root,
+	generation = btrfs_root_generation(&info->extent_root->root_item);
+	if (generation != trans->transid) {
+		ret = __btrfs_cow_block(trans, info->extent_root,
 				info->extent_root->node, NULL, 0, &tmp, 0, 0);
-	BUG_ON(ret);
-	free_extent_buffer(tmp);
-
-	ret = __btrfs_cow_block(trans, info->chunk_root, info->chunk_root->node,
-				NULL, 0, &tmp, 0, 0);
-	BUG_ON(ret);
-	free_extent_buffer(tmp);
+		BUG_ON(ret);
+		free_extent_buffer(tmp);
+	}
 
+	generation = btrfs_root_generation(&info->chunk_root->root_item);
+	if (generation != trans->transid) {
+		ret = __btrfs_cow_block(trans, info->chunk_root,
+				info->chunk_root->node, NULL, 0, &tmp, 0, 0);
+		BUG_ON(ret);
+		free_extent_buffer(tmp);
+	}
 
-	ret = __btrfs_cow_block(trans, info->dev_root, info->dev_root->node,
-				NULL, 0, &tmp, 0, 0);
-	BUG_ON(ret);
-	free_extent_buffer(tmp);
+	generation = btrfs_root_generation(&info->dev_root->root_item);
+	if (generation != trans->transid) {
+		ret = __btrfs_cow_block(trans, info->dev_root,
+				info->dev_root->node, NULL, 0, &tmp, 0, 0);
+		BUG_ON(ret);
+		free_extent_buffer(tmp);
+	}
 
-	ret = __btrfs_cow_block(trans, info->csum_root, info->csum_root->node,
-				NULL, 0, &tmp, 0, 0);
-	BUG_ON(ret);
-	free_extent_buffer(tmp);
+	generation = btrfs_root_generation(&info->csum_root->root_item);
+	if (generation != trans->transid) {
+		ret = __btrfs_cow_block(trans, info->csum_root,
+				info->csum_root->node, NULL, 0, &tmp, 0, 0);
+		BUG_ON(ret);
+		free_extent_buffer(tmp);
+	}
 
 	return 0;
 }
@@ -281,8 +299,6 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 					    (allowed & metadata_profile));
 		BUG_ON(ret);
 
-		ret = recow_roots(trans, root);
-		BUG_ON(ret);
 	}
 	if (!mixed && num_devices > 1 && (allowed & data_profile)) {
 		ret = create_one_raid_group(trans, root,
@@ -290,6 +306,9 @@ static int create_raid_groups(struct btrfs_trans_handle *trans,
 					    (allowed & data_profile));
 		BUG_ON(ret);
 	}
+	ret = recow_roots(trans, root);
+	BUG_ON(ret);
+
 	return 0;
 }
 
-- 
1.7.11.7







