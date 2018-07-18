Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8361 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbeGRJFB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 05:05:01 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id B942F4B5CD80
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2018 16:28:10 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 13/19] btrfs: qgroup: Drop fs_info parameter from btrfs_qgroup_trace_extent
Date: Wed, 18 Jul 2018 16:28:03 +0800
Message-ID: <20180718082803.16351-1-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180718064542.2730-14-lufq.fnst@cn.fujitsu.com>
References: <20180718064542.2730-14-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be fetched from the transaction handle. In addition, remove the
WARN_ON(trans == NULL) because there shouldn't hit this condition.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
v2:
Remove the WARN_ON(trans == NULL) suggested by Qu Wenruo.

 fs/btrfs/qgroup.c   | 15 ++++++---------
 fs/btrfs/qgroup.h   |  5 ++---
 fs/btrfs/tree-log.c |  2 +-
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index c85c1a0e933a..7621ad34244f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1579,10 +1579,10 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
-		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
-		gfp_t gfp_flag)
+int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
+			      u64 num_bytes, gfp_t gfp_flag)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_qgroup_extent_record *record;
 	struct btrfs_delayed_ref_root *delayed_refs;
 	int ret;
@@ -1590,8 +1590,6 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
 	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)
 	    || bytenr == 0 || num_bytes == 0)
 		return 0;
-	if (WARN_ON(trans == NULL))
-		return -EINVAL;
 	record = kmalloc(sizeof(*record), gfp_flag);
 	if (!record)
 		return -ENOMEM;
@@ -1644,8 +1642,8 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
 
 		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
 
-		ret = btrfs_qgroup_trace_extent(trans, fs_info, bytenr,
-						num_bytes, GFP_NOFS);
+		ret = btrfs_qgroup_trace_extent(trans, bytenr, num_bytes,
+						GFP_NOFS);
 		if (ret)
 			return ret;
 	}
@@ -1796,8 +1794,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
 
-			ret = btrfs_qgroup_trace_extent(trans, fs_info,
-							child_bytenr,
+			ret = btrfs_qgroup_trace_extent(trans, child_bytenr,
 							fs_info->nodesize,
 							GFP_NOFS);
 			if (ret)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 385367989ed6..0215dc0b1710 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -212,9 +212,8 @@ int btrfs_qgroup_trace_extent_post(struct btrfs_fs_info *fs_info,
  * Return <0 for error, like memory allocation failure or invalid parameter
  * (NULL trans)
  */
-int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
-		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
-		gfp_t gfp_flag);
+int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans, u64 bytenr,
+			      u64 num_bytes, gfp_t gfp_flag);
 
 /*
  * Inform qgroup to trace all leaf items of data
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7b7498f1f641..10f6a4223897 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -685,7 +685,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		 * as the owner of the file extent changed from log tree
 		 * (doesn't affect qgroup) to fs/file tree(affects qgroup)
 		 */
-		ret = btrfs_qgroup_trace_extent(trans, fs_info,
+		ret = btrfs_qgroup_trace_extent(trans,
 				btrfs_file_extent_disk_bytenr(eb, item),
 				btrfs_file_extent_disk_num_bytes(eb, item),
 				GFP_NOFS);
-- 
2.18.0



