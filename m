Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:60672 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaIXVU6 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 24 Sep 2014 17:20:58 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/2 v7] Btrfs: be aware of btree inode write errors to avoid fs corruption
Date: Wed, 24 Sep 2014 23:20:36 +0100
Message-Id: <1411597236-14241-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1411404065-767-2-git-send-email-fdmanana@suse.com>
References: <1411404065-767-2-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While we have a transaction ongoing, the VM might decide at any time
to call btree_inode->i_mapping->a_ops->writepages(), which will start
writeback of dirty pages belonging to btree nodes/leafs. This call
might return an error or the writeback might finish with an error
before we attempt to commit the running transaction. If this happens,
we might have no way of knowing that such error happened when we are
committing the transaction - because the pages might no longer be
marked dirty nor tagged for writeback (if a subsequent modification
to the extent buffer didn't happen before the transaction commit) which
makes filemap_fdata[write|wait]_range unable to find such pages (even
if they're marked with SetPageError).
So if this happens we must abort the transaction, otherwise we commit
a super block with btree roots that point to btree nodes/leafs whose
content on disk is invalid - either garbage or the content of some
node/leaf from a past generation that got cowed or deleted and is no
longer valid (for this later case we end up getting error messages like
"parent transid verify failed on 10826481664 wanted 25748 found 29562"
when reading btree nodes/leafs from disk).

Note that setting and checking AS_EIO/AS_ENOSPC in the btree inode's
i_mapping would not be enough because we need to distinguish between
log tree extents (not fatal) vs non-log tree extents (fatal) and
because the next call to filemap_fdatawait_range() will catch and clear
such errors in the mapping - and that call might be from a log sync and
not from a transaction commit, which means we would not know about the
error at transaction commit time. Also, checking for the eb flag
EXTENT_BUFFER_IOERR at transaction commit time isn't done and would
not be completely reliable, as the eb might be removed from memory and
read back when trying to get it, which clears that flag right before
reading the eb's pages from disk, making us not know about the previous
write error.

Using the new counters eb_write_errors and log_eb_write_errors in the
transaction also makes us achieve the goal of AS_EIO/AS_ENOSPC when
writepages() returns success, started writeback for all dirty pages
and before filemap_fdatawait_range() is called, the writeback for
all dirty pages had already finished with errors - because we were
not using AS_EIO/AS_ENOSPC, filemap_fdatawait_range() would return
success, as it could not know that writeback errors happened (the
pages were no longer tagged for writeback).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: If an extent buffer's write failed but it's also deleted from the tree
    before the transaction commits, don't abort the transaction with -EIO,
    since the unwritten node/leaf it represents can't be pointed to by any
    other node in a tree.

V3: Correct V2, missed unstaged changes.

V4: Use root's key to figure out which counter to update.

V5: Decrement the error counters too when an eb is made dirty again (the
    next write attempt might succeed).

V6: Moved counters from transaction struct to fs_info struct, because there's
    a (short) time window where fs_info->running_transaction is NULL.
    There's now 2 counters for log extent buffers too, each one representing
    a different log transaction.

V7: Track the eb's log index in the eb itself, otherwise it wasn't possible
    to find it when writeback triggered from a transaction commit.

 fs/btrfs/ctree.h       |   3 ++
 fs/btrfs/disk-io.c     |   7 +++-
 fs/btrfs/extent-tree.c |   4 +-
 fs/btrfs/extent_io.c   | 101 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/extent_io.h   |   6 ++-
 fs/btrfs/transaction.c |  18 +++++++++
 6 files changed, 128 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f20b60d..0e5ca39 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1510,6 +1510,9 @@ struct btrfs_fs_info {
 	atomic_t async_delalloc_pages;
 	atomic_t open_ioctl_trans;
 
+	atomic_t eb_write_errors;
+	atomic_t log_eb_write_errors[2];
+
 	/*
 	 * this is used to protect the following list -- ordered_roots.
 	 */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 23393ec..8f1deca 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -610,7 +610,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		goto err;
 
 	eb->read_mirror = mirror;
-	if (test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
+	if (test_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags)) {
 		ret = -EIO;
 		goto err;
 	}
@@ -683,7 +683,7 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 
 	eb = (struct extent_buffer *)page->private;
-	set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+	set_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
 	eb->read_mirror = failed_mirror;
 	atomic_dec(&eb->io_pages);
 	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
@@ -2271,6 +2271,9 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->nr_async_bios, 0);
 	atomic_set(&fs_info->defrag_running, 0);
 	atomic_set(&fs_info->qgroup_op_seq, 0);
+	atomic_set(&fs_info->eb_write_errors, 0);
+	atomic_set(&fs_info->log_eb_write_errors[0], 0);
+	atomic_set(&fs_info->log_eb_write_errors[1], 0);
 	atomic64_set(&fs_info->tree_mod_seq, 0);
 	fs_info->sb = sb;
 	fs_info->max_inline = 8192 * 1024;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ef0845d..9442f3c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6221,6 +6221,7 @@ out:
 	 * anymore.
 	 */
 	clear_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags);
+	clear_extent_buffer_write_err(buf);
 	btrfs_put_block_group(cache);
 }
 
