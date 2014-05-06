Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48208 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933956AbaEFGcN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 02:32:13 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Anand Jain <Anand.Jain@oracle.com>
Subject: [RFC PATCH 2/2] btrfs: Add new member of btrfs_ioctl_dev_info_args.
Date: Tue, 6 May 2014 14:33:13 +0800
Message-ID: <1399357993-9254-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1399357993-9254-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1399357993-9254-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add flags member for btrfs_ioctl_dev_info_args to preset missing btrfs
devices.

The new member is added in the original padding area so the ioctl API is
not affected but user headers needs to be updated.

Cc: Anand Jain <Anand.Jain@oracle.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c           | 3 +++
 include/uapi/linux/btrfs.h | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7680a40..1920f24 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2610,6 +2610,9 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	di_args->devid = dev->devid;
 	di_args->bytes_used = dev->bytes_used;
 	di_args->total_bytes = dev->total_bytes;
+	di_args->flags = BTRFS_IOCTL_DEV_INFO_FLAG_SET;
+	if (dev->missing)
+		di_args->flags |= BTRFS_IOCTL_DEV_INFO_MISSING;
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
 	if (dev->name) {
 		struct rcu_string *name;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index b4d6909..5eb1f03 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -168,12 +168,15 @@ struct btrfs_ioctl_dev_replace_args {
 	__u64 spare[64];
 };
 
+#define BTRFS_IOCTL_DEV_INFO_MISSING			(1ULL<<0)
+#define BTRFS_IOCTL_DEV_INFO_FLAG_SET			(1ULL<<63)
 struct btrfs_ioctl_dev_info_args {
 	__u64 devid;				/* in/out */
 	__u8 uuid[BTRFS_UUID_SIZE];		/* in/out */
 	__u64 bytes_used;			/* out */
 	__u64 total_bytes;			/* out */
-	__u64 unused[379];			/* pad to 4k */
+	__u64 flags;				/* out */
+	__u64 unused[378];			/* pad to 4k */
 	__u8 path[BTRFS_DEVICE_PATH_NAME_MAX];	/* out */
 };
 
-- 
1.9.2

