Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:56925 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaLJNO5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 08:14:57 -0500
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 10 Dec 2014 18:44:54 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id BBCF21258023
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:45:15 +0530 (IST)
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay05.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sBADFScg524720
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:45:28 +0530
Received: from d28av05.in.ibm.com (localhost [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sBADEogx000583
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 18:44:50 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com
Subject: [RFC PATCH V10 17/19] Btrfs: subpagesize-blocksize: Prevent writes to an extent buffer when PG_writeback flag is set.
Date: Wed, 10 Dec 2014 18:44:19 +0530
Message-Id: <1418217261-17273-18-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1418217261-17273-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1418217261-17273-1-git-send-email-chandan@linux.vnet.ibm.com>
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
index bc4dd46..598923c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3448,7 +3448,7 @@ done_unlocked:
 	return 0;
 }
 
-static int eb_wait(void *word)
+int eb_wait(void *word)
 {
 	io_schedule();
 	return 0;
@@ -3460,6 +3460,52 @@ void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
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
@@ -3480,21 +3526,17 @@ static void lock_extent_buffer_pages(struct extent_buffer_head *ebh,
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
@@ -3502,15 +3544,23 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
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
@@ -3518,22 +3568,20 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
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
 
@@ -3632,8 +3680,8 @@ static void end_extent_buffer_writeback(struct extent_buffer *eb)
 
 static void end_bio_subpagesize_blocksize_ebh_writepage(struct bio *bio, int err)
 {
-	struct bio_vec *bvec;
 	struct extent_buffer *eb;
+	struct bio_vec *bvec;
 	int i, done;
 
 	bio_for_each_segment_all(bvec, bio, i) {
@@ -3661,9 +3709,17 @@ static void end_bio_subpagesize_blocksize_ebh_writepage(struct bio *bio, int err
 
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
@@ -3673,6 +3729,7 @@ static void end_bio_subpagesize_blocksize_ebh_writepage(struct bio *bio, int err
 
 static void end_bio_regular_ebh_writepage(struct bio *bio, int err)
 {
+	struct extent_buffer_head *ebh;
 	struct extent_buffer *eb;
 	struct bio_vec *bvec;
 	int i, done;
@@ -3682,6 +3739,8 @@ static void end_bio_regular_ebh_writepage(struct bio *bio, int err)
 
 		eb = (struct extent_buffer *)page->private;
 		BUG_ON(!eb);
+		ebh = eb_head(eb);
+
 		done = atomic_dec_and_test(&eb_head(eb)->io_bvecs);
 
 		if (err || test_bit(EXTENT_BUFFER_IOERR, &eb->ebflags)) {
@@ -3696,6 +3755,10 @@ static void end_bio_regular_ebh_writepage(struct bio *bio, int err)
 			continue;
 
 		end_extent_buffer_writeback(eb);
+
+		clear_bit(EXTENT_BUFFER_HEAD_WRITEBACK, &ebh->bflags);
+		smp_mb__after_atomic();
+		wake_up_bit(&ebh->bflags, EXTENT_BUFFER_HEAD_WRITEBACK);
 	}
 
 	bio_put(bio);
@@ -3737,8 +3800,14 @@ write_regular_ebh(struct extent_buffer_head *ebh,
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
@@ -3771,6 +3840,7 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
 	unsigned long i;
 	unsigned long bio_flags = 0;
 	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
+	int nr_eb_submitted = 0;
 	int ret = 0, err = 0;
 
 	eb = &ebh->eb;
@@ -3783,7 +3853,7 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
 			continue;
 
 		clear_bit(EXTENT_BUFFER_IOERR, &eb->ebflags);
-		atomic_inc(&eb_head(eb)->io_bvecs);
+		atomic_inc(&ebh->io_bvecs);
 
 		if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
 			bio_flags = EXTENT_BIO_TREE_LOG;
@@ -3802,6 +3872,8 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
 			atomic_dec(&eb_head(eb)->io_bvecs);
 			end_extent_buffer_writeback(eb);
 			err = -EIO;
+		} else {
+			++nr_eb_submitted;
 		}
 	} while ((eb = eb->eb_next) != NULL);
 
@@ -3809,6 +3881,12 @@ static int write_subpagesize_blocksize_ebh(struct extent_buffer_head *ebh,
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
@@ -3920,24 +3998,31 @@ retry:
 
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
@@ -3951,22 +4036,32 @@ retry:
 
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
@@ -5214,7 +5309,7 @@ void free_extent_buffer_stale(struct extent_buffer *eb)
 
 static int page_ebs_clean(struct extent_buffer_head *ebh)
 {
-	struct extent_buffer *eb = &ebh->eb;;
+	struct extent_buffer *eb = &ebh->eb;
 
 	do {
 		if (test_bit(EXTENT_BUFFER_DIRTY, &eb->ebflags))
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 15bb2a7..6e952fb 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -45,6 +45,7 @@
 #define EXTENT_BUFFER_IOERR 8
 #define EXTENT_BUFFER_DUMMY 9
 #define EXTENT_BUFFER_IN_TREE 10
+#define EXTENT_BUFFER_HEAD_WRITEBACK 11
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define PAGE_UNLOCK		(1 << 0)
@@ -302,6 +303,7 @@ void free_extent_buffer_stale(struct extent_buffer *eb);
 int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     struct extent_buffer *eb, u64 start, int wait,
 			     get_extent_t *get_extent, int mirror_num);
+int eb_wait(void *word);
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
 
 static inline unsigned long num_extent_pages(u64 start, u64 len)
-- 
2.1.0

