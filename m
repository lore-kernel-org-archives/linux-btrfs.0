From: Sage Weil <sage@newdream.net>
Subject: [PATCH] fix ioctl-initiated transactions vs wait_current_trans()
 deadlock
Date: Sat, 2 Aug 2008 12:39:56 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0808021135050.23304@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Commit 597:466b27332893 (btrfs_start_transaction: wait for commits in 
progress) breaks the transaction start/stop ioctls by making 
btrfs_start_transaction conditionally wait for the next transaction to 
start.  If an application artificially is holding a transaction open, 
things deadlock.

This workaround maintains a count of open ioctl-initiated transactions in 
fs_info, and avoids wait_current_trans() if any are currently open (in 
start_transaction() and btrfs_throttle()).  The start transaction ioctl 
uses a new btrfs_start_ioctl_transaction() that _does_ call 
wait_current_trans(), effectively pushing the join/wait decision to the 
outer ioctl-initiated transaction.

This more or less neuters btrfs_throttle() when ioctl-initiated 
transactions are in use, but that seems like a pretty fundamental 
consequence of wrapping lots of write()'s in a transaction.  Btrfs has no 
way to tell if the application considers a given operation as part of it's 
transaction.

I'm not sure if throttle_on_drops() should also be avoided in that case?

Obviously, if the transaction start/stop ioctls aren't being used, there 
is no effect on current behavior.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 ctree.h       |    1 +
 ioctl.c       |   12 +++++++++++-
 transaction.c |   18 +++++++++++++-----
 transaction.h |    2 ++
 4 files changed, 27 insertions(+), 6 deletions(-)

diff -r 76a2ce720c36 ctree.h
--- a/ctree.h	Fri Aug 01 15:11:20 2008 -0400
+++ b/ctree.h	Sat Aug 02 12:06:17 2008 -0700
@@ -518,6 +518,7 @@ struct btrfs_fs_info {
 
 	u64 generation;
 	u64 last_trans_committed;
+	u64 open_ioctl_trans;
 	unsigned long mount_opt;
 	u64 max_extent;
 	u64 max_inline;
diff -r 76a2ce720c36 ioctl.c
--- a/ioctl.c	Fri Aug 01 15:11:20 2008 -0400
+++ b/ioctl.c	Sat Aug 02 12:06:17 2008 -0700
@@ -715,7 +715,12 @@ long btrfs_ioctl_trans_start(struct file
 		ret = -EINPROGRESS;
 		goto out;
 	}
-	trans = btrfs_start_transaction(root, 0);
+
+	mutex_lock(&root->fs_info->trans_mutex);
+	root->fs_info->open_ioctl_trans++;
+	mutex_unlock(&root->fs_info->trans_mutex);
+
+	trans = btrfs_start_ioctl_transaction(root, 0);
 	if (trans)
 		file->private_data = trans;
 	else
@@ -745,6 +750,11 @@ long btrfs_ioctl_trans_end(struct file *
 	}
 	btrfs_end_transaction(trans, root);
 	file->private_data = 0;
+
+	mutex_lock(&root->fs_info->trans_mutex);
+	root->fs_info->open_ioctl_trans--;
+	mutex_unlock(&root->fs_info->trans_mutex);
+
 out:
 	return ret;
 }
diff -r 76a2ce720c36 transaction.c
--- a/transaction.c	Fri Aug 01 15:11:20 2008 -0400
+++ b/transaction.c	Sat Aug 02 12:06:17 2008 -0700
@@ -152,14 +152,14 @@ static void wait_current_trans(struct bt
 }
 
 struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
-					     int num_blocks, int join)
+					     int num_blocks, int wait)
 {
 	struct btrfs_trans_handle *h =
 		kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
 	int ret;
 
 	mutex_lock(&root->fs_info->trans_mutex);
-	if (!join)
+	if ((wait == 1 && !root->fs_info->open_ioctl_trans) || wait == 2)
 		wait_current_trans(root);
 	ret = join_transaction(root);
 	BUG_ON(ret);
@@ -180,13 +180,20 @@ struct btrfs_trans_handle *btrfs_start_t
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_blocks)
 {
-	return start_transaction(root, num_blocks, 0);
+	return start_transaction(root, num_blocks, 1);
 }
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
 						   int num_blocks)
 {
-	return start_transaction(root, num_blocks, 1);
+	return start_transaction(root, num_blocks, 0);
 }
+
+struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
+							 int num_blocks)
+{
+	return start_transaction(r, num_blocks, 2);
+}
+
 
 static noinline int wait_for_commit(struct btrfs_root *root,
 				    struct btrfs_transaction *commit)
@@ -232,7 +239,8 @@ void btrfs_throttle(struct btrfs_root *r
 void btrfs_throttle(struct btrfs_root *root)
 {
 	mutex_lock(&root->fs_info->trans_mutex);
-	wait_current_trans(root);
+	if (!root->fs_info->open_ioctl_trans)
+		wait_current_trans(root);
 	mutex_unlock(&root->fs_info->trans_mutex);
 
 	throttle_on_drops(root);
diff -r 76a2ce720c36 transaction.h
--- a/transaction.h	Fri Aug 01 15:11:20 2008 -0400
+++ b/transaction.h	Sat Aug 02 12:06:17 2008 -0700
@@ -83,6 +83,8 @@ struct btrfs_trans_handle *btrfs_start_t
 						   int num_blocks);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
 						   int num_blocks);
+struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
+						   int num_blocks);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root);
 int btrfs_commit_tree_roots(struct btrfs_trans_handle *trans,

