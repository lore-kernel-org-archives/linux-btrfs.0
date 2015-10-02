Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39823 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbbJBRni (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 13:43:38 -0400
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Cc: jbacik@db.com, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix deadlock when finalizing block group creation
Date: Fri,  2 Oct 2015 18:43:28 +0100
Message-Id: <1443807808-26424-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Josef ran into a deadlock while a transaction handle was finalizing the
creation of its block groups, which produced the following trace:

  [260445.593112] fio             D ffff88022a9df468     0  8924   4518 0x00000084
  [260445.593119]  ffff88022a9df468 ffffffff81c134c0 ffff880429693c00 ffff88022a9df488
  [260445.593126]  ffff88022a9e0000 ffff8803490d7b00 ffff8803490d7b18 ffff88022a9df4b0
  [260445.593132]  ffff8803490d7af8 ffff88022a9df488 ffffffff8175a437 ffff8803490d7b00
  [260445.593137] Call Trace:
  [260445.593145]  [<ffffffff8175a437>] schedule+0x37/0x80
  [260445.593189]  [<ffffffffa0850f37>] btrfs_tree_lock+0xa7/0x1f0 [btrfs]
  [260445.593197]  [<ffffffff810db7c0>] ? prepare_to_wait_event+0xf0/0xf0
  [260445.593225]  [<ffffffffa07eac44>] btrfs_lock_root_node+0x34/0x50 [btrfs]
  [260445.593253]  [<ffffffffa07eff6b>] btrfs_search_slot+0x88b/0xa00 [btrfs]
  [260445.593295]  [<ffffffffa08389df>] ? free_extent_buffer+0x4f/0x90 [btrfs]
  [260445.593324]  [<ffffffffa07f1a06>] btrfs_insert_empty_items+0x66/0xc0 [btrfs]
  [260445.593351]  [<ffffffffa07ea94a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
  [260445.593394]  [<ffffffffa08403b9>] btrfs_finish_chunk_alloc+0x1c9/0x570 [btrfs]
  [260445.593427]  [<ffffffffa08002ab>] btrfs_create_pending_block_groups+0x11b/0x200 [btrfs]
  [260445.593459]  [<ffffffffa0800964>] do_chunk_alloc+0x2a4/0x2e0 [btrfs]
  [260445.593491]  [<ffffffffa0803815>] find_free_extent+0xa55/0xd90 [btrfs]
  [260445.593524]  [<ffffffffa0803c22>] btrfs_reserve_extent+0xd2/0x220 [btrfs]
  [260445.593532]  [<ffffffff8119fe5d>] ? account_page_dirtied+0xdd/0x170
  [260445.593564]  [<ffffffffa0803e78>] btrfs_alloc_tree_block+0x108/0x4a0 [btrfs]
  [260445.593597]  [<ffffffffa080c9de>] ? btree_set_page_dirty+0xe/0x10 [btrfs]
  [260445.593626]  [<ffffffffa07eb5cd>] __btrfs_cow_block+0x12d/0x5b0 [btrfs]
  [260445.593654]  [<ffffffffa07ebbff>] btrfs_cow_block+0x11f/0x1c0 [btrfs]
  [260445.593682]  [<ffffffffa07ef8c7>] btrfs_search_slot+0x1e7/0xa00 [btrfs]
  [260445.593724]  [<ffffffffa08389df>] ? free_extent_buffer+0x4f/0x90 [btrfs]
  [260445.593752]  [<ffffffffa07f1a06>] btrfs_insert_empty_items+0x66/0xc0 [btrfs]
  [260445.593830]  [<ffffffffa07ea94a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
  [260445.593905]  [<ffffffffa08403b9>] btrfs_finish_chunk_alloc+0x1c9/0x570 [btrfs]
  [260445.593946]  [<ffffffffa08002ab>] btrfs_create_pending_block_groups+0x11b/0x200 [btrfs]
  [260445.593990]  [<ffffffffa0815798>] btrfs_commit_transaction+0xa8/0xb40 [btrfs]
  [260445.594042]  [<ffffffffa085abcd>] ? btrfs_log_dentry_safe+0x6d/0x80 [btrfs]
  [260445.594089]  [<ffffffffa082bc84>] btrfs_sync_file+0x294/0x350 [btrfs]
  [260445.594115]  [<ffffffff8123e29b>] vfs_fsync_range+0x3b/0xa0
  [260445.594133]  [<ffffffff81023891>] ? syscall_trace_enter_phase1+0x131/0x180
  [260445.594149]  [<ffffffff8123e35d>] do_fsync+0x3d/0x70
  [260445.594169]  [<ffffffff81023bb8>] ? syscall_trace_leave+0xb8/0x110
  [260445.594187]  [<ffffffff8123e600>] SyS_fsync+0x10/0x20
  [260445.594204]  [<ffffffff8175de6e>] entry_SYSCALL_64_fastpath+0x12/0x71

This happened because the same transaction handle created a large number
of block groups and while finalizing their creation (inserting new items
and updating existing items in the chunk and device trees) a new metadata
extent had to be allocated and no free space was found in the current
metadata block groups, which made find_free_extent() attempt to allocate
a new block group via do_chunk_alloc(). However at do_chunk_alloc() we
ended up allocating a new system chunk too and exceeded the threshold
of 2Mb of reserved chunk bytes, which makes do_chunk_alloc() enter the
final part of block group creation again (at
btrfs_create_pending_block_groups()) and attempt to lock again the root
of the chunk tree when it's already write locked by the same task.

Fix this by never recursing into the finalization phase of block group
creation.

Reported-by: Josef Bacik <jbacik@fb.com>
Fixes: 00d80e342c0f ("Btrfs: fix quick exhaustion of the system array in the superblock")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 5 ++++-
 fs/btrfs/transaction.c | 1 +
 fs/btrfs/transaction.h | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9f96042..358453d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4306,7 +4306,8 @@ out:
 	 * the block groups that were made dirty during the lifetime of the
 	 * transaction.
 	 */
-	if (trans->chunk_bytes_reserved >= (2 * 1024 * 1024ull)) {
+	if (trans->chunk_bytes_reserved >= (2 * 1024 * 1024ull) &&
+	    !trans->creating_pending_bgs) {
 		btrfs_create_pending_block_groups(trans, trans->root);
 		btrfs_trans_release_chunk_metadata(trans);
 	}
@@ -9561,6 +9562,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	int ret = 0;
 
+	trans->creating_pending_bgs = true;
 	list_for_each_entry_safe(block_group, tmp, &trans->new_bgs, bg_list) {
 		if (ret)
 			goto next;
@@ -9581,6 +9583,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
 next:
 		list_del_init(&block_group->bg_list);
 	}
+	trans->creating_pending_bgs = false;
 }
 
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a2d6f7b..60544d9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -557,6 +557,7 @@ again:
 	h->delayed_ref_elem.seq = 0;
 	h->type = type;
 	h->allocating_chunk = false;
+	h->creating_pending_bgs = false;
 	h->reloc_reserved = false;
 	h->sync = false;
 	INIT_LIST_HEAD(&h->qgroup_ref_list);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 87964bf..ce86bb0 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -118,6 +118,7 @@ struct btrfs_trans_handle {
 	short aborted;
 	short adding_csums;
 	bool allocating_chunk;
+	bool creating_pending_bgs;
 	bool reloc_reserved;
 	bool sync;
 	unsigned int type;
-- 
2.1.3

