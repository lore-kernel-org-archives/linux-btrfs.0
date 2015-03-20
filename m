Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36591 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbbCTKEf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:35 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 22/27] Btrfs: sysfs: add support to add parent for fsid
Date: Fri, 20 Mar 2015 18:01:37 +0800
Message-Id: <1426845702-6298-23-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

To support seed sysfs layout and represent seed fsid under
the sprout we need the facility to create fsid under the
specified parent.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index be5342f..51e2fae 100644
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