@@ -7203,11 +7204,12 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	btrfs_set_buffer_uptodate(buf);
 
 	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
+		buf->log_index = root->log_transid % 2;
 		/*
 		 * we allow two log transactions at a time, use different
 		 * EXENT bit to differentiate dirty pages.
 		 */
-		if (root->log_transid % 2 == 0)
+		if (buf->log_index == 0)
 			set_extent_dirty(&root->dirty_log_pages, buf->start,
 					buf->start + buf->len - 1, GFP_NOFS);
 		else
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 91f866c..c1139ae 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -20,6 +20,7 @@
 #include "locking.h"
 #include "rcu-string.h"
 #include "backref.h"
+#include "transaction.h"
 
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
@@ -3606,6 +3607,60 @@ static void end_extent_buffer_writeback(struct extent_buffer *eb)
 	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
 }
 
+static void set_btree_ioerr(struct page *page)
+{
+	struct extent_buffer *eb = (struct extent_buffer *)page->private;
+	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
+
+	SetPageError(page);
+	if (test_and_set_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags))
+		return;
+
+	/*
+	 * If writeback for a btree extent that doesn't belong to a log tree
+	 * failed, increment the counter transaction->eb_write_errors.
+	 * We do this because while the transaction is running and before it's
+	 * committing (when we call filemap_fdata[write|wait]_range against
+	 * the btree inode), we might have
+	 * btree_inode->i_mapping->a_ops->writepages() called by the VM - if it
+	 * returns an error or an error happens during writeback, when we're
+	 * committing the transaction we wouldn't know about it, since the pages
+	 * can be no longer dirty nor marked anymore for writeback (if a
+	 * subsequent modification to the extent buffer didn't happen before the
+	 * transaction commit), which makes filemap_fdata[write|wait]_range not
+	 * able to find the pages tagged with SetPageError at transaction
+	 * commit time. So if this happens we must abort the transaction,
+	 * otherwise we commit a super block with btree roots that point to
+	 * btree nodes/leafs whose content on disk is invalid - either garbage
+	 * or the content of some node/leaf from a past generation that got
+	 * cowed or deleted and is no longer valid.
+	 *
+	 * Note: setting AS_EIO/AS_ENOSPC in the btree inode's i_mapping would
+	 * not be enough - we need to distinguish between log tree extents vs
+	 * non-log tree extents, and the next filemap_fdatawait_range() call
+	 * will catch and clear such errors in the mapping - and that call might
+	 * be from a log sync and not from a transaction commit. Also, checking
+	 * for the eb flag EXTENT_BUFFER_WRITE_ERR at transaction commit time is
+	 * not done and would not be completely reliable, as the eb might be
+	 * removed from memory and read back when trying to get it, which clears
+	 * that flag right before reading the eb's pages from disk, making us
+	 * not know about the previous write error.
+	 *
+	 * Using transaction counters eb_write_errors and log_eb_write_errors
+	 * also makes us achieve the goal of AS_EIO/AS_ENOSPC when writepages()
+	 * returns success, started writeback for all dirty pages and before
+	 * filemap_fdatawait_range() is called, the writeback for all dirty
+	 * pages had already finished with errors - because we were not using
+	 * AS_EIO/AS_ENOSPC, filemap_fdatawait_range() would return success, as
+	 * it could not know that writeback errors happened (the pages were no
+	 * longer tagged for writeback).
+	 */
+	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID)
+		atomic_inc(&eb->fs_info->log_eb_write_errors[eb->log_index]);
+	else
+		atomic_inc(&eb->fs_info->eb_write_errors);
+}
+
 static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
 {
 	struct bio_vec *bvec;
@@ -3619,10 +3674,9 @@ static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
 		BUG_ON(!eb);
 		done = atomic_dec_and_test(&eb->io_pages);
 
-		if (err || test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
-			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+		if (err || test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags)) {
 			ClearPageUptodate(page);
-			SetPageError(page);
+			set_btree_ioerr(page);
 		}
 
 		end_page_writeback(page);
@@ -3649,7 +3703,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	int rw = (epd->sync_io ? WRITE_SYNC : WRITE) | REQ_META;
 	int ret = 0;
 
-	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+	clear_extent_buffer_write_err(eb);
 	num_pages = num_extent_pages(eb->start, eb->len);
 	atomic_set(&eb->io_pages, num_pages);
 	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
@@ -3666,8 +3720,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 					 0, epd->bio_flags, bio_flags);
 		epd->bio_flags = bio_flags;
 		if (ret) {
-			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
-			SetPageError(p);
+			set_btree_ioerr(p);
 			end_page_writeback(p);
 			if (atomic_sub_and_test(num_pages - i, &eb->io_pages))
 				end_extent_buffer_writeback(eb);
@@ -5069,7 +5122,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 		goto unlock_exit;
 	}
 
