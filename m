Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24341 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaFCDgc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 23:36:32 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 1/6 v2] btrfs: rename add_device_membership to btrfs_kobj_add_device
Date: Tue,  3 Jun 2014 11:35:59 +0800
Message-Id: <1401766564-7381-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: this is a new patch in the patch-set sent before,
    as per the review comments. Thanks David.

 fs/btrfs/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 522d023..41b0672 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -572,7 +572,7 @@ static void init_feature_attrs(void)
 	}
 }
 
-static int add_device_membership(struct btrfs_fs_info *fs_info)
+static int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info)
 {
 	int error = 0;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
@@ -633,7 +633,7 @@ int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 	if (error)
 		goto failure;
 
-	error = add_device_membership(fs_info);
+	error = btrfs_kobj_add_device(fs_info);
 	if (error)
 		goto failure;
 
-- 
1.8.5.3

