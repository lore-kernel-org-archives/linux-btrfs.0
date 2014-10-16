Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29942 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484AbaJPByr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 21:54:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9G1shlV001305
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Oct 2014 09:54:43 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: fix wrong pad for kernelspace arg of btrfs dev stat
Date: Thu, 16 Oct 2014 09:53:37 +0800
Message-ID: <1413424419-15237-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The @btrfs_ioctl_get_dev_stats fails to pad to 1k as descripted,
actually it valuates to 1032 bytes.
The corresponding userspace change follows this change.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 include/uapi/linux/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 2f47824..fc4e326 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -416,7 +416,7 @@ struct btrfs_ioctl_get_dev_stats {
 	/* out values: */
 	__u64 values[BTRFS_DEV_STAT_VALUES_MAX];
 
-	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
+	__u64 unused[128 - 3 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
 #define BTRFS_QUOTA_CTL_ENABLE	1
-- 
1.8.1.4

