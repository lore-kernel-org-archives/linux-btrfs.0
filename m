Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22733 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbaF3RAS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jun 2014 13:00:18 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s5UH0HAD004263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 17:00:18 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s5UH0Gh3017207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 17:00:17 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s5UH0G1p022236
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 17:00:16 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: device delete must be sysloged
Date: Tue,  1 Jul 2014 00:58:57 +0800
Message-Id: <1404147537-19873-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com>
References: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

as in the disk add patch, disk detached from the volume must be
recorded in the syslog as well for the same reason.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 16d20df..be4e097 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2530,6 +2530,9 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	mutex_unlock(&root->fs_info->volume_mutex);
 	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
 
+	if (!ret)
+		btrfs_info(root->fs_info, "disk deleted %s",vol_args->name);
+
 out:
 	kfree(vol_args);
 	mnt_drop_write_file(file);
-- 
2.0.0.257.g75cc6c6

