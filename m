Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41445 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320Ab3DGKvD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 06:51:03 -0400
Received: by mail-pa0-f42.google.com with SMTP id kq13so2762604pab.15
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Apr 2013 03:51:02 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com, miaox@cn.fujitsu.com, sensille@gmx.net
Subject: [PATCH V3 5/5] Btrfs: fix a warning when updating qgroup limit
Date: Sun,  7 Apr 2013 18:50:20 +0800
Message-Id: <1365331820-973-6-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1365331820-973-1-git-send-email-wangshilong1991@gmail.com>
References: <1365331820-973-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Step to reproduce:
	mkfs.btrfs <disk>
	mount <disk> <mnt>
	btrfs quota enable <mnt>
	btrfs qgroup limit 0/1 <mnt>
	dmesg

If the relative qgroup dosen't exist, flag 'BTRFS_QGROUP_STATUS_
FLAG_INCONSISTENT' will be set, and print the noise message.
This is wrong, we can just move find_qgroup_rb() before
update_qgroup_limit_item().this dosen't change the logic of the
function. But it can avoid unnecessary noise message and wrong set of flag.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d0870c8..deaa2e8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1094,6 +1094,11 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
+	qgroup = find_qgroup_rb(fs_info, qgroupid);
+	if (!qgroup) {
+		ret = -ENOENT;
+		goto out;
+	}
 	ret = update_qgroup_limit_item(trans, quota_root, qgroupid,
 				       limit->flags, limit->max_rfer,
 				       limit->max_excl, limit->rsv_rfer,
@@ -1104,11 +1109,6 @@ int btrfs_limit_qgroup(struct btrfs_trans_handle *trans,
 		       (unsigned long long)qgroupid);
 	}
 
-	qgroup = find_qgroup_rb(fs_info, qgroupid);
-	if (!qgroup) {
-		ret = -ENOENT;
-		goto out;
-	}
 	spin_lock(&fs_info->qgroup_lock);
 	qgroup->lim_flags = limit->flags;
 	qgroup->max_rfer = limit->max_rfer;
-- 
1.7.11.7

