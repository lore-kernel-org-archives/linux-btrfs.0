Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38009 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbbHNKdu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:50 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 18/23] Btrfs: check device_path in btrfs_find_device_by_user_input()
Date: Fri, 14 Aug 2015 18:33:03 +0800
Message-Id: <1439548388-29686-19-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

so btrfs_dev_replace_start() can be sleak and btrfs_rm_device() will
also need it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 4 ----
 fs/btrfs/volumes.c     | 3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 937e53b..0df3d9b 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -321,10 +321,6 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
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
index dcb10fa..5803c45 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2001,6 +2001,9 @@ int btrfs_find_device_by_user_input(struct btrfs_root *root, u64 srcdevid,
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

