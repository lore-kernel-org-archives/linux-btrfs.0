Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29949 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab3KYKu4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 05:50:56 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id rAPAotnX003318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 10:50:56 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rAPAosuZ015309
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 10:50:55 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id rAPAosqs027876
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 10:50:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: scrub maintenance event should be recorded in the messages
Date: Mon, 25 Nov 2013 19:00:05 +0800
Message-Id: <1385377205-9461-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1385374689-3745-1-git-send-email-anand.jain@oracle.com>
References: <1385374689-3745-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

so to help problem understanding and solving

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: log shoud be starting instead of started

 fs/btrfs/ioctl.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d237af8..84801b9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3593,10 +3593,20 @@ static long btrfs_ioctl_scrub(struct file *file, void __user *arg)
 			goto out;
 	}
 
+	printk(KERN_INFO "btrfs: Scrub starting on %pU devid %llu\n",
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

