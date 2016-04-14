Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([125.16.236.6]:58214 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbcDNIdk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 04:33:40 -0400
Received: from localhost
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 14 Apr 2016 14:03:37 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u3E8XubG25100372
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 14:03:56 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u3E8XWDW021620
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 14:03:35 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, dsterba@suse.cz, clm@fb.com,
        jbacik@fb.com, chandan@mykolab.com, aneesh.kumar@linux.vnet.ibm.com
Subject: [PATCH V16 11/18] Btrfs: subpage-blocksize: Prevent writes to an extent buffer when PG_writeback flag is set
Date: Thu, 14 Apr 2016 14:02:48 +0530
Message-Id: <1460622775-20723-12-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1460622775-20723-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1460622775-20723-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In non-subpage-blocksize scenario, BTRFS_HEADER_FLAG_WRITTEN flag
prevents Btrfs code from writing into an extent buffer whose pages are
under writeback. This facility isn't sufficient for achieving the same
in subpage-blocksize scenario, since we have more than one extent buffer
mapped to a page.

Hence this patch adds a new flag (i.e. EXTENT_BUFFER_HEAD_WRITEBACK) and
corresponding code to track the writeback status of the page and to
prevent writes to any of the extent buffers mapped to the page while
writeback is going on.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.c       |  21 ++++++-
 fs/btrfs/extent-tree.c |  11 ++++
 fs/btrfs/extent_io.c   | 150 ++++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/extent_io.h   |   1 +
 fs/btrfs/file.c        |  34 +++++------
 5 files changed, 172 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 23118f4..7d76add 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1539,6 +1539,7 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		    struct extent_buffer *parent, int parent_slot,
 		    struct extent_buffer **cow_ret)
 {
+	struct extent_buffer_head *ebh = eb_head(buf);
 	u64 search_start;
 	int ret;
 
@@ -1552,6 +1553,14 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
 		       trans->transid, root->fs_info->generation);
 
 	if (!should_cow_block(trans, root, buf)) {
+		if (test_bit(EXTENT_BUFFER_HEAD_WRITEBACK, &ebh->bflags)) {
+			if (parent)
+				btrfs_set_lock_blocking(parent);
+			btrfs_set_lock_blocking(buf);
+			wait_on_bit_io(&ebh->bflags,
+				EXTENT_BUFFER_HEAD_WRITEBACK,
+				TASK_UNINTERRUPTIBLE);
+		}
 		*cow_ret = buf;
 		return 0;
 	}
