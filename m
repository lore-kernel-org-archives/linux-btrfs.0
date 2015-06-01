Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37369 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbbFAGQo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jun 2015 02:16:44 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t516GiTJ017978
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:16:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t516Gh3F023339
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:16:43 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t516GheS025121
	for <linux-btrfs@vger.kernel.org>; Mon, 1 Jun 2015 06:16:43 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] Btrfs: check device_path in btrfs_find_device_by_user_input()
Date: Mon,  1 Jun 2015 14:16:18 +0800
Message-Id: <1433139379-640-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1433139379-640-1-git-send-email-anand.jain@oracle.com>
References: <1433139379-640-1-git-send-email-anand.jain@oracle.com>
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
index ff1ef57..a6a2b84 100644
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
index a51d492..cafedaa 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1990,6 +1990,9 @@ int btrfs_find_device_by_user_input(struct btrfs_root *root, u64 srcdevid,
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

