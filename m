Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33882 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2LGJXa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2012 04:23:30 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qB79NTuN025280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Dec 2012 09:23:30 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qB79NSfJ008689
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Dec 2012 09:23:29 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qB79NSNu004855
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Dec 2012 03:23:28 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: rename root_times_lock to root_item_lock
Date: Fri,  7 Dec 2012 17:28:54 +0800
Message-Id: <1354872534-17728-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Originally root_times_lock was introduced as part of send/receive
code however newly developed patch to label the subvol reused
the same lock, so renaming it for a meaningful name.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.c     |   16 ++++++++--------
 fs/btrfs/ctree.h     |    2 +-
 fs/btrfs/disk-io.c   |    2 +-
 fs/btrfs/ioctl.c     |   10 +++++-----
 fs/btrfs/root-tree.c |    4 ++--
 fs/btrfs/send.c      |    8 ++++----
 6 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index cdfb4c4..a19fb29 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -5123,13 +5123,13 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 	right_path->search_commit_root = 1;
 	right_path->skip_locking = 1;
 
-	spin_lock(&left_root->root_times_lock);
+	spin_lock(&left_root->root_item_lock);
 	left_start_ctransid = btrfs_root_ctransid(&left_root->root_item);
-	spin_unlock(&left_root->root_times_lock);
+	spin_unlock(&left_root->root_item_lock);
 
-	spin_lock(&right_root->root_times_lock);
+	spin_lock(&right_root->root_item_lock);
 	right_start_ctransid = btrfs_root_ctransid(&right_root->root_item);
-	spin_unlock(&right_root->root_times_lock);
+	spin_unlock(&right_root->root_item_lock);
 
 	trans = btrfs_join_transaction(left_root);
 	if (IS_ERR(trans)) {
@@ -5224,15 +5224,15 @@ int btrfs_compare_trees(struct btrfs_root *left_root,
 				goto out;
 			}
 
-			spin_lock(&left_root->root_times_lock);
+			spin_lock(&left_root->root_item_lock);
 			ctransid = btrfs_root_ctransid(&left_root->root_item);
-			spin_unlock(&left_root->root_times_lock);
+			spin_unlock(&left_root->root_item_lock);
 			if (ctransid != left_start_ctransid)
 				left_start_ctransid = 0;
 
-			spin_lock(&right_root->root_times_lock);
+			spin_lock(&right_root->root_item_lock);
 			ctransid = btrfs_root_ctransid(&right_root->root_item);
-			spin_unlock(&right_root->root_times_lock);
+			spin_unlock(&right_root->root_item_lock);
 			if (ctransid != right_start_ctransid)
 				right_start_ctransid = 0;
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 039e11c..b99aa87 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1581,7 +1581,7 @@ struct btrfs_root {
 
 	int force_cow;
 
-	spinlock_t root_times_lock;
+	spinlock_t root_item_lock;
 };
 
 struct btrfs_ioctl_defrag_range_args {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7cda519..32b2bd8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1193,7 +1193,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->root_key.objectid = objectid;
 	root->anon_dev = 0;
 
-	spin_lock_init(&root->root_times_lock);
+	spin_lock_init(&root->root_item_lock);
 }
 
 static int __must_check find_and_setup_root(struct btrfs_root *tree_root,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index abbac27..27228d3 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3730,13 +3730,13 @@ static int btrfs_ioctl_subvol_getlabel(struct btrfs_root *root,
 {
 	char *label;
 
-	spin_lock(&root->root_times_lock);
+	spin_lock(&root->root_item_lock);
 	label = btrfs_root_label(&root->root_item);
 	if (copy_to_user(arg, label, BTRFS_SUBVOL_LABEL_SIZE)) {
-		spin_unlock(&root->root_times_lock);
+		spin_unlock(&root->root_item_lock);
 		return -EFAULT;
 	}
-	spin_unlock(&root->root_times_lock);
+	spin_unlock(&root->root_item_lock);
 	return 0;
 }
 
@@ -3769,9 +3769,9 @@ static int btrfs_ioctl_subvol_setlabel(struct file *file,
 		ret = PTR_ERR(trans);
 		goto out;
 	}
-	spin_lock(&root->root_times_lock);
+	spin_lock(&root->root_item_lock);
 	btrfs_root_set_label(&root->root_item, label);
-	spin_unlock(&root->root_times_lock);
+	spin_unlock(&root->root_item_lock);
 	btrfs_end_transaction(trans, root);
 
 out:
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index eb923d0..668af53 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -548,9 +548,9 @@ void btrfs_update_root_times(struct btrfs_trans_handle *trans,
 	struct btrfs_root_item *item = &root->root_item;
 	struct timespec ct = CURRENT_TIME;
 
-	spin_lock(&root->root_times_lock);
+	spin_lock(&root->root_item_lock);
 	item->ctransid = cpu_to_le64(trans->transid);
 	item->ctime.sec = cpu_to_le64(ct.tv_sec);
 	item->ctime.nsec = cpu_to_le32(ct.tv_nsec);
-	spin_unlock(&root->root_times_lock);
+	spin_unlock(&root->root_item_lock);
 }
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e78b297..5445454 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4397,9 +4397,9 @@ static int full_send_tree(struct send_ctx *sctx)
 	if (!path)
 		return -ENOMEM;
 
-	spin_lock(&send_root->root_times_lock);
+	spin_lock(&send_root->root_item_lock);
 	start_ctransid = btrfs_root_ctransid(&send_root->root_item);
-	spin_unlock(&send_root->root_times_lock);
+	spin_unlock(&send_root->root_item_lock);
 
 	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
 	key.type = BTRFS_INODE_ITEM_KEY;
@@ -4422,9 +4422,9 @@ join_trans:
 	 * Make sure the tree has not changed after re-joining. We detect this
 	 * by comparing start_ctransid and ctransid. They should always match.
 	 */
-	spin_lock(&send_root->root_times_lock);
+	spin_lock(&send_root->root_item_lock);
 	ctransid = btrfs_root_ctransid(&send_root->root_item);
-	spin_unlock(&send_root->root_times_lock);
+	spin_unlock(&send_root->root_item_lock);
 
 	if (ctransid != start_ctransid) {
 		WARN(1, KERN_WARNING "btrfs: the root that you're trying to "
-- 
1.7.1

