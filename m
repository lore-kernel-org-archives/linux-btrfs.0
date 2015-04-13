Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39649 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510AbbDMTXA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 15:23:00 -0400
Received: from pps.filterd (m0004348 [127.0.0.1])
	by m0004348.ppops.net (8.14.5/8.14.5) with SMTP id t3DJIcYo000308
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:23:00 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0004348.ppops.net with ESMTP id 1trfum8g4n-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:23:00 -0700
Received: from facebook.com (2401:db00:20:702c:face:0:2f:0)	by
 mx-out.facebook.com (10.212.236.87) with ESMTP	id
 7e3611e6e21211e48fd20002c9521c9e-ce3fc2c0 for <linux-btrfs@vger.kernel.org>;
	Mon, 13 Apr 2015 12:22:58 -0700
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] Btrfs: don't steal from the global reserve if we don't have the space
Date: Mon, 13 Apr 2015 12:22:52 -0700
Message-ID: <1428952972-1266934-6-git-send-email-clm@fb.com>
In-Reply-To: <1428952972-1266934-1-git-send-email-clm@fb.com>
References: <1428952972-1266934-1-git-send-email-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

btrfs_evict_inode() needs to be more careful about stealing from the
global_rsv.  We dont' want to end up aborting commit with ENOSPC just
because the evict_inode code was too greedy.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/inode.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 88537c5..141df0c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5010,6 +5010,7 @@ void btrfs_evict_inode(struct inode *inode)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv, *global_rsv;
+	int steal_from_global = 0;
 	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
 	int ret;
 
@@ -5077,9 +5078,20 @@ void btrfs_evict_inode(struct inode *inode)
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
@@ -5095,6 +5107,36 @@ void btrfs_evict_inode(struct inode *inode)
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
1.8.1

