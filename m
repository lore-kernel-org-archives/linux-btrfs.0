Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20424 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbbCIRLB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Mar 2015 13:11:01 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 22/26] Btrfs: sysfs: don't fail seeding for the sake of sysfs kobject issue v2
Date: Tue, 10 Mar 2015 06:38:40 +0800
Message-Id: <1425940724-7744-23-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
References: <1425940724-7744-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

v2: accept David comment

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

