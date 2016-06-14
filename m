Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40711 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbcFNHMB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 03:12:01 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5E79Jug119040
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 03:12:00 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23gf59b8ca-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 03:12:00 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 14 Jun 2016 01:11:58 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [PATCH V19 07/19] Btrfs: subpage-blocksize: Allow mounting filesystems where sectorsize < PAGE_SIZE
Date: Tue, 14 Jun 2016 12:41:04 +0530
In-Reply-To: <1465888276-30670-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1465888276-30670-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1465888276-30670-8-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit allows mounting filesystem instances with sectorsize smaller
than the PAGE_SIZE.

Since the code assumes that the super block is either equal to or larger
than sectorsize, this commit brings back the nodesize argument for
btrfs_find_create_tree_block() function. This change allows us to be
able to mount and use filesystems with 2048 bytes as the sectorsize.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/disk-io.c     | 21 ++++++++-------------
 fs/btrfs/disk-io.h     |  2 +-
 fs/btrfs/extent-tree.c |  4 ++--
 fs/btrfs/extent_io.c   |  3 +--
 fs/btrfs/extent_io.h   |  4 ++--
 fs/btrfs/tree-log.c    |  2 +-
 fs/btrfs/volumes.c     |  9 ++-------
 7 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 75129d2..b50f9a3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1099,7 +1099,7 @@ void readahead_tree_block(struct btrfs_root *root, u64 bytenr)
 	struct extent_buffer *buf = NULL;
 	struct inode *btree_inode = root->fs_info->btree_inode;
 
-	buf = btrfs_find_create_tree_block(root, bytenr);
+	buf = btrfs_find_create_tree_block(root, bytenr, root->nodesize);
 	if (!buf)
 		return;
 	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
@@ -1115,7 +1115,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
 	struct extent_io_tree *io_tree = &BTRFS_I(btree_inode)->io_tree;
 	int ret;
 
-	buf = btrfs_find_create_tree_block(root, bytenr);
+	buf = btrfs_find_create_tree_block(root, bytenr, root->nodesize);
 	if (!buf)
 		return 0;
 
@@ -1146,12 +1146,12 @@ struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
 }
 
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
-						 u64 bytenr)
+						 u64 bytenr, u32 blocksize)
 {
 	if (btrfs_test_is_dummy_root(root))
 		return alloc_test_extent_buffer(root->fs_info, bytenr,
-				root->nodesize);
-	return alloc_extent_buffer(root->fs_info, bytenr);
+						blocksize);
+	return alloc_extent_buffer(root->fs_info, bytenr, blocksize);
 }
 
 
@@ -1175,7 +1175,7 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	struct extent_buffer *buf = NULL;
 	int ret;
 
-	buf = btrfs_find_create_tree_block(root, bytenr);
+	buf = btrfs_find_create_tree_block(root, bytenr, root->nodesize);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -4089,17 +4089,12 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
 	 * Check sectorsize and nodesize first, other check will need it.
 	 * Check all possible sectorsize(4K, 8K, 16K, 32K, 64K) here.
 	 */
-	if (!is_power_of_2(sectorsize) || sectorsize < 4096 ||
+	if (!is_power_of_2(sectorsize) || sectorsize < 2048 ||
 	    sectorsize > BTRFS_MAX_METADATA_BLOCKSIZE) {
 		printk(KERN_ERR "BTRFS: invalid sectorsize %llu\n", sectorsize);
 		ret = -EINVAL;
 	}
-	/* Only PAGE SIZE is supported yet */
-	if (sectorsize != PAGE_SIZE) {
-		printk(KERN_ERR "BTRFS: sectorsize %llu not supported yet, only support %lu\n",
-				sectorsize, PAGE_SIZE);
-		ret = -EINVAL;
-	}
+
 	if (!is_power_of_2(nodesize) || nodesize < sectorsize ||
 	    nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
 		printk(KERN_ERR "BTRFS: invalid nodesize %llu\n", nodesize);
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index a81ff8d..aa3fb08 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -50,7 +50,7 @@ void readahead_tree_block(struct btrfs_root *root, u64 bytenr);
 int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
 			 int mirror_num, struct extent_buffer **eb);
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
-						   u64 bytenr);
+						   u64 bytenr, u32 blocksize);
 void clean_tree_block(struct btrfs_trans_handle *trans,
 		      struct btrfs_fs_info *fs_info, struct extent_buffer *buf);
 int open_ctree(struct super_block *sb,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index eed17ec..d225479 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8015,7 +8015,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 {
 	struct extent_buffer *buf;
 
-	buf = btrfs_find_create_tree_block(root, bytenr);
+	buf = btrfs_find_create_tree_block(root, bytenr, root->nodesize);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 	btrfs_set_header_generation(buf, trans->transid);
@@ -8658,7 +8658,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 
 	next = btrfs_find_tree_block(root->fs_info, bytenr);
 	if (!next) {
-		next = btrfs_find_create_tree_block(root, bytenr);
+		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
 		if (!next)
 			return -ENOMEM;
 		btrfs_set_buffer_lockdep_class(root->root_key.objectid, next,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b7ad9c1..0465311 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5405,9 +5405,8 @@ free_eb:
 #endif
 
 struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
-					  u64 start)
+					  u64 start, unsigned long len)
 {
-	unsigned long len = fs_info->tree_root->nodesize;
 	unsigned long num_pages = num_extent_pages(start, len);
 	unsigned long i;
 	unsigned long index = start >> PAGE_SHIFT;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7096ea7..9dd84ef 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -435,7 +435,7 @@ int clear_page_blks_state(struct page *page, unsigned long blk_states,
 int test_page_blks_state(struct page *page, enum blk_state blk_state,
 			u64 start, u64 end, int check_all);
 struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
-					  u64 start);
+					u64 start, unsigned long len);
 struct extent_buffer *__alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 						  u64 start, unsigned long len);
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
@@ -559,5 +559,5 @@ noinline u64 find_lock_delalloc_range(struct inode *inode,
 				      u64 *end, u64 max_bytes);
 #endif
 struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
-					       u64 start, u32 nodesize);
+					      u64 start, u32 nodesize);
 #endif
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index b7665af..3f99625 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2421,7 +2421,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 		parent = path->nodes[*level];
 		root_owner = btrfs_header_owner(parent);
 
-		next = btrfs_find_create_tree_block(root, bytenr);
+		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
 		if (!next)
 			return -ENOMEM;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 40eddd7..e6c509b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6556,13 +6556,8 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	u32 cur_offset;
 	struct btrfs_key key;
 
-	ASSERT(BTRFS_SUPER_INFO_SIZE <= root->nodesize);
-	/*
-	 * This will create extent buffer of nodesize, superblock size is
-	 * fixed to BTRFS_SUPER_INFO_SIZE. If nodesize > sb size, this will
-	 * overallocate but we can keep it as-is, only the first page is used.
-	 */
-	sb = btrfs_find_create_tree_block(root, BTRFS_SUPER_INFO_OFFSET);
+	sb = btrfs_find_create_tree_block(root, BTRFS_SUPER_INFO_OFFSET,
+					  BTRFS_SUPER_INFO_SIZE);
 	if (!sb)
 		return -ENOMEM;
 	set_extent_buffer_uptodate(sb);
-- 
2.1.0

