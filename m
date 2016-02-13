Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41982 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbcBMCCL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Feb 2016 21:02:11 -0500
From: Anand Jain <anand.jain@oracle.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 10/13] btrfs: enhance btrfs_find_device_by_user_input() to check device path
Date: Sat, 13 Feb 2016 10:01:37 +0800
Message-Id: <1455328900-1476-11-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The operation of device replace and device delete follows same steps upto
some depth with in btrfs kernel, however they don't share codes. This
enhancement will help replace and delete to share codes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: reword subject from
    Btrfs: check device_path in btrfs_find_device_by_user_input()
 fs/btrfs/dev-replace.c | 4 ----
 fs/btrfs/volumes.c     | 3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index b3e3f94..9700a60 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -320,10 +320,6 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 		return -EINVAL;
 	}
 
-	if ((args->start.srcdevid == 0 && args->start.srcdev_name[0] == '\0') ||
-	    args->start.tgtdev_name[0] == '\0')
-		return -EINVAL;
-
 	/* the disk copy procedure reuses the scrub code */
 	mutex_lock(&fs_info->volume_mutex);
 	ret = btrfs_find_device_by_user_input(root, args->start.srcdevid,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1324a9f..5dc8b7a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2111,6 +2111,9 @@ int btrfs_find_device_by_user_input(struct btrfs_root *root, u64 srcdevid,
 		if (!*device)
 			ret = -ENOENT;
 	} else {
+		if (!srcdev_name || !srcdev_name[0])
+			return -EINVAL;
+
 		ret = btrfs_find_device_missing_or_by_path(root, srcdev_name,
 							   device);
 	}
-- 
2.7.0

