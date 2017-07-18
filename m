Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751385AbdGRPln (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 11:41:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7E208AABA
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Jul 2017 15:41:42 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/4] btrfs: refactor find_device helper
Date: Tue, 18 Jul 2017 17:40:28 +0200
Message-Id: <c0ebbf95b65aaf6e1b571aa30788d405b44ddb2e.1500391979.git.dsterba@suse.com>
In-Reply-To: <cover.1500391979.git.dsterba@suse.com>
References: <cover.1500391979.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Polish the helper:
* drop underscores, no special meaning here
* pass fs_devices, as this is what the API implements
* drop noinline, no apparent reason for such simple helper
* constify uuid
* add comment

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 39deba4e88e3..c3eafc8367d5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -254,9 +254,17 @@ static struct btrfs_device *__alloc_device(void)
 	return dev;
 }
 
-static noinline struct btrfs_device *__find_device(struct list_head *head,
-						   u64 devid, u8 *uuid)
+/*
+ * Find a device specified by @devid or @uuid in the list of @fs_devices, or
+ * return NULL.
+ *
+ * If devid and uuid are both specified, the match must be exact, otherwise
+ * only devid is used.
+ */
+static struct btrfs_device *find_device(struct btrfs_fs_devices *fs_devices,
+		u64 devid, const u8 *uuid)
 {
+	struct list_head *head = &fs_devices->devices;
 	struct btrfs_device *dev;
 
 	list_for_each_entry(dev, head, dev_list) {
@@ -621,8 +629,8 @@ static noinline int device_list_add(const char *path,
 
 		device = NULL;
 	} else {
-		device = __find_device(&fs_devices->devices, devid,
-				       disk_super->dev_item.uuid);
+		device = find_device(fs_devices, devid,
+				disk_super->dev_item.uuid);
 	}
 
 	if (!device) {
@@ -6280,8 +6288,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 	while (cur_devices) {
 		if (!fsid ||
 		    !memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE)) {
-			device = __find_device(&cur_devices->devices,
-					       devid, uuid);
+			device = find_device(cur_devices, devid, uuid);
 			if (device)
 				return device;
 		}
-- 
2.13.0

