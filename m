Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23680 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758838AbdKPAMo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 19:12:44 -0500
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAG0Chc1030302
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 00:12:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAG0ChQs009299
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 00:12:43 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAG0CgLd001036
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 00:12:42 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: set plug for fsync
Date: Wed, 15 Nov 2017 16:10:28 -0700
Message-Id: <20171115231028.474-1-bo.li.liu@oracle.com>
In-Reply-To: <20171110001616.7875-1-bo.li.liu@oracle.com>
References: <20171110001616.7875-1-bo.li.liu@oracle.com>
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
v2: Explain why setting plug makes sense.

 fs/btrfs/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e43da6c..504e96d 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2018,10 +2018,20 @@ int btrfs_release_file(struct inode *inode, struct file *filp)
 static int start_ordered_ops(struct inode *inode, loff_t start, loff_t end)
 {
 	int ret;
+	struct blk_plug plug;
 
+	/*
+	 * This is only called in fsync, which would do synchronous
+	 * writes, so a plug can merge adjacent IOs as much as
+	 * possible.  Esp. in case of multiple disks using raid
+	 * profile, a large IO can be split to several segments of
+	 * stripe length(64K).
+	 */
+	blk_start_plug(&plug);
 	atomic_inc(&BTRFS_I(inode)->sync_writers);
 	ret = btrfs_fdatawrite_range(inode, start, end);
 	atomic_dec(&BTRFS_I(inode)->sync_writers);
+	blk_finish_plug(&plug);
 
 	return ret;
 }
-- 
2.9.4

