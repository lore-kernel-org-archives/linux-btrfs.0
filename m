Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56756 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161155AbaKNPkG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 10:40:06 -0500
Received: from /spool/local
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sat, 15 Nov 2014 01:40:04 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id C9DB22CE805D
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:40:02 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sAEFfoMY41025654
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:41:58 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sAEFdTFC022123
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Nov 2014 02:39:30 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com, steve.capper@linaro.org
Subject: [RFC PATCH V9 17/17] Btrfs: subpagesize-blocksize: Prevent writes to an extent buffer when PG_writeback flag is set.
Date: Fri, 14 Nov 2014 21:08:19 +0530
Message-Id: <1415979499-15821-18-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1415979499-15821-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1415979499-15821-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In non-subpagesize-blocksize scenario, BTRFS_HEADER_FLAG_WRITTEN flag prevents
Btrfs code from writing into an extent buffer whose pages are under
writeback. This facility isn't sufficient for achieving the same in
subpagesize-blocksize scenario, since we have more than one extent buffer
mapped to a page.

Hence this patch adds a new flag (i.e. EXTENT_BUFFER_HEAD_WRITEBACK) and
corresponding code to track the writeback status of the page and to prevent
writes to any of the extent buffers mapped to the page while writeback is
going on.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.c       |  20 ++++++-
 fs/btrfs/extent-tree.c |  12 ++++
 fs/btrfs/extent_io.c   | 153 +++++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/extent_io.h   |   2 +
 4 files changed, 157 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 693b541..75129da 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1543,6 +1543,7 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		    struct extent_buffer *parent, int parent_slot,
 		    struct extent_buffer **cow_ret)
 {
+	struct extent_buffer_head *ebh = eb_head(buf);
 	u64 search_start;
 	int ret;
 
@@ -1556,6 +1557,13 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		       trans->transid, root->fs_info->generation);
 
 	if (!should_cow_block(trans, root, buf)) {
+		if (test_bit(EXTENT_BUFFER_HEAD_WRITEBACK, &ebh->bflags)) {
+			if (parent)
+				btrfs_set_lock_blocking(parent);
+			btrfs_set_lock_blocking(buf);
+			wait_on_bit(&ebh->bflags, EXTENT_BUFFER_HEAD_WRITEBACK,
+				eb_wait, TASK_UNINTERRUPTIBLE);
+		}
 		*cow_ret = buf;
 		return 0;
 	}
@@ -2687,6 +2695,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_path *p, int
 		      ins_len, int cow)
 {
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *b;
 	int slot;
 	int ret;
@@ -2789,8 +2798,17 @@ again:
 			 * then we don't want to set the path blocking,
 			 * so we test it here
 			 */
-			if (!should_cow_block(trans, root, b))
+			if (!should_cow_block(trans, root, b)) {
+				ebh = eb_head(b);
+				if (test_bit(EXTENT_BUFFER_HEAD_WRITEBACK,
+						&ebh->bflags)) {
+					btrfs_set_path_blocking(p);
+					wait_on_bit(&ebh->bflags,
+						EXTENT_BUFFER_HEAD_WRITEBACK,
+						eb_wait, TASK_UNINTERRUPTIBLE);
+				}
 				goto cow_done;
+			}
 
 			btrfs_set_path_blocking(p);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fbcad82..fb5cc46 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7203,14 +7203,26 @@ static struct extent_buffer *
 btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      u64 bytenr, u32 blocksize, int level)
 {
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *buf;
 
 	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
+
+	ebh = eb_head(buf);
 	btrfs_set_header_generation(buf, trans->transid);
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
 	btrfs_tree_lock(buf);
+
+	if (test_bit(EXTENT_BUFFER_HEAD_WRITEBACK,
+			&ebh->bflags)) {
+		btrfs_set_lock_blocking(buf);
+		wait_on_bit(&ebh->bflags,
+			EXTENT_BUFFER_HEAD_WRITEBACK,
+			eb_wait, TASK_UNINTERRUPTIBLE);
+	}
+
 	clean_tree_block(trans, root, buf);
 	clear_bit(EXTENT_BUFFER_STALE, &buf->ebflags);
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3649c5d..ff51cfa 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3422,7 +3422,7 @@ done_unlocked:
 	return 0;
 }
 
