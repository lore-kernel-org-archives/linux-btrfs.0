Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab3KARY3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Nov 2013 13:24:29 -0400
Message-Id: <20131101172241.568825841@suse.com>
Date: Fri, 01 Nov 2013 13:07:05 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 11/13] btrfs: publish device membership in sysfs
References: <20131101170654.164867629@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we have the infrastructure for per-super attributes, we can
publish device membership in /sys/fs/btrfs/<fsid>/devices. The information
is published as symlinks to the block devices.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h |    1 +
 fs/btrfs/sysfs.c |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

--- a/fs/btrfs/ctree.h	2013-10-21 16:10:02.743982088 -0400
+++ b/fs/btrfs/ctree.h	2013-10-21 16:10:03.223971538 -0400
@@ -1522,6 +1522,7 @@ struct btrfs_fs_info {
 
 	struct kobject super_kobj;
 	struct kobject *space_info_kobj;
+	struct kobject *device_dir_kobj;
 	struct completion kobj_unregister;
 	int do_barriers;
 	int closing;
--- a/fs/btrfs/sysfs.c	2013-10-21 16:10:02.751981911 -0400
+++ b/fs/btrfs/sysfs.c	2013-10-21 16:10:03.227971451 -0400
@@ -23,11 +23,13 @@
 #include <linux/buffer_head.h>
 #include <linux/kobject.h>
 #include <linux/bug.h>
+#include <linux/genhd.h>
 
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
 #include "sysfs.h"
+#include "volumes.h"
 
 static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj);
 
@@ -374,6 +376,8 @@ static inline struct btrfs_fs_info *to_f
 void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 {
 	sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
+	kobject_del(fs_info->device_dir_kobj);
+	kobject_put(fs_info->device_dir_kobj);
 	kobject_del(fs_info->space_info_kobj);
 	kobject_put(fs_info->space_info_kobj);
 	kobject_del(&fs_info->super_kobj);
@@ -507,6 +511,30 @@ static int add_unknown_feature_attrs(str
 	return 0;
 }
 
+static int add_device_membership(struct btrfs_fs_info *fs_info)
+{
+	int error = 0;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *dev;
+
+	fs_info->device_dir_kobj = kobject_create_and_add("devices",
+						&fs_info->super_kobj);
+	if (!fs_info->device_dir_kobj)
+		return -ENOMEM;
+
+	list_for_each_entry(dev, &fs_devices->devices, dev_list) {
+		struct hd_struct *disk = dev->bdev->bd_part;
+		struct kobject *disk_kobj = &part_to_dev(disk)->kobj;
+
+		error = sysfs_create_link(fs_info->device_dir_kobj,
+					  disk_kobj, disk_kobj->name);
+		if (error)
+			break;
+	}
+
+	return error;
+}
+
 /* /sys/fs/btrfs/ entry */
 static struct kset *btrfs_kset;
 
@@ -528,6 +556,10 @@ int btrfs_sysfs_add_one(struct btrfs_fs_
 	if (error)
 		goto failure;
 
+	error = add_device_membership(fs_info);
+	if (error)
+		goto failure;
+
 	fs_info->space_info_kobj = kobject_create_and_add("allocation",
 						  &fs_info->super_kobj);
 	if (!fs_info->space_info_kobj) {



