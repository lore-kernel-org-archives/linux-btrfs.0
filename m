Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55091 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab3ENA7j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 May 2013 20:59:39 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Mon, 13 May 2013 20:59:38 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, linuxram@us.ibm.com,
        david@fromorbit.com, dsterba@suse.cz, gregkh@linuxfoundation.org,
        paulmck@linux.vnet.ibm.com, chris.mason@fusionio.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 08/12] VFS hot tracking: add one ioctl interface
Date: Tue, 14 May 2013 08:59:40 +0800
Message-Id: <1368493184-5939-9-git-send-email-zwu.kernel@gmail.com>
In-Reply-To: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
References: <1368493184-5939-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  FS_IOC_GET_HEAT_INFO: return a struct containing the various
metrics collected in hot_freq_data structs, and also return a
calculated data temperature based on those metrics. Optionally,
retrieve the temperature from the hot data hash list instead of
recalculating it.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/compat_ioctl.c            |  5 ++++
 fs/hot_tracking.c            |  2 +-
 fs/ioctl.c                   | 70 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hot_tracking.h | 21 +++++++++++++
 4 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 996cdc5..97bf972 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -57,6 +57,7 @@
 #include <linux/i2c-dev.h>
 #include <linux/atalk.h>
 #include <linux/gfp.h>
+#include <linux/hot_tracking.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci.h>
@@ -1402,6 +1403,9 @@ COMPATIBLE_IOCTL(TIOCSTART)
 COMPATIBLE_IOCTL(TIOCSTOP)
 #endif
 
+/*Hot data tracking*/
+COMPATIBLE_IOCTL(FS_IOC_GET_HEAT_INFO)
+
 /* fat 'r' ioctls. These are handled by fat with ->compat_ioctl,
    but we don't want warnings on other file systems. So declare
    them as compatible here. */
@@ -1581,6 +1585,7 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 	case FIBMAP:
 	case FIGETBSZ:
 	case FIONREAD:
+	case FS_IOC_GET_HEAT_INFO:
 		if (S_ISREG(file_inode(f.file)->i_mode))
 			break;
 		/*FALL THROUGH*/
diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index cea3675..1618f21 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -375,7 +375,7 @@ static void hot_freq_update(struct hot_info *root,
  * the *_COEFF_POWER values and combined to a single temperature
  * value.
  */
-static u32 hot_temp_calc(struct hot_comm_item *ci)
+u32 hot_temp_calc(struct hot_comm_item *ci)
 {
 	u32 result = 0;
 	struct hot_freq_data *freq_data = &ci->hot_freq_data;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index fd507fb..f9f3497 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
 #include <linux/falloc.h>
+#include <linux/hot_tracking.h>
 
 #include <asm/ioctls.h>
 
@@ -537,6 +538,72 @@ static int ioctl_fsthaw(struct file *filp)
 }
 
 /*
+ * Retrieve information about access frequency for the given file. Return it in
+ * a userspace-friendly struct for btrfsctl (or another tool) to parse.
+ *
+ * The temperature that is returned can be "live" -- that is, recalculated when
+ * the ioctl is called -- or it can be returned from the map list, reflecting
+ * the (possibly old) value that the system will use when considering files
+ * for migration. This behavior is determined by hot_heat_info->live.
+ */
+static int ioctl_heat_info(struct file *file, void __user *argp)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct hot_heat_info heat_info;
+	struct hot_inode_item *he;
+	int ret = 0;
+
+	if (copy_from_user((void *)&heat_info,
+			argp,
+			sizeof(struct hot_heat_info)) != 0) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	he = hot_inode_item_lookup(inode->i_sb->s_hot_root, inode->i_ino, 0);
+	if (IS_ERR(he)) {
+		/* we don't have any info on this file yet */
+		ret = -ENODATA;
+		goto err;
+	}
+
+	heat_info.avg_delta_reads =
+		(__u64) he->hot_inode.hot_freq_data.avg_delta_reads;
+	heat_info.avg_delta_writes =
+		(__u64) he->hot_inode.hot_freq_data.avg_delta_writes;
+	heat_info.last_read_time =
+	(__u64) timespec_to_ns(&he->hot_inode.hot_freq_data.last_read_time);
+	heat_info.last_write_time =
+	(__u64) timespec_to_ns(&he->hot_inode.hot_freq_data.last_write_time);
+	heat_info.num_reads =
+		(__u32) he->hot_inode.hot_freq_data.nr_reads;
+	heat_info.num_writes =
+		(__u32) he->hot_inode.hot_freq_data.nr_writes;
+
+	if (heat_info.live > 0) {
+		/*
+		 * got a request for live temperature,
+		 * call hot_calc_temp() to recalculate
+		 */
+		heat_info.temp = hot_temp_calc(&he->hot_inode);
+	} else {
+		/* not live temperature, get it from the map list */
+		heat_info.temp = he->hot_inode.hot_freq_data.last_temp;
+	}
+
+	hot_comm_item_put(&he->hot_inode);
+
+	if (copy_to_user(argp, (void *)&heat_info,
+			sizeof(struct hot_heat_info))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+err:
+	return ret;
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -591,6 +658,9 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, argp);
 
+	case FS_IOC_GET_HEAT_INFO:
+		return ioctl_heat_info(filp, argp);
+
 	default:
 		if (S_ISREG(inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 63baae3..263a15e 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -17,6 +17,18 @@
 
 #include <linux/types.h>
 
+struct hot_heat_info {
+	__u64 avg_delta_reads;
+	__u64 avg_delta_writes;
+	__u64 last_read_time;
+	__u64 last_write_time;
+	__u32 num_reads;
+	__u32 num_writes;
+	__u32 temp;
+	__u8 live;
+	__u8 resv[3];
+};
+
 #ifdef __KERNEL__
 
 #include <linux/rbtree.h>
@@ -97,6 +109,14 @@ struct hot_info {
 	struct dentry *debugfs_dentry;
 };
 
+/*
+ * Hot data tracking ioctls:
+ *
+ * HOT_INFO - retrieve info on frequency of access
+ */
+#define FS_IOC_GET_HEAT_INFO _IOR('f', 17, \
+			struct hot_heat_info)
+
 extern void __init hot_cache_init(void);
 extern int hot_track_init(struct super_block *sb);
 extern void hot_track_exit(struct super_block *sb);
@@ -108,6 +128,7 @@ extern struct hot_inode_item *hot_inode_item_lookup(struct hot_info *root,
 extern struct hot_range_item *hot_range_item_lookup(struct hot_inode_item *he,
 						loff_t start, int alloc);
 extern void hot_inode_item_delete(struct inode *inode);
+extern u32 hot_temp_calc(struct hot_comm_item *ci);
 
 static inline u64 hot_shift(u64 counter, u32 bits, bool dir)
 {
-- 
1.7.11.7