-static int eb_wait(void *word)
+int eb_wait(void *word)
 {
 	io_schedule();
 	return 0;
@@ -3434,6 +3434,52 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 		    TASK_UNINTERRUPTIBLE);
 }
 
+static void lock_extent_buffers(struct extent_buffer_head *ebh,
+				struct extent_page_data *epd)
+{
+	struct extent_buffer *locked_eb = NULL;
+	struct extent_buffer *eb;
+again:
+	eb = &ebh->eb;
+	do {
+		if (eb == locked_eb)
+			continue;
+
+		if (!btrfs_try_tree_write_lock(eb))
+			goto backoff;
+
+	} while ((eb = eb->eb_next) != NULL);
+
+	return;
+
+backoff:
+	if (locked_eb && (locked_eb->start > eb->start))
+		btrfs_tree_unlock(locked_eb);
+
+	locked_eb = eb;
+
+	eb = &ebh->eb;
+	while (eb != locked_eb) {
+		btrfs_tree_unlock(eb);
+		eb = eb->eb_next;
+	}
+
+	flush_write_bio(epd);
+
+	btrfs_tree_lock(locked_eb);
+
+	goto again;
+}
+
+static void unlock_extent_buffers(struct extent_buffer_head *ebh)
+{
+	struct extent_buffer *eb = &ebh->eb;
+
+	do {
+		btrfs_tree_unlock(eb);
+	} while ((eb = eb->eb_next) != NULL);
+}
+
 static void lock_extent_buffer_pages(struct extent_buffer_head *ebh,
 				struct extent_page_data *epd)
 {
@@ -3454,21 +3500,17 @@ static void lock_extent_buffer_pages(struct extent_buffer_head *ebh,
 }
 
 static int noinline_for_stack
-lock_extent_buffer_for_io(struct extent_buffer *eb,
+mark_extent_buffer_writeback(struct extent_buffer *eb,
 			struct btrfs_fs_info *fs_info,
 			struct extent_page_data *epd)
 {
+	struct extent_buffer_head *ebh = eb_head(eb);
+	struct extent_buffer *cur;
 	int dirty;
 	int ret = 0;
 
-	if (!btrfs_try_tree_write_lock(eb)) {
-		flush_write_bio(epd);
-		btrfs_tree_lock(eb);
-	}
-
 	if (test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags)) {
 		dirty = test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags);
-		btrfs_tree_unlock(eb);
 		if (!epd->sync_io) {
 			if (!dirty)
 				return 1;
@@ -3476,15 +3518,23 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 				return 2;
 		}
 
+		cur = &ebh->eb;
+		do {
+			btrfs_set_lock_blocking(cur);
+		} while ((cur = cur->eb_next) != NULL);
+
 		flush_write_bio(epd);
 
 		while (1) {
 			wait_on_extent_buffer_writeback(eb);
-			btrfs_tree_lock(eb);
 			if (!test_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags))
 				break;
-			btrfs_tree_unlock(eb);
 		}
+
+		cur = &ebh->eb;
+		do {
+			btrfs_clear_lock_blocking(cur);
+		} while ((cur = cur->eb_next) != NULL);
 	}
 
 	/*
@@ -3492,22 +3542,20 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 	 * under IO since we can end up having no IO bits set for a short period
 	 * of time.
 	 */
-	spin_lock(&eb_head(eb)->refs_lock);
+	spin_lock(&ebh->refs_lock);
 	if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags)) {
 		set_bit(EXTENT_BUFFER_WRITEBACK, &eb->ebflags);
-		spin_unlock(&eb_head(eb)->refs_lock);
+		spin_unlock(&ebh->refs_lock);
 		btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
 		__percpu_counter_add(&fs_info->dirty_metadata_bytes,
 				     -eb->len,
 				     fs_info->dirty_metadata_batch);
 		ret = 0;
 	} else {
-		spin_unlock(&eb_head(eb)->refs_lock);
+		spin_unlock(&ebh->refs_lock);
 		ret = 1;
 	}
 
-	btrfs_tree_unlock(eb);
-
 	return ret;
 }
 
