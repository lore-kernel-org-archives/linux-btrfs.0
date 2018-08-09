Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:40406 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbeHIUcW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:32:22 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 14/17] btrfs: redirty released extent buffers in sequential BGs
Date: Fri, 10 Aug 2018 03:04:47 +0900
Message-Id: <20180809180450.5091-15-naota@elisp.net>
In-Reply-To: <20180809180450.5091-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tree manipulating operations like merging nodes often release
once-allocated tree nodes. Btrfs cleans such nodes so that pages in the
node are not uselessly written out. On HMZONED drives, however, such
optimization blocks the following IOs as the cancellation of the write out
of the freed blocks breaks the sequential write sequence expected by the
device.

This patch introduces a list of clean extent buffers that have been
released in a transaction. Btrfs consult the list before writing out and
waiting for the IOs, and it redirties a buffer if 1) it's in sequential BG,
2) it's in un-submit range, and 3) it's not under IO. Thus, such buffers
are marked for IO in btrfs_write_and_wait_transaction() to send proper bios
to the disk.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 fs/btrfs/disk-io.c     | 23 +++++++++++++++++++++--
 fs/btrfs/extent_io.c   |  1 +
 fs/btrfs/extent_io.h   |  1 +
 fs/btrfs/transaction.c | 32 ++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.h |  3 +++
 5 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f79abd5e6b3a..aa69c167fd57 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1098,10 +1098,20 @@ struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 void clean_tree_block(struct btrfs_fs_info *fs_info,
 		      struct extent_buffer *buf)
 {
-	if (btrfs_header_generation(buf) ==
-	    fs_info->running_transaction->transid) {
+	struct btrfs_transaction *cur_trans = fs_info->running_transaction;
+
+	if (btrfs_header_generation(buf) == cur_trans->transid) {
 		btrfs_assert_tree_locked(buf);
 
+		if (btrfs_fs_incompat(fs_info, HMZONED) &&
+		    list_empty(&buf->release_list)) {
+			atomic_inc(&buf->refs);
+			spin_lock(&cur_trans->releasing_ebs_lock);
+			list_add_tail(&buf->release_list,
+				      &cur_trans->releasing_ebs);
+			spin_unlock(&cur_trans->releasing_ebs_lock);
+		}
+
 		if (test_and_clear_bit(EXTENT_BUFFER_DIRTY, &buf->bflags)) {
 			percpu_counter_add_batch(&fs_info->dirty_metadata_bytes,
 						 -buf->len,
@@ -4484,6 +4494,15 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans,
 	btrfs_destroy_pinned_extent(fs_info,
 				    fs_info->pinned_extents);
 
+	while (!list_empty(&cur_trans->releasing_ebs)) {
+		struct extent_buffer *eb;
+
+		eb = list_first_entry(&cur_trans->releasing_ebs,
+				      struct extent_buffer, release_list);
+		list_del_init(&eb->release_list);
+		free_extent_buffer(eb);
+	}
+
 	cur_trans->state =TRANS_STATE_COMPLETED;
 	wake_up(&cur_trans->commit_wait);
 }
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 736d097d2851..31996c6a5d46 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4825,6 +4825,7 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	init_waitqueue_head(&eb->read_lock_wq);
 
 	btrfs_leak_debug_add(&eb->leak_list, &buffers);
+	INIT_LIST_HEAD(&eb->release_list);
 
 	spin_lock_init(&eb->refs_lock);
 	atomic_set(&eb->refs, 1);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b4d03e677e1d..bcd9a068ed3b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -192,6 +192,7 @@ struct extent_buffer {
 	 */
 	wait_queue_head_t read_lock_wq;
 	struct page *pages[INLINE_EXTENT_BUFFER_PAGES];
+	struct list_head release_list;
 #ifdef CONFIG_BTRFS_DEBUG
 	struct list_head leak_list;
 #endif
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3b84f5015029..5146e287917a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -273,6 +273,8 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	spin_lock_init(&cur_trans->dirty_bgs_lock);
 	INIT_LIST_HEAD(&cur_trans->deleted_bgs);
 	spin_lock_init(&cur_trans->dropped_roots_lock);
+	INIT_LIST_HEAD(&cur_trans->releasing_ebs);
+	spin_lock_init(&cur_trans->releasing_ebs_lock);
 	list_add_tail(&cur_trans->list, &fs_info->trans_list);
 	extent_io_tree_init(&cur_trans->dirty_pages,
 			     fs_info->btree_inode);
@@ -2230,7 +2232,28 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	wake_up(&fs_info->transaction_wait);
 
+	if (btrfs_fs_incompat(fs_info, HMZONED)) {
+		struct extent_buffer *eb;
+
+		list_for_each_entry(eb, &cur_trans->releasing_ebs,
+				    release_list) {
+			struct btrfs_block_group_cache *cache;
+
+			cache = btrfs_lookup_block_group(fs_info, eb->start);
+			if (!cache)
+				continue;
+			spin_lock(&cache->submit_lock);
+			if (cache->alloc_type == BTRFS_ALLOC_SEQ &&
+			    cache->submit_offset <= eb->start &&
+			    !extent_buffer_under_io(eb))
+				set_extent_buffer_dirty(eb);
+			spin_unlock(&cache->submit_lock);
+			btrfs_put_block_group(cache);
+		}
+	}
+
 	ret = btrfs_write_and_wait_transaction(trans);
+
 	if (ret) {
 		btrfs_handle_fs_error(fs_info, ret,
 				      "Error while writing out transaction");
@@ -2238,6 +2261,15 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		goto scrub_continue;
 	}
 
+	while (!list_empty(&cur_trans->releasing_ebs)) {
+		struct extent_buffer *eb;
+
+		eb = list_first_entry(&cur_trans->releasing_ebs,
+				      struct extent_buffer, release_list);
+		list_del_init(&eb->release_list);
+		free_extent_buffer(eb);
+	}
+
 	ret = write_all_supers(fs_info, 0);
 	/*
 	 * the super is written, we can safely allow the tree-loggers
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 4cbb1b55387d..d88c335dd78c 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -88,6 +88,9 @@ struct btrfs_transaction {
 	spinlock_t dropped_roots_lock;
 	struct btrfs_delayed_ref_root delayed_refs;
 	struct btrfs_fs_info *fs_info;
+
+	spinlock_t releasing_ebs_lock;
+	struct list_head releasing_ebs;
 };
 
 #define __TRANS_FREEZABLE	(1U << 0)
-- 
2.18.0

