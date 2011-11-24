From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 18/99] btrfs: set_extent_bit should return void with __GFP_WAIT set
Date: Wed, 23 Nov 2011 19:35:51 -0500
Message-ID: <20111124004221.903195233@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 Now that allocations that are allowed to sleep can't fail,
 set_extent_bit has no more error conditions and we can assume the
 return value will be 0 and return void to callers.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h     |    4 +-
 fs/btrfs/disk-io.c   |    5 +-
 fs/btrfs/disk-io.h   |    2 -
 fs/btrfs/extent_io.c |   90 ++++++++++++++++++++++++++++-----------------------
 fs/btrfs/extent_io.h |   34 +++++++++++--------
 fs/btrfs/file.c      |    6 ---
 fs/btrfs/inode.c     |   38 +++++----------------
 fs/btrfs/scrub.c     |   11 +-----
 8 files changed, 89 insertions(+), 101 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2675,8 +2675,8 @@ int btrfs_truncate_inode_items(struct bt
 			       u32 min_type);
 
 int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
-int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
-			      struct extent_state **cached_state);
+void btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
+			       struct extent_state **cached_state);
 int btrfs_writepages(struct address_space *mapping,
 		     struct writeback_control *wbc);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2971,11 +2971,10 @@ int btrfs_buffer_uptodate(struct extent_
 	return !ret;
 }
 
-int btrfs_set_buffer_uptodate(struct extent_buffer *buf)
+void btrfs_set_buffer_uptodate(struct extent_buffer *buf)
 {
 	struct inode *btree_inode = buf->first_page->mapping->host;
-	return set_extent_buffer_uptodate(&BTRFS_I(btree_inode)->io_tree,
-					  buf);
+	set_extent_buffer_uptodate(&BTRFS_I(btree_inode)->io_tree, buf);
 }
 
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -67,7 +67,7 @@ void __btrfs_btree_balance_dirty(struct
 int btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid);
-int btrfs_set_buffer_uptodate(struct extent_buffer *buf);
+void btrfs_set_buffer_uptodate(struct extent_buffer *buf);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
 u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, char *result);
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -953,12 +953,24 @@ search_again:
 	goto again;
 }
 
-int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
-		   u64 *failed_start, struct extent_state **cached_state,
-		   gfp_t mask)
+int set_extent_bit_atomic(struct extent_io_tree *tree, u64 start, u64 end,
+			  int bits, u64 *failed_start,
+			  struct extent_state **cached_state, gfp_t mask)
+{
+	WARN_ON(mask & __GFP_WAIT);
+	return __set_extent_bit(tree, start, end, bits, 0, failed_start,
+				cached_state, mask);
+}
+
+void set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
+		    u64 *failed_start, struct extent_state **cached_state,
+		    gfp_t mask)
 {
-	return __set_extent_bit(tree, start, end, bits, 0,
-				failed_start, cached_state, mask);
+	int ret;
+	WARN_ON(!(mask & __GFP_WAIT));
+	ret = __set_extent_bit(tree, start, end, bits, 0,
+			       failed_start, cached_state, mask);
+	BUG_ON(ret < 0);
 }
 
 int set_extent_bit_excl(struct extent_io_tree *tree, u64 start, u64 end,
@@ -1155,18 +1167,16 @@ search_again:
 }
 
 /* wrappers around set/clear extent bit */
-int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
-		     gfp_t mask)
+void set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
+		      gfp_t mask)
 {
-	return set_extent_bit(tree, start, end, EXTENT_DIRTY, NULL,
-			      NULL, mask);
+	set_extent_bit(tree, start, end, EXTENT_DIRTY, NULL, NULL, mask);
 }
 
-int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		    int bits, gfp_t mask)
+void set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
+		     int bits, gfp_t mask)
 {
-	return set_extent_bit(tree, start, end, bits, NULL,
-			      NULL, mask);
+	set_extent_bit(tree, start, end, bits, NULL, NULL, mask);
 }
 
 void clear_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
@@ -1182,12 +1192,11 @@ void clear_extent_bits(struct extent_io_
 	clear_extent_bit(tree, start, end, bits, 0, 0, NULL);
 }
 
-int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
-			struct extent_state **cached_state, gfp_t mask)
+void set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
+			 struct extent_state **cached_state, gfp_t mask)
 {
-	return set_extent_bit(tree, start, end,
-			      EXTENT_DELALLOC | EXTENT_UPTODATE,
-			      NULL, cached_state, mask);
+	set_extent_bit(tree, start, end, EXTENT_DELALLOC | EXTENT_UPTODATE,
+		       NULL, cached_state, mask);
 }
 
 void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end)
