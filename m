Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61827 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754525AbbCBRrA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 12:47:00 -0500
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t22HjlxZ012827
	for <linux-btrfs@vger.kernel.org>; Mon, 2 Mar 2015 09:46:59 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1svsp50t33-3
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 02 Mar 2015 09:46:59 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix ASSERT(list_empty(&cur_trans->dirty_bgs_list)
Date: Mon, 2 Mar 2015 12:46:55 -0500
Message-ID: <1425318415-322-1-git-send-email-jbacik@fb.com>
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
 fs/btrfs/transaction.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 038fcf6..a7a413f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1023,16 +1023,22 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 	u64 old_root_bytenr;
 	u64 old_root_used;
 	struct btrfs_root *tree_root = root->fs_info->tree_root;
-	bool extent_root = (root->objectid == BTRFS_EXTENT_TREE_OBJECTID);
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	old_root_used = btrfs_root_used(&root->root_item);
 	btrfs_write_dirty_block_groups(trans, root);
 
 	while (1) {
 		old_root_bytenr = btrfs_root_bytenr(&root->root_item);
+
+		/*
+		 * We can only break out if our root matches the root item and
+		 * we either have more roots to process or we have no more roots
+		 * to process and there are no empty bgs.
+		 */
 		if (old_root_bytenr == root->node->start &&
 		    old_root_used == btrfs_root_used(&root->root_item) &&
-		    (!extent_root ||
+		    (!list_empty(&fs_info->dirty_cowonly_roots) ||
 		     list_empty(&trans->transaction->dirty_bgs)))
 			break;
 
@@ -1044,7 +1050,7 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 			return ret;
 
 		old_root_used = btrfs_root_used(&root->root_item);
-		if (extent_root) {
+		if (list_empty(&fs_info->dirty_cowonly_roots)) {
 			ret = btrfs_write_dirty_block_groups(trans, root);
 			if (ret)
 				return ret;
-- 
1.8.3.1

