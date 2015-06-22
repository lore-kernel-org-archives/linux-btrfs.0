Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34607 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbbFVKVv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 06:21:51 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] Btrfs: Check if kobject is initialized before put
Date: Mon, 22 Jun 2015 18:18:32 +0800
Message-Id: <1434968312-16463-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index ea81a05..603b0cc 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -523,9 +523,11 @@ static void __btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 		fs_devs->device_dir_kobj = NULL;
 	}
 
-	kobject_del(&fs_devs->super_kobj);
-	kobject_put(&fs_devs->super_kobj);
-	wait_for_completion(&fs_devs->kobj_unregister);
+	if (fs_devs->super_kobj.state_initialized) {
+		kobject_del(&fs_devs->super_kobj);
+		kobject_put(&fs_devs->super_kobj);
+		wait_for_completion(&fs_devs->kobj_unregister);
+	}
 }
 
 /* when fs_devs is NULL it will remove all fsid kobject */
-- 
2.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
