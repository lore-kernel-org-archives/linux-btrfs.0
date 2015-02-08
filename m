Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40962 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759857AbbBIH6s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:58:48 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 24/24] Btrfs: sysfs: add check if super kobject is already initialized
Date: Mon,  9 Feb 2015 07:56:25 +0800
Message-Id: <1423439785-10260-25-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 fs/btrfs/sysfs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index f8358d2..5c555da 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -750,10 +750,14 @@ int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 	int error = 0;
 
 	while (fs_devs) {
-		init_completion(&fs_devs->kobj_unregister);
-		fs_devs->super_kobj.kset = btrfs_kset;
-		error = kobject_init_and_add(&fs_devs->super_kobj,
+		if (!fs_devs->super_kobj.state_initialized) {
+			init_completion(&fs_devs->kobj_unregister);
+			fs_devs->super_kobj.kset = btrfs_kset;
+			error = kobject_init_and_add(&fs_devs->super_kobj,
 				&btrfs_ktype, parent, "%pU", fs_devs->fsid);
+		} else {
+			error = -EINVAL;
+		}
 		if (!follow_seed)
 			return error;
 		parent = &fs_devs->super_kobj;
-- 
2.0.0.153.g79dcccc

