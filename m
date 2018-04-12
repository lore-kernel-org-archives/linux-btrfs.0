Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37322 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752551AbeDLC1k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2QIol099079
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:38 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2h6ny3hwh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:38 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Rcm0026928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:38 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2RbUR021308
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 02/15] btrfs: rename struct btrfs_fs_devices::list
Date: Thu, 12 Apr 2018 10:29:25 +0800
Message-Id: <20180412022938.8257-3-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_fs_devices::list is the list of BTRFS fsid in the kernel, a generic
name 'list' makes it's search very difficult, rename it to fs_list.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/sysfs.c   |  2 +-
 fs/btrfs/volumes.c | 16 ++++++++--------
 fs/btrfs/volumes.h |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index ca067471cd46..ba14d79cf5d2 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -602,7 +602,7 @@ void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
 		return;
 	}
 
-	list_for_each_entry(fs_devs, fs_uuids, list) {
+	list_for_each_entry(fs_devs, fs_uuids, fs_list) {
 		__btrfs_sysfs_remove_fsid(fs_devs);
 	}
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7ccd1a38c634..aacaf6c9feb7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -232,7 +232,7 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
 	INIT_LIST_HEAD(&fs_devs->devices);
 	INIT_LIST_HEAD(&fs_devs->resized_devices);
 	INIT_LIST_HEAD(&fs_devs->alloc_list);
-	INIT_LIST_HEAD(&fs_devs->list);
+	INIT_LIST_HEAD(&fs_devs->fs_list);
 	if (fsid)
 		memcpy(fs_devs->fsid, fsid, BTRFS_FSID_SIZE);
 
@@ -278,8 +278,8 @@ void __exit btrfs_cleanup_fs_uuids(void)
 
 	while (!list_empty(&fs_uuids)) {
 		fs_devices = list_entry(fs_uuids.next,
-					struct btrfs_fs_devices, list);
-		list_del(&fs_devices->list);
+					struct btrfs_fs_devices, fs_list);
+		list_del(&fs_devices->fs_list);
 		free_fs_devices(fs_devices);
 	}
 }
@@ -348,7 +348,7 @@ static noinline struct btrfs_fs_devices *find_fsid(u8 *fsid)
 {
 	struct btrfs_fs_devices *fs_devices;
 
-	list_for_each_entry(fs_devices, &fs_uuids, list) {
+	list_for_each_entry(fs_devices, &fs_uuids, fs_list) {
 		if (memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE) == 0)
 			return fs_devices;
 	}
@@ -612,7 +612,7 @@ static void btrfs_free_stale_devices(const char *path,
 	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
 	struct btrfs_device *dev, *tmp_dev;
 
-	list_for_each_entry_safe(fs_devs, tmp_fs_devs, &fs_uuids, list) {
+	list_for_each_entry_safe(fs_devs, tmp_fs_devs, &fs_uuids, fs_list) {
 
 		if (fs_devs->opened)
 			continue;
@@ -637,7 +637,7 @@ static void btrfs_free_stale_devices(const char *path,
 			/* delete the stale device */
 			if (fs_devs->num_devices == 1) {
 				btrfs_sysfs_remove_fsid(fs_devs);
-				list_del(&fs_devs->list);
+				list_del(&fs_devs->fs_list);
 				free_fs_devices(fs_devs);
 				break;
 			} else {
@@ -737,7 +737,7 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 		if (IS_ERR(fs_devices))
 			return ERR_CAST(fs_devices);
 
-		list_add(&fs_devices->list, &fs_uuids);
+		list_add(&fs_devices->fs_list, &fs_uuids);
 
 		device = NULL;
 	} else {
@@ -2256,7 +2256,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 		return PTR_ERR(old_devices);
 	}
 
-	list_add(&old_devices->list, &fs_uuids);
+	list_add(&old_devices->fs_list, &fs_uuids);
 
 	memcpy(seed_devices, fs_devices, sizeof(*seed_devices));
 	seed_devices->opened = 1;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 681be2dc0c6a..ef220d541d4b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -221,6 +221,7 @@ BTRFS_DEVICE_GETSET_FUNCS(bytes_used);
 
 struct btrfs_fs_devices {
 	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
+	struct list_head fs_list;
 
 	u64 num_devices;
 	u64 open_devices;
@@ -242,7 +243,6 @@ struct btrfs_fs_devices {
 	struct list_head resized_devices;
 	/* devices not currently being allocated */
 	struct list_head alloc_list;
-	struct list_head list;
 
 	struct btrfs_fs_devices *seed;
 	int seeding;
-- 
2.7.0

