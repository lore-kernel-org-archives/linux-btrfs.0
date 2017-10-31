Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52851 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932373AbdJaRqf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:46:35 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6D291AD95
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:46:34 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 06/11] btrfs: document device locking
Date: Tue, 31 Oct 2017 18:44:45 +0100
Message-Id: <5f3dc05b0b44803e9d20498970f259ead2bfe7de.1509471604.git.dsterba@suse.com>
In-Reply-To: <cover.1509471604.git.dsterba@suse.com>
References: <cover.1509471604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Overview of the main locks protecting various device-related structures.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/volumes.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 75aed8ec64bd..098affc58361 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -145,6 +145,72 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 			     struct btrfs_bio **bbio_ret,
 			     int mirror_num, int need_raid_map);
 
+/*
+ * Device locking
+ * ==============
+ *
+ * There are several mutexes that protect manipulation of devices and low-level
+ * structures like chunks but not block groups, extents or files
+ *
+ * - uuid_mutex (global lock)
+ *
+ *   protects the fs_uuids list that tracks all per-fs fs_devices, resulting
+ *   from the SCAN_DEV ioctl registration or from mount either implicitly
+ *   (the first device) or requested by the device= mount option
+ *
+ *   the mutex can be very coarse and can cover long-running operations
+ *
+ *   protects: updates to fs_devices counters like missing devices, rw devices,
+ *   seeding, structure cloning, openning/closing devices at mount/umount time
+ *
+ *   global::fs_devs - add, remove, updates to the global list
+ *
+ *   does not protect: manipulation of the fs_devices::devices list!
+ *
+ *   btrfs_device::name - renames (write side), read is RCU
+ *
+ * - fs_devices::device_list_mutex (per-fs, with RCU)
+ *
+ *   protects updates to fs_devices::devices, ie. adding and deleting
+ *
+ *   simple list traversal with read-only actions can be done with RCU
+ *   protection
+ *
+ *   may be used to exclude some operations from running concurrently without
+ *   any modifications to the list (see write_all_supers)
+ *
+ * - volume_mutex
+ *
+ *   coarse lock owned by a mounted filesystem; used to exclude some operations
+ *   that cannot run in parallel and affect the higher-level properties of the
+ *   filesystem like: device add/deleting/resize/replace, or balance
+ *
+ * - balance_mutex
+ *
+ *   protects balance structures (status, state) and context accessed from
+ *   several places (internally, ioctl)
+ *
+ * - chunk_mutex
+ *
+ *   protects chunks, adding or removing during allocation, trim or when
+ *   a new device is added/removed
+ *
+ * - cleaner_mutex
+ *
+ *   a big lock that is held by the cleaner thread and prevents running
+ *   subvolume cleaning together with relocation or delayed iputs
+ *
+ *
+ * Lock nesting
+ * ------------
+ *
+ * uuid_mutex
+ *   volume_mutex
+ *     device_list_mutex
+ *       chunk_mutex
+ *     balance_mutex
+ *
+ */
 DEFINE_MUTEX(uuid_mutex);
 static LIST_HEAD(fs_uuids);
 struct list_head *btrfs_get_fs_uuids(void)
-- 
2.14.0

