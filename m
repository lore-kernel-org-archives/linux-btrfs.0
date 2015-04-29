Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4720 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031493AbbD2Cb2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 22:31:28 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3T2UCIo018342
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2015 10:30:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 12/18] btrfs: qgroup: Switch rescan to new mechanism.
Date: Wed, 29 Apr 2015 10:29:05 +0800
Message-ID: <1430274551-9277-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Switch rescan to use the new new extent oriented mechanism.

As rescan is also based on extent, new mechanism is just a perfect match
for rescan.

With re-designed internal functions, rescan is quite easy, just call
btrfs_find_all_roots() and then btrfs_qgroup_account_one_extent().

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  None
---
 fs/btrfs/qgroup.c | 43 +++++++------------------------------------
 1 file changed, 7 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c6975f1..c86e515 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2877,15 +2877,13 @@ void assert_qgroups_uptodate(struct btrfs_trans_handle *trans)
  */
 static int
 qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
-		   struct btrfs_trans_handle *trans, struct ulist *qgroups,
-		   struct ulist *tmp, struct extent_buffer *scratch_leaf)
+		   struct btrfs_trans_handle *trans,
+		   struct extent_buffer *scratch_leaf)
 {
 	struct btrfs_key found;
 	struct ulist *roots = NULL;
 	struct seq_list tree_mod_seq_elem = {};
 	u64 num_bytes;
-	u64 seq;
-	int new_roots;
 	int slot;
 	int ret;
 
@@ -2935,33 +2933,15 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		else
 			num_bytes = found.offset;
 
-		ulist_reinit(qgroups);
 		ret = btrfs_find_all_roots(NULL, fs_info, found.objectid, 0,
 					   &roots);
 		if (ret < 0)
 			goto out;
-		spin_lock(&fs_info->qgroup_lock);
-		seq = fs_info->qgroup_seq;
-		fs_info->qgroup_seq += roots->nnodes + 1; /* max refcnt */
-
-		new_roots = 0;
-		ret = qgroup_calc_old_refcnt(fs_info, 0, tmp, roots, qgroups,
-					     seq, &new_roots, 1);
-		if (ret < 0) {
-			spin_unlock(&fs_info->qgroup_lock);
-			ulist_free(roots);
-			goto out;
-		}
-
-		ret = qgroup_adjust_counters(fs_info, 0, num_bytes, qgroups,
-					     seq, 0, new_roots, 1);
-		if (ret < 0) {
-			spin_unlock(&fs_info->qgroup_lock);
-			ulist_free(roots);
+		/* For rescan, just pass old_roots as NULL */
+		ret = btrfs_qgroup_account_extent(trans, fs_info,
+				found.objectid, num_bytes, NULL, roots);
+		if (ret < 0)
 			goto out;
-		}
-		spin_unlock(&fs_info->qgroup_lock);
-		ulist_free(roots);
 	}
 out:
 	btrfs_put_tree_mod_seq(fs_info, &tree_mod_seq_elem);
@@ -2975,19 +2955,12 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 						     qgroup_rescan_work);
 	struct btrfs_path *path;
 	struct btrfs_trans_handle *trans = NULL;
-	struct ulist *tmp = NULL, *qgroups = NULL;
 	struct extent_buffer *scratch_leaf = NULL;
 	int err = -ENOMEM;
 
 	path = btrfs_alloc_path();
 	if (!path)
 		goto out;
-	qgroups = ulist_alloc(GFP_NOFS);
-	if (!qgroups)
-		goto out;
-	tmp = ulist_alloc(GFP_NOFS);
-	if (!tmp)
-		goto out;
 	scratch_leaf = kmalloc(sizeof(*scratch_leaf), GFP_NOFS);
 	if (!scratch_leaf)
 		goto out;
@@ -3003,7 +2976,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 			err = -EINTR;
 		} else {
 			err = qgroup_rescan_leaf(fs_info, path, trans,
-						 qgroups, tmp, scratch_leaf);
+						 scratch_leaf);
 		}
 		if (err > 0)
 			btrfs_commit_transaction(trans, fs_info->fs_root);
@@ -3013,8 +2986,6 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 
 out:
 	kfree(scratch_leaf);
-	ulist_free(qgroups);
-	ulist_free(tmp);
 	btrfs_free_path(path);
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
-- 
2.3.6

