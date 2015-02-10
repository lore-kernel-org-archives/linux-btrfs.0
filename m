Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24217 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754827AbbBJK0q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:26:46 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQ0eK000856
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:00 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 4/9] btrfs: qgroup: consolidate the parameter of fucntion update_qgroup_limit_item().
Date: Tue, 10 Feb 2015 18:23:18 +0800
Message-ID: <1423563803-8996-7-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cleanup: Change the parameter of update_qgroup_limit_item() to the family of
update_qgroup_xxx_item().

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 51 ++++++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1aae0c3..a7ffebb 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -644,9 +644,8 @@ out:
 }
 
 static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *root, u64 qgroupid,
-				    u64 flags, u64 max_rfer, u64 max_excl,
-				    u64 rsv_rfer, u64 rsv_excl)
+				    struct btrfs_root *root,
+				    struct btrfs_qgroup *qgroup)
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -657,7 +656,7 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 
 	key.objectid = 0;
 	key.type = BTRFS_QGROUP_LIMIT_KEY;
-	key.offset = qgroupid;
+	key.offset = qgroup->qgroupid;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -673,11 +672,11 @@ static int update_qgroup_limit_item(struct btrfs_trans_handle *trans,
 	l = path->nodes[0];
 	slot = path->slots[0];
 	qgroup_limit = btrfs_item_ptr(l, slot, struct btrfs_qgroup_limit_item);
-	btrfs_set_qgroup_limit_flags(l, qgroup_limit, flags);
-	btrfs_set_qgroup_limit_max_rfer(l, qgroup_limit, max_rfer);
-	btrfs_set_qgroup_limit_max_excl(l, qgroup_limit, max_excl);
-	btrfs_set_qgroup_limit_rsv_rfer(l, qgroup_limit, rsv_rfer);
-	btrfs_set_qgroup_limit_rsv_excl(l, qgroup_limit, rsv_excl);
+	btrfs_set_qgroup_limit_flags(l, qgroup_limit, qgroup->lim_flags);
+	btrfs_set_qgroup_limit_max_rfer(l, qgroup_limit, qgroup->max_rfer);
+	btrfs_set_qgroup_limit_max_excl(l, qgroup_limit, qgroup->max_excl);
+	btrfs_set_qgroup_limit_rsv_rfer(l, qgroup_limit, qgroup->rsv_rfer);
+	btrfs_set_qgroup_limit_rsv_excl(l, qgroup_limit, qgroup->rsv_excl);
 
 	btrfs_mark_buffer_dirty(l);
 
@@ -1184,15 +1183,6 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		ret = -ENOENT;
 		goto out;
 	}
-	ret = update_qgroup_limit_item(trans, quota_root, qgroupid,
-				       limit->flags, limit->max_rfer,
-				       limit->max_excl, limit->rsv_rfer,
-				       limit->rsv_excl);
-	if (ret) {
-		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-		btrfs_info(fs_info, "unable to update quota limit for %llu",
-		       qgroupid);
-	}
 
 	spin_lock(&fs_info->qgroup_lock);
 	qgroup->lim_flags = limit->flags;
@@ -1201,6 +1191,14 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 	qgroup->rsv_rfer = limit->rsv_rfer;
 	qgroup->rsv_excl = limit->rsv_excl;
 	spin_unlock(&fs_info->qgroup_lock);
+
+	ret = update_qgroup_limit_item(trans, quota_root, qgroup);
+	if (ret) {
+		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+		btrfs_info(fs_info, "unable to update quota limit for %llu",
+		       qgroupid);
+	}
+
 out:
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
@@ -2276,20 +2274,19 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	}
 
 	if (inherit && inherit->flags & BTRFS_QGROUP_INHERIT_SET_LIMITS) {
-		ret = update_qgroup_limit_item(trans, quota_root, objectid,
-					       inherit->lim.flags,
-					       inherit->lim.max_rfer,
-					       inherit->lim.max_excl,
-					       inherit->lim.rsv_rfer,
-					       inherit->lim.rsv_excl);
-		if (ret)
-			goto unlock;
-
 		dstgroup->lim_flags = inherit->lim.flags;
 		dstgroup->max_rfer = inherit->lim.max_rfer;
 		dstgroup->max_excl = inherit->lim.max_excl;
 		dstgroup->rsv_rfer = inherit->lim.rsv_rfer;
 		dstgroup->rsv_excl = inherit->lim.rsv_excl;
+
+		ret = update_qgroup_limit_item(trans, quota_root, dstgroup);
+		if (ret) {
+			fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+			btrfs_info(fs_info, "unable to update quota limit for %llu",
+			       dstgroup->qgroupid);
+			goto unlock;
+		}
 	}
 
 	if (srcid) {
-- 
1.8.4.2

