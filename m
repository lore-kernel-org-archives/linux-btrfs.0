Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47883 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934153AbcDLOQ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 10:16:56 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH 09/13] btrfs: provide framework to get and put a spare device
Date: Tue, 12 Apr 2016 22:15:59 +0800
Message-Id: <1460470563-752-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1460470563-752-1-git-send-email-anand.jain@oracle.com>
References: <1460470563-752-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This adds functions to get and put a spare device from the list.
So that hot repace code can pick a spare device when needed.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
 fs/btrfs/ctree.h   |  1 +
 fs/btrfs/super.c   |  5 +++++
 fs/btrfs/volumes.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |  2 ++
 4 files changed, 61 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a823ff7944f1..1cf1bbf3058f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4185,6 +4185,7 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info);
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 
 /* super.c */
+struct file_system_type *btrfs_get_fs_type(void);
 int btrfs_parse_options(struct btrfs_root *root, char *options,
 			unsigned long new_flags);
 int btrfs_sync_fs(struct super_block *sb, int wait);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 729f596b540a..2d77a8dde92c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -69,6 +69,11 @@ static struct file_system_type btrfs_fs_type;
 
 static int btrfs_remount(struct super_block *sb, int *flags, char *data);
 
+struct file_system_type *btrfs_get_fs_type()
+{
+	return &btrfs_fs_type;
+}
+
 const char *btrfs_decode_error(int errno)
 {
 	char *errstr = "unknown";
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 150807e0310e..00d82872ede0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -525,6 +525,59 @@ static void pending_bios_fn(struct btrfs_work *work)
 	run_scheduled_bios(device);
 }
 
+int btrfs_get_spare_device(char **path)
+{
+	int ret = 1;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_device *device;
+	struct list_head *fs_uuids = btrfs_get_fs_uuids();
+
+	mutex_lock(&uuid_mutex);
+	list_for_each_entry(fs_devices, fs_uuids, list) {
+		if (!fs_devices->spare)
+			continue;
+
+		/* as of now there is only one device in the spare fs_devices */
+		device = list_entry(fs_devices->devices.next,
+					struct btrfs_device, dev_list);
+
+		if (!device || !device->name)
+			continue;
+
+		fs_devices->spare = 0;
+		/*
+		 * Its under uuid_mutex and there is one spare per fsid
+		 * so rcu lock is actually not required
+		 */
+		*path = kstrdup(device->name->str, GFP_KERNEL);
+		if (*path)
+			ret = 0;
+		else
+			ret = -ENOMEM;
+		break;
+	}
+
+	if (!ret) {
+		btrfs_sysfs_remove_fsid(fs_devices);
+		list_del(&fs_devices->list);
+		free_fs_devices(fs_devices);
+	}
+	mutex_unlock(&uuid_mutex);
+
+	return ret;
+}
+
+void btrfs_put_spare_device(char *path)
+{
+	struct file_system_type *btrfs_fs_type;
+	struct btrfs_fs_devices *fs_devices;
+
+	btrfs_fs_type = btrfs_get_fs_type();
+
+	if (btrfs_scan_one_device(path, FMODE_READ,
+				    btrfs_fs_type, &fs_devices))
+		printk(KERN_INFO "failed to return spare device\n");
+}
 
 void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 51cf716eb35b..b4308afa3097 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -469,6 +469,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *path);
 int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 				  struct btrfs_device *srcdev,
 				  struct btrfs_device **device_out);
+int btrfs_get_spare_device(char **path);
+void btrfs_put_spare_device(char *path);
 int btrfs_balance(struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);
 int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
-- 
2.7.0

