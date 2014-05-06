Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20016 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933953AbaEFGcX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 02:32:23 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s466WKSr025169
	for <linux-btrfs@vger.kernel.org>; Tue, 6 May 2014 14:32:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH 1/2] btrfs-progs: Follow kernel changes to add new member of btrfs_ioctl_dev_info_args.
Date: Tue, 6 May 2014 14:33:24 +0800
Message-ID: <1399358005-9780-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Follow the kernel header changes to add new member of
btrfs_ioctl_dev_info_args.

This change will use special bit to keep backward compatibility, so even
on old kernels this will not screw anything up.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ioctl.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/ioctl.h b/ioctl.h
index 9627e8d..672a3a3 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -156,12 +156,15 @@ struct btrfs_ioctl_dev_replace_args {
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

