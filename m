Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10319 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755182AbbBJK1u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:27:50 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAR38h000970
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:27:03 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 4/7] btrfs: qgroup: Apply qgroup type to qgroup creating.
Date: Tue, 10 Feb 2015 18:24:19 +0800
Message-ID: <1423563862-9151-9-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563862-9151-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch provide a method to user to create a qgroup
in a specified type.

It use a byte of the ->create in btrfs_ioctl_qgroup_create_args
to pass the type of qgroup to kernel. Then there is a macro
named as BTRFS_QGROUP_TYPE_SHIFT to help kernel get the type
of qgroup user want to creat.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c  | 12 ++++++++++--
 fs/btrfs/qgroup.h |  6 ++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index a50f295..b1f46e8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4675,8 +4675,16 @@ static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
 
 	/* FIXME: check if the IDs really exist */
 	if (sa->create) {
-		ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid,
-					  BTRFS_QGROUP_TYPE_DEFAULT);
+		u8 type = (sa->create >> BTRFS_QGROUP_TYPE_SHIFT);
+		if (type) {
+			if (!btrfs_fs_incompat(root->fs_info, QGROUP_TYPE)) {
+				ret = -EINVAL;
+				goto out;
+			}
+		} else {
+			type = BTRFS_QGROUP_TYPE_DEFAULT;
+		}
+		ret = btrfs_create_qgroup(trans, root->fs_info, sa->qgroupid, type);
 	} else {
 		ret = btrfs_remove_qgroup(trans, root->fs_info, sa->qgroupid);
 	}
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 75d0bb6..0be0548 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -30,6 +30,12 @@
 #define BTRFS_QGROUP_TYPE_DEFAULT	BTRFS_QGROUP_TYPE_MIXED
 
 /*
+ * We are using the first byte in ->create of btrfs_ioctl_qgroup_create_args
+ * to specify the type of the qgroup to be created.
+ */
+#define BTRFS_QGROUP_TYPE_SHIFT		56
+
+/*
  * A description of the operations, all of these operations only happen when we
  * are adding the 1st reference for that subvolume in the case of adding space
  * or on the last reference delete in the case of subtraction.  The only
-- 
1.8.4.2

