Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51285 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbbBAIDA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 03:03:00 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 01/12] Btrfs: sysfs: fix, btrfs_release_super_kobj() should to clean up the kobject data
Date: Sun,  1 Feb 2015 16:01:31 +0800
Message-Id: <1422777702-12584-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
References: <1421683347-18226-1-git-send-email-anand.jain@oracle.com>
 <1422777702-12584-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
1.9.1

