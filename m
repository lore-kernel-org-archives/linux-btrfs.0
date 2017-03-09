Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17783 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754798AbdCIBnj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Mar 2017 20:43:39 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <anand.jain@oracle.com>
Subject: [PATCH v3.1 4/7] btrfs: Introduce extra_rw_degrade_errors parameter for btrfs_check_rw_degradable
Date: Thu, 9 Mar 2017 09:34:39 +0800
Message-ID: <20170309013442.19957-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170309013442.19957-1-quwenruo@cn.fujitsu.com>
References: <20170309013442.19957-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new structure, extra_rw_degrade_errors, to record
devid<->error mapping.

This strucutre will have a array to record runtime error, which affects
degraded mount, like failure to flush or wait one device.

Also allow btrfs_check_rw_degradable() to accept such structure as
another error source other than btrfs_device->missing.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
Tested-by: Adam Borowski <kilobyte@angband.pl>
Tested-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>
---
 fs/btrfs/disk-io.c |  3 ++-
 fs/btrfs/super.c   |  2 +-
 fs/btrfs/volumes.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.h | 36 ++++++++++++++++++++++++++++-
 4 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3de89283d400..658b8fab1d39 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3058,7 +3058,8 @@ int open_ctree(struct super_block *sb,
 		goto fail_sysfs;
 	}
 
-	if (!(sb->s_flags & MS_RDONLY) && !btrfs_check_rw_degradable(fs_info)) {
+	if (!(sb->s_flags & MS_RDONLY) &&
+	    !btrfs_check_rw_degradable(fs_info, NULL)) {
 		btrfs_warn(fs_info,
 		"writeable mount is not allowed due to too many missing devices");
 		goto fail_sysfs;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 1f5772501c92..06bd9b332e18 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1785,7 +1785,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		}
 
 		if (!(*flags & MS_RDONLY) &&
-		    !btrfs_check_rw_degradable(fs_info)) {
+		    !btrfs_check_rw_degradable(fs_info, NULL)) {
 			btrfs_warn(fs_info,
 				"too many missing devices, writeable remount is not allowed");
 			ret = -EACCES;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 83613955e3c2..46cf676be15a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6765,13 +6765,72 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
 	return -EIO;
 }
 
+void record_extra_rw_degrade_error(struct extra_rw_degrade_errors *errors,
+				   u64 devid)
+{
+	int i;
+	bool inserted = false;
+
+	if (!errors)
+		return;
+
+	spin_lock(&errors->lock);
+	for (i = 0; i < errors->nr_devs; i++) {
+		struct rw_degrade_error *error = &errors->errors[i];
+
+		if (!error->initialized) {
+			error->devid = devid;
+			error->initialized = true;
+			error->err = true;
+			inserted = true;
+			break;
+		}
+		if (error->devid == devid) {
+			error->err = true;
+			inserted = true;
+			break;
+		}
+	}
+	spin_unlock(&errors->lock);
+	/*
+	 * We iterate all the error records but still found no empty slot
+	 * This means errors->nr_devs is not correct.
+	 */
+	WARN_ON(!inserted);
+}
+
+static bool device_has_rw_degrade_error(struct extra_rw_degrade_errors *errors,
+					u64 devid)
+{
+	int i;
+	bool ret = false;
+
+	if (!errors)
+		return ret;
+
+	spin_lock(&errors->lock);
+	for (i = 0; i < errors->nr_devs; i++) {
+		struct rw_degrade_error *error = &errors->errors[i];
+
+		if (!error->initialized)
+			break;
+		if (error->devid == devid) {
+			ret = true;
+			break;
+		}
+	}
+	spin_unlock(&errors->lock);
+	return ret;
+}
+
 /*
  * Check if all chunks in the fs is OK for read-write degraded mount
  *
  * Return true if the fs is OK to be mounted degraded read-write
  * Return false if the fs is not OK to be mounted degraded
  */
-bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
+bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
+			       struct extra_rw_degrade_errors *errors)
 {
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
 	struct extent_map *em;
@@ -6797,7 +6856,10 @@ bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
 			btrfs_get_num_tolerated_disk_barrier_failures(
 					map->type);
 		for (i = 0; i < map->num_stripes; i++) {
-			if (map->stripes[i].dev->missing)
+			struct btrfs_device *device = map->stripes[i].dev;
+
+			if (device->missing ||
+			    device_has_rw_degrade_error(errors, device->devid))
 				missing++;
 		}
 		if (missing > max_tolerated) {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index db1b5ef479cf..67d7474e42a3 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -538,5 +538,39 @@ struct list_head *btrfs_get_fs_uuids(void);
 void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 
-bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info);
+/*
+ * For btrfs_check_rw_degradable() to check extra error from
+ * barrier_all_devices()
+ */
+struct rw_degrade_error {
+	u64 devid;
+	bool initialized;
+	bool err;
+};
+
+struct extra_rw_degrade_errors {
+	int nr_devs;
+	spinlock_t lock;
+	struct rw_degrade_error errors[];
+};
+
+static inline struct extra_rw_degrade_errors *alloc_extra_rw_degrade_errors(
+		int nr_devs)
+{
+	struct extra_rw_degrade_errors *ret;
+
+	ret = kzalloc(sizeof(struct extra_rw_degrade_errors) + nr_devs *
+		      sizeof(struct rw_degrade_error), GFP_NOFS);
+	if (!ret)
+		return ret;
+	spin_lock_init(&ret->lock);
+	ret->nr_devs = nr_devs;
+	return ret;
+}
+
+void record_extra_rw_degrade_error(struct extra_rw_degrade_errors *errors,
+				   u64 devid);
+
+bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
+			       struct extra_rw_degrade_errors *errors);
 #endif
-- 
2.12.0



