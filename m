Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39721 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbJFPTo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Oct 2015 11:19:44 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH V2 5/7] Btrfs: enhance btrfs_find_device_by_user_input() to check device path
Date: Tue,  6 Oct 2015 23:19:22 +0800
Message-Id: <1444144764-2384-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
References: <1444144764-2384-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The operation of device replace and device delete follows same steps
upto some depth with in btrfs kernel, however they don't share codes.
This enhancement will help replace and delete to share codes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: reword subject from
    Btrfs: check device_path in btrfs_find_device_by_user_input()

 fs/btrfs/dev-replace.c | 4 ----
 fs/btrfs/volumes.c     | 3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index c093f49..02df419 100644
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
index fbbe3fe..e929211 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2039,6 +2039,9 @@ int btrfs_find_device_by_user_input(struct btrfs_root *root, u64 srcdevid,
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
2.4.1

