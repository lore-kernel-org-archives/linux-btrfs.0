Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26206 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbbBLHVy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 02:21:54 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 01/24] Btrfs: sysfs: fix, btrfs_release_super_kobj() should to clean up the kobject data
Date: Thu, 12 Feb 2015 07:20:45 +0800
Message-Id: <1423696868-8971-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423696868-8971-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1423696868-8971-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

The following test case fails indicating that, thread tried to init an initialized object.

kernel: [232104.016513] kobject (ffff880006c1c980): tried to init an initialized object, something is seriously wrong.

btrfs_sysfs_remove_one() self test code:

open_tree()
{
 ::
        ret = btrfs_sysfs_add_one(fs_info);
	if (ret) {
              pr_err("BTRFS: failed to init sysfs interface: %d\n", ret);
                goto fail_block_groups;
        }
+       btrfs_sysfs_remove_one(fs_info);
+       ret = btrfs_sysfs_add_one(fs_info);
+       if (ret) {
+               pr_err("BTRFS: failed to init sysfs interface: %d\n", ret);
+               goto fail_block_groups;
+       }

cleaning up the unregistered kobject fixes this.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 92db3f6..68dcd17 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -439,6 +439,8 @@ static struct attribute *btrfs_attrs[] = {
 static void btrfs_release_super_kobj(struct kobject *kobj)
 {
 	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+
+	memset(&fs_info->super_kobj, 0, sizeof(struct kobject));
 	complete(&fs_info->kobj_unregister);
 }
 
-- 
2.0.0.153.g79dcccc

