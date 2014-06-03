Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49210 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaFCDgj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 23:36:39 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 4/6 v2] btrfs: dev replace should replace the sysfs entry
Date: Tue,  3 Jun 2014 11:36:02 +0800
Message-Id: <1401766564-7381-5-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>

when we replace the device its corresponding sysfs
entry has to be replaced as well

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: the function name change applied here

 fs/btrfs/dev-replace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 9f22905..1219982 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -36,6 +36,7 @@
 #include "check-integrity.h"
 #include "rcu-string.h"
 #include "dev-replace.h"
+#include "sysfs.h"
 
 static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 				       int scrub_ret);
@@ -562,6 +563,10 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
 	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
 
+	/* replace the sysfs entry */
+	btrfs_kobj_rm_device(fs_info, src_device);
+	btrfs_kobj_add_device(fs_info, tgt_device);
+
 	btrfs_rm_dev_replace_blocked(fs_info);
 
 	btrfs_rm_dev_replace_srcdev(fs_info, src_device);
-- 
1.8.5.3