@@ -3607,8 +3655,8 @@ static void end_extent_buffer_writeback(struct extent_buffer *eb)
 
 static void end_bio_subpagesize_blocksize_ebh_writepage(struct bio *bio, int err)
 {
-	struct bio_vec *bvec;
 	struct extent_buffer *eb;
+	struct bio_vec *bvec;
 	int i, done;
 
 	bio_for_each_segment_all(bvec, bio, i) {
@@ -3636,9 +3684,17 @@ static void end_bio_subpagesize_blocksize_ebh_writepage(struct bio *bio, int err
 
 			end_extent_buffer_writeback(eb);
 
-			if (done)
+			if (done) {
+				struct extent_buffer_head *ebh = eb_head(eb);
+
 				end_page_writeback(page);
 
+				clear_bit(EXTENT_BUFFER_HEAD_WRITEBACK,
+					&ebh->bflags);
+				smp_mb__after_atomic();
+				wake_up_bit(&ebh->bflags,
+					EXTENT_BUFFER_HEAD_WRITEBACK);
+			}
 		} while ((eb = eb->eb_next) != NULL);
 
 	}
@@ -3648,6 +3704,7 @@ static void end_bio_subpagesize_blocksize_ebh_writepage(struct bio *bio, int err
 
 static void end_bio_regular_ebh_writepage(struct bio *bio, int err)
 {
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *eb;
 	struct bio_vec *bvec;
 	int i, done;
@@ -3657,6 +3714,8 @@ static void end_bio_regular_ebh_writepage(struct bio *bio, int err)
 
 		eb = (struct extent_buffer *)page->private;
 		BUG_ON(!eb);
+		ebh = eb_head(eb);
+
 		done = atomic_dec_and_test(&eb_head(eb)->io_bvecs);
 
 		if (err || test_bit(EXTENT_BUFFER_IOERR, &eb->ebflags)) {
@@ -3671,6 +3730,10 @@ static void end_bio_regular_ebh_writepage(struct bio *bio, int err)
 			continue;
 
 		end_extent_buffer_writeback(eb);
+
+		clear_bit(EXTENT_BUFFER_HEAD_WRITEBACK, &ebh->bflags);
+		smp_mb__after_atomic();
+		wake_up_bit(&ebh->bflags, EXTENT_BUFFER_HEAD_WRITEBACK);
 	}
 
 	bio_put(bio);
@@ -3712,8 +3775,14 @@ write_regular_ebh(struct extent_buffer_head *ebh,
 			set_bit(EXTENT_BUFFER_IOERR, &eb->ebflags);
 			SetPageError(p);
 			if (atomic_sub_and_test(num_pages - i,
-							&eb_head(eb)->io_bvecs))
+							&ebh->io_bvecs)) {
 				end_extent_buffer_writeback(eb);
+				clear_bit(EXTENT_BUFFER_HEAD_WRITEBACK,
+					&ebh->bflags);
+				smp_mb__after_atomic();
+				wake_up_bit(&ebh->bflags,
+					EXTENT_BUFFER_HEAD_WRITEBACK);
+			}
 			ret = -EIO;
 			break;
 		}
@@ -3746,6 +3815,7 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
 	unsigned long i;
 	unsigned long bio_flags = 0;
 	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
+	int nr_eb_submitted = 0;
 	int ret = 0, err = 0;
 
 	eb = &ebh->eb;
@@ -3758,7 +3828,7 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
 			continue;
 
 		clear_bit(EXTENT_BUFFER_IOERR, &eb->ebflags);
-		atomic_inc(&eb_head(eb)->io_bvecs);
+		atomic_inc(&ebh->io_bvecs);
 
 		if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
 			bio_flags = EXTENT_BIO_TREE_LOG;
@@ -3777,6 +3847,8 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
 			atomic_dec(&eb_head(eb)->io_bvecs);
 			end_extent_buffer_writeback(eb);
 			err = -EIO;
+		} else {
+			++nr_eb_submitted;
 		}
 	} while ((eb = eb->eb_next) != NULL);
 
@@ -3784,6 +3856,12 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
 		update_nr_written(p, wbc, 1);
 	}
 
