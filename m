Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46960 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaGBBh5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 21:37:57 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2 v2] btrfs: device add must be sysloged
Date: Wed,  2 Jul 2014 09:37:31 +0800
Message-Id: <1404265052-29424-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com>
References: <1404147537-19873-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when we add a new disk to the mounted btrfs we don't record it
as of now, disk add is a critical change of btrfs configuration,
it must be recorded in the syslog to help offline investigations
of customer problems when reported.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
---
 v2: Accepts David's review comment, thanks

 fs/btrfs/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 86d5474..4e10259 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2488,6 +2488,10 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	ret = btrfs_init_new_device(root, vol_args->name);
 
+	if (!ret)
+		btrfs_info(root->fs_info, "device added %s",
+						vol_args->name);
+
 	kfree(vol_args);
 out:
 	mutex_unlock(&root->fs_info->volume_mutex);
-- 
2.0.0.257.g75cc6c6

