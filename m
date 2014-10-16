Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30101 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751916AbaJPBys (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 21:54:48 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9G1siUP001310
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Oct 2014 09:54:44 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix wrong pad for userspace arg of btrfs dev stat
Date: Thu, 16 Oct 2014 09:53:38 +0800
Message-ID: <1413424419-15237-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1413424419-15237-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1413424419-15237-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The @btrfs_ioctl_get_dev_stats fails to pad to 1k as descripted,
actually it valuates to 1032 bytes.
Correct it following the kernel patch.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 ioctl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ioctl.h b/ioctl.h
index f0fc060..6657f8f 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -429,7 +429,7 @@ struct btrfs_ioctl_get_dev_stats {
 	/* out values: */
 	__u64 values[BTRFS_DEV_STAT_VALUES_MAX];
 
-	__u64 unused[128 - 2 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
+	__u64 unused[128 - 3 - BTRFS_DEV_STAT_VALUES_MAX]; /* pad to 1k */
 };
 
 /* BTRFS_IOC_SNAP_CREATE is no longer used by the btrfs command */
-- 
1.8.1.4