@@ -1196,18 +1205,24 @@ void clear_extent_dirty(struct extent_io
 			 EXTENT_DO_ACCOUNTING, 0, 0, NULL);
 }
 
-int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
-		     gfp_t mask)
+void set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
+		    gfp_t mask)
 {
-	return set_extent_bit(tree, start, end, EXTENT_NEW, NULL,
-			      NULL, mask);
+	set_extent_bit(tree, start, end, EXTENT_NEW, NULL, NULL, mask);
 }
 
-int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
-			struct extent_state **cached_state, gfp_t mask)
+int set_extent_uptodate_atomic(struct extent_io_tree *tree, u64 start, u64 end,
+			       struct extent_state **cached_state, gfp_t mask)
 {
-	return set_extent_bit(tree, start, end, EXTENT_UPTODATE,
-			      NULL, cached_state, mask);
+	return set_extent_bit_atomic(tree, start, end, EXTENT_UPTODATE, NULL,
+				     cached_state, mask);
+}
+
+void set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
+			 struct extent_state **cached_state, gfp_t mask)
+{
+	set_extent_bit(tree, start, end, EXTENT_UPTODATE, NULL, cached_state,
+		       mask);
 }
 
 static void clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
@@ -2107,19 +2122,16 @@ static int bio_readpage_error(struct bio
 		free_extent_map(em);
 
 		/* set the bits in the private failure tree */
-		ret = set_extent_bits(failure_tree, start, end,
-					EXTENT_LOCKED | EXTENT_DIRTY, GFP_NOFS);
-		if (ret >= 0)
-			ret = set_state_private(failure_tree, start,
-						(u64)(unsigned long)failrec);
-		/* set the bits in the inode's tree */
-		if (ret >= 0)
-			ret = set_extent_bits(tree, start, end, EXTENT_DAMAGED,
-						GFP_NOFS);
+		set_extent_bits(failure_tree, start, end,
+				EXTENT_LOCKED | EXTENT_DIRTY, GFP_NOFS);
+		ret = set_state_private(failure_tree, start,
+					(u64)(unsigned long)failrec);
 		if (ret < 0) {
 			kfree(failrec);
 			return ret;
 		}
+		/* set the bits in the inode's tree */
+		set_extent_bits(tree, start, end, EXTENT_DAMAGED, GFP_NOFS);
 	} else {
 		failrec = (struct io_failure_record *)(unsigned long)private;
 		pr_debug("bio_readpage_error: (found) logical=%llu, "
@@ -2375,8 +2387,9 @@ static void end_bio_extent_readpage(stru
 		}
 
 		if (uptodate) {
-			set_extent_uptodate(tree, start, end, &cached,
-					    GFP_ATOMIC);
+			ret = set_extent_uptodate_atomic(tree, start, end,
+							 &cached, GFP_ATOMIC);
+			BUG_ON(ret < 0);
 		}
 		ret = unlock_extent_cached_atomic(tree, start, end, &cached);
 		BUG_ON(ret < 0);
@@ -3919,10 +3932,9 @@ int set_extent_buffer_uptodate(struct ex
 
 	num_pages = num_extent_pages(eb->start, eb->len);
 
-	if (eb_straddles_pages(eb)) {
+	if (eb_straddles_pages(eb))
 		set_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
 				    NULL, GFP_NOFS);
-	}
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
 		if ((i == 0 && (eb->start & (PAGE_CACHE_SIZE - 1))) ||
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -215,27 +215,35 @@ int __must_check clear_extent_bit_atomic
 void clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		      int bits, int wake, int delete,
 		      struct extent_state **cached);
-int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-		    int bits, gfp_t mask);
+void set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
+		     int bits, gfp_t mask);
 int __must_check set_extent_bit_excl(struct extent_io_tree *tree, u64 start,
 				     u64 end, int bits, int exclusive_bits,
 				     u64 *failed_start,
 				     struct extent_state **cached_state,
 				     gfp_t mask);
