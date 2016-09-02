Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56187 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932555AbcIBTkg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 15:40:36 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.17/8.16.0.17) with SMTP id u82JY1sv005799
        for <linux-btrfs@vger.kernel.org>; Fri, 2 Sep 2016 12:40:35 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
        by m0089730.ppops.net with ESMTP id 2570s674ue-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 12:40:35 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH 1/7] Btrfs: replace tree->mapping with tree->private_data
Date: Fri, 2 Sep 2016 15:40:00 -0400
Message-ID: <1472845206-22870-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1472845206-22870-1-git-send-email-jbacik@fb.com>
References: <1472845206-22870-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For extent_io tree's we have carried the address_mapping of the inode around in
the io tree in order to pull the inode back out for calling into various tree
ops hooks.  This works fine when everything that has an extent_io_tree has an
inode.  But we are going to remove the btree_inode, so we need to change this.
Instead just have a generic void * for private data that we can initialize with,
and have all the tree ops use that instead.  This had a lot of cascading changes
but should be relatively straightforward.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/ctree.h                 |  1 +
 fs/btrfs/disk-io.c               | 50 ++++++++++++----------
 fs/btrfs/disk-io.h               |  6 +--
 fs/btrfs/extent_io.c             | 51 +++++++---------------
 fs/btrfs/extent_io.h             | 21 ++++++----
 fs/btrfs/inode.c                 | 91 ++++++++++++++++++++++++++++++----------
 fs/btrfs/relocation.c            |  3 +-
 fs/btrfs/tests/extent-io-tests.c |  2 +-
 fs/btrfs/transaction.c           |  2 +-
 9 files changed, 133 insertions(+), 94 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2fe8f89..bb50d7c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3122,6 +3122,7 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio,
 			 unsigned long bio_flags);
+void btrfs_set_range_writeback(void *private_data, u64 start, u64 end);
 int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_evict_inode(struct inode *inode);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4034ad6..c1d951a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -119,7 +119,8 @@ void btrfs_end_io_wq_exit(void)
  * just before they are sent down the IO stack.
  */
 struct async_submit_bio {
-	struct inode *inode;
+	void *private_data;
+	struct btrfs_fs_info *fs_info;
 	struct bio *bio;
 	struct list_head list;
 	extent_submit_bio_hook_t *submit_bio_start;
@@ -796,7 +797,7 @@ static void run_one_async_start(struct btrfs_work *work)
 	int ret;
 
 	async = container_of(work, struct  async_submit_bio, work);
-	ret = async->submit_bio_start(async->inode, async->bio,
+	ret = async->submit_bio_start(async->private_data, async->bio,
 				      async->mirror_num, async->bio_flags,
 				      async->bio_offset);
 	if (ret)
@@ -810,7 +811,7 @@ static void run_one_async_done(struct btrfs_work *work)
 	int limit;
 
 	async = container_of(work, struct  async_submit_bio, work);
-	fs_info = BTRFS_I(async->inode)->root->fs_info;
+	fs_info = async->fs_info;
 
 	limit = btrfs_async_submit_limit(fs_info);
 	limit = limit * 2 / 3;
@@ -829,7 +830,7 @@ static void run_one_async_done(struct btrfs_work *work)
 		return;
 	}
 
-	async->submit_bio_done(async->inode, async->bio, async->mirror_num,
+	async->submit_bio_done(async->private_data, async->bio, async->mirror_num,
 			       async->bio_flags, async->bio_offset);
 }
 
@@ -841,10 +842,9 @@ static void run_one_async_free(struct btrfs_work *work)
 	kfree(async);
 }
 
-int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
-			struct bio *bio, int mirror_num,
-			unsigned long bio_flags,
-			u64 bio_offset,
+int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
+			int mirror_num, unsigned long bio_flags,
+			u64 bio_offset, void *private_data,
 			extent_submit_bio_hook_t *submit_bio_start,
 			extent_submit_bio_hook_t *submit_bio_done)
 {
@@ -854,7 +854,8 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 	if (!async)
 		return -ENOMEM;
 
-	async->inode = inode;
+	async->private_data = private_data;
+	async->fs_info = fs_info;
 	async->bio = bio;
 	async->mirror_num = mirror_num;
 	async->submit_bio_start = submit_bio_start;
@@ -900,7 +901,7 @@ static int btree_csum_one_bio(struct bio *bio)
 	return ret;
 }
 
