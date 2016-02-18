Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45633 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbcBRFBW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Feb 2016 00:01:22 -0500
Date: Thu, 18 Feb 2016 08:01:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chris Mason <clm@fb.com>, Anand Jain <anand.jain@oracle.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] btrfs: array overflow in btrfs_ioctl_rm_dev_v2()
Message-ID: <20160218050109.GA7781@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We were putting the NUL terminator at BTRFS_PATH_NAME_MAX (4087) bytes
instead of BTRFS_SUBVOL_NAME_MAX (4039) so it corrupted memory.

Fixes: 22af1a869288 ('btrfs: introduce device delete by devid')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5224fc8..77c61b4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2700,7 +2700,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 	if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID) {
 		ret = btrfs_rm_device(root, NULL, vol_args->devid);
 	} else {
-		vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+		vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
 		ret = btrfs_rm_device(root, vol_args->name, 0);
 	}
 	mutex_unlock(&root->fs_info->volume_mutex);
