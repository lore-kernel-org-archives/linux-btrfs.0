Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36347 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbbCTKEg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 06:04:36 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 23/27] Btrfs: sysfs: don't fail seeding for the sake of sysfs kobject issue
Date: Fri, 20 Mar 2015 18:01:38 +0800
Message-Id: <1426845702-6298-24-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1426845702-6298-1-git-send-email-anand.jain@oracle.com>

From: Anand Jain <Anand.Jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 549f978..58232bc 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2249,7 +2249,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 						root->fs_info->fsid);
 		if (kobject_rename(&root->fs_info->fs_devices->super_kobj,
 								fsid_buf))
-			goto error_trans;
+			pr_warn("BTRFS: sysfs: failed to create fsid for sprout\n");
 	}
 
 	root->fs_info->num_tolerated_disk_barrier_failures =
-- 
2.0.0.153.g79dcccc

