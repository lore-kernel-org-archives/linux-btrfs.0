Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46378 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3KYKI6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 05:08:58 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rAPA8vGZ022318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 10:08:57 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rAPA8u68026645
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 10:08:57 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rAPA8uew021018
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 10:08:56 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: scrub maintenance event should be recorded in the messages
Date: Mon, 25 Nov 2013 18:18:09 +0800
Message-Id: <1385374689-3745-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

so to help problem understanding and solving

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d237af8..ba980fb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3593,10 +3593,20 @@ static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
 			goto out;
 	}
 
+	printk(KERN_INFO "btrfs: Scrub started on %pU devid %llu\n",
+		root->fs_info->fsid, sa->devid);
+
 	ret = btrfs_scrub_dev(root->fs_info, sa->devid, sa->start, sa->end,
 			      &sa->progress, sa->flags & BTRFS_SCRUB_READONLY,
 			      0);
 
+	if (ret)
+		printk(KERN_INFO "btrfs: Scrub failed on %pU devid %llu\n",
+			root->fs_info->fsid, sa->devid);
+	else
+		printk(KERN_INFO "btrfs: Scrub finished on %pU devid %llu\n",
+			root->fs_info->fsid, sa->devid);
+
 	if (copy_to_user(arg, sa, sizeof(*sa)))
 		ret = -EFAULT;
 
-- 
1.7.1

