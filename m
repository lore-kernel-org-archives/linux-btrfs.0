Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46966 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaGBBh7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 21:37:59 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/2 v2] btrfs: device delete must be sysloged
Date: Wed,  2 Jul 2014 09:37:32 +0800
Message-Id: <1404265052-29424-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1404265052-29424-1-git-send-email-Anand.Jain@oracle.com>
References: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com>
 <1404265052-29424-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

as in the disk add patch, disk detached from the volume must be
recorded in the syslog as well for the same reason.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
 v2: Accepts David's review comments, thanks

 fs/btrfs/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4e10259..016a5eb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2531,6 +2531,10 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	mutex_unlock(&root->fs_info->volume_mutex);
 	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
 
+	if (!ret)
+		btrfs_info(root->fs_info, "device deleted %s",
+							vol_args->name);
+
 out:
 	kfree(vol_args);
 	mnt_drop_write_file(file);
-- 
2.0.0.257.g75cc6c6

