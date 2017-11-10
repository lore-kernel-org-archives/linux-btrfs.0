Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29982 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755255AbdKJBSb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Nov 2017 20:18:31 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAA1IUc1028326
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Nov 2017 01:18:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAA1IUZW007492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Nov 2017 01:18:30 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAA1IUkI013927
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Nov 2017 01:18:30 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: set plug for fsync
Date: Thu,  9 Nov 2017 17:16:16 -0700
Message-Id: <20171110001616.7875-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Setting plug can merge adjacent IOs before dispatching IOs to the disk
driver.

Without plug, it'd not be a problem for single disk usecases, but for
multiple disks using raid profile, a large IO can be split to several
IOs of stripe length, and plug can be helpful to bring them together
for each disk so that we can save several disk access.

Moreover, fsync issues synchronous writes, so plug can really take
effect.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e43da6c..063180b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2018,10 +2018,13 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
 static int start_ordered_ops(struct inode *inode, loff_t start, loff_t end)
 {
 	int ret;
+	struct blk_plug plug;
 
+	blk_start_plug(&plug);
 	atomic_inc(&BTRFS_I(inode)->sync_writers);
 	ret = btrfs_fdatawrite_range(inode, start, end);
 	atomic_dec(&BTRFS_I(inode)->sync_writers);
+	blk_finish_plug(&plug);
 
 	return ret;
 }
-- 
2.9.4

