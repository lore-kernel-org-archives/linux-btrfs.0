Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46343 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaJOIom (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 04:44:42 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 1/2] btrfs-progs: introduce btrfs_register_all_device()
Date: Wed, 15 Oct 2014 08:51:09 +0800
Message-Id: <1413334270-25766-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is to register all devices found after scanning
the system. Before we had this functionality with in the
btrfs_scan_lblkid(), however scanning and registering are two
different distinct operation its better keep them separate.
Also we want to optimize btrfs_scan_lblkid and avoid multiple
system scans unless needed. As of now device scan uses this function.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.h   |  1 +
 volumes.c | 25 +++++++++++++++++++++++++
 volumes.h |  1 +
 3 files changed, 27 insertions(+)

diff --git a/utils.h b/utils.h
index 3f7b388..237cf64 100644
--- a/utils.h
+++ b/utils.h
@@ -162,5 +162,6 @@ static inline u64 btrfs_min_dev_size(u32 leafsize)
 	return 2 * (BTRFS_MKFS_SYSTEM_GROUP_SIZE +
 		    btrfs_min_global_blk_rsv_size(leafsize));
 }
+int btrfs_register_one_device(char *fname);
 
 #endif
diff --git a/volumes.c b/volumes.c
index 266a474..c8057c8 100644
--- a/volumes.c
+++ b/volumes.c
@@ -30,6 +30,7 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "math.h"
+#include "utils.h"
 
 struct stripe {
 	struct btrfs_device *dev;
@@ -1533,6 +1534,30 @@ btrfs_find_device_by_devid(struct btrfs_fs_devices *fs_devices,
 	return NULL;
 }
 
+/*
+ * Register all devices in the fs_uuid list created in the user
+ * space. Ensure btrfs_scan_lblkid() is called before this func.
+ */
+int btrfs_register_all_devices(void)
+{
+	int err;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device;
+
+	list_for_each_entry(fs_devices, &fs_uuids, list) {
+		list_for_each_entry(device, &fs_devices->devices, dev_list) {
+			if (strlen(device->name) != 0) {
+				err = btrfs_register_one_device(device->name);
+				if (err < 0)
+					return err;
+				if (err > 0)
+					return -err;
+			}
+		}
+	}
+	return 0;
+}
+
 int btrfs_chunk_readonly(struct btrfs_root *root, u64 chunk_offset)
 {
 	struct cache_extent *ce;
diff --git a/volumes.h b/volumes.h
index 447dd4b..ccba34b 100644
--- a/volumes.h
+++ b/volumes.h
@@ -195,4 +195,5 @@ int write_raid56_with_parity(struct btrfs_fs_info *info,
 			     struct extent_buffer *eb,
 			     struct btrfs_multi_bio *multi,
 			     u64 stripe_len, u64 *raid_map);
+int btrfs_register_all_devices(void);
 #endif
-- 
2.0.0.153.g79dcccc