@@ -2671,6 +2680,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_key *key, struct btrfs_path *p, int
 		      ins_len, int cow)
 {
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *b;
 	int slot;
 	int ret;
@@ -2773,8 +2783,17 @@ again:
 			 * then we don't want to set the path blocking,
 			 * so we test it here
 			 */
-			if (!should_cow_block(trans, root, b))
+			if (!should_cow_block(trans, root, b)) {
+				ebh = eb_head(b);
+				if (test_bit(EXTENT_BUFFER_HEAD_WRITEBACK,
+						&ebh->bflags)) {
+					btrfs_set_path_blocking(p);
+					wait_on_bit_io(&ebh->bflags,
+						EXTENT_BUFFER_HEAD_WRITEBACK,
+						TASK_UNINTERRUPTIBLE);
+				}
 				goto cow_done;
+			}
 
 			/*
 			 * must have write locks on this node and the
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b8df911..4625413 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7898,14 +7898,25 @@ static struct extent_buffer *
 btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      u64 bytenr, int level)
 {
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *buf;
 
 	buf = btrfs_find_create_tree_block(root, bytenr);
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
+		wait_on_bit_io(&ebh->bflags, EXTENT_BUFFER_HEAD_WRITEBACK,
+			TASK_UNINTERRUPTIBLE);
+	}
+
 	clean_tree_block(trans, root->fs_info, buf);
 	clear_bit(EXTENT_BUFFER_STALE, &buf->ebflags);
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 98fff69..75221a9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3654,6 +3654,52 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
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
@@ -3673,21 +3719,17 @@ static void lock_extent_buffer_pages(struct extent_buffer_head *ebh,
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
@@ -3695,15 +3737,23 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
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
@@ -3711,22 +3761,20 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
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
 
@@ -3876,8 +3924,8 @@ static void set_btree_ioerr(struct extent_buffer *eb, struct page *page)
 
 static void end_bio_subpagesize_blocksize_ebh_writepage(struct bio *bio)
 {
-	struct bio_vec *bvec;
 	struct extent_buffer *eb;
+	struct bio_vec *bvec;
 	int i, done;
 
 	bio_for_each_segment_all(bvec, bio, i) {
@@ -3909,6 +3957,15 @@ static void end_bio_subpagesize_blocksize_ebh_writepage(struct bio *bio)
 
 			end_extent_buffer_writeback(eb);
 
+			if (done) {
+				struct extent_buffer_head *ebh = eb_head(eb);
+
+				clear_bit(EXTENT_BUFFER_HEAD_WRITEBACK,
+					&ebh->bflags);
+				smp_mb__after_atomic();
+				wake_up_bit(&ebh->bflags,
+					EXTENT_BUFFER_HEAD_WRITEBACK);
+			}
 		} while ((eb = eb->eb_next) != NULL);
 
 	}
@@ -3918,6 +3975,7 @@ static void end_bio_subpagesize_blocksize_ebh_writepage(struct bio *bio)
 
 static void end_bio_regular_ebh_writepage(struct bio *bio)
 {
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *eb;
 	struct bio_vec *bvec;
 	int i, done;
@@ -3928,7 +3986,9 @@ static void end_bio_regular_ebh_writepage(struct bio *bio)
 		eb = (struct extent_buffer *)page->private;
 		BUG_ON(!eb);
 
-		done = atomic_dec_and_test(&eb_head(eb)->io_bvecs);
+		ebh = eb_head(eb);
+
+		done = atomic_dec_and_test(&ebh->io_bvecs);
 
 		if (bio->bi_error ||
 		    test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->ebflags)) {
@@ -3942,6 +4002,10 @@ static void end_bio_regular_ebh_writepage(struct bio *bio)
 			continue;
 
 		end_extent_buffer_writeback(eb);
+
+		clear_bit(EXTENT_BUFFER_HEAD_WRITEBACK, &ebh->bflags);
+		smp_mb__after_atomic();
+		wake_up_bit(&ebh->bflags, EXTENT_BUFFER_HEAD_WRITEBACK);
 	}
 
 	bio_put(bio);
@@ -3983,8 +4047,14 @@ write_regular_ebh(struct extent_buffer_head *ebh,
 			set_btree_ioerr(eb, p);
 			end_page_writeback(p);
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
@@ -4018,6 +4088,7 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
 	unsigned long i;
 	unsigned long bio_flags = 0;
 	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
+	int nr_eb_submitted = 0;
 	int ret = 0, err = 0;
 
 	eb = &ebh->eb;
@@ -4030,7 +4101,7 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
 			continue;
 
 		clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->ebflags);
-		atomic_inc(&eb_head(eb)->io_bvecs);
+		atomic_inc(&ebh->io_bvecs);
 
 		if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
 			bio_flags = EXTENT_BIO_TREE_LOG;
@@ -4048,6 +4119,8 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
 			atomic_dec(&eb_head(eb)->io_bvecs);
 			end_extent_buffer_writeback(eb);
 			err = -EIO;
+		} else {
+			++nr_eb_submitted;
 		}
 	} while ((eb = eb->eb_next) != NULL);
 
@@ -4055,6 +4128,12 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
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
@@ -4166,24 +4245,31 @@ retry:
 
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
@@ -4197,22 +4283,32 @@ retry:
 
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
 
 			if (ebh->eb.len < PAGE_SIZE) {
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
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index db5ebaf..63ad8c0 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -35,6 +35,7 @@
 #define EXTENT_BUFFER_HEAD_TREE_REF 0
 #define EXTENT_BUFFER_HEAD_DUMMY 1
 #define EXTENT_BUFFER_HEAD_IN_TREE 2
+#define EXTENT_BUFFER_HEAD_WRITEBACK 3
 
 /* these are bit numbers for test/set bit on extent buffer */
 #define EXTENT_BUFFER_UPTODATE 0
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a17bcab..8d35c47 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2432,11 +2432,11 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		goto out_only_mutex;
 	}
 