+	if (!nr_eb_submitted) {
+		clear_bit(EXTENT_BUFFER_HEAD_WRITEBACK, &ebh->bflags);
+		smp_mb__after_atomic();
+		wake_up_bit(&ebh->bflags, EXTENT_BUFFER_HEAD_WRITEBACK);
+	}
+
 	unlock_page(p);
 
 	return ret;
@@ -3895,24 +3973,31 @@ retry:
 
 			j = 0;
 			ebs_to_write = dirty_ebs = 0;
+
+			lock_extent_buffers(ebh, &epd);
+
+			set_bit(EXTENT_BUFFER_HEAD_WRITEBACK, &ebh->bflags);
+
 			eb = &ebh->eb;
 			do {
 				BUG_ON(j >= BITS_PER_LONG);
 
-				ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
+				ret = mark_extent_buffer_writeback(eb, fs_info,
+								&epd);
 				switch (ret) {
 				case 0:
 					/*
-					  EXTENT_BUFFER_DIRTY was set and we were able to
-					  clear it.
+					  EXTENT_BUFFER_DIRTY was set and we were
+					  able to clear it.
 					*/
 					set_bit(j, &ebs_to_write);
 					break;
 				case 2:
 					/*
-					  EXTENT_BUFFER_DIRTY was set, but we were unable
-					  to clear EXTENT_BUFFER_WRITEBACK that was set
-					  before we got the extent buffer locked.
+					  EXTENT_BUFFER_DIRTY was set, but we were
+					  unable to clear EXTENT_BUFFER_WRITEBACK
+					  that was set before we got the extent
+					  buffer locked.
 					 */
 					set_bit(j, &dirty_ebs);
 				default:
@@ -3926,22 +4011,32 @@ retry:
 
 			ret = 0;
 
+			unlock_extent_buffers(ebh);
+
 			if (!ebs_to_write) {
+				clear_bit(EXTENT_BUFFER_HEAD_WRITEBACK,
+					&ebh->bflags);
+				smp_mb__after_atomic();
+				wake_up_bit(&ebh->bflags,
+					EXTENT_BUFFER_HEAD_WRITEBACK);
 				free_extent_buffer(&ebh->eb);
 				continue;
 			}
 
 			/*
-			  Now that we know that atleast one of the extent buffer
+			  Now that we know that atleast one of the extent buffers
 			  belonging to the extent buffer head must be written to
 			  the disk, lock the extent_buffer_head's pages.
 			 */
 			lock_extent_buffer_pages(ebh, &epd);
 
 			if (ebh->eb.len < PAGE_CACHE_SIZE) {
-				ret = write_subpagesize_blocksize_ebh(ebh, fs_info, wbc, &epd, ebs_to_write);
+				ret = write_subpagesize_blocksize_ebh(ebh, fs_info,
+								wbc, &epd,
+								ebs_to_write);
 				if (dirty_ebs) {
-					redirty_extent_buffer_pages_for_writepage(&ebh->eb, wbc);
+					redirty_extent_buffer_pages_for_writepage(&ebh->eb,
+										wbc);
 				}
 			} else {
 				ret = write_regular_ebh(ebh, fs_info, wbc, &epd);
@@ -5189,7 +5284,7 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
 
 static int page_ebs_clean(struct extent_buffer_head *ebh)
 {
-	struct extent_buffer *eb = &ebh->eb;;
+	struct extent_buffer *eb = &ebh->eb;
 
 	do {
 		if (test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags))
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ec12455..c8f39ed 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -44,6 +44,7 @@
 #define EXTENT_BUFFER_IOERR 8
 #define EXTENT_BUFFER_DUMMY 9
 #define EXTENT_BUFFER_IN_TREE 10
+#define EXTENT_BUFFER_HEAD_WRITEBACK 11
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define PAGE_UNLOCK		(1 << 0)
@@ -301,6 +302,7 @@ void free_extent_buffer_stale(struct extent_buffer *eb);
 int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     struct extent_buffer *eb, u64 start, int wait,
 			     get_extent_t *get_extent, int mirror_num);
+int eb_wait(void *word);
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
 
 static inline unsigned long num_extent_pages(u64 start, u64 len)
-- 
2.1.0

