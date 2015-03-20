Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36176 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbCTKEK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:10 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 05/27] Btrfs: sysfs: fix, kobject pointer clean up needed after kobject release
Date: Fri, 20 Mar 2015 18:01:20 +0800
Message-Id: <1426845702-6298-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

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