-	start_index = lockstart >> PAGE_CACHE_SHIFT;
-	end_index = lockend >> PAGE_CACHE_SHIFT;
+	start_index = lockstart >> PAGE_SHIFT;
+	end_index = lockend >> PAGE_SHIFT;
 
-	same_page = lockstart >> PAGE_CACHE_SHIFT
-		== lockend >> PAGE_CACHE_SHIFT;
+	same_page = lockstart >> PAGE_SHIFT
+		== lockend >> PAGE_SHIFT;
 
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
@@ -2446,7 +2446,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 		truncate_pagecache_range(inode, lockstart, lockend);
 
-		if (lockstart & (PAGE_CACHE_SIZE - 1)) {
+		if (lockstart & (PAGE_SIZE - 1)) {
 			start_page = find_or_create_page(mapping, start_index,
 							GFP_NOFS);
 			if (!start_page) {
@@ -2455,13 +2455,13 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 			}
 		}
 
-		if (!same_page && ((lockend + 1) & (PAGE_CACHE_SIZE - 1))) {
+		if (!same_page && ((lockend + 1) & (PAGE_SIZE - 1))) {
 			end_page = find_or_create_page(mapping, end_index,
 						GFP_NOFS);
 			if (!end_page) {
 				if (start_page) {
 					unlock_page(start_page);
-					page_cache_release(start_page);
+					put_page(start_page);
 				}
 				mutex_unlock(&inode->i_mutex);
 				return -ENOMEM;
@@ -2478,9 +2478,9 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		 * and nobody raced in and read a page in this range, if we did
 		 * we need to try again.
 		 */
-		nr_pages = round_up(lockend, PAGE_CACHE_SIZE)
-			- round_down(lockstart, PAGE_CACHE_SIZE);
-		nr_pages >>= PAGE_CACHE_SHIFT;
+		nr_pages = round_up(lockend, PAGE_SIZE)
+			- round_down(lockstart, PAGE_SIZE);
+		nr_pages >>= PAGE_SHIFT;
 
 		if ((!ordered ||
 		    (ordered->file_offset + ordered->len <= lockstart ||
@@ -2488,22 +2488,22 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		     (!(start_page && PagePrivate(start_page) &&
 			test_page_blks_state(start_page, 1 << BLK_STATE_UPTODATE,
 			 lockstart,
-			 min(lockstart + PAGE_CACHE_SIZE - 1, lockend), 0)) &&
+			 min(lockstart + PAGE_SIZE - 1, lockend), 0)) &&
 		      !(end_page && PagePrivate(end_page) &&
 			test_page_blks_state(end_page, 1 << BLK_STATE_UPTODATE,
 			 page_offset(end_page), lockend, 0)) &&
 		      !(nr_pages > 2 && btrfs_page_exists_in_range(inode,
-					 round_up(lockstart, PAGE_CACHE_SIZE),
-					 round_down(lockend, PAGE_CACHE_SIZE) - 1)))) {
+					 round_up(lockstart, PAGE_SIZE),
+					 round_down(lockend, PAGE_SIZE) - 1)))) {
 			if (ordered)
 				btrfs_put_ordered_extent(ordered);
 			if (end_page) {
 				unlock_page(end_page);
-				page_cache_release(end_page);
+				put_page(end_page);
 			}
 			if (start_page) {
 				unlock_page(start_page);
-				page_cache_release(start_page);
+				put_page(start_page);
 			}
 			break;
 		}
@@ -2513,11 +2513,11 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 				     lockend, &cached_state, GFP_NOFS);
 		if (end_page) {
 			unlock_page(end_page);
-			page_cache_release(end_page);
+			put_page(end_page);
 		}
 		if (start_page) {
 			unlock_page(start_page);
-			page_cache_release(start_page);
+			put_page(start_page);
 		}
 		ret = btrfs_wait_ordered_range(inode, lockstart,
 					       lockend - lockstart + 1);
-- 
2.1.0

