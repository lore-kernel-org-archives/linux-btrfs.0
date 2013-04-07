Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52881 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933322Ab3DGKvA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 06:51:00 -0400
Received: by mail-pd0-f169.google.com with SMTP id 10so2748765pdc.14
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Apr 2013 03:50:59 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com, miaox@cn.fujitsu.com, sensille@gmx.net
Subject: [PATCH V3 4/5] Btrfs: fix missing check in the btrfs_qgroup_inherit()
Date: Sun,  7 Apr 2013 18:50:19 +0800
Message-Id: <1365331820-973-5-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1365331820-973-1-git-send-email-wangshilong1991@gmail.com>
References: <1365331820-973-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

The original code forgot to check 'inherit', we should
gurantee that all the qgroups in the struct 'inherit' exist.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 575e7e4..d0870c8 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1414,6 +1414,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 	struct btrfs_qgroup *srcgroup;
 	struct btrfs_qgroup *dstgroup;
 	u32 level_size = 0;
+	u64 nums;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (!fs_info->quota_enabled)
@@ -1424,6 +1425,20 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
+	if (inherit) {
+		i_qgroups = (u64 *)(inherit + 1);
+		nums = inherit->num_qgroups + 2 * inherit->num_ref_copies +
+		       2 * inherit->num_excl_copies;
+		for (i = 0; i < nums; ++i) {
+			srcgroup = find_qgroup_rb(fs_info, *i_qgroups);
+			if (!srcgroup) {
+				ret = -EINVAL;
+				goto out;
+			}
+			++i_qgroups;
+		}
+	}
+
 	/*
 	 * create a tracking group for the subvol itself
 	 */
-- 
1.7.11.7