-	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+	clear_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
 	eb->read_mirror = 0;
 	atomic_set(&eb->io_pages, num_reads);
 	for (i = start_i; i < num_pages; i++) {
@@ -5514,3 +5567,37 @@ int try_release_extent_buffer(struct page *page)
 
 	return release_extent_buffer(eb);
 }
+
+void clear_extent_buffer_write_err(struct extent_buffer *eb)
+{
+	/*
+	 * Ignore/discard a write IO error when:
+	 *
+	 * 1) The unwritten node/leaf isn't pointed to by any other node in
+	 * a tree because it was deleted - so it's safe to forget about the
+	 * write error and avoid a transaction abort;
+	 *
+	 * 2) The same eb was marked dirty again, so we will attempt to write
+	 * it to disk again, which might succeed this time.
+	 */
+	if (test_and_clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags)) {
+		struct btrfs_root *root;
+
+		root = BTRFS_I(eb->pages[0]->mapping->host)->root;
+
+		if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
+			const int i = eb->log_index;
+
+			atomic_dec(&eb->fs_info->log_eb_write_errors[i]);
+		} else {
+			/*
+			 * The counter can be 0 here, because the previous
+			 * current transaction (fs_info->running_transaction)
+			 * just called btrfs_wait_marked_extents() and is about
+			 * to set the fs to read-only mode and abort.
+			 */
+			atomic_add_unless(&eb->fs_info->eb_write_errors, -1, 0);
+		}
+	}
+
+}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5e91fb9..f9ba8c4 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -41,9 +41,10 @@
 #define EXTENT_BUFFER_TREE_REF 5
 #define EXTENT_BUFFER_STALE 6
 #define EXTENT_BUFFER_WRITEBACK 7
-#define EXTENT_BUFFER_IOERR 8
+#define EXTENT_BUFFER_READ_ERR 8        /* read IO error */
 #define EXTENT_BUFFER_DUMMY 9
 #define EXTENT_BUFFER_IN_TREE 10
+#define EXTENT_BUFFER_WRITE_ERR 11    /* write IO error */
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define PAGE_UNLOCK		(1 << 0)
@@ -142,6 +143,8 @@ struct extent_buffer {
 	atomic_t spinning_readers;
 	atomic_t spinning_writers;
 	int lock_nested;
+	/* meaningful only if the owner root is from a log tree */
+	int log_index;
 
 	/* protects write locks */
 	rwlock_t lock;
@@ -314,6 +317,7 @@ void memmove_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
 			   unsigned long src_offset, unsigned long len);
 void memset_extent_buffer(struct extent_buffer *eb, char c,
 			  unsigned long start, unsigned long len);
+void clear_extent_buffer_write_err(struct extent_buffer *eb);
 void clear_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_uptodate(struct extent_buffer *eb);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 1e272c0..6e696a0 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -852,6 +852,7 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
 	struct extent_state *cached_state = NULL;
 	u64 start = 0;
 	u64 end;
+	int errors;
 
 	while (!find_first_extent_bit(dirty_pages, start, &start, &end,
 				      EXTENT_NEED_WAIT, &cached_state)) {
@@ -865,6 +866,23 @@ int btrfs_wait_marked_extents(struct btrfs_root *root,
 	}
 	if (err)
 		werr = err;
+
+	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
+		atomic_t *log_errors = root->fs_info->log_eb_write_errors;
+
+		errors = 0;
+		if (mark & EXTENT_DIRTY)
+			errors += atomic_xchg(&log_errors[0], 0);
+		if (mark & EXTENT_NEW)
+			errors += atomic_xchg(&log_errors[1], 0);
+	} else {
+		errors = atomic_xchg(&root->fs_info->eb_write_errors, 0);
+	}
+
+	ASSERT(errors >= 0);
+	if (errors > 0 && !werr)
+		werr = -EIO;
+
 	return werr;
 }
 
-- 
1.9.1

