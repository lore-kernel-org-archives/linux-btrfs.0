Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39089 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550Ab3LPS0e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 13:26:34 -0500
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id rBGIQ8td012061
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 10:26:34 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1gt4hv0fva-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 10:26:33 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: move the extent buffer radix tree into the fs_info
Date: Mon, 16 Dec 2013 13:26:26 -0500
Message-ID: <1387218386-5339-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I need to create a fake tree to test qgroups and I don't want to have to setup a
fake btree_inode.  The fact is we only use the radix tree for the fs_info, so
everybody else who allocates an extent_io_tree is just wasting the space anyway.
This patch moves the radix tree and its lock into btrfs_fs_info so there is less
stuff I have to fake to do qgroup sanity tests.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ctree.h     |  4 ++++
 fs/btrfs/disk-io.c   | 14 ++++----------
 fs/btrfs/extent_io.c | 47 +++++++++++++++++++++++------------------------
 fs/btrfs/extent_io.h |  8 +++-----
 4 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f27faa3..944c916 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1691,6 +1691,10 @@ struct btrfs_fs_info {
 	spinlock_t reada_lock;
 	struct radix_tree_root reada_tree;
 
+	/* Extent buffer radix tree */
+	spinlock_t buffer_lock;
+	struct radix_tree_root buffer_radix;
+
 	/* next backup root to be overwritten */
 	int backup_root_index;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 44c0875..3eb27b9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1089,21 +1089,13 @@ int reada_tree_block_flagged(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize)
 {
-	struct inode *btree_inode = root->fs_info->btree_inode;
-	struct extent_buffer *eb;
-	eb = find_extent_buffer(&BTRFS_I(btree_inode)->io_tree, bytenr);
-	return eb;
+	return find_extent_buffer(root->fs_info, bytenr);
 }
 
 struct extent_buffer *btrfs_find_create_tree_block(struct btrfs_root *root,
 						 u64 bytenr, u32 blocksize)
 {
-	struct inode *btree_inode = root->fs_info->btree_inode;
-	struct extent_buffer *eb;
-
-	eb = alloc_extent_buffer(&BTRFS_I(btree_inode)->io_tree,
-				 bytenr, blocksize);
-	return eb;
+	return alloc_extent_buffer(root->fs_info, bytenr, blocksize);
 }
 
 
@@ -2145,6 +2137,7 @@ int open_ctree(struct super_block *sb,
 	mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
 
 	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
+	INIT_RADIX_TREE(&fs_info->buffer_radix, GFP_ATOMIC);
 	INIT_LIST_HEAD(&fs_info->trans_list);
 	INIT_LIST_HEAD(&fs_info->dead_roots);
 	INIT_LIST_HEAD(&fs_info->delayed_iputs);
@@ -2159,6 +2152,7 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->tree_mod_seq_lock);
 	spin_lock_init(&fs_info->super_lock);
 	spin_lock_init(&fs_info->qgroup_op_lock);
+	spin_lock_init(&fs_info->buffer_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
 	mutex_init(&fs_info->reloc_mutex);
 	seqlock_init(&fs_info->profiles_lock);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dc392d9..a8cc389 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -194,11 +194,9 @@ void extent_io_tree_init(struct extent_io_tree *tree,
 			 struct address_space *mapping)
 {
 	tree->state = RB_ROOT;
-	INIT_RADIX_TREE(&tree->buffer, GFP_ATOMIC);
 	tree->ops = NULL;
 	tree->dirty_bytes = 0;
 	spin_lock_init(&tree->lock);
-	spin_lock_init(&tree->buffer_lock);
 	tree->mapping = mapping;
 }
 
@@ -3499,6 +3497,7 @@ static int write_one_eb(struct extent_buffer *eb,
 			struct extent_page_data *epd)
 {
 	struct block_device *bdev = fs_info->fs_devices->latest_bdev;
+	struct extent_io_tree *tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
 	u64 offset = eb->start;
 	unsigned long i, num_pages;
 	unsigned long bio_flags = 0;
@@ -3516,7 +3515,7 @@ static int write_one_eb(struct extent_buffer *eb,
 
 		clear_page_dirty_for_io(p);
 		set_page_writeback(p);
-		ret = submit_extent_page(rw, eb->tree, p, offset >> 9,
+		ret = submit_extent_page(rw, tree, p, offset >> 9,
 					 PAGE_CACHE_SIZE, 0, bdev, &epd->bio,
 					 -1, end_bio_extent_buffer_writepage,
 					 0, epd->bio_flags, bio_flags);
@@ -4380,10 +4379,9 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 	__free_extent_buffer(eb);
 }
 
-static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
-						   u64 start,
-						   unsigned long len,
-						   gfp_t mask)
+static struct extent_buffer *
+__alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
+		      unsigned long len, gfp_t mask)
 {
 	struct extent_buffer *eb = NULL;
 
@@ -4392,7 +4390,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
 		return NULL;
 	eb->start = start;
 	eb->len = len;
-	eb->tree = tree;
+	eb->fs_info = fs_info;
 	eb->bflags = 0;
 	rwlock_init(&eb->lock);
 	atomic_set(&eb->write_locks, 0);
@@ -4524,13 +4522,14 @@ static void mark_extent_buffer_accessed(struct extent_buffer *eb)
 	}
 }
 
-struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
-					 		u64 start)
+struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
+					 u64 start)
 {
 	struct extent_buffer *eb;
 
 	rcu_read_lock();
-	eb = radix_tree_lookup(&tree->buffer, start >> PAGE_CACHE_SHIFT);
+	eb = radix_tree_lookup(&fs_info->buffer_radix,
+			       start >> PAGE_CACHE_SHIFT);
 	if (eb && atomic_inc_not_zero(&eb->refs)) {
 		rcu_read_unlock();
 		mark_extent_buffer_accessed(eb);
@@ -4541,7 +4540,7 @@ struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
 	return NULL;
 }
 
-struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
+struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  u64 start, unsigned long len)
 {
 	unsigned long num_pages = num_extent_pages(start, len);
@@ -4550,16 +4549,15 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	struct extent_buffer *eb;
 	struct extent_buffer *exists = NULL;
 	struct page *p;
-	struct address_space *mapping = tree->mapping;
+	struct address_space *mapping = fs_info->btree_inode->i_mapping;
 	int uptodate = 1;
 	int ret;
 
-
-	eb = find_extent_buffer(tree, start);
+	eb = find_extent_buffer(fs_info, start);
 	if (eb)
 		return eb;
 
-	eb = __alloc_extent_buffer(tree, start, len, GFP_NOFS);
+	eb = __alloc_extent_buffer(fs_info, start, len, GFP_NOFS);
 	if (!eb)
 		return NULL;
 
@@ -4614,12 +4612,13 @@ again:
 	if (ret)
 		goto free_eb;
 
-	spin_lock(&tree->buffer_lock);
-	ret = radix_tree_insert(&tree->buffer, start >> PAGE_CACHE_SHIFT, eb);
-	spin_unlock(&tree->buffer_lock);
+	spin_lock(&fs_info->buffer_lock);
+	ret = radix_tree_insert(&fs_info->buffer_radix,
+				start >> PAGE_CACHE_SHIFT, eb);
+	spin_unlock(&fs_info->buffer_lock);
 	radix_tree_preload_end();
 	if (ret == -EEXIST) {
-		exists = find_extent_buffer(tree, start);
+		exists = find_extent_buffer(fs_info, start);
 		if (exists)
 			goto free_eb;
 		else
@@ -4672,14 +4671,14 @@ static int release_extent_buffer(struct extent_buffer *eb)
 	WARN_ON(atomic_read(&eb->refs) == 0);
 	if (atomic_dec_and_test(&eb->refs)) {
 		if (test_and_clear_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags)) {
-			struct extent_io_tree *tree = eb->tree;
+			struct btrfs_fs_info *fs_info = eb->fs_info;
 
 			spin_unlock(&eb->refs_lock);
 
-			spin_lock(&tree->buffer_lock);
-			radix_tree_delete(&tree->buffer,
+			spin_lock(&fs_info->buffer_lock);
+			radix_tree_delete(&fs_info->buffer_radix,
 					  eb->start >> PAGE_CACHE_SHIFT);
-			spin_unlock(&tree->buffer_lock);
+			spin_unlock(&fs_info->buffer_lock);
 		} else {
 			spin_unlock(&eb->refs_lock);
 		}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 92e4347..58b27e5 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -95,12 +95,10 @@ struct extent_io_ops {
 
 struct extent_io_tree {
 	struct rb_root state;
-	struct radix_tree_root buffer;
 	struct address_space *mapping;
 	u64 dirty_bytes;
 	int track_uptodate;
 	spinlock_t lock;
-	spinlock_t buffer_lock;
 	struct extent_io_ops *ops;
 };
 
@@ -131,7 +129,7 @@ struct extent_buffer {
 	unsigned long map_start;
 	unsigned long map_len;
 	unsigned long bflags;
-	struct extent_io_tree *tree;
+	struct btrfs_fs_info *fs_info;
 	spinlock_t refs_lock;
 	atomic_t refs;
 	atomic_t io_pages;
@@ -267,11 +265,11 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private);
 void set_page_extent_mapped(struct page *page);
 
-struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
+struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  u64 start, unsigned long len);
 struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len);
 struct extent_buffer *btrfs_clone_extent_buffer(struct extent_buffer *src);
-struct extent_buffer *find_extent_buffer(struct extent_io_tree *tree,
+struct extent_buffer *find_extent_buffer(struct btrfs_fs_info *fs_info,
 					 u64 start);
 void free_extent_buffer(struct extent_buffer *eb);
 void free_extent_buffer_stale(struct extent_buffer *eb);
-- 
1.8.3.1

