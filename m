Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbbBXQvh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 11:51:37 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 82CE7ADBA
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 16:51:36 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/4] btrfs: add comments to barriers before waitqueue_active
Date: Tue, 24 Feb 2015 17:51:36 +0100
Message-Id: <7ddde866fbaf3b492401b494e4e2744f6439c01c.1424795734.git.dsterba@suse.cz>
In-Reply-To: <cover.1424795734.git.dsterba@suse.cz>
References: <cover.1424795734.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reduce number of undocumented barriers out there.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/compression.c  | 3 +++
 fs/btrfs/extent-tree.c  | 3 +--
 fs/btrfs/locking.c      | 3 +++
 fs/btrfs/ordered-data.c | 6 ++++++
 fs/btrfs/transaction.c  | 3 +++
 5 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e9df8862012c..38ffb5526b1b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -838,6 +838,9 @@ static void free_workspace(int type, struct list_head *workspace)
 	btrfs_compress_op[idx]->free_workspace(workspace);
 	atomic_dec(alloc_workspace);
 wake:
+	/*
+	 * Make sure counter is updated before we wake up waiters.
+	 */
 	smp_mb();
 	if (waitqueue_active(workspace_wait))
 		wake_up(workspace_wait);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 28ce5c8004d4..46ca10ab243f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9732,8 +9732,7 @@ void btrfs_end_write_no_snapshoting(struct btrfs_root *root)
 {
 	percpu_counter_dec(&root->subv_writers->counter);
 	/*
-	 * Make sure counter is updated before we wake up
-	 * waiters.
+	 * Make sure counter is updated before we wake up waiters.
 	 */
 	smp_mb();
 	if (waitqueue_active(&root->subv_writers->wait))
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index f8229ef1b46d..ec69baf28692 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -279,6 +279,9 @@ void btrfs_tree_unlock(struct extent_buffer *eb)
 	if (blockers) {
 		WARN_ON(atomic_read(&eb->spinning_writers));
 		atomic_dec(&eb->blocking_writers);
+		/*
+		 * Make sure counter is updated before we wake up waiters.
+		 */
 		smp_mb();
 		if (waitqueue_active(&eb->write_lock_wq))
 			wake_up(&eb->write_lock_wq);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 534544e08f76..09dc73e7df7b 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -352,6 +352,9 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 
 	if (entry->bytes_left == 0) {
 		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
+		/*
+		 * Implicit memory barrier after test_and_set_bit
+		 */
 		if (waitqueue_active(&entry->wait))
 			wake_up(&entry->wait);
 	} else {
@@ -416,6 +419,9 @@ have_entry:
 
 	if (entry->bytes_left == 0) {
 		ret = test_and_set_bit(BTRFS_ORDERED_IO_DONE, &entry->flags);
+		/*
+		 * Implicit memory barrier after test_and_set_bit
+		 */
 		if (waitqueue_active(&entry->wait))
 			wake_up(&entry->wait);
 	} else {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 90ba0c3c3d0d..6302939345a8 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -814,6 +814,9 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	atomic_dec(&cur_trans->num_writers);
 	extwriter_counter_dec(cur_trans, trans->type);
 
+	/*
+	 * Make sure counter is updated before we wake up waiters.
+	 */
 	smp_mb();
 	if (waitqueue_active(&cur_trans->writer_wait))
 		wake_up(&cur_trans->writer_wait);
-- 
1.8.4.5

