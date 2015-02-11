Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45838 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbbBLEcz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 23:32:55 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t1C4WtMt031894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id t1C4WsqL028389
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:54 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t1C4Ws41024810
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 04:32:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: procfs-devlist: introduce procfs interface for the device list
Date: Thu, 12 Feb 2015 04:32:29 +0800
Message-Id: <1423686751-5053-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423686751-5053-1-git-send-email-anand.jain@oracle.com>
References: <1423686751-5053-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

(added RFC prefix to the patch header)
(as of now just an experimental interface)

This patch introduces profs interface /proc/fs/btrfs/devlist,
which as of now exports all the members of kernel fs_devices.

The current /sys/fs/btrfs interface works when the fs is
mounted, and is on the file directory hierarchy and also has
the sysfs limitation max output of U64 per file.

Here btrfs procfs uses seq_file to export all the members of
fs_devices. Also shows the contents when device is not mounted,
but have registered with btrfs kernel (useful as an alternative
to buggy ready ioctl)

An attempt is made to follow the some standard file format
output such as ini. So that a simple warper python script will
provide end user useful interfaces.

Further planning to add few more members to the interface such as
group profile info. The long term idea is to make procfs
interface a onestop btrfs application interface for the device and
fs info from the kernel, where a simple python script can make
use of it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/Makefile  |   2 +-
 fs/btrfs/ctree.h   |   4 ++
 fs/btrfs/procfs.c  | 142 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/super.c   |   4 ++
 fs/btrfs/volumes.h |   1 +
 5 files changed, 152 insertions(+), 1 deletion(-)
 create mode 100644 fs/btrfs/procfs.c

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 6d1d0b9..134a62f 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_BTRFS_FS) := btrfs.o
 btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o inode.o file.o tree-defrag.o \
-	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
+	   extent_map.o sysfs.o procfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9493b91..a83a16a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3986,6 +3986,10 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
 int btrfs_parse_options(struct btrfs_root *root, char *options);
 int btrfs_sync_fs(struct super_block *sb, int wait);
 
+/* procfs.c */
+void btrfs_exit_procfs(void);
+void btrfs_init_procfs(void);
+
 #ifdef CONFIG_PRINTK
 __printf(2, 3)
 void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...);
