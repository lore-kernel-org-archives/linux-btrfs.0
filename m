Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759657AbcAUScO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 13:32:14 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 8E406AC20
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 18:32:12 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/4] btrfs: sysfs: introduce helper for syncing bits with sysfs files
Date: Thu, 21 Jan 2016 19:32:07 +0100
Message-Id: <444e75169872f668eb890f19ec1f32dfc632e704.1453400624.git.dsterba@suse.com>
In-Reply-To: <cover.1453400624.git.dsterba@suse.com>
References: <cover.1453400624.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The files under /sys/fs/UUID/features get out of sync with the actual
incompat bits set for the filesystem if they change after mount. We're
going to sync them and need a helper to do that.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 30 ++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.h |  3 +++
 2 files changed, 33 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 906f7ed6fc80..6986886243bf 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -782,6 +782,36 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 	return error;
 }
 
+
+/*
+ * Change per-fs features in /sys/fs/btrfs/UUID/features to match current
+ * values in superblock. Call after any changes to incompat/compat_ro flags
+ */
+void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
+		u64 bit, enum btrfs_feature_set set)
+{
+	struct btrfs_fs_devices *fs_devs;
+	struct kobject *fsid_kobj;
+	u64 features;
+	int ret;
+
+	if (!fs_info)
+		return;
+
+	features = get_features(fs_info, set);
+	ASSERT(bit & supported_feature_masks[set]);
+
+	fs_devs = fs_info->fs_devices;
+	fsid_kobj = &fs_devs->fsid_kobj;
+
+	/*
+	 * FIXME: this is too heavy to update just one value, ideally we'd like
+	 * to use sysfs_update_group but some refactoring is needed first.
+	 */
+	sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
+	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
+}
+
 static int btrfs_init_debugfs(void)
 {
 #ifdef CONFIG_DEBUG_FS
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 72408e2c4ea8..d7da1a4c2f6c 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -90,4 +90,7 @@ int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 				struct kobject *parent);
 int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
+void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
+		u64 bit, enum btrfs_feature_set set);
+
 #endif /* _BTRFS_SYSFS_H_ */
-- 
2.6.3

