Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4524 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754810AbbBJK0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:26:45 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAPx63000852
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:25:59 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/9] btrfs: qgroup: update qgroup in memory at the same time when we update it in btree.
Date: Tue, 10 Feb 2015 18:23:17 +0800
Message-ID: <1423563803-8996-6-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we call btrfs_qgroup_inherit() with BTRFS_QGROUP_INHERIT_SET_LIMITS,
btrfs will update the limit info of qgroup in btree but forget to update
the qgroup in rbtree at the same time. It obviousely will cause an inconsistency.

This patch fix it by updating the rbtree at the same time.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b2cee33..1aae0c3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2230,17 +2230,6 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	if (inherit && inherit->flags & BTRFS_QGROUP_INHERIT_SET_LIMITS) {
-		ret = update_qgroup_limit_item(trans, quota_root, objectid,
-					       inherit->lim.flags,
-					       inherit->lim.max_rfer,
-					       inherit->lim.max_excl,
-					       inherit->lim.rsv_rfer,
-					       inherit->lim.rsv_excl);
-		if (ret)
-			goto out;
-	}
-
 	if (srcid) {
 		struct btrfs_root *srcroot;
 		struct btrfs_key srckey;
@@ -2286,6 +2275,23 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		goto unlock;
 	}
 
+	if (inherit && inherit->flags & BTRFS_QGROUP_INHERIT_SET_LIMITS) {
+		ret = update_qgroup_limit_item(trans, quota_root, objectid,
+					       inherit->lim.flags,
+					       inherit->lim.max_rfer,
+					       inherit->lim.max_excl,
+					       inherit->lim.rsv_rfer,
+					       inherit->lim.rsv_excl);
+		if (ret)
+			goto unlock;
+
+		dstgroup->lim_flags = inherit->lim.flags;
+		dstgroup->max_rfer = inherit->lim.max_rfer;
+		dstgroup->max_excl = inherit->lim.max_excl;
+		dstgroup->rsv_rfer = inherit->lim.rsv_rfer;
+		dstgroup->rsv_excl = inherit->lim.rsv_excl;
+	}
+
 	if (srcid) {
 		srcgroup = find_qgroup_rb(fs_info, srcid);
 		if (!srcgroup)
-- 
1.8.4.2

