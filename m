Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64679 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755559AbcI3BQ0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 21:16:26 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: rgoldwyn@suse.de, rgoldwyn@suse.com
Subject: [PATCH 1/2] btrfs: Add WARN_ON for qgroup reserved underflow
Date: Fri, 30 Sep 2016 09:15:36 +0800
Message-Id: <20160930011537.4857-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While the reason why qgroup reserved space may underflow is still under
investigation, such WARN_ON will help us to expose the bug more easily,
and for end-user we can detect and avoid underflow.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 8db2e29..8532587 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1061,8 +1061,12 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 	WARN_ON(sign < 0 && qgroup->excl < num_bytes);
 	qgroup->excl += sign * num_bytes;
 	qgroup->excl_cmpr += sign * num_bytes;
-	if (sign > 0)
-		qgroup->reserved -= num_bytes;
+	if (sign > 0) {
+		if (WARN_ON(qgroup->reserved < num_bytes))
+			qgroup->reserved = 0;
+		else
+			qgroup->reserved -= num_bytes;
+	}
 
 	qgroup_dirty(fs_info, qgroup);
 
@@ -1082,8 +1086,12 @@ static int __qgroup_excl_accounting(struct btrfs_fs_info *fs_info,
 		qgroup->rfer_cmpr += sign * num_bytes;
 		WARN_ON(sign < 0 && qgroup->excl < num_bytes);
 		qgroup->excl += sign * num_bytes;
-		if (sign > 0)
-			qgroup->reserved -= num_bytes;
+		if (sign > 0) {
+			if (WARN_ON(qgroup->reserved < num_bytes))
+				qgroup->reserved = 0;
+			else
+				qgroup->reserved -= num_bytes;
+		}
 		qgroup->excl_cmpr += sign * num_bytes;
 		qgroup_dirty(fs_info, qgroup);
 
@@ -2201,7 +2209,10 @@ void btrfs_qgroup_free_refroot(struct btrfs_fs_info *fs_info,
 
 		qg = u64_to_ptr(unode->aux);
 
-		qg->reserved -= num_bytes;
+		if (WARN_ON(qgroup->reserved < num_bytes))
+			qgroup->reserved = 0;
+		else
+			qgroup->reserved -= num_bytes;
 
 		list_for_each_entry(glist, &qg->groups, next_group) {
 			ret = ulist_add(fs_info->qgroup_ulist,
-- 
2.10.0



