Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56389 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754333AbeBGP4G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:06 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BA7CBACED
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 07/14] btrfs: Don't pass fs_info to btrfs_run_delayed_items/_nr
Date: Wed,  7 Feb 2018 17:55:43 +0200
Message-Id: <1518018950-31456-8-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We already pass the transaction which has a reference to the fs_info,
so use that. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/delayed-inode.c |  6 ++----
 fs/btrfs/delayed-inode.h |  6 ++----
 fs/btrfs/extent-tree.c   |  2 +-
 fs/btrfs/transaction.c   |  8 ++++----
 fs/btrfs/tree-log.c      | 12 ++++--------
 5 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 1305872bbff8..86cc0f5b0435 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1161,14 +1161,12 @@ static int __btrfs_run_delayed_items(struct btrfs_trans_handle *trans, int nr)
 	return ret;
 }
 
-int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info)
+int btrfs_run_delayed_items(struct btrfs_trans_handle *trans)
 {
 	return __btrfs_run_delayed_items(trans, -1);
 }
 
-int btrfs_run_delayed_items_nr(struct btrfs_trans_handle *trans,
-			       struct btrfs_fs_info *fs_info, int nr)
+int btrfs_run_delayed_items_nr(struct btrfs_trans_handle *trans, int nr)
 {
 	return __btrfs_run_delayed_items(trans, nr);
 }
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index c4189d495934..ae893d85224f 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -111,10 +111,8 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 
 int btrfs_inode_delayed_dir_index_count(struct btrfs_inode *inode);
 
-int btrfs_run_delayed_items(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info);
-int btrfs_run_delayed_items_nr(struct btrfs_trans_handle *trans,
-			       struct btrfs_fs_info *fs_info, int nr);
+int btrfs_run_delayed_items(struct btrfs_trans_handle *trans);
+int btrfs_run_delayed_items_nr(struct btrfs_trans_handle *trans, int nr);
 
 void btrfs_balance_delayed_items(struct btrfs_fs_info *fs_info);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 47c27fc403b9..52cb4eb12318 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4994,7 +4994,7 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 			ret = PTR_ERR(trans);
 			break;
 		}
-		ret = btrfs_run_delayed_items_nr(trans, fs_info, nr);
+		ret = btrfs_run_delayed_items_nr(trans, nr);
 		btrfs_end_transaction(trans);
 		break;
 	case FLUSH_DELALLOC:
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index aef311531ab2..f24f05fb508e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1529,7 +1529,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 * otherwise we corrupt the FS during
 	 * snapshot
 	 */
-	ret = btrfs_run_delayed_items(trans, fs_info);
+	ret = btrfs_run_delayed_items(trans);
 	if (ret) {	/* Transaction aborted */
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
@@ -2066,7 +2066,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	if (ret)
 		goto cleanup_transaction;
 
-	ret = btrfs_run_delayed_items(trans, fs_info);
+	ret = btrfs_run_delayed_items(trans);
 	if (ret)
 		goto cleanup_transaction;
 
@@ -2074,7 +2074,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		   extwriter_counter_read(cur_trans) == 0);
 
 	/* some pending stuffs might be added after the previous flush. */
-	ret = btrfs_run_delayed_items(trans, fs_info);
+	ret = btrfs_run_delayed_items(trans);
 	if (ret)
 		goto cleanup_transaction;
 
@@ -2127,7 +2127,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 * because all the tree which are snapshoted will be forced to COW
 	 * the nodes and leaves.
 	 */
-	ret = btrfs_run_delayed_items(trans, fs_info);
+	ret = btrfs_run_delayed_items(trans);
 	if (ret) {
 		mutex_unlock(&fs_info->reloc_mutex);
 		goto scrub_continue;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index df8e76d01dbe..2fbe49a04933 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -852,7 +852,6 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 				      struct btrfs_inode *dir,
 				      struct btrfs_dir_item *di)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct inode *inode;
 	char *name;
 	int name_len;
@@ -886,7 +885,7 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 	else
-		ret = btrfs_run_delayed_items(trans, fs_info);
+		ret = btrfs_run_delayed_items(trans);
 out:
 	kfree(name);
 	iput(inode);
@@ -1004,7 +1003,6 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				  u64 ref_index, char *name, int namelen,
 				  int *search_done)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 	char *victim_name;
 	int victim_name_len;
@@ -1062,7 +1060,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 				kfree(victim_name);
 				if (ret)
 					return ret;
-				ret = btrfs_run_delayed_items(trans, fs_info);
+				ret = btrfs_run_delayed_items(trans);
 				if (ret)
 					return ret;
 				*search_done = 1;
@@ -1133,8 +1131,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 							victim_name_len);
 					if (!ret)
 						ret = btrfs_run_delayed_items(
-								  trans,
-								  fs_info);
+								  trans);
 				}
 				iput(victim_parent);
 				kfree(victim_name);
@@ -1991,7 +1988,6 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 				      struct inode *dir,
 				      struct btrfs_key *dir_key)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 	struct extent_buffer *eb;
 	int slot;
@@ -2055,7 +2051,7 @@ static noinline int check_item_in_log(struct btrfs_trans_handle *trans,
 			ret = btrfs_unlink_inode(trans, root, BTRFS_I(dir),
 					BTRFS_I(inode), name, name_len);
 			if (!ret)
-				ret = btrfs_run_delayed_items(trans, fs_info);
+				ret = btrfs_run_delayed_items(trans);
 			kfree(name);
 			iput(inode);
 			if (ret)
-- 
2.7.4

