Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51981 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaGGSlx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 14:41:53 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s67IfqhG013692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 18:41:53 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s67Ifp53029672
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 18:41:52 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s67IfpX9029660
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Jul 2014 18:41:51 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: syslog when quota is disabled
Date: Tue,  8 Jul 2014 02:41:29 +0800
Message-Id: <1404758489-7085-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1404758489-7085-1-git-send-email-Anand.Jain@oracle.com>
References: <1404758489-7085-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Offline investigations of the issues would need to know when quota is disabled.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index bb4a498..fd29978 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4221,6 +4221,8 @@ static long btrfs_ioctl_quota_ctl(struct file *file, void __user *arg)
 		break;
 	case BTRFS_QUOTA_CTL_DISABLE:
 		ret = btrfs_quota_disable(trans, root->fs_info);
+		if (!ret)
+			btrfs_info(root->fs_info, "quota is disabled");
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.0.0.257.g75cc6c6

