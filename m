Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51654 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2G3IQT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 04:16:19 -0400
Date: Mon, 30 Jul 2012 11:16:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>, Arne Jansen <sensille@gmx.net>
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] Btrfs: fix some error codes in btrfs_qgroup_inherit()
Message-ID: <20120730081610.GD15702@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These are returning zero when it should be returning a negative error
code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Applies to linux-next.

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b650155..38b42e7 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1371,8 +1371,10 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 
 	if (srcid) {
 		srcgroup = find_qgroup_rb(fs_info, srcid);
-		if (!srcgroup)
+		if (!srcgroup) {
+			ret = -EINVAL;
 			goto unlock;
+		}
 		dstgroup->rfer = srcgroup->rfer - level_size;
 		dstgroup->rfer_cmpr = srcgroup->rfer_cmpr - level_size;
 		srcgroup->excl = level_size;
@@ -1381,8 +1383,10 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		qgroup_dirty(fs_info, srcgroup);
 	}
 
-	if (!inherit)
+	if (!inherit) {
+		ret = -EINVAL;
 		goto unlock;
+	}
 
 	i_qgroups = (u64 *)(inherit + 1);
 	for (i = 0; i < inherit->num_qgroups; ++i) {
