From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: cleanup transaction starting and fix
	current->journal_info setting
Date: Tue, 3 Nov 2009 10:16:12 -0500
Message-ID: <20091103151612.GB5541@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We use journal_info to tell if we're in a nested transaction to make sure we
don't commit the transaction within a nested transaction.  We use another
method to see if there are any outstanding ioctl trans handles, so if we're
starting one do not set current->journal_info, since it will screw with other
filesystems.  This patch also cleans up the starting stuff so there aren't any
magic numbers.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/transaction.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index bca82a4..c207e8c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -163,8 +163,14 @@ static void wait_current_trans(struct btrfs_root *root)
 	}
 }
 
+enum btrfs_trans_type {
+	TRANS_START,
+	TRANS_JOIN,
+	TRANS_USERSPACE,
+};
+
 static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
-					     int num_blocks, int wait)
+					     int num_blocks, int type)
 {
 	struct btrfs_trans_handle *h =
 		kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
@@ -172,7 +178,8 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 
 	mutex_lock(&root->fs_info->trans_mutex);
 	if (!root->fs_info->log_root_recovering &&
-	    ((wait == 1 && !root->fs_info->open_ioctl_trans) || wait == 2))
+	    ((type == TRANS_START && !root->fs_info->open_ioctl_trans) ||
+	     type == TRANS_USERSPACE))
 		wait_current_trans(root);
 	ret = join_transaction(root);
 	BUG_ON(ret);
@@ -186,7 +193,7 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 	h->alloc_exclude_start = 0;
 	h->delayed_ref_updates = 0;
 
-	if (!current->journal_info)
+	if (!current->journal_info && type != TRANS_USERSPACE)
 		current->journal_info = h;
 
 	root->fs_info->running_transaction->use_count++;
@@ -198,18 +205,18 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_blocks)
 {
-	return start_transaction(root, num_blocks, 1);
+	return start_transaction(root, num_blocks, TRANS_START);
 }
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
 						   int num_blocks)
 {
-	return start_transaction(root, num_blocks, 0);
+	return start_transaction(root, num_blocks, TRANS_JOIN);
 }
 
 struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
 							 int num_blocks)
 {
-	return start_transaction(r, num_blocks, 2);
+	return start_transaction(r, num_blocks, TRANS_USERSPACE);
 }
 
 /* wait for a transaction commit to be fully complete */
-- 
1.5.4.3

