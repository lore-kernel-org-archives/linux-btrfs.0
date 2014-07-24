Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36767 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758705AbaGXDfk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:35:40 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3Zba6017405
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:35:37 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 07/10] Btrfs: update the comment of total_bytes and disk_total_bytes of btrfs_devie
Date: Thu, 24 Jul 2014 11:37:12 +0800
Message-ID: <1406173035-29478-7-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0defd23..90d4fa8 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -64,10 +64,10 @@ struct btrfs_device {
 	/* the internal btrfs device id */
 	u64 devid;
 
-	/* size of the device */
+	/* size of the device in memory */
 	u64 total_bytes;
 
-	/* size of the disk */
+	/* size of the device on disk */
 	u64 disk_total_bytes;
 
 	/* bytes used */
-- 
1.9.3

