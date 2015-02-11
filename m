Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26491 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbbBLHWe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 02:22:34 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 22/24] Btrfs: sysfs: don't fail seeding for the sake of sysfs kobject issue
Date: Thu, 12 Feb 2015 07:21:06 +0800
Message-Id: <1423696868-8971-23-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423696868-8971-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1423696868-8971-1-git-send-email-anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 51873ec..1490723 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2249,7 +2249,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 						root->fs_info->fsid);
 		if (kobject_rename(&root->fs_info->fs_devices->super_kobj,
 								fsid_buf))
-			goto error_trans;
+			printk(KERN_WARNING\
+			"BTRFS: sysfs: failed to create fsid for sprout\n");
 	}
 
 	root->fs_info->num_tolerated_disk_barrier_failures =
-- 
2.0.0.153.g79dcccc