-static int __btree_submit_bio_start(struct inode *inode, struct bio *bio,
+static int __btree_submit_bio_start(void *private_data, struct bio *bio,
 				    int mirror_num, unsigned long bio_flags,
 				    u64 bio_offset)
 {
@@ -911,10 +912,11 @@ static int __btree_submit_bio_start(struct inode *inode, struct bio *bio,
 	return btree_csum_one_bio(bio);
 }
 
-static int __btree_submit_bio_done(struct inode *inode, struct bio *bio,
+static int __btree_submit_bio_done(void *private_data, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags,
 				 u64 bio_offset)
 {
+	struct inode *inode = private_data;
 	int ret;
 
 	/*
@@ -940,10 +942,11 @@ static int check_async_write(struct inode *inode, unsigned long bio_flags)
 	return 1;
 }
 
-static int btree_submit_bio_hook(struct inode *inode, struct bio *bio,
+static int btree_submit_bio_hook(void *private_data, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags,
 				 u64 bio_offset)
 {
+	struct inode *inode = private_data;
 	int async = check_async_write(inode, bio_flags);
 	int ret;
 
@@ -968,8 +971,8 @@ static int btree_submit_bio_hook(struct inode *inode, struct bio *bio,
 		 * checksumming can happen in parallel across all CPUs
 		 */
 		ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
-					  inode, bio, mirror_num, 0,
-					  bio_offset,
+					  bio, mirror_num, 0,
+					  bio_offset, private_data,
 					  __btree_submit_bio_start,
 					  __btree_submit_bio_done);
 	}
@@ -1283,8 +1286,7 @@ static void __setup_root(u32 nodesize, u32 sectorsize, u32 stripesize,
 	root->log_transid_committed = -1;
 	root->last_log_commit = 0;
 	if (!dummy)
-		extent_io_tree_init(&root->dirty_log_pages,
-				     fs_info->btree_inode->i_mapping);
+		extent_io_tree_init(&root->dirty_log_pages, NULL);
 
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
@@ -2261,7 +2263,7 @@ static void btrfs_init_btree_inode(struct btrfs_fs_info *fs_info,
 
 	RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
 	extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
-			     fs_info->btree_inode->i_mapping);
+			    fs_info->btree_inode);
 	BTRFS_I(fs_info->btree_inode)->io_tree.track_uptodate = 0;
 	extent_map_tree_init(&BTRFS_I(fs_info->btree_inode)->extent_tree);
 
@@ -2666,10 +2668,8 @@ int open_ctree(struct super_block *sb,
 	fs_info->block_group_cache_tree = RB_ROOT;
 	fs_info->first_logical_byte = (u64)-1;
 
-	extent_io_tree_init(&fs_info->freed_extents[0],
-			     fs_info->btree_inode->i_mapping);
-	extent_io_tree_init(&fs_info->freed_extents[1],
-			     fs_info->btree_inode->i_mapping);
+	extent_io_tree_init(&fs_info->freed_extents[0], NULL);
+	extent_io_tree_init(&fs_info->freed_extents[1], NULL);
 	fs_info->pinned_extents = &fs_info->freed_extents[0];
 	fs_info->do_barriers = 1;
 
@@ -4510,10 +4510,18 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 	return 0;
 }
 
+static struct btrfs_fs_info *btree_fs_info(void *private_data)
+{
+	struct inode *inode = private_data;
+	return btrfs_sb(inode->i_sb);
+}
+
 static const struct extent_io_ops btree_extent_io_ops = {
 	.readpage_end_io_hook = btree_readpage_end_io_hook,
 	.readpage_io_failed_hook = btree_io_failed_hook,
 	.submit_bio_hook = btree_submit_bio_hook,
 	/* note we're sharing with inode.c for the merge bio hook */
 	.merge_bio_hook = btrfs_merge_bio_hook,
+	.tree_fs_info = btree_fs_info,
+	.set_range_writeback = btrfs_set_range_writeback,
 };
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index b3207a0e..591f078 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -122,9 +122,9 @@ u32 btrfs_csum_data(char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, char *result);
 int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			enum btrfs_wq_endio_type metadata);
-int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
-			struct bio *bio, int mirror_num,
-			unsigned long bio_flags, u64 bio_offset,
+int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
+			int mirror_num, unsigned long bio_flags,
+			u64 bio_offset, void *private_data,
 			extent_submit_bio_hook_t *submit_bio_start,
 			extent_submit_bio_hook_t *submit_bio_done);
 unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 80d9283..515b78a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -87,19 +87,9 @@ void btrfs_leak_debug_check(void)
 static inline void __btrfs_debug_check_extent_io_range(const char *caller,
 		struct extent_io_tree *tree, u64 start, u64 end)
 {
-	struct inode *inode;
-	u64 isize;
-
-	if (!tree->mapping)
-		return;
-
-	inode = tree->mapping->host;
-	isize = i_size_read(inode);
-	if (end >= PAGE_SIZE && (end % 2) == 0 && end != isize - 1) {
-		btrfs_debug_rl(BTRFS_I(inode)->root->fs_info,
-		    "%s: ino %llu isize %llu odd range [%llu,%llu]",
-				caller, btrfs_ino(inode), isize, start, end);
-	}
+	if (tree->ops && tree->ops->check_extent_io_range)
+		tree->ops->check_extent_io_range(tree->private_data, caller,
+						 start, end);
 }
 #else
 #define btrfs_leak_debug_add(new, head)	do {} while (0)