diff --git a/fs/btrfs/procfs.c b/fs/btrfs/procfs.c
new file mode 100644
index 0000000..d16a76b
--- /dev/null
+++ b/fs/btrfs/procfs.c
@@ -0,0 +1,142 @@
+#include <linux/seq_file.h>
+#include <linux/vmalloc.h>
+#include <linux/proc_fs.h>
+#include <linux/rcustring.h>
+#include "ctree.h"
+#include "volumes.h"
+
+#define BTRFS_PROC_PATH		"fs/btrfs"
+#define BTRFS_PROC_DEVLIST	"devlist"
+
+struct proc_dir_entry	*btrfs_proc_root;
+
+void btrfs_print_devlist(struct seq_file *seq)
+{
+
+	/* Btrfs Procfs String Len */
+#define BPSL	256
+#define BTRFS_SEQ_PRINT(plist, arg)\
+		snprintf(str, BPSL, plist, arg);\
+		if (sprt)\
+			seq_printf(seq, "\t");\
+		seq_printf(seq, str)
+
+	char str[BPSL];
+	struct btrfs_device *device;
+	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_fs_devices *cur_fs_devices;
+	struct btrfs_fs_devices *sprt; //sprout fs devices
+	struct list_head *fs_uuids = btrfs_get_fs_uuids();
+	struct list_head *cur_uuid;
+
+	seq_printf(seq, "\n#Its Experimental, parameters may change without notice.\n\n");
+
+	mutex_lock(&uuid_mutex);
+	/* Todo: there must be better way than nested locks */
+	list_for_each(cur_uuid, fs_uuids) {
+		cur_fs_devices  = list_entry(cur_uuid, struct btrfs_fs_devices, list);
+
+		mutex_lock(&cur_fs_devices->device_list_mutex);
+
+		fs_devices = cur_fs_devices;
+		sprt = NULL;
+
+again_fs_devs:
+		if (sprt) {
+			BTRFS_SEQ_PRINT("[[seed_fsid: %pU]]\n", fs_devices->fsid);
+			BTRFS_SEQ_PRINT("\tsprout_fsid:\t\t%pU\n", sprt->fsid);
+		} else {
+			BTRFS_SEQ_PRINT("[fsid: %pU]\n", fs_devices->fsid);
+		}
+		if (fs_devices->seed) {
+			BTRFS_SEQ_PRINT("\tseed_fsid:\t\t%pU\n", fs_devices->seed->fsid);
+		}
+		BTRFS_SEQ_PRINT("\tfs_devs_addr:\t\t%p\n", fs_devices);
+		BTRFS_SEQ_PRINT("\tnum_devices:\t\t%llu\n", fs_devices->num_devices);
+		BTRFS_SEQ_PRINT("\topen_devices:\t\t%llu\n", fs_devices->open_devices);
+		BTRFS_SEQ_PRINT("\trw_devices:\t\t%llu\n", fs_devices->rw_devices);
+		BTRFS_SEQ_PRINT("\tmissing_devices:\t%llu\n", fs_devices->missing_devices);
+		BTRFS_SEQ_PRINT("\ttotal_rw_devices:\t%llu\n", fs_devices->total_rw_bytes);
+		BTRFS_SEQ_PRINT("\ttotal_devices:\t\t%llu\n", fs_devices->total_devices);
+		BTRFS_SEQ_PRINT("\topened:\t\t\t%d\n", fs_devices->opened);
+		BTRFS_SEQ_PRINT("\tseeding:\t\t%d\n", fs_devices->seeding);
+		BTRFS_SEQ_PRINT("\trotating:\t\t%d\n", fs_devices->rotating);
+
+		list_for_each_entry(device, &fs_devices->devices, dev_list) {
+			BTRFS_SEQ_PRINT("\t[[uuid: %pU]]\n", device->uuid);
+			BTRFS_SEQ_PRINT("\t\tdev_addr:\t%p\n", device);
+			rcu_read_lock();
+			BTRFS_SEQ_PRINT("\t\tdevice:\t\t%s\n",
+				device->name ? rcu_string_dereference(device->name): "(null)");
+			rcu_read_unlock();
+			BTRFS_SEQ_PRINT("\t\tdevid:\t\t%llu\n", device->devid);
+			if (device->dev_root) {
+				BTRFS_SEQ_PRINT("\t\tdev_root_fsid:\t%pU\n",
+						device->dev_root->fs_info->fsid);
+			}
+			BTRFS_SEQ_PRINT("\t\tgeneration:\t%llu\n", device->generation);
+			BTRFS_SEQ_PRINT("\t\ttotal_bytes:\t%llu\n", device->total_bytes);
+			BTRFS_SEQ_PRINT("\t\tdev_totalbytes:\t%llu\n", device->disk_total_bytes);
+			BTRFS_SEQ_PRINT("\t\tbytes_used:\t%llu\n", device->bytes_used);
+			BTRFS_SEQ_PRINT("\t\ttype:\t\t%llu\n", device->type);
+			BTRFS_SEQ_PRINT("\t\tio_align:\t%u\n", device->io_align);
+			BTRFS_SEQ_PRINT("\t\tio_width:\t%u\n", device->io_width);
+			BTRFS_SEQ_PRINT("\t\tsector_size:\t%u\n", device->sector_size);
+			BTRFS_SEQ_PRINT("\t\tmode:\t\t0x%llx\n", (u64)device->mode);
+			BTRFS_SEQ_PRINT("\t\twriteable:\t%d\n", device->writeable);
+			BTRFS_SEQ_PRINT("\t\tin_fs_metadata:\t%d\n", device->in_fs_metadata);
+			BTRFS_SEQ_PRINT("\t\tmissing:\t%d\n", device->missing);
+			BTRFS_SEQ_PRINT("\t\tcan_discard:\t%d\n", device->can_discard);
+			BTRFS_SEQ_PRINT("\t\treplace_tgtdev:\t%d\n",
+								device->is_tgtdev_for_dev_replace);
+			BTRFS_SEQ_PRINT("\t\tactive_pending:\t%d\n", device->running_pending);
+			BTRFS_SEQ_PRINT("\t\tnobarriers:\t%d\n", device->nobarriers);
+			BTRFS_SEQ_PRINT("\t\tdevstats_valid:\t%d\n", device->dev_stats_valid);
+			BTRFS_SEQ_PRINT("\t\tbdev:\t\t%s\n", device->bdev ? "not_null":"null");
+		}
+
+		if (fs_devices->seed) {
+			sprt = fs_devices;
+			fs_devices = fs_devices->seed;
+			goto again_fs_devs;
+		}
+		seq_printf(seq, "\n");
+
+		mutex_unlock(&cur_fs_devices->device_list_mutex);
+	}
+	mutex_unlock(&uuid_mutex);
+}
+static int btrfs_devlist_show(struct seq_file *seq, void *offset)
+{
+	btrfs_print_devlist(seq);
+	return 0;
+}
+
+static int btrfs_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, btrfs_devlist_show, PDE_DATA(inode));
+}
+
+static const struct file_operations btrfs_seq_fops = {
+	.owner   = THIS_MODULE,
+	.open    = btrfs_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+void btrfs_init_procfs(void)
+{
+	btrfs_proc_root = proc_mkdir(BTRFS_PROC_PATH, NULL);
+	if (btrfs_proc_root)
+		proc_create_data(BTRFS_PROC_DEVLIST, S_IRUGO, btrfs_proc_root,
+					&btrfs_seq_fops, NULL);
+	return;
+}
+
+void btrfs_exit_procfs(void)
+{
+	if (btrfs_proc_root)
+		remove_proc_entry(BTRFS_PROC_DEVLIST, btrfs_proc_root);
+	remove_proc_entry(BTRFS_PROC_PATH, NULL);
+}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 60f7cbe..f3a7f72 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2086,6 +2086,8 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_hash;
 
+	btrfs_init_procfs();
+
 	btrfs_init_compress();
 
 	err = btrfs_init_cachep();
@@ -2164,6 +2166,7 @@ free_cachep:
 	btrfs_destroy_cachep();
 free_compress:
 	btrfs_exit_compress();
+	btrfs_exit_procfs();
 	btrfs_exit_sysfs();
 free_hash:
 	btrfs_hash_exit();
@@ -2183,6 +2186,7 @@ static void __exit exit_btrfs_fs(void)
 	btrfs_interface_exit();
 	btrfs_end_io_wq_exit();
 	unregister_filesystem(&btrfs_fs_type);
+	btrfs_exit_procfs();
 	btrfs_exit_sysfs();
 	btrfs_cleanup_fs_uuids();
 	btrfs_exit_compress();
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 4e99f06..7916935 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -392,6 +392,7 @@ struct btrfs_balance_control {
 	struct btrfs_balance_progress stat;
 };
 
+struct list_head *btrfs_get_fs_uuids(void);
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length);
 
-- 
2.0.0.153.g79dcccc

