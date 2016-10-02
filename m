Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751802AbcJBNZt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 09:25:49 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u92DNFJL005072
        for <linux-btrfs@vger.kernel.org>; Sun, 2 Oct 2016 09:25:48 -0400
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25tkbgw8gn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Oct 2016 09:25:48 -0400
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 2 Oct 2016 07:25:47 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V21 10/19] Btrfs: subpage-blocksize: Allow mounting filesystems where sectorsize < PAGE_SIZE
Date: Sun,  2 Oct 2016 18:54:19 +0530
In-Reply-To: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1475414668-25954-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1475414668-25954-11-git-send-email-chandan@linux.vnet.ibm.com>
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
 fs/btrfs/extent_io.h   |  2 +-
 fs/btrfs/tree-log.c    |  2 +-
 fs/btrfs/volumes.c     | 10 +++-------
 7 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5663481..2684438 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -936,7 +936,7 @@ void readahead_tree_block(struct btrfs_root *root, u64 bytenr)
 {
 	struct extent_buffer *buf = NULL;
 
-	buf = btrfs_find_create_tree_block(root, bytenr);
+	buf = btrfs_find_create_tree_block(root, bytenr, root->nodesize);
 	if (IS_ERR(buf))
 		return;
 	read_extent_buffer_pages(buf, WAIT_NONE, 0);
@@ -949,7 +949,7 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr,
 	struct extent_buffer *buf = NULL;
 	int ret;
 
-	buf = btrfs_find_create_tree_block(root, bytenr);
+	buf = btrfs_find_create_tree_block(root, bytenr, root->nodesize);
 	if (IS_ERR(buf))
 		return 0;
 
@@ -979,12 +979,12 @@ struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
 }
 
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
-						 u64 bytenr)
+						 u64 bytenr, u32 blocksize)
 {
 	if (btrfs_is_testing(root->fs_info))
 		return alloc_test_extent_buffer(root->fs_info->eb_info, bytenr,
-						root->nodesize);
-	return alloc_extent_buffer(root->fs_info, bytenr);
+						blocksize);
+	return alloc_extent_buffer(root->fs_info, bytenr, blocksize);
 }
 
 
@@ -1006,7 +1006,7 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	struct extent_buffer *buf = NULL;
 	int ret;
 
-	buf = btrfs_find_create_tree_block(root, bytenr);
+	buf = btrfs_find_create_tree_block(root, bytenr, root->nodesize);
 	if (IS_ERR(buf))
 		return buf;
 
@@ -3891,17 +3891,12 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
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
index 591f078..5f6263e 100644
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
index 03da2f6..25fbfa2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8238,7 +8238,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 {
 	struct extent_buffer *buf;
 
-	buf = btrfs_find_create_tree_block(root, bytenr);
+	buf = btrfs_find_create_tree_block(root, bytenr, root->nodesize);
 	if (IS_ERR(buf))
 		return buf;
 
@@ -8885,7 +8885,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 
 	next = btrfs_find_tree_block(root->fs_info, bytenr);
 	if (!next) {
-		next = btrfs_find_create_tree_block(root, bytenr);
+		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
 		if (IS_ERR(next))
 			return PTR_ERR(next);
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8ace367..9af8237 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5113,9 +5113,8 @@ free_eb:
 #endif
 
 struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
-					  u64 start)
+					  u64 start, unsigned long len)
 {
-	unsigned long len = fs_info->tree_root->nodesize;
 	unsigned long num_pages = num_extent_pages(start, len);
 	unsigned long i;
 	struct extent_buffer *eb;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 6a02343..ad5b000 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -430,7 +430,7 @@ int clear_page_blks_state(struct page *page, unsigned long blk_states,
 int test_page_blks_state(struct page *page, enum blk_state blk_state,
 			u64 start, u64 end, int check_all);
 struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
-					  u64 start);
+					  u64 start, unsigned long len);
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_eb_info *eb_info,
 						u64 start, unsigned long len);
 struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a25be18b..bc5e0c1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2421,7 +2421,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 		parent = path->nodes[*level];
 		root_owner = btrfs_header_owner(parent);
 
-		next = btrfs_find_create_tree_block(root, bytenr);
+		next = btrfs_find_create_tree_block(root, bytenr, blocksize);
 		if (IS_ERR(next))
 			return PTR_ERR(next);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 89dc9c7..3994ab9 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6664,15 +6664,11 @@ int btrfs_read_sys_array(struct btrfs_root *root)
 	u64 type;
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
 	if (IS_ERR(sb))
 		return PTR_ERR(sb);
+
 	set_extent_buffer_uptodate(sb);
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, sb, 0);
 	/*
-- 
2.5.5