@@ -154,9 +144,9 @@ static noinline void flush_write_bio(void *data);
 static inline struct btrfs_fs_info *
 tree_fs_info(struct extent_io_tree *tree)
 {
-	if (!tree->mapping)
-		return NULL;
-	return btrfs_sb(tree->mapping->host->i_sb);
+	if (tree->ops && tree->ops->tree_fs_info)
+		return tree->ops->tree_fs_info(tree->private_data);
+	return NULL;
 }
 
 int __init extent_io_init(void)
@@ -213,13 +203,13 @@ void extent_io_exit(void)
 }
 
 void extent_io_tree_init(struct extent_io_tree *tree,
-			 struct address_space *mapping)
+			 void *private_data)
 {
 	tree->state = RB_ROOT;
 	tree->ops = NULL;
 	tree->dirty_bytes = 0;
 	spin_lock_init(&tree->lock);
-	tree->mapping = mapping;
+	tree->private_data = private_data;
 }
 
 static struct extent_state *alloc_extent_state(gfp_t mask)
@@ -364,8 +354,7 @@ static void merge_cb(struct extent_io_tree *tree, struct extent_state *new,
 		     struct extent_state *other)
 {
 	if (tree->ops && tree->ops->merge_extent_hook)
-		tree->ops->merge_extent_hook(tree->mapping->host, new,
-					     other);
+		tree->ops->merge_extent_hook(tree->private_data, new, other);
 }
 
 /*
@@ -416,14 +405,14 @@ static void set_state_cb(struct extent_io_tree *tree,
 			 struct extent_state *state, unsigned *bits)
 {
 	if (tree->ops && tree->ops->set_bit_hook)
-		tree->ops->set_bit_hook(tree->mapping->host, state, bits);
+		tree->ops->set_bit_hook(tree->private_data, state, bits);
 }
 
 static void clear_state_cb(struct extent_io_tree *tree,
 			   struct extent_state *state, unsigned *bits)
 {
 	if (tree->ops && tree->ops->clear_bit_hook)
-		tree->ops->clear_bit_hook(tree->mapping->host, state, bits);
+		tree->ops->clear_bit_hook(tree->private_data, state, bits);
 }
 
 static void set_state_bits(struct extent_io_tree *tree,
@@ -473,7 +462,7 @@ static void split_cb(struct extent_io_tree *tree, struct extent_state *orig,
 		     u64 split)
 {
 	if (tree->ops && tree->ops->split_extent_hook)
-		tree->ops->split_extent_hook(tree->mapping->host, orig, split);
+		tree->ops->split_extent_hook(tree->private_data, orig, split);
 }
 
 /*
@@ -1398,17 +1387,7 @@ void extent_range_redirty_for_io(struct inode *inode, u64 start, u64 end)
  */
 static void set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 {
-	unsigned long index = start >> PAGE_SHIFT;
-	unsigned long end_index = end >> PAGE_SHIFT;
-	struct page *page;
-
-	while (index <= end_index) {
-		page = find_get_page(tree->mapping, index);
-		BUG_ON(!page); /* Pages should be in the extent_io_tree */
-		set_page_writeback(page);
-		put_page(page);
-		index++;
-	}
+	tree->ops->set_range_writeback(tree->private_data, start, end);
 }
 
 /* find the first state struct with 'bits' set after 'start', and
@@ -2418,7 +2397,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	pr_debug("Repair Read Error: submitting new read[%#x] to this_mirror=%d, in_validation=%d\n",
 		 read_mode, failrec->this_mirror, failrec->in_validation);
 
-	ret = tree->ops->submit_bio_hook(inode, bio, failrec->this_mirror,
+	ret = tree->ops->submit_bio_hook(tree->private_data, bio, failrec->this_mirror,
 					 failrec->bio_flags, 0);
 	if (ret) {
 		free_io_failure(inode, failrec);
@@ -2739,7 +2718,7 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	bio_get(bio);
 
 	if (tree->ops && tree->ops->submit_bio_hook)
-		ret = tree->ops->submit_bio_hook(page->mapping->host, bio,
+		ret = tree->ops->submit_bio_hook(tree->private_data, bio,
 					   mirror_num, bio_flags, start);
 	else
 		btrfsic_submit_bio(bio);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index bc2729a..c3dd064 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -63,11 +63,11 @@ struct btrfs_root;
 struct btrfs_io_bio;
 struct io_failure_record;
 
-typedef	int (extent_submit_bio_hook_t)(struct inode *inode, struct bio *bio,
+typedef	int (extent_submit_bio_hook_t)(void *private_data, struct bio *bio,
 				       int mirror_num, unsigned long bio_flags,
 				       u64 bio_offset);
 struct extent_io_ops {
-	int (*fill_delalloc)(struct inode *inode, struct page *locked_page,
+	int (*fill_delalloc)(void *private_data, struct page *locked_page,
 			     u64 start, u64 end, int *page_started,
 			     unsigned long *nr_written);
 	int (*writepage_start_hook)(struct page *page, u64 start, u64 end);
@@ -81,20 +81,24 @@ struct extent_io_ops {
 				    int mirror);
 	int (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
-	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
+	void (*set_bit_hook)(void *private_data, struct extent_state *state,
 			     unsigned *bits);
-	void (*clear_bit_hook)(struct inode *inode, struct extent_state *state,
+	void (*clear_bit_hook)(void *private_data, struct extent_state *state,
 			       unsigned *bits);
-	void (*merge_extent_hook)(struct inode *inode,
+	void (*merge_extent_hook)(void *private_data,
 				  struct extent_state *new,
 				  struct extent_state *other);
-	void (*split_extent_hook)(struct inode *inode,
+	void (*split_extent_hook)(void *private_data,
 				  struct extent_state *orig, u64 split);
+	void (*check_extent_io_range)(void *private_data, const char *caller,
+				      u64 start, u64 end);
+	struct btrfs_fs_info *(*tree_fs_info)(void *private_data);
+	void (*set_range_writeback)(void *private_data, u64 start, u64 end);
 };
 
 struct extent_io_tree {
 	struct rb_root state;
-	struct address_space *mapping;
+	void *private_data;
 	u64 dirty_bytes;
 	int track_uptodate;
 	spinlock_t lock;
@@ -191,8 +195,7 @@ typedef struct extent_map *(get_extent_t)(struct inode *inode,
 					  u64 start, u64 len,
 					  int create);
 
-void extent_io_tree_init(struct extent_io_tree *tree,
-			 struct address_space *mapping);
+void extent_io_tree_init(struct extent_io_tree *tree, void *private_data);
 int try_release_extent_mapping(struct extent_map_tree *map,
 			       struct extent_io_tree *tree, struct page *page,
 			       gfp_t mask);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b0f421f..66b7e0d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1551,10 +1551,11 @@ static inline int need_force_cow(struct inode *inode, u64 start, u64 end)
 /*
  * extent_io.c call back to do delayed allocation processing
  */
