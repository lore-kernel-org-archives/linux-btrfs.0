Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33587 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3DPJUK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 05:20:10 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r3G9K9DF031558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 09:20:10 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3G9K8nR019059
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 09:20:09 GMT
Received: from abhmt111.oracle.com (abhmt111.oracle.com [141.146.116.63])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r3G9K8NV027337
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2013 09:20:08 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: return error when we specify wrong start to defrag
Date: Tue, 16 Apr 2013 17:20:28 +0800
Message-Id: <1366104028-26830-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need such a sanity check for wrong start when we defrag a file, otherwise,
even with a wrong start that's larger than file size, we can end up changing
not only inode's force compress flag but also FS's incompat flags.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
v2: make changelog more clearly.

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

