Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54375 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752722AbeCOP1m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 11:27:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7F076AF73
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 15:27:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: drop fs_info parameter from btrfs_run_delayed_refs
Date: Thu, 15 Mar 2018 17:27:37 +0200
Message-Id: <1521127657-6074-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1521122427-25062-1-git-send-email-nborisov@suse.com>
References: <1521122427-25062-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's provided by the trans handle

Signed-off-by: Nikolay Borisov <nborisov@suse.com>

---

V2: Fixed some build failures. 
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/extent-tree.c |  9 +++++----
 fs/btrfs/inode.c       |  4 +---
 fs/btrfs/transaction.c | 23 +++++++++++------------
 4 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8046e3f9c0d2..b037541d393d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2623,7 +2623,7 @@ void btrfs_dec_nocow_writers(struct btrfs_fs_info *fs_info, u64 bytenr);
 void btrfs_wait_nocow_writers(struct btrfs_block_group_cache *bg);
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
-			   struct btrfs_fs_info *fs_info, unsigned long count);
+			   unsigned long count);
 int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
 				 unsigned long count, u64 transid, int wait);
 int btrfs_lookup_data_extent(struct btrfs_fs_info *fs_info, u64 start, u64 len);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 60ece25101ee..f931c0d59fd3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2992,7 +2992,7 @@ static void delayed_ref_async_start(struct btrfs_work *work)
 	if (trans->transid > async->transid)
 		goto end;
 
-	ret = btrfs_run_delayed_refs(trans, fs_info, async->count);
+	ret = btrfs_run_delayed_refs(trans, async->count);
 	if (ret)
 		async->error = ret;
 end:
@@ -3051,8 +3051,9 @@ int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
  * Returns <0 on error and aborts the transaction
  */
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
-			   struct btrfs_fs_info *fs_info, unsigned long count)
+			   unsigned long count)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct rb_node *node;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	struct btrfs_delayed_ref_head *head;
@@ -3799,7 +3800,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans)
 	 * go through delayed refs for all the stuff we've just kicked off
 	 * and then loop back (just once)
 	 */
-	ret = btrfs_run_delayed_refs(trans, fs_info, 0);
+	ret = btrfs_run_delayed_refs(trans, 0);
 	if (!ret && loops == 0) {
 		loops++;
 		spin_lock(&cur_trans->dirty_bgs_lock);
@@ -3881,7 +3882,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 		cache_save_setup(cache, trans, path);
 
 		if (!ret)
-			ret = btrfs_run_delayed_refs(trans, fs_info,
+			ret = btrfs_run_delayed_refs(trans,
 						     (unsigned long) -1);
 
 		if (!ret && cache->disk_cache_state == BTRFS_DC_SETUP) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index baaba3564177..3fae8d9220ac 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4730,7 +4730,6 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 				if (updates) {
 					trans->delayed_ref_updates = 0;
 					ret = btrfs_run_delayed_refs(trans,
-								   fs_info,
 								   updates * 2);
 					if (ret && !err)
 						err = ret;
@@ -4770,8 +4769,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		unsigned long updates = trans->delayed_ref_updates;
 		if (updates) {
 			trans->delayed_ref_updates = 0;
-			ret = btrfs_run_delayed_refs(trans, fs_info,
-						     updates * 2);
+			ret = btrfs_run_delayed_refs(trans, updates * 2);
 			if (ret && !err)
 				err = ret;
 		}
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 24e41f36e249..9913aa9f3a25 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -781,7 +781,6 @@ static int should_end_transaction(struct btrfs_trans_handle *trans)
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
-	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int updates;
 	int err;
 
@@ -793,7 +792,7 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
 	updates = trans->delayed_ref_updates;
 	trans->delayed_ref_updates = 0;
 	if (updates) {
-		err = btrfs_run_delayed_refs(trans, fs_info, updates * 2);
+		err = btrfs_run_delayed_refs(trans, updates * 2);
 		if (err) /* Error code will also eval true */
 			return err;
 	}
@@ -1161,7 +1160,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 	if (ret)
 		return ret;
 
-	ret = btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1);
+	ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
 	if (ret)
 		return ret;
 
@@ -1180,7 +1179,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 		return ret;
 
 	/* run_qgroups might have added some more refs */
-	ret = btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1);
+	ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
 	if (ret)
 		return ret;
 again:
@@ -1197,7 +1196,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 		ret = update_cowonly_root(trans, root);
 		if (ret)
 			return ret;
-		ret = btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1);
+		ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
 		if (ret)
 			return ret;
 	}
@@ -1206,7 +1205,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 		ret = btrfs_write_dirty_block_groups(trans, fs_info);
 		if (ret)
 			return ret;
-		ret = btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1);
+		ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
 		if (ret)
 			return ret;
 	}
@@ -1617,7 +1616,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	ret = btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1);
+	ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
@@ -1671,7 +1670,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	ret = btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1);
+	ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
@@ -1958,7 +1957,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	/* make a pass through all the delayed refs we have so far
 	 * any runnings procs may add more while we are here
 	 */
-	ret = btrfs_run_delayed_refs(trans, fs_info, 0);
+	ret = btrfs_run_delayed_refs(trans, 0);
 	if (ret) {
 		btrfs_end_transaction(trans);
 		return ret;
@@ -1979,7 +1978,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (!list_empty(&trans->new_bgs))
 		btrfs_create_pending_block_groups(trans);
 
-	ret = btrfs_run_delayed_refs(trans, fs_info, 0);
+	ret = btrfs_run_delayed_refs(trans, 0);
 	if (ret) {
 		btrfs_end_transaction(trans);
 		return ret;
@@ -2128,7 +2127,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		goto scrub_continue;
 	}
 
-	ret = btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1);
+	ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
 	if (ret) {
 		mutex_unlock(&fs_info->reloc_mutex);
 		goto scrub_continue;
@@ -2179,7 +2178,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 * commit_fs_roots() can call btrfs_save_ino_cache(), which generates
 	 * new delayed refs. Must handle them or qgroup can be wrong.
 	 */
-	ret = btrfs_run_delayed_refs(trans, fs_info, (unsigned long)-1);
+	ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
 	if (ret) {
 		mutex_unlock(&fs_info->tree_log_mutex);
 		mutex_unlock(&fs_info->reloc_mutex);
-- 
2.7.4

