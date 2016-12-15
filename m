Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35566 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbcLONiN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Dec 2016 08:38:13 -0500
Received: by mail-wm0-f67.google.com with SMTP id a20so6565018wme.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Dec 2016 05:38:12 -0800 (PST)
From: Seraphime Kirkovski <kirkseraph@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, jbacik@fb.com, clm@fb.com,
        Seraphime Kirkovski <kirkseraph@gmail.com>
Subject: [PATCH 2/4] Btrfs: coding style fixes
Date: Thu, 15 Dec 2016 14:38:05 +0100
Message-Id: <20161215133805.25681-1-kirkseraph@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This eliminates the rare uses of `unsigned` instead of `unsigned int`.

Signed-off-by: Seraphime Kirkovski <kirkseraph@gmail.com>
---
 fs/btrfs/dir-item.c         |  6 ++---
 fs/btrfs/extent-tree.c      | 20 ++++++++---------
 fs/btrfs/extent_io.c        | 55 +++++++++++++++++++++++----------------------
 fs/btrfs/free-space-cache.c |  4 ++--
 fs/btrfs/inode.c            | 12 +++++-----
 fs/btrfs/send.c             |  6 ++---
 fs/btrfs/super.c            |  4 ++--
 fs/btrfs/volumes.c          |  6 ++---
 8 files changed, 57 insertions(+), 56 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index ae496fd..2d68c17 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -466,7 +466,7 @@ int verify_dir_item(struct btrfs_root *root,
 
 	if (btrfs_dir_name_len(leaf, dir_item) > namelen) {
 		btrfs_crit(root->fs_info, "invalid dir item name len: %u",
-		       (unsigned)btrfs_dir_data_len(leaf, dir_item));
+		       (unsigned int)btrfs_dir_data_len(leaf, dir_item));
 		return 1;
 	}
 
