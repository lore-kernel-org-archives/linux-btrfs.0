Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53964 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752751AbeDLC1l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2RPdn042739
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:40 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2h6pn4srr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:40 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2ReIw026928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:40 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3C2RdqW028418
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:40 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/15] btrfs: rename __btrfs_close_devices to close_fs_devices
Date: Thu, 12 Apr 2018 10:29:27 +0800
Message-Id: <20180412022938.8257-5-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

__btrfs_close_devices() is un-exported, drop the __ prefix and rename it
to close_fs_devices().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 793471eb3f51..ef8578bf6b99 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1010,7 +1010,7 @@ static void btrfs_prepare_close_one_device(struct btrfs_device *device)
 	new_device->fs_devices = device->fs_devices;
 }
 
-static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
+static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
 {
 	struct btrfs_device *device, *tmp;
 	struct list_head pending_put;
@@ -1055,7 +1055,7 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 	int ret;
 
 	mutex_lock(&uuid_mutex);
-	ret = __btrfs_close_devices(fs_devices);
+	ret = close_fs_devices(fs_devices);
 	if (!fs_devices->opened) {
 		seed_devices = fs_devices->seed;
 		fs_devices->seed = NULL;
@@ -1065,7 +1065,7 @@ int btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 	while (seed_devices) {
 		fs_devices = seed_devices;
 		seed_devices = fs_devices->seed;
-		__btrfs_close_devices(fs_devices);
+		close_fs_devices(fs_devices);
 		free_fs_devices(fs_devices);
 	}
 	return ret;
@@ -2031,7 +2031,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 			fs_devices = fs_devices->seed;
 		}
 		cur_devices->seed = NULL;
-		__btrfs_close_devices(cur_devices);
+		close_fs_devices(cur_devices);
 		free_fs_devices(cur_devices);
 	}
 
@@ -2112,7 +2112,7 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 			tmp_fs_devices = tmp_fs_devices->seed;
 		}
 		fs_devices->seed = NULL;
-		__btrfs_close_devices(fs_devices);
+		close_fs_devices(fs_devices);
 		free_fs_devices(fs_devices);
 	}
 }
@@ -6578,7 +6578,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 	}
 
 	if (!fs_devices->seeding) {
-		__btrfs_close_devices(fs_devices);
+		close_fs_devices(fs_devices);
 		free_fs_devices(fs_devices);
 		fs_devices = ERR_PTR(-EINVAL);
 		goto out;
-- 
2.7.0

