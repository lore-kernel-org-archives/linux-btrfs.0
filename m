Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57424 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933325Ab3DGKu6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 06:50:58 -0400
Received: by mail-pa0-f47.google.com with SMTP id bj3so2771736pad.20
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Apr 2013 03:50:57 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangsl-fnst@cn.fujitsu.com, miaox@cn.fujitsu.com, sensille@gmx.net
Subject: [PATCH V3 3/5] Btrfs: fix missing check before creating a qgroup relation
Date: Sun,  7 Apr 2013 18:50:18 +0800
Message-Id: <1365331820-973-4-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1365331820-973-1-git-send-email-wangshilong1991@gmail.com>
References: <1365331820-973-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Step to reproduce:
		mkfs.btrfs <disk>
		mount <disk> <mnt>
		btrfs quota enable <mnt>
		btrfs qgroup assign 0/1 1/1 <mnt>
		umount <mnt>
		btrfs-debug-tree <disk> | grep QGROUP
If we want to add a qgroup relation, we should gurantee that
'src' and 'dst' exist, otherwise, such qgroup relation should
not be allowed to create.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 466bcd6..575e7e4 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -956,6 +956,8 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 			      struct btrfs_fs_info *fs_info, u64 src, u64 dst)
 {
 	struct btrfs_root *quota_root;
+	struct btrfs_qgroup *parent;
+	struct btrfs_qgroup *member;
 	int ret = 0;
 
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
@@ -964,6 +966,12 @@ int btrfs_add_qgroup_relation(struct btrfs_trans_handle *trans,
 		ret = -EINVAL;
 		goto out;
 	}
+	member = find_qgroup_rb(fs_info, src);
+	parent = find_qgroup_rb(fs_info, dst);
+	if (!member || !parent) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = add_qgroup_relation_item(trans, quota_root, src, dst);
 	if (ret)
-- 
1.7.11.7

