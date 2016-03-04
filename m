Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36279 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759463AbcCDTXR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Mar 2016 14:23:17 -0500
Received: by mail-pa0-f43.google.com with SMTP id fi3so37583555pac.3
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 11:23:17 -0800 (PST)
From: Adam Buchbinder <adam.buchbinder@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: trivial@kernel.org, Adam Buchbinder <adam.buchbinder@gmail.com>
Subject: [PATCH] btrfs: Fix misspellings in comments.
Date: Fri,  4 Mar 2016 11:23:12 -0800
Message-Id: <1457119392-15593-1-git-send-email-adam.buchbinder@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Adam Buchbinder <adam.buchbinder@gmail.com>
---
 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/ctree.h           | 10 +++++-----
 fs/btrfs/dev-replace.c     |  2 +-
 fs/btrfs/disk-io.c         |  2 +-
 fs/btrfs/extent-tree.c     |  2 +-
 fs/btrfs/extent_map.c      |  4 ++--
 fs/btrfs/file.c            |  2 +-
 fs/btrfs/ordered-data.c    |  2 +-
 fs/btrfs/tree-log.c        |  2 +-
 fs/btrfs/volumes.c         |  4 ++--
 10 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 861d472..2eeb155 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -176,7 +176,7 @@ struct btrfsic_block {
  * Elements of this type are allocated dynamically and required because
  * each block object can refer to and can be ref from multiple blocks.
  * The key to lookup them in the hashtable is the dev_bytenr of
- * the block ref to plus the one from the block refered from.
+ * the block ref to plus the one from the block referred from.
  * The fact that they are searchable via a hashtable and that a
  * ref_cnt is maintained is not required for the btrfs integrity
  * check algorithm itself, it is only used to make the output more
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bfe4a33..7c1c6e4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -793,7 +793,7 @@ struct btrfs_root_item {
 
 	/*
 	 * This generation number is used to test if the new fields are valid
-	 * and up to date while reading the root item. Everytime the root item
+	 * and up to date while reading the root item. Every time the root item
 	 * is written out, the "generation" field is copied into this field. If
 	 * anyone ever mounted the fs with an older kernel, we will have
 	 * mismatching generation values here and thus must invalidate the
@@ -1222,10 +1222,10 @@ struct btrfs_space_info {
 	 * we've called update_block_group and dropped the bytes_used counter
 	 * and increased the bytes_pinned counter.  However this means that
 	 * bytes_pinned does not reflect the bytes that will be pinned once the
-	 * delayed refs are flushed, so this counter is inc'ed everytime we call
-	 * btrfs_free_extent so it is a realtime count of what will be freed
-	 * once the transaction is committed.  It will be zero'ed everytime the
-	 * transaction commits.
+	 * delayed refs are flushed, so this counter is inc'ed every time we
+	 * call btrfs_free_extent so it is a realtime count of what will be
+	 * freed once the transaction is committed.  It will be zero'ed every
+	 * time the transaction commits.
 	 */
 	struct percpu_counter total_bytes_pinned;
 
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index cbb7dbf..707dc6c 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -858,7 +858,7 @@ int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace)
 		 * not called and the the filesystem is remounted
 		 * in degraded state. This does not stop the
 		 * dev_replace procedure. It needs to be canceled
-		 * manually if the cancelation is wanted.
+		 * manually if the cancellation is wanted.
 		 */
 		break;
 	}
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 4545e2e..5b139f1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -816,7 +816,7 @@ static void run_one_async_done(struct btrfs_work *work)
 	    waitqueue_active(&fs_info->async_submit_wait))
 		wake_up(&fs_info->async_submit_wait);
 
-	/* If an error occured we just want to clean up the bio and move on */
+	/* If an error occurred we just want to clean up the bio and move on */
 	if (async->error) {
 		async->bio->bi_error = async->error;
 		bio_endio(async->bio);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2287c7..7ed61e9 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5752,7 +5752,7 @@ out_fail:
 
 		/*
 		 * This is tricky, but first we need to figure out how much we
-		 * free'd from any free-ers that occured during this
+		 * free'd from any free-ers that occurred during this
 		 * reservation, so we reset ->csum_bytes to the csum_bytes
 		 * before we dropped our lock, and then call the free for the
 		 * number of bytes that were freed while we were trying our
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 84fb56d..6259b8a 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -62,7 +62,7 @@ struct extent_map *alloc_extent_map(void)
 
 /**
  * free_extent_map - drop reference count of an extent_map
- * @em:		extent map beeing releasead
+ * @em:		extent map being releasead
  *
  * Drops the reference out on @em by one and free the structure
  * if the reference count hits zero.
@@ -422,7 +422,7 @@ struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
 /**
  * remove_extent_mapping - removes an extent_map from the extent tree
  * @tree:	extent tree to remove from
- * @em:		extent map beeing removed
+ * @em:		extent map being removed
  *
  * Removes @em from @tree.  No reference counts are dropped, and no checks
  * are done to see if the range is in use
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 098bb8f..0920820 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1825,7 +1825,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 	/*
 	 * We also have to set last_sub_trans to the current log transid,
 	 * otherwise subsequent syncs to a file that's been synced in this
-	 * transaction will appear to have already occured.
+	 * transaction will appear to have already occurred.
 	 */
 	spin_lock(&BTRFS_I(inode)->lock);
 	BTRFS_I(inode)->last_sub_trans = root->log_transid;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 8c27292..f4e8a5d 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -1009,7 +1009,7 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 	for (; node; node = rb_prev(node)) {
 		test = rb_entry(node, struct btrfs_ordered_extent, rb_node);
 
-		/* We treat this entry as if it doesnt exist */
+		/* We treat this entry as if it doesn't exist */
 		if (test_bit(BTRFS_ORDERED_UPDATED_ISIZE, &test->flags))
 			continue;
 		if (test->file_offset + test->len <= disk_i_size)
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 978c3a8..fa38456 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1045,7 +1045,7 @@ again:
 
 		/*
 		 * NOTE: we have searched root tree and checked the
-		 * coresponding ref, it does not need to check again.
+		 * corresponding ref, it does not need to check again.
 		 */
 		*search_done = 1;
 	}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 366b335..e6db2cf 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2748,7 +2748,7 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 	    em->start + em->len < chunk_offset) {
 		/*
 		 * This is a logic error, but we don't want to just rely on the
-		 * user having built with ASSERT enabled, so if ASSERT doens't
+		 * user having built with ASSERT enabled, so if ASSERT doesn't
 		 * do anything we still error out.
 		 */
 		ASSERT(0);
@@ -4118,7 +4118,7 @@ out:
  * Callback for btrfs_uuid_tree_iterate().
  * returns:
  * 0	check succeeded, the entry is not outdated.
- * < 0	if an error occured.
+ * < 0	if an error occurred.
  * > 0	if the check failed, which means the caller shall remove the entry.
  */
 static int btrfs_check_uuid_tree_entry(struct btrfs_fs_info *fs_info,
-- 
2.7.0.rc3.207.g0ac5344

