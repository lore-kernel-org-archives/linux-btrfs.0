Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20884 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab3DPIkR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 04:40:17 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3G8eFZn015655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 08:40:16 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3G8eFrb007768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 08:40:15 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3G8eFqg007755
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 08:40:15 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: return error when we specify wrong start
Date: Tue, 16 Apr 2013 16:40:36 +0800
Message-Id: <1366101636-26536-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need such a sanity check for wrong start, otherwise, even with
a wrong start that's larger than file size, we can end up not only
changing inode's force compress flag but also FS's incompat flags.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 69cd80d..262d9db 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1152,8 +1152,11 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	u64 new_align = ~((u64)128 * 1024 - 1);
 	struct page **pages = NULL;
 
-	if (extent_thresh == 0)
-		extent_thresh = 256 * 1024;
+	if (isize == 0)
+		return 0;
+
+	if (range->start >= isize)
+		return -EINVAL;
 
 	if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS) {
 		if (range->compress_type > BTRFS_COMPRESS_TYPES)
@@ -1162,8 +1165,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			compress_type = range->compress_type;
 	}
 
-	if (isize == 0)
-		return 0;
+	if (extent_thresh == 0)
+		extent_thresh = 256 * 1024;
 
 	/*
 	 * if we were not given a file, allocate a readahead
-- 
1.7.7

