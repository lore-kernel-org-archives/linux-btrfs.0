Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6307 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729306AbeGRHWb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 03:22:31 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 85A8F4B5CD99
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 14:46:08 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 14/19] btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_trace_leaf_items
Date: Wed, 18 Jul 2018 14:45:37 +0800
Message-ID: <20180718064542.2730-15-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/qgroup.c      | 8 ++++----
 fs/btrfs/qgroup.h      | 1 -
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ced26ba8d392..51da902a0ad7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8760,7 +8760,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
 			else
 				ret = btrfs_dec_ref(trans, root, eb, 0);
 			BUG_ON(ret); /* -ENOMEM */
-			ret = btrfs_qgroup_trace_leaf_items(trans, fs_info, eb);
+			ret = btrfs_qgroup_trace_leaf_items(trans, eb);
 			if (ret) {
 				btrfs_err_rl(fs_info,
 					     "error %d accounting leaf items. Quota is out of sync, rescan required.",
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 01add73cb2aa..5cce45c30735 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1612,9 +1612,9 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 }
 
 int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info,
 				  struct extent_buffer *eb)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int nr = btrfs_header_nritems(eb);
 	int i, extent_type, ret;
 	struct btrfs_key key;
@@ -1738,7 +1738,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 	}
 
 	if (root_level == 0) {
-		ret = btrfs_qgroup_trace_leaf_items(trans, fs_info, root_eb);
+		ret = btrfs_qgroup_trace_leaf_items(trans, root_eb);
 		goto out;
 	}
 
@@ -1804,8 +1804,8 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 		}
 
 		if (level == 0) {
-			ret = btrfs_qgroup_trace_leaf_items(trans,fs_info,
-							   path->nodes[level]);
+			ret = btrfs_qgroup_trace_leaf_items(trans,
+							    path->nodes[level]);
 			if (ret)
 				goto out;
 
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 0215dc0b1710..9d434a01d467 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -222,7 +222,6 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
  * Return <0 for error(ENOMEM)
  */
 int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
-				  struct btrfs_fs_info *fs_info,
 				  struct extent_buffer *eb);
 /*
  * Inform qgroup to trace a whole subtree, including all its child tree
-- 
2.18.0



