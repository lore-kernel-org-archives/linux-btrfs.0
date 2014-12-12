Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16443 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981AbaLLVBV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 16:01:21 -0500
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id sBCKvp5T022862
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 13:01:20 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1r84s4rtru-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 13:01:20 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: separate out the extent root update
Date: Fri, 12 Dec 2014 16:01:17 -0500
Message-ID: <1418418077-1223-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Depending on where the extent root shows up in the dirty list we could end up
recowing the extent root a few times during commit.  This is inefficient, so
instead only track the other COW only roots and update them all at once, and
then do the extent root/block group update loop by itself to try and reduce the
amount of churn we do at commit time.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/disk-io.c     |  1 -
 fs/btrfs/transaction.c | 34 +++++++++++++++++++---------------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2409718..b69402a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2713,7 +2713,6 @@ retry_root_backup:
 		ret = PTR_ERR(extent_root);
 		goto recovery_tree_root;
 	}
-	set_bit(BTRFS_ROOT_TRACK_DIRTY, &extent_root->state);
 	fs_info->extent_root = extent_root;
 
 	location.objectid = BTRFS_DEV_TREE_OBJECTID;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index dcaae36..1b84595 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -933,17 +933,16 @@ int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 }
 
 /*
- * this is used to update the root pointer in the tree of tree roots.
+ * Update the extent_root pointer in the tree of tree roots.
  *
- * But, in the case of the extent allocation tree, updating the root
- * pointer may allocate blocks which may change the root of the extent
- * allocation tree.
+ * In the case of the extent allocation tree, updating the root pointer may
+ * allocate blocks which may change the root of the extent allocation tree.
  *
  * So, this loops and repeats and makes sure the cowonly root didn't
  * change while the root pointer was being updated in the metadata.
  */
-static int update_cowonly_root(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root)
+static int update_extent_root(struct btrfs_trans_handle *trans,
+			      struct btrfs_root *root)
 {
 	int ret;
 	u64 old_root_bytenr;
@@ -986,6 +985,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 					 struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct list_head *next;
 	struct extent_buffer *eb;
 	int ret;
@@ -1017,26 +1017,30 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	/* run_qgroups might have added some more refs */
-	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-	if (ret)
-		return ret;
-
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
 		next = fs_info->dirty_cowonly_roots.next;
 		list_del_init(next);
 		root = list_entry(next, struct btrfs_root, dirty_list);
 
-		if (root != fs_info->extent_root)
-			list_add_tail(&root->dirty_list,
-				      &trans->transaction->switch_commits);
-		ret = update_cowonly_root(trans, root);
+		list_add_tail(&root->dirty_list,
+			      &trans->transaction->switch_commits);
+		btrfs_set_root_node(&root->root_item, root->node);
+		ret = btrfs_update_root(trans, tree_root, &root->root_key,
+					&root->root_item);
 		if (ret)
 			return ret;
 	}
 
+	ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
+	if (ret)
+		return ret;
+
 	list_add_tail(&fs_info->extent_root->dirty_list,
 		      &trans->transaction->switch_commits);
+	ret = update_extent_root(trans, fs_info->extent_root);
+	if (ret)
+		return ret;
+
 	btrfs_after_dev_replace_commit(fs_info);
 
 	return 0;
-- 
1.8.3.1