-static int run_delalloc_range(struct inode *inode, struct page *locked_page,
+static int run_delalloc_range(void *private_data, struct page *locked_page,
 			      u64 start, u64 end, int *page_started,
 			      unsigned long *nr_written)
 {
+	struct inode *inode = private_data;
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
 
@@ -1576,9 +1577,10 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	return ret;
 }
 
-static void btrfs_split_extent_hook(struct inode *inode,
+static void btrfs_split_extent_hook(void *private_data,
 				    struct extent_state *orig, u64 split)
 {
+	struct inode *inode = private_data;
 	u64 size;
 
 	/* not delalloc, ignore it */
@@ -1616,10 +1618,11 @@ static void btrfs_split_extent_hook(struct inode *inode,
  * extents, such as when we are doing sequential writes, so we can properly
  * account for the metadata space we'll need.
  */
-static void btrfs_merge_extent_hook(struct inode *inode,
+static void btrfs_merge_extent_hook(void *private_data,
 				    struct extent_state *new,
 				    struct extent_state *other)
 {
+	struct inode *inode = private_data;
 	u64 new_size, old_size;
 	u64 num_extents;
 
@@ -1719,9 +1722,10 @@ static void btrfs_del_delalloc_inode(struct btrfs_root *root,
  * bytes in this file, and to maintain the list of inodes that
  * have pending delalloc work to be done.
  */
-static void btrfs_set_bit_hook(struct inode *inode,
+static void btrfs_set_bit_hook(void *private_data,
 			       struct extent_state *state, unsigned *bits)
 {
+	struct inode *inode = private_data;
 
 	if ((*bits & EXTENT_DEFRAG) && !(*bits & EXTENT_DELALLOC))
 		WARN_ON(1);
@@ -1763,10 +1767,12 @@ static void btrfs_set_bit_hook(struct inode *inode,
 /*
  * extent_io.c clear_bit_hook, see set_bit_hook for why
  */
-static void btrfs_clear_bit_hook(struct inode *inode,
+static void btrfs_clear_bit_hook(void *private_data,
 				 struct extent_state *state,
 				 unsigned *bits)
 {
+	struct inode *inode = private_data;
+
 	u64 len = state->end + 1 - state->start;
 	u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE -1,
 				    BTRFS_MAX_EXTENT_SIZE);
@@ -1863,10 +1869,11 @@ int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
  * At IO completion time the cums attached on the ordered extent record
  * are inserted into the btree
  */
-static int __btrfs_submit_bio_start(struct inode *inode, struct bio *bio,
+static int __btrfs_submit_bio_start(void *private_data, struct bio *bio,
 				    int mirror_num, unsigned long bio_flags,
 				    u64 bio_offset)
 {
+	struct inode *inode = private_data;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret = 0;
 
@@ -1883,10 +1890,11 @@ static int __btrfs_submit_bio_start(struct inode *inode, struct bio *bio,
  * At IO completion time the cums attached on the ordered extent record
  * are inserted into the btree
  */
-static int __btrfs_submit_bio_done(struct inode *inode, struct bio *bio,
+static int __btrfs_submit_bio_done(void *private_data, struct bio *bio,
 			  int mirror_num, unsigned long bio_flags,
 			  u64 bio_offset)
 {
+	struct inode *inode = private_data;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
@@ -1902,10 +1910,11 @@ static int __btrfs_submit_bio_done(struct inode *inode, struct bio *bio,
  * extent_io.c submission hook. This does the right thing for csum calculation
  * on write, or reading the csums from the tree before a read
  */
-static int btrfs_submit_bio_hook(struct inode *inode, struct bio *bio,
-			  int mirror_num, unsigned long bio_flags,
-			  u64 bio_offset)
+static int btrfs_submit_bio_hook(void *private_data, struct bio *bio,
+				 int mirror_num, unsigned long bio_flags,
+				 u64 bio_offset)
 {
+	struct inode *inode = private_data;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	enum btrfs_wq_endio_type metadata = BTRFS_WQ_ENDIO_DATA;
 	int ret = 0;
@@ -1939,10 +1948,10 @@ static int btrfs_submit_bio_hook(struct inode *inode, struct bio *bio,
 			goto mapit;
 		/* we're doing a write, do the async checksumming */
 		ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
-				   inode, bio, mirror_num,
-				   bio_flags, bio_offset,
-				   __btrfs_submit_bio_start,
-				   __btrfs_submit_bio_done);
+					  bio, mirror_num, bio_flags,
+					  bio_offset, inode,
+					  __btrfs_submit_bio_start,
+					  __btrfs_submit_bio_done);
 		goto out;
 	} else if (!skip_sum) {
 		ret = btrfs_csum_one_bio(root, inode, bio, 0, 0);
@@ -8190,11 +8199,12 @@ static void btrfs_endio_direct_write(struct bio *bio)
 	bio_put(bio);
 }
 
-static int __btrfs_submit_bio_start_direct_io(struct inode *inode,
+static int __btrfs_submit_bio_start_direct_io(void *private_data,
 				    struct bio *bio, int mirror_num,
 				    unsigned long bio_flags, u64 offset)
 {
 	int ret;
+	struct inode *inode = private_data;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	ret = btrfs_csum_one_bio(root, inode, bio, offset, 1);
 	BUG_ON(ret); /* -ENOMEM */
@@ -8307,10 +8317,10 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 		goto map;
 
 	if (write && async_submit) {
-		ret = btrfs_wq_submit_bio(root->fs_info,
-				   inode, bio, 0, 0, file_offset,
-				   __btrfs_submit_bio_start_direct_io,
-				   __btrfs_submit_bio_done);
+		ret = btrfs_wq_submit_bio(root->fs_info, bio, 0, 0,
+					  file_offset, inode,
+					  __btrfs_submit_bio_start_direct_io,
+					  __btrfs_submit_bio_done);
 		goto err;
 	} else if (write) {
 		/*
@@ -9274,8 +9284,8 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 
 	inode = &ei->vfs_inode;
 	extent_map_tree_init(&ei->extent_tree);
-	extent_io_tree_init(&ei->io_tree, &inode->i_data);
-	extent_io_tree_init(&ei->io_failure_tree, &inode->i_data);
+	extent_io_tree_init(&ei->io_tree, inode);
+	extent_io_tree_init(&ei->io_failure_tree, inode);
 	ei->io_tree.track_uptodate = 1;
 	ei->io_failure_tree.track_uptodate = 1;
 	atomic_set(&ei->sync_writers, 0);
@@ -10515,6 +10525,42 @@ int btrfs_inode_check_errors(struct inode *inode)
 	return ret;
 }
 
+static struct btrfs_fs_info *iotree_fs_info(void *private_data)
+{
+	struct inode *inode = private_data;
+	return btrfs_sb(inode->i_sb);
+}
+
+static void btrfs_check_extent_io_range(void *private_data, const char *caller,
+					u64 start, u64 end)
+{
+	struct inode *inode = private_data;
+	u64 isize;
+
+	isize = i_size_read(inode);
+	if (end >= PAGE_SIZE && (end % 2) == 0 && end != isize - 1) {
+		btrfs_debug_rl(BTRFS_I(inode)->root->fs_info,
+		    "%s: ino %llu isize %llu odd range [%llu,%llu]",
+				caller, btrfs_ino(inode), isize, start, end);
+	}
+}
+
+void btrfs_set_range_writeback(void *private_data, u64 start, u64 end)
+{
+	struct inode *inode = private_data;
+	unsigned long index = start >> PAGE_SHIFT;
+	unsigned long end_index = end >> PAGE_SHIFT;
+	struct page *page;
+
+	while (index <= end_index) {
+		page = find_get_page(inode->i_mapping, index);
+		ASSERT(page); /* Pages should be in the extent_io_tree */
+		set_page_writeback(page);
+		put_page(page);
+		index++;
+	}
+}
+
 static const struct inode_operations btrfs_dir_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.lookup		= btrfs_lookup,
@@ -10568,6 +10614,9 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.clear_bit_hook = btrfs_clear_bit_hook,
 	.merge_extent_hook = btrfs_merge_extent_hook,
 	.split_extent_hook = btrfs_split_extent_hook,
+	.check_extent_io_range = btrfs_check_extent_io_range,
+	.tree_fs_info = iotree_fs_info,
+	.set_range_writeback = btrfs_set_range_writeback,
 };
 
 /*
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 6e194a5..7fc6ea7 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4203,8 +4203,7 @@ static struct reloc_control *alloc_reloc_control(struct btrfs_fs_info *fs_info)
 	INIT_LIST_HEAD(&rc->reloc_roots);
 	backref_cache_init(&rc->backref_cache);
 	mapping_tree_init(&rc->reloc_root_tree);
-	extent_io_tree_init(&rc->processed_blocks,
-			    fs_info->btree_inode->i_mapping);
+	extent_io_tree_init(&rc->processed_blocks, NULL);
 	return rc;
 }
 
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index d19ab03..1110b8c 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -87,7 +87,7 @@ static int test_find_delalloc(u32 sectorsize)
 		return -ENOMEM;
 	}
 
-	extent_io_tree_init(&tmp, &inode->i_data);
+	extent_io_tree_init(&tmp, inode);
 
 	/*
 	 * First go through and create and mark all of our pages dirty, we pin
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9cca0a7..9de37b5 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -294,7 +294,7 @@ loop:
 	spin_lock_init(&cur_trans->dropped_roots_lock);
 	list_add_tail(&cur_trans->list, &fs_info->trans_list);
 	extent_io_tree_init(&cur_trans->dirty_pages,
-			     fs_info->btree_inode->i_mapping);
+			     fs_info->btree_inode);
 	fs_info->generation++;
 	cur_trans->transid = fs_info->generation;
 	fs_info->running_transaction = cur_trans;
-- 
2.7.4

