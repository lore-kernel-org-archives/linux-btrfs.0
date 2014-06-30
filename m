Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22443 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaF3RAQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jun 2014 13:00:16 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s5UH0Fvv029795
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 17:00:16 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s5UH0Ens026468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 17:00:15 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s5UH0Ein018360
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Jun 2014 17:00:14 GMT
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: device add must be sysloged
Date: Tue,  1 Jul 2014 00:58:56 +0800
Message-Id: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when we add a new disk to the mounted btrfs we don't record it
as of now, disk add is a critical change of btrfs configuration,
it must be recorded in the syslog to help offline investigations
of customer problems when reported.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 86d5474..16d20df 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2488,6 +2488,9 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	ret = btrfs_init_new_device(root, vol_args->name);
 
+	if (!ret)
+		btrfs_info(root->fs_info, "disk added %s",vol_args->name);
+
 	kfree(vol_args);
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
-- 
2.0.0.257.g75cc6c6

