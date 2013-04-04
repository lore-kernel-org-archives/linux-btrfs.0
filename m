Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33667 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761142Ab3DDSdn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Apr 2013 14:33:43 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 7B0AD9A0371
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2013 12:33:43 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id eBYVuQBqX6mnwk6y (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 04 Apr 2013 12:33:42 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: log ram bytes properly
Date: Thu, 4 Apr 2013 14:33:40 -0400
Message-ID: <1365100420-1697-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When logging changed extents I was logging ram_bytes as the current length,
which isn't correct, it's supposed to be the ram bytes of the original extent.
This is for compression where even if we split the extent we need to know the
ram bytes so when we uncompress the extent we know how big it will be.  This was
still working out right with compression for some reason but I think we were
getting lucky.  It was definitely off for prealloc which is why I noticed it,
btrfsck was complaining about it.  With this patch btrfsck no longer complains
after a log replay.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_map.h |    1 +
 fs/btrfs/file.c       |    3 +++
 fs/btrfs/inode.c      |   21 +++++++++++++++++----
 fs/btrfs/tree-log.c   |    2 +-
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index c6598c8..b18314b 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -26,6 +26,7 @@ struct extent_map {
 	u64 mod_len;
 	u64 orig_start;
 	u64 orig_block_len;
+	u64 ram_bytes;
 	u64 block_start;
 	u64 block_len;
 	u64 generation;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1be25b9..17f52a3 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -607,6 +607,7 @@ void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 				split->block_len = em->block_len;
 			else
 				split->block_len = split->len;
+			split->ram_bytes = em->ram_bytes;
 			split->orig_block_len = max(split->block_len,
 						    em->orig_block_len);
 			split->generation = gen;
@@ -632,6 +633,7 @@ void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			split->generation = gen;
 			split->orig_block_len = max(em->block_len,
 						    em->orig_block_len);
+			split->ram_bytes = em->ram_bytes;
 
 			if (compressed) {
 				split->block_len = em->block_len;
@@ -1915,6 +1917,7 @@ out:
 	} else {
 		hole_em->start = offset;
 		hole_em->len = end - offset;
+		hole_em->ram_bytes = hole_em->len;
 		hole_em->orig_start = offset;
 
 		hole_em->block_start = EXTENT_MAP_HOLE;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d96ee30..0dd3ac4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -100,7 +100,8 @@ static noinline int cow_file_range(struct inode *inode,
 static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 					   u64 len, u64 orig_start,
 					   u64 block_start, u64 block_len,
-					   u64 orig_block_len, int type);
+					   u64 orig_block_len, u64 ram_bytes,
+					   int type);
 
 static int btrfs_init_inode_security(struct btrfs_trans_handle *trans,
 				     struct inode *inode,  struct inode *dir,
@@ -722,6 +723,7 @@ retry:
 		em->block_start = ins.objectid;
 		em->block_len = ins.offset;
 		em->orig_block_len = ins.offset;
+		em->ram_bytes = async_extent->ram_size;
 		em->bdev = root->fs_info->fs_devices->latest_bdev;
 		em->compress_type = async_extent->compress_type;
 		set_bit(EXTENT_FLAG_PINNED, &em->flags);
@@ -932,6 +934,7 @@ static noinline int __cow_file_range(struct btrfs_trans_handle *trans,
 		em->block_start = ins.objectid;
 		em->block_len = ins.offset;
 		em->orig_block_len = ins.offset;
+		em->ram_bytes = ram_size;
 		em->bdev = root->fs_info->fs_devices->latest_bdev;
 		set_bit(EXTENT_FLAG_PINNED, &em->flags);
 		em->generation = -1;
@@ -1194,6 +1197,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	u64 disk_bytenr;
 	u64 num_bytes;
 	u64 disk_num_bytes;
+	u64 ram_bytes;
 	int extent_type;
 	int ret, err;
 	int type;
@@ -1290,6 +1294,7 @@ next_slot:
 				    struct btrfs_file_extent_item);
 		extent_type = btrfs_file_extent_type(leaf, fi);
 
+		ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
 		if (extent_type == BTRFS_FILE_EXTENT_REG ||
 		    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 			disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
@@ -1373,6 +1378,7 @@ out_check:
 			em->block_len = num_bytes;
 			em->block_start = disk_bytenr;
 			em->orig_block_len = disk_num_bytes;
+			em->ram_bytes = ram_bytes;
 			em->bdev = root->fs_info->fs_devices->latest_bdev;
 			em->mod_start = em->start;
 			em->mod_len = em->len;
@@ -4454,6 +4460,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 			hole_em->block_start = EXTENT_MAP_HOLE;
 			hole_em->block_len = 0;
 			hole_em->orig_block_len = 0;
+			hole_em->ram_bytes = hole_size;
 			hole_em->bdev = root->fs_info->fs_devices->latest_bdev;
 			hole_em->compress_type = BTRFS_COMPRESS_NONE;
 			hole_em->generation = trans->transid;
@@ -6156,6 +6163,7 @@ again:
 		goto not_found_em;
 	}
 
+	em->ram_bytes = btrfs_file_extent_ram_bytes(leaf, item);
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		em->start = extent_start;
@@ -6487,7 +6495,7 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 	}
 
 	em = create_pinned_em(inode, start, ins.offset, start, ins.objectid,
-			      ins.offset, ins.offset, 0);
+			      ins.offset, ins.offset, ins.offset, 0);
 	if (IS_ERR(em))
 		goto out;
 
@@ -6666,7 +6674,8 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
 static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 					   u64 len, u64 orig_start,
 					   u64 block_start, u64 block_len,
-					   u64 orig_block_len, int type)
+					   u64 orig_block_len, u64 ram_bytes,
+					   int type)
 {
 	struct extent_map_tree *em_tree;
 	struct extent_map *em;
@@ -6687,6 +6696,7 @@ static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 	em->block_start = block_start;
 	em->bdev = root->fs_info->fs_devices->latest_bdev;
 	em->orig_block_len = orig_block_len;
+	em->ram_bytes = ram_bytes;
 	em->generation = -1;
 	set_bit(EXTENT_FLAG_PINNED, &em->flags);
 	if (type == BTRFS_ORDERED_PREALLOC)
@@ -6815,13 +6825,15 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 		if (can_nocow_odirect(trans, inode, start, len) == 1) {
 			u64 orig_start = em->orig_start;
 			u64 orig_block_len = em->orig_block_len;
+			u64 ram_bytes = em->ram_bytes;
 
 			if (type == BTRFS_ORDERED_PREALLOC) {
 				free_extent_map(em);
 				em = create_pinned_em(inode, start, len,
 						       orig_start,
 						       block_start, len,
-						       orig_block_len, type);
+						       orig_block_len,
+						       ram_bytes, type);
 				if (IS_ERR(em)) {
 					btrfs_end_transaction(trans, root);
 					goto unlock_err;
@@ -8574,6 +8586,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		em->block_start = ins.objectid;
 		em->block_len = ins.offset;
 		em->orig_block_len = ins.offset;
+		em->ram_bytes = ins.offset;
 		em->bdev = root->fs_info->fs_devices->latest_bdev;
 		set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
 		em->generation = trans->transid;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 241daf7..535c351 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3403,7 +3403,7 @@ insert:
 					   em->start - em->orig_start,
 					   &token);
 	btrfs_set_token_file_extent_num_bytes(leaf, fi, em->len, &token);
-	btrfs_set_token_file_extent_ram_bytes(leaf, fi, em->len, &token);
+	btrfs_set_token_file_extent_ram_bytes(leaf, fi, em->ram_bytes, &token);
 	btrfs_set_token_file_extent_compression(leaf, fi, em->compress_type,
 						&token);
 	btrfs_set_token_file_extent_encryption(leaf, fi, 0, &token);
-- 
1.7.7.6

