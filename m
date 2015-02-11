Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31977 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbbBLHWh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 02:22:37 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 24/24 V3] Btrfs: sysfs: add check if super kobject is already initialized
Date: Thu, 12 Feb 2015 07:21:08 +0800
Message-Id: <1423696868-8971-25-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423696868-8971-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1423696868-8971-1-git-send-email-anand.jain@oracle.com>

This patch will be useful when we have to change the context in which we create
and destroy sysfs fsid and device kobjects. But this is a good change to have it,
as it just does the right thing in general.


Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: add missing signed-off, update commit
v1->v2: when kobject is already created return EEXIST, not sent to ML

 fs/btrfs/sysfs.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index f8358d2..6ebbe6c 100644
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
+			error = -EEXIST;
+		}
 		if (!follow_seed)
 			return error;
 		parent = &fs_devs->super_kobj;
-- 
2.0.0.153.g79dcccc

