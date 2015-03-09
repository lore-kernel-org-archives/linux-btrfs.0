Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20631 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbbCIRKb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 13:10:31 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 04/26] Btrfs: sysfs: fix, kobject pointer clean up needed after kobject release
Date: Tue, 10 Mar 2015 06:38:22 +0800
Message-Id: <1425940724-7744-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
References: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

The sysfs clean up self test like in the below code fails, since
fs_info->device_dir_kobject still points to its stale kobject.
Reseting this pointer will help to fix this.

open_ctree()
{

ret = btrfs_sysfs_add_one(fs_info);
::
+       btrfs_sysfs_remove_one(fs_info);
+       ret = btrfs_sysfs_add_one(fs_info);
+       if (ret) {
+               pr_err("BTRFS: failed to init sysfs interface: %d\n", ret);
+               goto fail_block_groups;
+       }

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index adfac3e..15fead2 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -525,6 +525,7 @@ void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 	btrfs_kobj_rm_device(fs_info, NULL);
 	kobject_del(fs_info->device_dir_kobj);
 	kobject_put(fs_info->device_dir_kobj);
+	fs_info->device_dir_kobj = NULL;
 	addrm_unknown_feature_attrs(fs_info, false);
 	sysfs_remove_group(&fs_info->super_kobj, &btrfs_feature_attr_group);
 	__btrfs_sysfs_remove_one(fs_info);
-- 
2.0.0.153.g79dcccc

