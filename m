Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24925 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3JHKTl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 06:19:41 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r98AJeqa024236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Oct 2013 10:19:41 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r98AJdxZ001858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Oct 2013 10:19:40 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r98AJdNd028458
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Oct 2013 10:19:39 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not defrag extent root in ioctl
Date: Tue,  8 Oct 2013 18:19:30 +0800
Message-Id: <1381227570-6829-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can't defrag the extent root without deadlock.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9d46f60..12d8570 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2322,9 +2322,6 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 			goto out;
 		}
 		ret = btrfs_defrag_root(root);
-		if (ret)
-			goto out;
-		ret = btrfs_defrag_root(root->fs_info->extent_root);
 		break;
 	case S_IFREG:
 		if (!(file->f_mode & FMODE_WRITE)) {
-- 
1.8.1.4

