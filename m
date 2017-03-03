Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25204 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751369AbdCCI5v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 03:57:51 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 04/17] fs, btrfs: convert btrfs_ordered_extent.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:13 +0200
Message-Id: <1488531326-21271-5-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
References: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/btrfs/ordered-data.c      | 18 +++++++++---------
 fs/btrfs/ordered-data.h      |  2 +-
 include/trace/events/btrfs.h |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index da5399f..7b40e2e 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -212,7 +212,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 		set_bit(BTRFS_ORDERED_DIRECT, &entry->flags);
 
 	/* one ref for the tree */
-	atomic_set(&entry->refs, 1);
+	refcount_set(&entry->refs, 1);
 	init_waitqueue_head(&entry->wait);
 	INIT_LIST_HEAD(&entry->list);
 	INIT_LIST_HEAD(&entry->root_extent_list);
@@ -358,7 +358,7 @@ int btrfs_dec_test_first_ordered_pending(struct inode *inode,
 out:
 	if (!ret && cached && entry) {
 		*cached = entry;
-		atomic_inc(&entry->refs);
+		refcount_inc(&entry->refs);
 	}
 	spin_unlock_irqrestore(&tree->lock, flags);
 	return ret == 0;
@@ -425,7 +425,7 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 out:
 	if (!ret && cached && entry) {
 		*cached = entry;
-		atomic_inc(&entry->refs);
+		refcount_inc(&entry->refs);
 	}
 	spin_unlock_irqrestore(&tree->lock, flags);
 	return ret == 0;
@@ -456,7 +456,7 @@ void btrfs_get_logged_extents(struct btrfs_inode *inode,
 		if (test_and_set_bit(BTRFS_ORDERED_LOGGED, &ordered->flags))
 			continue;
 		list_add(&ordered->log_list, logged_list);
-		atomic_inc(&ordered->refs);
+		refcount_inc(&ordered->refs);
 	}
 	spin_unlock_irq(&tree->lock);
 }
@@ -565,7 +565,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 
 	trace_btrfs_ordered_extent_put(entry->inode, entry);
 
-	if (atomic_dec_and_test(&entry->refs)) {
+	if (refcount_dec_and_test(&entry->refs)) {
 		ASSERT(list_empty(&entry->log_list));
 		ASSERT(list_empty(&entry->trans_list));
 		ASSERT(list_empty(&entry->root_extent_list));
@@ -690,7 +690,7 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr,
 
 		list_move_tail(&ordered->root_extent_list,
 			       &root->ordered_extents);
-		atomic_inc(&ordered->refs);
+		refcount_inc(&ordered->refs);
 		spin_unlock(&root->ordered_extent_lock);
 
 		btrfs_init_work(&ordered->flush_work,
@@ -870,7 +870,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_extent(struct inode *inode,
 	if (!offset_in_entry(entry, file_offset))
 		entry = NULL;
 	if (entry)
-		atomic_inc(&entry->refs);
+		refcount_inc(&entry->refs);
 out:
 	spin_unlock_irq(&tree->lock);
 	return entry;
@@ -911,7 +911,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(
 	}
 out:
 	if (entry)
-		atomic_inc(&entry->refs);
+		refcount_inc(&entry->refs);
 	spin_unlock_irq(&tree->lock);
 	return entry;
 }
@@ -948,7 +948,7 @@ btrfs_lookup_first_ordered_extent(struct inode *inode, u64 file_offset)
 		goto out;
 
 	entry = rb_entry(node, struct btrfs_ordered_extent, rb_node);
-	atomic_inc(&entry->refs);
+	refcount_inc(&entry->refs);
 out:
 	spin_unlock_irq(&tree->lock);
 	return entry;
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 195c93b..e0c1d5b 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -113,7 +113,7 @@ struct btrfs_ordered_extent {
 	int compress_type;
 
 	/* reference count */
-	atomic_t refs;
+	refcount_t refs;
 
 	/* the inode we belong to */
 	struct inode *inode;
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 9dd29e8..8f206263 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -275,7 +275,7 @@ DECLARE_EVENT_CLASS(btrfs__ordered_extent,
 		__entry->bytes_left	= ordered->bytes_left;
 		__entry->flags		= ordered->flags;
 		__entry->compress_type	= ordered->compress_type;
-		__entry->refs		= atomic_read(&ordered->refs);
+		__entry->refs		= refcount_read(&ordered->refs);
 		__entry->root_objectid	=
 				BTRFS_I(inode)->root->root_key.objectid;
 		__entry->truncated_len	= ordered->truncated_len;
-- 
2.7.4