@@ -475,8 +475,8 @@ int verify_dir_item(struct btrfs_root *root,
 	     btrfs_dir_name_len(leaf, dir_item)) > BTRFS_MAX_XATTR_SIZE(root)) {
 		btrfs_crit(root->fs_info,
 			   "invalid dir item name + data len: %u + %u",
-			   (unsigned)btrfs_dir_name_len(leaf, dir_item),
-			   (unsigned)btrfs_dir_data_len(leaf, dir_item));
+			   (unsigned int)btrfs_dir_name_len(leaf, dir_item),
+			   (unsigned int)btrfs_dir_data_len(leaf, dir_item));
 		return 1;
 	}
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e5c19d9..cc82eae 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4106,7 +4106,7 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 
 static u64 get_alloc_profile(struct btrfs_root *root, u64 orig_flags)
 {
-	unsigned seq;
+	unsigned int seq;
 	u64 flags;
 
 	do {
@@ -5863,13 +5863,13 @@ void btrfs_subvolume_release_metadata(struct btrfs_root *root,
  * reserved extents that need to be freed.  This must be called with
  * BTRFS_I(inode)->lock held.
  */
-static unsigned drop_outstanding_extent(struct inode *inode, u64 num_bytes)
+static unsigned int drop_outstanding_extent(struct inode *inode, u64 num_bytes)
 {
-	unsigned drop_inode_space = 0;
-	unsigned dropped_extents = 0;
-	unsigned num_extents = 0;
+	unsigned int drop_inode_space = 0;
+	unsigned int dropped_extents = 0;
+	unsigned int num_extents = 0;
 
-	num_extents = (unsigned)div64_u64(num_bytes +
+	num_extents = (unsigned int)div64_u64(num_bytes +
 					  BTRFS_MAX_EXTENT_SIZE - 1,
 					  BTRFS_MAX_EXTENT_SIZE);
 	ASSERT(num_extents);
@@ -5947,12 +5947,12 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	struct btrfs_block_rsv *block_rsv = &root->fs_info->delalloc_block_rsv;
 	u64 to_reserve = 0;
 	u64 csum_bytes;
-	unsigned nr_extents = 0;
+	unsigned int nr_extents = 0;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
 	bool delalloc_lock = true;
 	u64 to_free = 0;
-	unsigned dropped;
+	unsigned int dropped;
 	bool release_extra = false;
 
 	/* If we are a free space inode we need to not flush since we will be in
@@ -5980,7 +5980,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 
 	spin_lock(&BTRFS_I(inode)->lock);
-	nr_extents = (unsigned)div64_u64(num_bytes +
+	nr_extents = (unsigned int)div64_u64(num_bytes +
 					 BTRFS_MAX_EXTENT_SIZE - 1,
 					 BTRFS_MAX_EXTENT_SIZE);
 	BTRFS_I(inode)->outstanding_extents += nr_extents;
@@ -6108,7 +6108,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 to_free = 0;
-	unsigned dropped;
+	unsigned int dropped;
 
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 	spin_lock(&BTRFS_I(inode)->lock);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b92bcf3..4ffb29a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -131,7 +131,7 @@ struct extent_page_data {
 	unsigned int sync_io:1;
 };
 
-static void add_extent_changeset(struct extent_state *state, unsigned bits,
+static void add_extent_changeset(struct extent_state *state, unsigned int bits,
 				 struct extent_changeset *changeset,
 				 int set)
 {
@@ -413,21 +413,21 @@ static void merge_state(struct extent_io_tree *tree,
 }
 
 static void set_state_cb(struct extent_io_tree *tree,
-			 struct extent_state *state, unsigned *bits)
+			 struct extent_state *state, unsigned int *bits)
 {
 	if (tree->ops && tree->ops->set_bit_hook)
 		tree->ops->set_bit_hook(tree->mapping->host, state, bits);
 }
 
 static void clear_state_cb(struct extent_io_tree *tree,
-			   struct extent_state *state, unsigned *bits)
+			   struct extent_state *state, unsigned int *bits)
 {
 	if (tree->ops && tree->ops->clear_bit_hook)
 		tree->ops->clear_bit_hook(tree->mapping->host, state, bits);
 }
 
 static void set_state_bits(struct extent_io_tree *tree,
-			   struct extent_state *state, unsigned *bits,
+			   struct extent_state *state, unsigned int *bits,
 			   struct extent_changeset *changeset);
 
 /*
@@ -444,7 +444,7 @@ static int insert_state(struct extent_io_tree *tree,
 			struct extent_state *state, u64 start, u64 end,
 			struct rb_node ***p,
 			struct rb_node **parent,
-			unsigned *bits, struct extent_changeset *changeset)
+			unsigned int *bits, struct extent_changeset *changeset)
 {
 	struct rb_node *node;
 
@@ -530,14 +530,15 @@ static struct extent_state *next_state(struct extent_state *state)
  */
 static struct extent_state *clear_state_bit(struct extent_io_tree *tree,
 					    struct extent_state *state,
-					    unsigned *bits, int wake,
+					    unsigned int *bits, int wake,
 					    struct extent_changeset *changeset)
 {
 	struct extent_state *next;
-	unsigned bits_to_clear = *bits & ~EXTENT_CTLBITS;
+	unsigned int bits_to_clear = *bits & ~EXTENT_CTLBITS;
 
 	if ((bits_to_clear & EXTENT_DIRTY) && (state->state & EXTENT_DIRTY)) {
 		u64 range = state->end - state->start + 1;
+
 		WARN_ON(range > tree->dirty_bytes);
 		tree->dirty_bytes -= range;
 	}
@@ -590,7 +591,7 @@ static void extent_io_tree_panic(struct extent_io_tree *tree, int err)
  * This takes the tree lock, and returns 0 on success and < 0 on error.
  */
 static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-			      unsigned bits, int wake, int delete,
+			      unsigned int bits, int wake, int delete,
 			      struct extent_state **cached_state,
 			      gfp_t mask, struct extent_changeset *changeset)
 {
@@ -811,9 +812,9 @@ static void wait_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 static void set_state_bits(struct extent_io_tree *tree,
 			   struct extent_state *state,
-			   unsigned *bits, struct extent_changeset *changeset)
+			   unsigned int *bits, struct extent_changeset *changeset)
 {
-	unsigned bits_to_set = *bits & ~EXTENT_CTLBITS;
+	unsigned int bits_to_set = *bits & ~EXTENT_CTLBITS;
 
 	set_state_cb(tree, state, bits);
 	if ((bits_to_set & EXTENT_DIRTY) && !(state->state & EXTENT_DIRTY)) {
@@ -827,7 +828,7 @@ static void set_state_bits(struct extent_io_tree *tree,
 
 static void cache_state_if_flags(struct extent_state *state,
 				 struct extent_state **cached_ptr,
-				 unsigned flags)
+				 unsigned int flags)
 {
 	if (cached_ptr && !(*cached_ptr)) {
 		if (!flags || (state->state & flags)) {
@@ -857,7 +858,7 @@ static void cache_state(struct extent_state *state,
 
 static int __must_check
 __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		 unsigned bits, unsigned exclusive_bits,
+		 unsigned int bits, unsigned int exclusive_bits,
 		 u64 *failed_start, struct extent_state **cached_state,
 		 gfp_t mask, struct extent_changeset *changeset)
 {
@@ -1064,7 +1065,7 @@ __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 }
 
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   unsigned bits, u64 *failed_start,
+		   unsigned int bits, u64 *failed_start,
 		   struct extent_state **cached_state, gfp_t mask)
 {
 	return __set_extent_bit(tree, start, end, bits, 0, failed_start,
@@ -1091,7 +1092,7 @@ int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
  * All allocations are done with GFP_NOFS.
  */
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		       unsigned bits, unsigned clear_bits,
+		       unsigned int bits, unsigned int clear_bits,
 		       struct extent_state **cached_state)
 {
 	struct extent_state *state;
@@ -1291,7 +1292,7 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 /* wrappers around set/clear extent bit */
 int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-			   unsigned bits, struct extent_changeset *changeset)
+			   unsigned int bits, struct extent_changeset *changeset)
 {
 	/*
 	 * We don't support EXTENT_LOCKED yet, as current changeset will
@@ -1306,7 +1307,7 @@ int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 }
 
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		     unsigned bits, int wake, int delete,
+		     unsigned int bits, int wake, int delete,
 		     struct extent_state **cached, gfp_t mask)
 {
 	return __clear_extent_bit(tree, start, end, bits, wake, delete,
@@ -1314,7 +1315,7 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 }
 
 int clear_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		unsigned bits, struct extent_changeset *changeset)
+		unsigned int bits, struct extent_changeset *changeset)
 {
 	/*
 	 * Don't support EXTENT_LOCKED case, same reason as
@@ -1421,7 +1422,7 @@ static void set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
  */
 static struct extent_state *
 find_first_extent_bit_state(struct extent_io_tree *tree,
-			    u64 start, unsigned bits)
+			    u64 start, unsigned int bits)
 {
 	struct rb_node *node;
 	struct extent_state *state;
@@ -1455,7 +1456,7 @@ find_first_extent_bit_state(struct extent_io_tree *tree,
  * If nothing was found, 1 is returned. If found something, return 0.
  */
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
-			  u64 *start_ret, u64 *end_ret, unsigned bits,
+			  u64 *start_ret, u64 *end_ret, unsigned int bits,
 			  struct extent_state **cached_state)
 {
 	struct extent_state *state;
@@ -1734,7 +1735,7 @@ STATIC u64 find_lock_delalloc_range(struct inode *inode,
 
 void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
 				 u64 delalloc_end, struct page *locked_page,
-				 unsigned clear_bits,
+				 unsigned int clear_bits,
 				 unsigned long page_ops)
 {
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
@@ -1790,7 +1791,7 @@ void extent_clear_unlock_delalloc(struct inode *inode, u64 start, u64 end,
  */
 u64 count_range_bits(struct extent_io_tree *tree,
 		     u64 *start, u64 search_end, u64 max_bytes,
-		     unsigned bits, int contig)
+		     unsigned int bits, int contig)
 {
 	struct rb_node *node;
 	struct extent_state *state;
@@ -1910,7 +1911,7 @@ static noinline int get_state_failrec(struct extent_io_tree *tree, u64 start,
  * range is found set.
  */
 int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   unsigned bits, int filled, struct extent_state *cached)
+		   unsigned int bits, int filled, struct extent_state *cached)
 {
 	struct extent_state *state = NULL;
 	struct rb_node *node;
@@ -2622,7 +2623,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 		if (likely(uptodate)) {
 			loff_t i_size = i_size_read(inode);
 			pgoff_t end_index = i_size >> PAGE_SHIFT;
-			unsigned off;
+			unsigned int off;
 
 			/* Zero out the end if this page straddles i_size */
 			off = i_size & (PAGE_SIZE-1);
@@ -3841,7 +3842,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 	while (!done && !nr_to_write_done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		unsigned i;
+		unsigned int i;
 
 		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
@@ -3989,7 +3990,7 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 	while (!done && !nr_to_write_done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		unsigned i;
+		unsigned int i;
 
 		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
@@ -4188,11 +4189,11 @@ int extent_writepages(struct extent_io_tree *tree,
 
 int extent_readpages(struct extent_io_tree *tree,
 		     struct address_space *mapping,
-		     struct list_head *pages, unsigned nr_pages,
+		     struct list_head *pages, unsigned int nr_pages,
 		     get_extent_t get_extent)
 {
 	struct bio *bio = NULL;
-	unsigned page_idx;
+	unsigned int page_idx;
 	unsigned long bio_flags = 0;
 	struct page *pagepool[16];
 	struct page *page;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 63ef463..4ed604d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -464,7 +464,7 @@ static void io_ctl_set_crc(struct btrfs_io_ctl *io_ctl, int index)
 {
 	u32 *tmp;
 	u32 crc = ~(u32)0;
-	unsigned offset = 0;
+	unsigned int offset = 0;
 
 	if (!io_ctl->check_crcs) {
 		io_ctl_unmap_page(io_ctl);
@@ -487,7 +487,7 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 {
 	u32 *tmp, val;
 	u32 crc = ~(u32)0;
-	unsigned offset = 0;
+	unsigned int offset = 0;
 
 	if (!io_ctl->check_crcs) {
 		io_ctl_map_page(io_ctl, 0);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 14784a2..681ac57 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1785,7 +1785,7 @@ static void btrfs_set_bit_hook(struct inode *inode,
  */
 static void btrfs_clear_bit_hook(struct inode *inode,
 				 struct extent_state *state,
-				 unsigned *bits)
+				 unsigned int *bits)
 {
 	u64 len = state->end + 1 - state->start;
 	u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
@@ -4715,7 +4715,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	char *kaddr;
 	u32 blocksize = root->sectorsize;
 	pgoff_t index = from >> PAGE_SHIFT;
-	unsigned offset = from & (blocksize - 1);
+	unsigned int offset = from & (blocksize - 1);
 	struct page *page;
 	gfp_t mask = btrfs_alloc_write_mask(mapping);
 	int ret = 0;
@@ -7649,9 +7649,9 @@ static void adjust_dio_outstanding_extents(struct inode *inode,
 					   struct btrfs_dio_data *dio_data,
 					   const u64 len)
 {
-	unsigned num_extents;
+	unsigned int num_extents;
 
-	num_extents = (unsigned) div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
+	num_extents = (unsigned int)div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
 					   BTRFS_MAX_EXTENT_SIZE);
 	/*
 	 * If we have an outstanding_extents count still set then we're
@@ -8643,7 +8643,7 @@ static ssize_t check_direct_IO(struct btrfs_root *root, struct kiocb *iocb,
 {
 	int seg;
 	int i;
-	unsigned blocksize_mask = root->sectorsize - 1;
+	unsigned int blocksize_mask = root->sectorsize - 1;
 	ssize_t retval = -EINVAL;
 
 	if (offset & blocksize_mask)
@@ -8831,7 +8831,7 @@ static int btrfs_writepages(struct address_space *mapping,
 
 static int
 btrfs_readpages(struct file *file, struct address_space *mapping,
-		struct list_head *pages, unsigned nr_pages)
+		struct list_head *pages, unsigned int nr_pages)
 {
 	struct extent_io_tree *tree;
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index cceadff..42a6a66 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4604,7 +4604,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 	struct btrfs_key key;
 	pgoff_t index = offset >> PAGE_SHIFT;
 	pgoff_t last_index;
-	unsigned pg_offset = offset & ~PAGE_MASK;
+	unsigned int pg_offset = offset & ~PAGE_MASK;
 	ssize_t ret = 0;
 
 	key.objectid = sctx->cur_ino;
@@ -4633,7 +4633,7 @@ static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
 		       last_index - index + 1);
 
 	while (index <= last_index) {
-		unsigned cur_len = min_t(unsigned, len,
+		unsigned int cur_len = min_t(unsigned int, len,
 					 PAGE_SIZE - pg_offset);
 		page = find_or_create_page(inode->i_mapping, index, GFP_KERNEL);
 		if (!page) {
@@ -6160,7 +6160,7 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	u32 i;
 	u64 *clone_sources_tmp = NULL;
 	int clone_sources_to_rollback = 0;
-	unsigned alloc_size;
+	unsigned int alloc_size;
 	int sort_clone_roots = 0;
 	int index;
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5a58f8a..3e25cfe 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1724,7 +1724,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	struct btrfs_root *root = fs_info->tree_root;
-	unsigned old_flags = sb->s_flags;
+	unsigned int old_flags = sb->s_flags;
 	unsigned long old_opts = fs_info->mount_opt;
 	unsigned long old_compress_type = fs_info->compress_type;
 	u64 old_max_inline = fs_info->max_inline;
@@ -2087,7 +2087,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u64 total_free_meta = 0;
 	int bits = dentry->d_sb->s_blocksize_bits;
 	__be32 *fsid = (__be32 *)fs_info->fsid;
-	unsigned factor = 1;
+	unsigned int factor = 1;
 	struct btrfs_block_rsv *block_rsv = &fs_info->global_block_rsv;
 	int ret;
 	u64 thresh = 0;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9240b78..fe1cfeb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1786,7 +1786,7 @@ static int btrfs_check_raid_min_devices(struct btrfs_fs_info *fs_info,
 		u64 num_devices)
 {
 	u64 all_avail;
-	unsigned seq;
+	unsigned int seq;
 	int i;
 
 	do {
@@ -3769,7 +3769,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	int mixed = 0;
 	int ret;
 	u64 num_devices;
-	unsigned seq;
+	unsigned int seq;
 
 	if (btrfs_fs_closing(fs_info) ||
 	    atomic_read(&fs_info->balance_pause_req) ||
@@ -5675,7 +5675,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int op,
 	    ((op == REQ_OP_WRITE || op == REQ_GET_READ_MIRRORS) ||
 	    mirror_num > 1)) {
 		u64 tmp;
-		unsigned rot;
+		unsigned int rot;
 
 		bbio->raid_map = (u64 *)((void *)bbio->stripes +
 				 sizeof(struct btrfs_bio_stripe) *
-- 
2.10.2

