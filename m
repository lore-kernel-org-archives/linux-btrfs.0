Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33461 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751795AbdCCJHA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:07:00 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 08/17] fs, btrfs: convert btrfs_delayed_item.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:17 +0200
Message-Id: <1488531326-21271-9-git-send-email-elena.reshetova@intel.com>
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
 fs/btrfs/delayed-inode.c | 18 +++++++++---------
 fs/btrfs/delayed-inode.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 7396c36..8ae409b 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -308,7 +308,7 @@ static struct btrfs_delayed_item *btrfs_alloc_delayed_item(u32 data_len)
 		item->ins_or_del = 0;
 		item->bytes_reserved = 0;
 		item->delayed_node = NULL;
-		atomic_set(&item->refs, 1);
+		refcount_set(&item->refs, 1);
 	}
 	return item;
 }
@@ -483,7 +483,7 @@ static void btrfs_release_delayed_item(struct btrfs_delayed_item *item)
 {
 	if (item) {
 		__btrfs_remove_delayed_item(item);
-		if (atomic_dec_and_test(&item->refs))
+		if (refcount_dec_and_test(&item->refs))
 			kfree(item);
 	}
 }
@@ -1600,14 +1600,14 @@ bool btrfs_readdir_get_delayed_items(struct inode *inode,
 	mutex_lock(&delayed_node->mutex);
 	item = __btrfs_first_delayed_insertion_item(delayed_node);
 	while (item) {
-		atomic_inc(&item->refs);
+		refcount_inc(&item->refs);
 		list_add_tail(&item->readdir_list, ins_list);
 		item = __btrfs_next_delayed_item(item);
 	}
 
 	item = __btrfs_first_delayed_deletion_item(delayed_node);
 	while (item) {
-		atomic_inc(&item->refs);
+		refcount_inc(&item->refs);
 		list_add_tail(&item->readdir_list, del_list);
 		item = __btrfs_next_delayed_item(item);
 	}
@@ -1634,13 +1634,13 @@ void btrfs_readdir_put_delayed_items(struct inode *inode,
 
 	list_for_each_entry_safe(curr, next, ins_list, readdir_list) {
 		list_del(&curr->readdir_list);
-		if (atomic_dec_and_test(&curr->refs))
+		if (refcount_dec_and_test(&curr->refs))
 			kfree(curr);
 	}
 
 	list_for_each_entry_safe(curr, next, del_list, readdir_list) {
 		list_del(&curr->readdir_list);
-		if (atomic_dec_and_test(&curr->refs))
+		if (refcount_dec_and_test(&curr->refs))
 			kfree(curr);
 	}
 
@@ -1667,7 +1667,7 @@ int btrfs_should_delete_dir_index(struct list_head *del_list,
 		list_del(&curr->readdir_list);
 		ret = (curr->key.offset == index);
 
-		if (atomic_dec_and_test(&curr->refs))
+		if (refcount_dec_and_test(&curr->refs))
 			kfree(curr);
 
 		if (ret)
@@ -1705,7 +1705,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 		list_del(&curr->readdir_list);
 
 		if (curr->key.offset < ctx->pos) {
-			if (atomic_dec_and_test(&curr->refs))
+			if (refcount_dec_and_test(&curr->refs))
 				kfree(curr);
 			continue;
 		}
@@ -1722,7 +1722,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
 		over = !dir_emit(ctx, name, name_len,
 			       location.objectid, d_type);
 
-		if (atomic_dec_and_test(&curr->refs))
+		if (refcount_dec_and_test(&curr->refs))
 			kfree(curr);
 
 		if (over)
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index d234974..6d4f5a0 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -81,7 +81,7 @@ struct btrfs_delayed_item {
 	struct list_head readdir_list;	/* used for readdir items */
 	u64 bytes_reserved;
 	struct btrfs_delayed_node *delayed_node;
-	atomic_t refs;
+	refcount_t refs;
 	int ins_or_del;
 	u32 data_len;
 	char data[0];
-- 
2.7.4

