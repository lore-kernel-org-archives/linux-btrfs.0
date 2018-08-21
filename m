Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725732AbeHUFLy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 01:11:54 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9CD7EAE58
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Aug 2018 01:53:51 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4] btrfs: locking: Add extra check in btrfs_init_new_buffer() to avoid deadlock
Date: Tue, 21 Aug 2018 09:53:47 +0800
Message-Id: <20180821015347.6953-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
For certains crafted image, whose csum root leaf has missing backref, if
we try to trigger write with data csum, it could cause deadlock with the
following kernel WARN_ON():
------
WARNING: CPU: 1 PID: 41 at fs/btrfs/locking.c:230 btrfs_tree_lock+0x3e2/0x400
CPU: 1 PID: 41 Comm: kworker/u4:1 Not tainted 4.18.0-rc1+ #8
Workqueue: btrfs-endio-write btrfs_endio_write_helper
RIP: 0010:btrfs_tree_lock+0x3e2/0x400
Call Trace:
 btrfs_alloc_tree_block+0x39f/0x770
 __btrfs_cow_block+0x285/0x9e0
 btrfs_cow_block+0x191/0x2e0
 btrfs_search_slot+0x492/0x1160
 btrfs_lookup_csum+0xec/0x280
 btrfs_csum_file_blocks+0x2be/0xa60
 add_pending_csums+0xaf/0xf0
 btrfs_finish_ordered_io+0x74b/0xc90
 finish_ordered_fn+0x15/0x20
 normal_work_helper+0xf6/0x500
 btrfs_endio_write_helper+0x12/0x20
 process_one_work+0x302/0x770
 worker_thread+0x81/0x6d0
 kthread+0x180/0x1d0
 ret_from_fork+0x35/0x40
---[ end trace 2e85051acb5f6dc1 ]---
------

[CAUSE]
That crafted image has missing backref for csum tree root leaf.
And when we try to allocate new tree block, since there is no
EXTENT/METADATA_ITEM for csum tree root, btrfs consider it's free slot
and use it.

The extent tree of the image looks like:
Normal image                      |       This fuzzed image
----------------------------------+--------------------------------
BG 29360128                       | BG 29360128
 One empty slot                   |  One empty slot
29364224: backref to UUID tree    | 29364224: backref to UUID tree
 Two empty slots                  |  Two empty slots
29376512: backref to CSUM tree    |  One empty slot (bad type) <<<
29380608: backref to D_RELOC tree | 29380608: backref to D_RELOC tree
...                               | ...

Since bytenr 29376512 has no METADATA/EXTENT_ITEM, when btrfs try to
alloc tree block, it's an valid slot for btrfs.

And for finish_ordered_write, when we need to insert csum, we try to CoW
csum tree root.

By *COINCIDENT*, empty slots at bytenr BG_OFFSET, BG_OFFSET + 8K,
BG_OFFSET + 12K is already used by tree block COW for other trees,
the next empty slot is BG_OFFSET + 16K, which should be the backref for
CSUM tree.

But due to the bad type, btrfs can recognize it and still consider it as
an empty slot, and will try to use it for csum tree CoW.

Then in the following call trace, we will try to lock the new tree
block, which turns out to be the old csum tree root which is already
locked:

btrfs_search_slot() called on csum tree root, which is at 29376512
|- btrfs_cow_block()
   |- btrfs_set_lock_block()
   |  |- Now locks tree block 29376512 (old csum tree root)
   |- __btrfs_cow_block()
      |- btrfs_alloc_tree_block()
         |- btrfs_reserve_extent()
            | Now it returns tree block 29376512, which extent tree
            | shows its empty slot, but it's already hold by csum tree
            |- btrfs_init_new_buffer()
               |- btrfs_tree_lock()
                  | Triggers WARN_ON(eb->lock_owner == current->pid)
                  |- wait_event()
                     Wait lock owner to release the lock, but it's
                     locked by ourself, so it will deadlock

[FIX]
This patch will do the lock_owner and current->pid check at
btrfs_init_new_buffer().
So above deadlock can be avoided.

Since such problem can only happen in crafted image, we will still
trigger kernel warning for later aborted transaction, but with a little
more meaningful warning message.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=200405
Reported-by: Xu Wen <wen.xu@gatech.edu>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Modify btrfs_tree_lock() to be able to return int to detect possible
  deadlock and return.
v3:
  Instead of modify all btrfs_tree_lock() callers, only check possible
  deadlock at btrfs_init_new_buffer(), as the bug only happens for newly
  allocated tree block.
  With better commit message describing the on-disk extent tree
  corruption along with the call trace of how dead lock happens.
v4:
  Use btrfs_err_rl() to replace original WARN(). (ratelimit to avoid
  error message flood before fs turned RO)
  Add tree block owner output for better debugging.
---
 fs/btrfs/extent-tree.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 697dffc9d598..f690cf2be36c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8302,6 +8302,19 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	if (IS_ERR(buf))
 		return buf;
 
+	/*
+	 * Just extra safe net in case extent tree is corrupted and extent
+	 * allocator chooses to use a tree block which is already used and
+	 * locked.
+	 */
+	if (buf->lock_owner == current->pid) {
+		btrfs_err_rl(fs_info,
+"tree block %llu owner %llu already locked by pid=%d, extent tree corruption detected",
+		     buf->start, btrfs_header_owner(buf), current->pid);
+		free_extent_buffer(buf);
+		return ERR_PTR(-EUCLEAN);
+	}
+
 	btrfs_set_header_generation(buf, trans->transid);
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
 	btrfs_tree_lock(buf);
-- 
2.18.0
