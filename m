Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47884 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaEZJ12 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 05:27:28 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 1/4] btrfs: dev delete should remove sysfs entry
Date: Mon, 26 May 2014 17:30:23 +0800
Message-Id: <1401096626-13210-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

when we delete the device from the mounted btrfs,
we would need its corresponding sysfs enty to
be removed as well.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 fs/btrfs/sysfs.c   |   20 ++++++++++++++++++++
 fs/btrfs/sysfs.h   |    2 ++
 fs/btrfs/volumes.c |    4 ++++
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 522d023..4fe3f0b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -572,6 +572,26 @@ static void init_feature_attrs(void)
 	}
 }
 
+int rm_device_membership(struct btrfs_fs_info *fs_info,
+		struct btrfs_device *one_device)
+{
+	struct hd_struct *disk;
+	struct kobject *disk_kobj;
+
+	if (!fs_info->device_dir_kobj)
+		return -EINVAL;
+
+	if (one_device) {
+		disk = one_device->bdev->bd_part;
+		disk_kobj = &part_to_dev(disk)->kobj;
+
+		sysfs_remove_link(fs_info->device_dir_kobj,
+						disk_kobj->name);
+	}
+
+	return 0;
+}
+
 static int add_device_membership(struct btrfs_fs_info *fs_info)
 {
 	int error = 0;
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 9ab5763..eaed810 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -66,4 +66,6 @@ char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
 extern const char * const btrfs_feature_set_names[3];
 extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
+int rm_device_membership(struct btrfs_fs_info *fs_info,
+                struct btrfs_device *one_device);
 #endif /* _BTRFS_SYSFS_H_ */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 15a8934..3ceb28c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -40,6 +40,7 @@
 #include "rcu-string.h"
 #include "math.h"
 #include "dev-replace.h"
+#include "sysfs.h"
 
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
@@ -1651,6 +1652,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	if (device->bdev)
 		device->fs_devices->open_devices--;
 
+	/* remove sysfs entry */
+	rm_device_membership(root->fs_info, device);
+
 	call_rcu(&device->rcu, free_device);
 
 	num_devices = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
-- 
1.7.1

