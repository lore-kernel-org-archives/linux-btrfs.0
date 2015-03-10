Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47767 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751390AbbCJWSY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Mar 2015 18:18:24 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t2AM9Me5012247
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2015 15:18:23 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1t28t683cq-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2015 15:18:23 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix ASSERT(list_empty(&cur_trans->dirty_bgs_list) V2
Date: Tue, 10 Mar 2015 18:18:20 -0400
Message-ID: <1426025900-29261-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave could hit this assert consistently running btrfs/078.  This is because
when we update the block groups we could truncate the free space, which would
try to delete the csums for that range and dirty the csum root.  For this to
happen we have to have already written out the csum root so it's kind of hard to
hit this case.  This patch fixes this by changing the logic to only write the
dirty block groups if the dirty_cowonly_roots list is empty.  This will get us
the same effect as before since we add the extent root last, and will cover the
case that we dirty some other root again but not the extent root.  Thanks,

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: moved the logic to the loop in commit_cowonly_roots so we can be sure
that we're always running delayed refs and always writing the drity block
groups.

 fs/btrfs/transaction.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 038fcf6..97e9c7f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1023,7 +1023,6 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 	u64 old_root_bytenr;
 	u64 old_root_used;
 	struct btrfs_root *tree_root = root->fs_info->tree_root;
-	bool extent_root = (root->objectid == BTRFS_EXTENT_TREE_OBJECTID);
 
 	old_root_used = btrfs_root_used(&root->root_item);
 	btrfs_write_dirty_block_groups(trans, root);
@@ -1031,9 +1030,7 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 	while (1) {
 		old_root_bytenr = btrfs_root_bytenr(&root->root_item);
 		if (old_root_bytenr == root->node->start &&
-		    old_root_used == btrfs_root_used(&root->root_item) &&
-		    (!extent_root ||
-		     list_empty(&trans->transaction->dirty_bgs)))
+		    old_root_used == btrfs_root_used(&root->root_item))
 			break;
 
 		btrfs_set_root_node(&root->root_item, root->node);
@@ -1044,17 +1041,6 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 			return ret;
 
 		old_root_used = btrfs_root_used(&root->root_item);
-		if (extent_root) {
-			ret = btrfs_write_dirty_block_groups(trans, root);
-			if (ret)
-				return ret;
-		}
-		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-		if (ret)
-			return ret;
-		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
-		if (ret)
-			return ret;
 	}
 
 	return 0;
@@ -1115,6 +1101,14 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans,
 		ret = update_cowonly_root(trans, root);
 		if (ret)
 			return ret;
+		if (list_empty(&fs_info->dirty_cowonly_roots)) {
+			ret = btrfs_write_dirty_block_groups(trans, root);
+			if (ret)
+				return ret;
+		}
+		ret = btrfs_run_delayed_refs(trans, root, (unsigned long)-1);
+		if (ret)
+			return ret;
 	}
 
 	list_add_tail(&fs_info->extent_root->dirty_list,
-- 
1.9.3

