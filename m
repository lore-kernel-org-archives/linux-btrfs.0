Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:34550 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937126AbeE3Gz5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 02:55:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4U6tvES102056
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:57 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2j9ev8904f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:57 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4U6trGj011478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:53 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4U6trec017387
        for <linux-btrfs@vger.kernel.org>; Wed, 30 May 2018 06:55:53 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/6] btrfs: rename btrfs_free_stale_devices drop btrfs prefix
Date: Wed, 30 May 2018 14:58:21 +0800
Message-Id: <20180530065821.28385-7-anand.jain@oracle.com>
In-Reply-To: <20180530065821.28385-1-anand.jain@oracle.com>
References: <20180530065821.28385-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_free_stale_devices() is a static function drop the btrfs prefix.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a6a23b0185e5..afb3504f4097 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -634,7 +634,7 @@ static void pending_bios_fn(struct btrfs_work *work)
  *  skip_dev:	Optional. Will skip this device when searching for the stale
  *		devices.
  */
-static void btrfs_free_stale_devices(const char *path,
+static void free_stale_devices(const char *path,
 				     struct btrfs_device *skip_device)
 {
 	struct btrfs_fs_devices *fs_devices, *tmp_fs_devices;
@@ -1271,7 +1271,7 @@ int btrfs_scan_one_device(const char *path, fmode_t flags, void *holder,
 	} else {
 		*fs_devices_ret = device->fs_devices;
 		if (new_device_added)
-			btrfs_free_stale_devices(path, device);
+			free_stale_devices(path, device);
 	}
 	mutex_unlock(&uuid_mutex);
 
-- 
2.7.0

