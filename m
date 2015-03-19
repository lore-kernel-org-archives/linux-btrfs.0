Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62294 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751380AbbCSGFB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 02:05:01 -0400
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>, <jbacik@fb.com>,
        <clm@fb.com>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 6/7] Btrfs: qgroup: account data and metadata separately in rescan.
Date: Thu, 19 Mar 2015 14:01:03 +0800
Message-ID: <1426744864-7031-11-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1426744864-7031-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So far, we can account quota number for data and metadata separately,
but in quota resan, we have not implemented this feature. This patch
make the rescan smart to distingush data and metadata and account them
separately.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9363fd0..bb98bdd 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2872,6 +2872,8 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	int new_roots;
 	int slot;
 	int ret;
+	bool skinny_metadata = btrfs_fs_incompat(fs_info,
+						 SKINNY_METADATA);
 
 	path->leave_spinning = 1;
 	mutex_lock(&fs_info->qgroup_rescan_lock);
@@ -2910,14 +2912,27 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
 	for (; slot < btrfs_header_nritems(scratch_leaf); ++slot) {
+		u8 quota_type = BTRFS_QGROUP_REF_TYPE_DATA;
+		struct btrfs_extent_item *ei;
+		u64 flags;
+
+		ei = btrfs_item_ptr(scratch_leaf, slot, struct btrfs_extent_item);
+		flags = btrfs_extent_flags(scratch_leaf, ei);
+
 		btrfs_item_key_to_cpu(scratch_leaf, &found, slot);
 		if (found.type != BTRFS_EXTENT_ITEM_KEY &&
 		    found.type != BTRFS_METADATA_ITEM_KEY)
 			continue;
-		if (found.type == BTRFS_METADATA_ITEM_KEY)
+		if (found.type == BTRFS_METADATA_ITEM_KEY) {
 			num_bytes = fs_info->extent_root->nodesize;
-		else
+			if (btrfs_fs_incompat(fs_info, QGROUP_TYPE))
+				quota_type = BTRFS_QGROUP_REF_TYPE_METADATA;
+		} else {
 			num_bytes = found.offset;
+			if (!skinny_metadata && (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) &&
+			    btrfs_fs_incompat(fs_info, QGROUP_TYPE))
+				quota_type = BTRFS_QGROUP_REF_TYPE_METADATA;
+		}
 
 		ulist_reinit(qgroups);
 		ret = btrfs_find_all_roots(NULL, fs_info, found.objectid, 0,
@@ -2937,7 +2952,7 @@ qgroup_rescan_leaf(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 			goto out;
 		}
 
-		ret = qgroup_adjust_counters(fs_info, 0, num_bytes, 0, qgroups,
+		ret = qgroup_adjust_counters(fs_info, 0, num_bytes, quota_type, qgroups,
 					     seq, 0, new_roots, 1);
 		if (ret < 0) {
 			spin_unlock(&fs_info->qgroup_lock);
-- 
1.8.4.2

