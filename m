Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46546 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbcEJOCJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 10:02:09 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH] btrfs: introduce BTRFS_FEATURE_INCOMPAT_SPARE_DEV
Date: Tue, 10 May 2016 22:01:44 +0800
Message-Id: <1462888911-5227-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1462888911-5227-1-git-send-email-anand.jain@oracle.com>
References: <1462888911-5227-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Add BTRFS_FEATURE_INCOMPAT_SPARE_DEV (400) flag to identify
a spare device.

Along with this it checks in the mount context that a spare
device will fail to mount.  As spare devices aren't mountable.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
Tested-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
---
V6: rebase on for-next

 fs/btrfs/ctree.h           | 3 ++-
 include/uapi/linux/btrfs.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 92e689787cae..728712baf5d5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -279,7 +279,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_SPARE_DEV)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 23c6960e94a4..c9ff6734e734 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -263,6 +263,7 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_SPARE_DEV 	(1ULL << 10)
 
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
-- 
2.7.0

