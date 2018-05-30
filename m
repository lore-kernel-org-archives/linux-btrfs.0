Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44525 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750762AbeE3Eka (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 00:40:30 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BE258ADD3
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 04:40:28 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH REBASED 2/2] btrfs: Delayed empty block group auto removal to next transaction
Date: Wed, 30 May 2018 12:40:23 +0800
Message-Id: <20180530044023.9192-3-wqu@suse.com>
In-Reply-To: <20180530044023.9192-1-wqu@suse.com>
References: <20180530044023.9192-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Under certain KVM load and LTP tests, we are possible to hit the
following calltrace if quota is enabled:
------
BTRFS critical (device vda2): unable to find logical 8820195328 length 4096
BTRFS critical (device vda2): unable to find logical 8820195328 length 4096
------------[ cut here ]------------
WARNING: CPU: 0 PID: 49 at ../block/blk-core.c:172 blk_status_to_errno+0x1a/0x30
CPU: 0 PID: 49 Comm: kworker/u2:1 Not tainted 4.12.14-15-default #1 SLE15 (unreleased)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
task: ffff9f827b340bc0 task.stack: ffffb4f8c0304000
RIP: 0010:blk_status_to_errno+0x1a/0x30
Call Trace:
 submit_extent_page+0x191/0x270 [btrfs]
 ? btrfs_create_repair_bio+0x130/0x130 [btrfs]
 __do_readpage+0x2d2/0x810 [btrfs]
 ? btrfs_create_repair_bio+0x130/0x130 [btrfs]
 ? run_one_async_done+0xc0/0xc0 [btrfs]
 __extent_read_full_page+0xe7/0x100 [btrfs]
 ? run_one_async_done+0xc0/0xc0 [btrfs]
 read_extent_buffer_pages+0x1ab/0x2d0 [btrfs]
 ? run_one_async_done+0xc0/0xc0 [btrfs]
 btree_read_extent_buffer_pages+0x94/0xf0 [btrfs]
 read_tree_block+0x31/0x60 [btrfs]
 read_block_for_search.isra.35+0xf0/0x2e0 [btrfs]
 btrfs_search_slot+0x46b/0xa00 [btrfs]
 ? kmem_cache_alloc+0x1a8/0x510
 ? btrfs_get_token_32+0x5b/0x120 [btrfs]
 find_parent_nodes+0x11d/0xeb0 [btrfs]
 ? leaf_space_used+0xb8/0xd0 [btrfs]
 ? btrfs_leaf_free_space+0x49/0x90 [btrfs]
 ? btrfs_find_all_roots_safe+0x93/0x100 [btrfs]
 btrfs_find_all_roots_safe+0x93/0x100 [btrfs]
 btrfs_find_all_roots+0x45/0x60 [btrfs]
 btrfs_qgroup_trace_extent_post+0x20/0x40 [btrfs]
 btrfs_add_delayed_data_ref+0x1a3/0x1d0 [btrfs]
 btrfs_alloc_reserved_file_extent+0x38/0x40 [btrfs]
 insert_reserved_file_extent.constprop.71+0x289/0x2e0 [btrfs]
 btrfs_finish_ordered_io+0x2f4/0x7f0 [btrfs]
 ? pick_next_task_fair+0x2cd/0x530
 ? __switch_to+0x92/0x4b0
 btrfs_worker_helper+0x81/0x300 [btrfs]
 process_one_work+0x1da/0x3f0
 worker_thread+0x2b/0x3f0
 ? process_one_work+0x3f0/0x3f0
 kthread+0x11a/0x130
 ? kthread_create_on_node+0x40/0x40
 ret_from_fork+0x35/0x40
Code: 00 00 5b c3 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 40 80 ff 0c 40 0f b6 c7 77 0b 48 c1 e0 04 8b 80 00 bf c8 bd c3 <0f> 0b b8 fb ff ff ff c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00
---[ end trace f079fb809e7a862b ]---
BTRFS critical (device vda2): unable to find logical 8820195328 length 16384
BTRFS: error (device vda2) in btrfs_finish_ordered_io:3023: errno=-5 IO failure
BTRFS info (device vda2): forced readonly
BTRFS error (device vda2): pending csums is 2887680
------

Although we haven't hit the same bug in real world, it shows that since
qgroup is heavily relying on commit root, if block group auto removal
happens and removed the empty block group, qgroup could failed to find
its old referencers.

This patch will add a new member for btrfs_transaction,
pending_unused_bgs.
Now unused bgs will go trans->transaction->pending_unused_bgs, then
fs_info->unused_bgs, and finally get removed by
btrfs_deleted_unused_bgs().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/ctree.h       |  3 ++-
 fs/btrfs/extent-tree.c | 34 ++++++++++++++++++++++++++++++----
 fs/btrfs/scrub.c       |  2 +-
 fs/btrfs/transaction.c |  7 +++++++
 fs/btrfs/transaction.h | 10 ++++++++++
 5 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9431ed7b7cd1..02eee472fbd2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2827,7 +2827,8 @@ void check_system_chunk(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info, const u64 type);
 u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
 		       u64 start, u64 end);
