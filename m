Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbbBXQvo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 11:51:44 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 027D4ADBA
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 16:51:43 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/4] btrfs: comment the rest of implicit barriers before waitqueue_active
Date: Tue, 24 Feb 2015 17:51:42 +0100
Message-Id: <1b127581ed4eb64dc941d2ecaba3174802870c07.1424795734.git.dsterba@suse.cz>
In-Reply-To: <cover.1424795734.git.dsterba@suse.cz>
References: <cover.1424795734.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are atomic operations that imply the barrier for waitqueue_active
mixed in an if-condition.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/delayed-inode.c | 4 ++++
 fs/btrfs/disk-io.c       | 3 +++
 fs/btrfs/inode.c         | 3 +++
 fs/btrfs/locking.c       | 9 +++++++++
 fs/btrfs/volumes.c       | 3 +++
 5 files changed, 22 insertions(+)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 82f0c7c95474..913d8295cb3f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -463,6 +463,10 @@ static int __btrfs_add_delayed_deletion_item(struct btrfs_delayed_node *node,
 static void finish_one_item(struct btrfs_delayed_root *delayed_root)
 {
 	int seq = atomic_inc_return(&delayed_root->items_seq);
+
+	/*
+	 * atomic_dec_return implies a barrier for waitqueue_active
+	 */
 	if ((atomic_dec_return(&delayed_root->items) <
 	    BTRFS_DELAYED_BACKGROUND || seq % BTRFS_DELAYED_BATCH == 0) &&
 	    waitqueue_active(&delayed_root->wait))
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 41b320e235d7..7c29d81bd4b1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -807,6 +807,9 @@ static void run_one_async_done(struct btrfs_work *work)
 	limit = btrfs_async_submit_limit(fs_info);
 	limit = limit * 2 / 3;
 
+	/*
+	 * atomic_dec_return implies a barrier for waitqueue_active
+	 */
 	if (atomic_dec_return(&fs_info->nr_async_submits) < limit &&
 	    waitqueue_active(&fs_info->async_submit_wait))
 		wake_up(&fs_info->async_submit_wait);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8564d8ce03de..11c7866184c6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1089,6 +1089,9 @@ static noinline void async_cow_submit(struct btrfs_work *work)
 	nr_pages = (async_cow->end - async_cow->start + PAGE_CACHE_SIZE) >>
 		PAGE_CACHE_SHIFT;
 
+	/*
+	 * atomic_sub_return implies a barrier for waitqueue_active
+	 */
 	if (atomic_sub_return(nr_pages, &root->fs_info->async_delalloc_pages) <
 	    5 * 1024 * 1024 &&
 	    waitqueue_active(&root->fs_info->async_submit_wait))
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index ec69baf28692..fe6de74bacda 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -79,6 +79,9 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 		write_lock(&eb->lock);
 		WARN_ON(atomic_read(&eb->spinning_writers));
 		atomic_inc(&eb->spinning_writers);
+		/*
+		 * atomic_dec_and_test implies a barrier for waitqueue_active
+		 */
 		if (atomic_dec_and_test(&eb->blocking_writers) &&
 		    waitqueue_active(&eb->write_lock_wq))
 			wake_up(&eb->write_lock_wq);
@@ -86,6 +89,9 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw)
 		BUG_ON(atomic_read(&eb->blocking_readers) == 0);
 		read_lock(&eb->lock);
 		atomic_inc(&eb->spinning_readers);
+		/*
+		 * atomic_dec_and_test implies a barrier for waitqueue_active
+		 */
 		if (atomic_dec_and_test(&eb->blocking_readers) &&
 		    waitqueue_active(&eb->read_lock_wq))
 			wake_up(&eb->read_lock_wq);
@@ -229,6 +235,9 @@ void btrfs_tree_read_unlock_blocking(struct extent_buffer *eb)
 	}
 	btrfs_assert_tree_read_locked(eb);
 	WARN_ON(atomic_read(&eb->blocking_readers) == 0);
+	/*
+	 * atomic_dec_and_test implies a barrier for waitqueue_active
+	 */
 	if (atomic_dec_and_test(&eb->blocking_readers) &&
 	    waitqueue_active(&eb->read_lock_wq))
 		wake_up(&eb->read_lock_wq);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8222f6f74147..8e34332c5f2e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -341,6 +341,9 @@ loop_lock:
 		pending = pending->bi_next;
 		cur->bi_next = NULL;
 
+		/*
+		 * atomic_dec_return implies a barrier for waitqueue_active
+		 */
 		if (atomic_dec_return(&fs_info->nr_async_bios) < limit &&
 		    waitqueue_active(&fs_info->async_submit_wait))
 			wake_up(&fs_info->async_submit_wait);
-- 
1.8.4.5

