Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38125 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab2GDNzw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 09:55:52 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q64DgqJn028817
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Jul 2012 21:42:53 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4] Btrfs: do not abort transaction in prealloc case
Date: Wed, 4 Jul 2012 21:52:55 +0800
Message-Id: <1341409978-22423-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During disk balance, we prealloc new file extent for file data relocation,
but we may fail in 'no available space' case, and only under this case can
the error be reported to userspace, so we do not need to abort transaction
here.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |    8 ++++----
 fs/btrfs/extent-tree.c |   13 +++++++------
 fs/btrfs/inode.c       |    8 ++++----
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 84ac723..821a556 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2564,10 +2564,10 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 				   u64 root_objectid, u64 owner, u64 offset,
 				   struct btrfs_key *ins);
 int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
-				  struct btrfs_root *root,
-				  u64 num_bytes, u64 min_alloc_size,
-				  u64 empty_size, u64 hint_byte,
-				  struct btrfs_key *ins, u64 data);
+			 struct btrfs_root *root,
+			 u64 num_bytes, u64 min_alloc_size,
+			 u64 empty_size, u64 hint_byte,
+			 struct btrfs_key *ins, u64 data, int abort_on_enospc);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, int full_backref, int for_cow);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5775dc4..bbe79ab 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5419,7 +5419,7 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *orig_root,
 				     u64 num_bytes, u64 empty_size,
 				     u64 hint_byte, struct btrfs_key *ins,
-				     u64 data)
+				     u64 data, int abort_on_enospc)
 {
 	int ret = 0;
 	struct btrfs_root *root = orig_root->fs_info->extent_root;
@@ -5778,8 +5778,9 @@ loop:
 						     2 * 1024 * 1024, data,
 						     CHUNK_ALLOC_LIMITED);
 				if (ret < 0) {
-					btrfs_abort_transaction(trans,
-								root, ret);
+					if (abort_on_enospc)
+						btrfs_abort_transaction(trans,
+								    root, ret);
 					goto out;
 				}
 				allowed_chunk_alloc = 0;
@@ -5864,7 +5865,7 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_root *root,
 			 u64 num_bytes, u64 min_alloc_size,
 			 u64 empty_size, u64 hint_byte,
-			 struct btrfs_key *ins, u64 data)
+			 struct btrfs_key *ins, u64 data, int abort_on_enospc)
 {
 	bool final_tried = false;
 	int ret;
@@ -5887,7 +5888,7 @@ again:
 
 	WARN_ON(num_bytes < root->sectorsize);
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
-			       hint_byte, ins, data);
+			       hint_byte, ins, data, abort_on_enospc);
 
 	if (ret == -ENOSPC) {
 		if (!final_tried) {
@@ -6294,7 +6295,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 		return ERR_CAST(block_rsv);
 
 	ret = btrfs_reserve_extent(trans, root, blocksize, blocksize,
-				   empty_size, hint, &ins, 0);
+				   empty_size, hint, &ins, 0, 1);
 	if (ret) {
 		unuse_block_rsv(root->fs_info, block_rsv, blocksize);
 		return ERR_PTR(ret);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9f07bd1..1f72817 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -662,7 +662,7 @@ retry:
 			ret = btrfs_reserve_extent(trans, root,
 					   async_extent->compressed_size,
 					   async_extent->compressed_size,
-					   0, alloc_hint, &ins, 1);
+					   0, alloc_hint, &ins, 1, 1);
 			if (ret)
 				btrfs_abort_transaction(trans, root, ret);
 			btrfs_end_transaction(trans, root);
@@ -888,7 +888,7 @@ static noinline int cow_file_range(struct inode *inode,
 		cur_alloc_size = disk_num_bytes;
 		ret = btrfs_reserve_extent(trans, root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
-					   &ins, 1);
+					   &ins, 1, 1);
 		if (ret < 0) {
 			btrfs_abort_transaction(trans, root, ret);
 			goto out_unlock;
@@ -5643,7 +5643,7 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 
 	alloc_hint = get_extent_allocation_hint(inode, start, len);
 	ret = btrfs_reserve_extent(trans, root, len, root->sectorsize, 0,
-				   alloc_hint, &ins, 1);
+				   alloc_hint, &ins, 1, 1);
 	if (ret) {
 		em = ERR_PTR(ret);
 		goto out;
@@ -7540,7 +7540,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		}
 
 		ret = btrfs_reserve_extent(trans, root, num_bytes, min_size,
-					   0, *alloc_hint, &ins, 1);
+					   0, *alloc_hint, &ins, 1, 0);
 		if (ret) {
 			if (own_trans)
 				btrfs_end_transaction(trans, root);
-- 
1.6.5.2