-void btrfs_mark_bg_unused(struct btrfs_block_group_cache *bg);
+void btrfs_mark_bg_unused(struct btrfs_block_group_cache *bg,
+			  struct btrfs_trans_handle *trans);
 
 /* ctree.c */
 int btrfs_bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 31627de751d1..3d468ed0e071 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6294,7 +6294,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		 * cache writeout.
 		 */
 		if (!alloc && old_val == 0)
-			btrfs_mark_bg_unused(cache);
+			btrfs_mark_bg_unused(cache, trans);
 
 		btrfs_put_block_group(cache);
 		total -= num_bytes;
@@ -10136,7 +10136,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 			inc_block_group_ro(cache, 1);
 		} else if (btrfs_block_group_used(&cache->item) == 0) {
 			ASSERT(list_empty(&cache->bg_list));
-			btrfs_mark_bg_unused(cache);
+			btrfs_mark_bg_unused(cache, NULL);
 		}
 	}
 
@@ -11055,15 +11055,41 @@ void btrfs_wait_for_snapshot_creation(struct btrfs_root *root)
 	}
 }
 
-void btrfs_mark_bg_unused(struct btrfs_block_group_cache *bg)
+/*
+ * Get a block group cache and mark it as unused (if not already
+ * unused/deleted)
+ *
+ * NOTE:
+ * Since qgroup could search commit root at any time, we can't just
+ * delete the block group and its chunk mapping in current trans.
+ * So we record bgs to be deleted in trans->transaction and then
+ * queue them into fs_info->unused_bgs.
+ *
+ * @bg:		The block group cache
+ * @trans:	The trans handler
+ */
+void btrfs_mark_bg_unused(struct btrfs_block_group_cache *bg,
+			  struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = bg->fs_info;
 
 	spin_lock(&fs_info->unused_bgs_lock);
 	if (list_empty(&bg->bg_list)) {
+		/*
+		 * Get one reference, will be freed at btrfs_delete_unused_bgs()
+		 */
 		btrfs_get_block_group(bg);
 		trace_btrfs_add_unused_block_group(bg);
-		list_add_tail(&bg->bg_list, &fs_info->unused_bgs);
+
+		/*
+		 * If we don't have a trans, it means we are at mount time.
+		 * It's completely fine to mark it ready to be deleted.
+		 */
+		if (!trans)
+			list_add_tail(&bg->bg_list, &fs_info->unused_bgs);
+		else
+			list_add_tail(&bg->bg_list,
+				      &trans->transaction->pending_unused_bgs);
 	}
 	spin_unlock(&fs_info->unused_bgs_lock);
 }
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 40086b47a65f..d9e2420da457 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3981,7 +3981,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		if (!cache->removed && !cache->ro && cache->reserved == 0 &&
 		    btrfs_block_group_used(&cache->item) == 0) {
 			spin_unlock(&cache->lock);
-			btrfs_mark_bg_unused(cache);
+			btrfs_mark_bg_unused(cache, NULL);
 		} else {
 			spin_unlock(&cache->lock);
 		}
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4485eae41e88..4bead1fd1006 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -264,6 +264,7 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 
 	INIT_LIST_HEAD(&cur_trans->pending_snapshots);
 	INIT_LIST_HEAD(&cur_trans->pending_chunks);
+	INIT_LIST_HEAD(&cur_trans->pending_unused_bgs);
 	INIT_LIST_HEAD(&cur_trans->switch_commits);
 	INIT_LIST_HEAD(&cur_trans->dirty_bgs);
 	INIT_LIST_HEAD(&cur_trans->io_bgs);
@@ -2262,6 +2263,12 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	wake_up(&cur_trans->commit_wait);
 	clear_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags);
 
+	/* transaction is done, queue pending unused bgs to cleaner */
+	spin_lock(&fs_info->unused_bgs_lock);
+	list_splice_tail_init(&cur_trans->pending_unused_bgs,
+			      &fs_info->unused_bgs);
+	spin_unlock(&fs_info->unused_bgs_lock);
+
 	spin_lock(&fs_info->trans_lock);
 	list_del_init(&cur_trans->list);
 	spin_unlock(&fs_info->trans_lock);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index d8c0826bc2c7..9f160e1811f7 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -57,6 +57,16 @@ struct btrfs_transaction {
 	struct list_head switch_commits;
 	struct list_head dirty_bgs;
 
+	/*
+	 * Unused block groups waiting to be deleted after current transaction.
+	 * Protected by fs_info->unused_bgs_lock.
+	 *
+	 * Since qgroup could search commit root, we can't delete unused block
+	 * group in the same trans when it get emptied, but delay it to next
+	 * transaction (or next mount if power loss happens)
+	 */
+	struct list_head pending_unused_bgs;
+
 	/*
 	 * There is no explicit lock which protects io_bgs, rather its
 	 * consistency is implied by the fact that all the sites which modify
-- 
2.17.0

