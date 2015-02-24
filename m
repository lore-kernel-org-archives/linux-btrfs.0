Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21802 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721AbbBXVgH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 16:36:07 -0500
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t1OLVulS000777
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 13:36:05 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1sry8ar8yt-5
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 13:36:05 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: check before stealing from the global rsv in evict
Date: Tue, 24 Feb 2015 16:35:41 -0500
Message-ID: <1424813741-26172-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even with all of the current fixes we still had one gluster box abort() with
enospc when removing files.  This is because evict() will steal from the global
reserve unconditionally if it cannot make its reservation.  This isn't ideal
when we've built up a lot of backlock in delayed refs, so we can race with this
migration and the checks to see if we need to commit the transaction.  So
instead note that we need to steal from the global reserve and then check if we
have enough space in the global reserve to handle the outstanding work we have
queued up.  If not we commit the transaction and try again.  If we fail to get
space again and commit the transaction again we'll break out and let it cleanup
after a remount.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6d82bd..6938b83 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4892,6 +4892,7 @@ void btrfs_evict_inode(struct inode *inode)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv, *global_rsv;
+	int steal_from_global = 0;
 	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
 	int ret;
 
@@ -4959,9 +4960,20 @@ void btrfs_evict_inode(struct inode *inode)
 		 * hard as possible to get this to work.
 		 */
 		if (ret)
-			ret = btrfs_block_rsv_migrate(global_rsv, rsv, min_size);
+			steal_from_global++;
+		else
+			steal_from_global = 0;
+		ret = 0;
 
-		if (ret) {
+		/*
+		 * steal_from_global == 0: we reserved stuff, hooray!
+		 * steal_from_global == 1: we didn't reserve stuff, boo!
+		 * steal_from_global == 2: we've committed, still not a lot of
+		 * room but maybe we'll have room in the global reserve this
+		 * time.
+		 * steal_from_global == 3: abandon all hope!
+		 */
+		if (steal_from_global > 2) {
 			btrfs_warn(root->fs_info,
 				"Could not get space for a delete, will truncate on mount %d",
 				ret);
@@ -4977,6 +4989,36 @@ void btrfs_evict_inode(struct inode *inode)
 			goto no_delete;
 		}
 
+		/*
+		 * We can't just steal from the global reserve, we need tomake
+		 * sure there is room to do it, if not we need to commit and try
+		 * again.
+		 */
+		if (steal_from_global) {
+			if (!btrfs_check_space_for_delayed_refs(trans, root))
+				ret = btrfs_block_rsv_migrate(global_rsv, rsv,
+							      min_size);
+			else
+				ret = -ENOSPC;
+		}
+
+		/*
+		 * Couldn't steal from the global reserve, we have too much
+		 * pending stuff built up, commit the transaction and try it
+		 * again.
+		 */
+		if (ret) {
+			ret = btrfs_commit_transaction(trans, root);
+			if (ret) {
+				btrfs_orphan_del(NULL, inode);
+				btrfs_free_block_rsv(root, rsv);
+				goto no_delete;
+			}
+			continue;
+		} else {
+			steal_from_global = 0;
+		}
+
 		trans->block_rsv = rsv;
 
 		ret = btrfs_truncate_inode_items(trans, root, inode, 0, 0);
-- 
1.8.3.1

