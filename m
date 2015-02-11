Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26479 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbbBLHWd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 02:22:33 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 21/24 V3] Btrfs: sysfs: add support to add parent for fsid
Date: Thu, 12 Feb 2015 07:21:05 +0800
Message-Id: <1423696868-8971-22-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423696868-8971-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1423696868-8971-1-git-send-email-anand.jain@oracle.com>

To support seed sysfs layout and represent seed fsid under
the sprout we need the facility to create fsid under the
specified parent.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: added missing signed-off
v1->v2: does not exist

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

