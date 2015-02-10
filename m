Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10319 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755148AbbBJK1v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:51 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAR5P4000981
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:27:05 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 6/7] btrfs: qgroup: apply type to quota rescan.
Date: Tue, 10 Feb 2015 18:24:21 +0800
Message-ID: <1423563862-9151-11-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although we have different type for each qgroup now,
but the rescan is also working as before which is considering
data and metadata both.

This patch fix this problem.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index ba1997f..d4ad565 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1759,7 +1759,8 @@ static int qgroup_calc_new_refcnt(struct btrfs_fs_info *fs_info,
 static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 				  u64 root_to_skip, u64 num_bytes,
 				  struct ulist *qgroups, u64 seq,
-				  int old_roots, int new_roots, int rescan)
+				  int old_roots, int new_roots, int rescan,
+				  u8 qgroup_type)
 {
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
@@ -1771,6 +1772,9 @@ static int qgroup_adjust_counters(struct btrfs_fs_info *fs_info,
 		bool dirty = false;
 
 		qg = u64_to_ptr(unode->aux);
+
+		if (!(qg->type & qgroup_type))
+			continue;
 		/*
 		 * Wasn't referenced before but is now, add to the reference
 		 * counters.
@@ -2007,7 +2011,7 @@ static int qgroup_shared_accounting(struct btrfs_trans_handle *trans,
 	 * solution for this.
 	 */
 	qgroup_adjust_counters(fs_info, oper->ref_root, oper->num_bytes,
-			       qgroups, seq, old_roots, new_roots, 0);
+			       qgroups, seq, old_roots, new_roots, 0, oper->quota_type);
 out:
 	spin_unlock(&fs_info->qgroup_lock);
 	ulist_free(qgroups);
@@ -2670,14 +2674,19 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
 	for (; slot < btrfs_header_nritems(scratch_leaf); ++slot) {
+		u8 type;
+
 		btrfs_item_key_to_cpu(scratch_leaf, &found, slot);
 		if (found.type != BTRFS_EXTENT_ITEM_KEY &&
 		    found.type != BTRFS_METADATA_ITEM_KEY)
 			continue;
-		if (found.type == BTRFS_METADATA_ITEM_KEY)
+		if (found.type == BTRFS_METADATA_ITEM_KEY) {
 			num_bytes = fs_info->extent_root->nodesize;
-		else
+			type = BTRFS_QGROUP_TYPE_METADATA;
+		} else {
 			num_bytes = found.offset;
+			type = BTRFS_QGROUP_TYPE_DATA;
+		}
 
 		ulist_reinit(qgroups);
 		ret = btrfs_find_all_roots(NULL, fs_info, found.objectid, 0,
@@ -2698,7 +2707,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 		}
 
 		ret = qgroup_adjust_counters(fs_info, 0, num_bytes, qgroups,
-					     seq, 0, new_roots, 1);
+					     seq, 0, new_roots, 1, type);
 		if (ret < 0) {
 			spin_unlock(&fs_info->qgroup_lock);
 			ulist_free(roots);
-- 
1.8.4.2

