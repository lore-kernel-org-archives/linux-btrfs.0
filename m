Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16693 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaGGSlv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 14:41:51 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s67Ifov5003354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 18:41:50 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s67IfnMp029571
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 18:41:50 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s67Ifnwi029565
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 18:41:49 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: syslog when quota is enabled
Date: Tue,  8 Jul 2014 02:41:28 +0800
Message-Id: <1404758489-7085-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

must syslog when btrfs working config changes so is to support
offline investigation of the issues.
---
 fs/btrfs/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 016a5eb..bb4a498 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4216,6 +4216,8 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 	switch (sa->cmd) {
 	case BTRFS_QUOTA_CTL_ENABLE:
 		ret = btrfs_quota_enable(trans, root->fs_info);
+		if (!ret)
+			btrfs_info(root->fs_info, "quota is enabled");
 		break;
 	case BTRFS_QUOTA_CTL_DISABLE:
 		ret = btrfs_quota_disable(trans, root->fs_info);
-- 
2.0.0.257.g75cc6c6

