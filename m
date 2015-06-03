Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751739AbbFCHCZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 03:02:25 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5370qSK010777
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2015 15:00:52 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: qgroup: allow user to clear the limitation on qgroup
Date: Wed, 3 Jun 2015 14:57:32 +0800
Message-ID: <1433314653-548-2-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1433314653-548-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1433314653-548-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, we can only set a limitation on a qgroup, but we
can not clear it.

This patch provide a choice to user to clear a limitation on
qgroup by passing a value of CLEAR_VALUE(-1) to kernel.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 49 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3d65465..0412d5b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1317,6 +1317,11 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 	struct btrfs_root *quota_root;
 	struct btrfs_qgroup *qgroup;
 	int ret = 0;
+	/* Sometimes we would want to clear the limit on this qgroup.
+	 * To meet this requirement, we treat the -1 as a special value
+	 * which tell kernel to clear the limit on this qgroup.
+	 */
+	const u64 CLEAR_VALUE = -1;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	quota_root = fs_info->quota_root;
@@ -1332,14 +1337,42 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 	}
 
 	spin_lock(&fs_info->qgroup_lock);
-	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
-		qgroup->max_rfer = limit->max_rfer;
-	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
-		qgroup->max_excl = limit->max_excl;
-	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_RFER)
-		qgroup->rsv_rfer = limit->rsv_rfer;
-	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_EXCL)
-		qgroup->rsv_excl = limit->rsv_excl;
+	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_RFER) {
+		if (limit->max_rfer == CLEAR_VALUE) {
+			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_MAX_RFER;
+			limit->flags &= ~BTRFS_QGROUP_LIMIT_MAX_RFER;
+			qgroup->max_rfer = 0;
+		} else {
+			qgroup->max_rfer = limit->max_rfer;
+		}
+	}
+	if (limit->flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) {
+		if (limit->max_excl == CLEAR_VALUE) {
+			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_MAX_EXCL;
+			limit->flags &= ~BTRFS_QGROUP_LIMIT_MAX_EXCL;
+			qgroup->max_excl = 0;
+		} else {
+			qgroup->max_excl = limit->max_excl;
+		}
+	}
+	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_RFER) {
+		if (limit->rsv_rfer == CLEAR_VALUE) {
+			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_RSV_RFER;
+			limit->flags &= ~BTRFS_QGROUP_LIMIT_RSV_RFER;
+			qgroup->rsv_rfer = 0;
+		} else {
+			qgroup->rsv_rfer = limit->rsv_rfer;
+		}
+	}
+	if (limit->flags & BTRFS_QGROUP_LIMIT_RSV_EXCL) {
+		if (limit->rsv_excl == CLEAR_VALUE) {
+			qgroup->lim_flags &= ~BTRFS_QGROUP_LIMIT_RSV_EXCL;
+			limit->flags &= ~BTRFS_QGROUP_LIMIT_RSV_EXCL;
+			qgroup->rsv_excl = 0;
+		} else {
+			qgroup->rsv_excl = limit->rsv_excl;
+		}
+	}
 	qgroup->lim_flags |= limit->flags;
 
 	spin_unlock(&fs_info->qgroup_lock);
-- 
1.8.4.2

