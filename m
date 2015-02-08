Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40901 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759828AbbBIH6m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:58:42 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 21/24] Btrfs: sysfs: add support to add parent for fsid
Date: Mon,  9 Feb 2015 07:56:22 +0800
Message-Id: <1423439785-10260-22-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To support seed sysfs layout and represent seed fsid under
the sprout we need the facility to create fsid under the
specified parent.
---
 fs/btrfs/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index d0caa32..d89bf4d 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -729,8 +729,8 @@ int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 
 	init_completion(&fs_devs->kobj_unregister);
 	fs_devs->super_kobj.kset = btrfs_kset;
-	error = kobject_init_and_add(&fs_devs->super_kobj, &btrfs_ktype, NULL,
-				     "%pU", fs_devs->fsid);
+	error = kobject_init_and_add(&fs_devs->super_kobj,
+				&btrfs_ktype, parent, "%pU", fs_devs->fsid);
 	return error;
 }
 
-- 
2.0.0.153.g79dcccc