-int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
-		   int bits, u64 *failed_start,
-		   struct extent_state **cached_state, gfp_t mask);
-int set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
-			struct extent_state **cached_state, gfp_t mask);
-int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
-		   gfp_t mask);
-int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
-		     gfp_t mask);
+int __must_check set_extent_bit_atomic(struct extent_io_tree *tree, u64 start,
+				       u64 end, int bits, u64 *failed_start,
+				       struct extent_state **cached_state,
+				       gfp_t mask);
+void set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end, int bits,
+		    u64 *failed_start, struct extent_state **cached_state,
+		    gfp_t mask);
+int __must_check set_extent_uptodate_atomic(struct extent_io_tree *tree,
+					    u64 start, u64 end,
+					    struct extent_state **cached_state,
+					    gfp_t mask);
+void set_extent_uptodate(struct extent_io_tree *tree, u64 start, u64 end,
+			 struct extent_state **cached_state, gfp_t mask);
+void set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
+		    gfp_t mask);
+void set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
+		      gfp_t mask);
 void clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end);
 int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       int bits, int clear_bits, gfp_t mask);
-int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
-			struct extent_state **cached_state, gfp_t mask);
+void set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
+			 struct extent_state **cached_state, gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, int bits);
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -390,7 +390,6 @@ int btrfs_dirty_pages(struct btrfs_root
 		      loff_t pos, size_t write_bytes,
 		      struct extent_state **cached)
 {
-	int err = 0;
 	int i;
 	u64 num_bytes;
 	u64 start_pos;
@@ -403,10 +402,7 @@ int btrfs_dirty_pages(struct btrfs_root
 		    root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
 
 	end_of_last_block = start_pos + num_bytes - 1;
-	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
-					cached);
-	if (err)
-		return err;
+	btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block, cached);
 
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = pages[i];
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1530,13 +1530,13 @@ static noinline int add_pending_csums(st
 	return 0;
 }
 
-int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
-			      struct extent_state **cached_state)
+void btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
+			       struct extent_state **cached_state)
 {
 	if ((end & (PAGE_CACHE_SIZE - 1)) == 0)
 		WARN_ON(1);
-	return set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
-				   cached_state, GFP_NOFS);
+	set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
+			    cached_state, GFP_NOFS);
 }
 
 /* see btrfs_writepage_start_hook for details on why this is required */
@@ -3248,13 +3248,7 @@ again:
 			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
 			  0, 0, &cached_state);
 
-	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
-					&cached_state);
-	if (ret) {
-		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state);
-		goto out_unlock;
-	}
+	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
 
 	ret = 0;
 	if (offset != PAGE_CACHE_SIZE) {
@@ -4210,7 +4204,7 @@ void btrfs_dirty_inode(struct inode *ino
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
 			printk_ratelimited(KERN_ERR "btrfs: fail to "
-				       "dirty  inode %llu error %ld\n",
+				       "dirty  inode %llu error %ld (trans)\n",
 				       (unsigned long long)btrfs_ino(inode),
 				       PTR_ERR(trans));
 			return;
@@ -6090,15 +6084,8 @@ static ssize_t btrfs_direct_IO(int rw, s
 	 */
 	if (writing) {
 		write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING;
-		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     EXTENT_DELALLOC, NULL, &cached_state,
-				     GFP_NOFS);
-		if (ret) {
-			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-					 lockend, EXTENT_LOCKED | write_bits,
-					 1, 0, &cached_state);
-			goto out;
-		}
+		set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+			       EXTENT_DELALLOC, NULL, &cached_state, GFP_NOFS);
 	}
 
 	free_extent_state(cached_state);
@@ -6340,14 +6327,7 @@ again:
 			  EXTENT_DIRTY | EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING,
 			  0, 0, &cached_state);
 
-	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
-					&cached_state);
-	if (ret) {
-		unlock_extent_cached(io_tree, page_start, page_end,
-				     &cached_state);
-		ret = VM_FAULT_SIGBUS;
-		goto out_unlock;
-	}
+	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
 	ret = 0;
 
 	/* page is wholly or partially inside EOF */
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -424,15 +424,8 @@ static int scrub_fixup_readpage(u64 inum
 		 * will call repair_io_failure for us, we just have to make
 		 * sure we read the bad mirror.
 		 */
-		ret = set_extent_bits(&BTRFS_I(inode)->io_tree, offset, end,
-					EXTENT_DAMAGED, GFP_NOFS);
-		if (ret) {
-			/* set_extent_bits should give proper error */
-			WARN_ON(ret > 0);
-			if (ret > 0)
-				ret = -EFAULT;
-			goto out;
-		}
+		set_extent_bits(&BTRFS_I(inode)->io_tree, offset, end,
+				EXTENT_DAMAGED, GFP_NOFS);
 
 		ret = extent_read_full_page(&BTRFS_I(inode)->io_tree, page,
 						btrfs_get_extent,


