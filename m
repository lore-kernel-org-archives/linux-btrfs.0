From: bchociej@gmail.com
Subject: [RFC PATCH 3/5] Btrfs: 3 new ioctls related to hot data features
Date: Tue, 27 Jul 2010 17:00:21 -0500
Message-ID: <1280268023-18408-4-git-send-email-bchociej@gmail.com>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.ibm.com, crscott@us.ibm.com,
	linux-kernel@vger.kernel.org
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

From: Ben Chociej <bcchocie@us.ibm.com>

BTRFS_IOC_GET_HEAT_INFO: return a struct containing the various
metrics collected in btrfs_freq_data structs, and also return a
calculated data temperature based on those metrics. Optionally, retrieve
the temperature from the hot data hash list instead of recalculating it.

BTRFS_IOC_GET_HEAT_OPTS: return an integer representing the current
state of hot data tracking and migration:
	0 = do nothing
	1 = track frequency of access
	2 = migrate data to fast media based on	temperature
		(not implemented)

BTRFS_IOC_SET_HEAT_OPTS: change the state of hot data tracking and
migration, as described above.

Signed-off-by: Ben Chociej <bcchocie@us.ibm.com>
Signed-off-by: Matt Lupfer <mrlupfer@us.ibm.com>
Signed-off-by: Conor Scott <crscott@us.ibm.com>
Reviewed-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Steve French <sfrench@us.ibm.com>
---
 fs/btrfs/ioctl.c |  146 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ioctl.h |   21 ++++++++
 2 files changed, 166 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4dbaf89..be7aba2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -49,6 +49,8 @@
 #include "print-tree.h"
 #include "volumes.h"
 #include "locking.h"
+#include "hotdata_map.h"
+#include "hotdata_hash.h"
 
 /* Mask out flags that are inappropriate for the given type of inode. */
 static inline __u32 btrfs_mask_flags(umode_t mode, __u32 flags)
@@ -1869,7 +1871,7 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	return 0;
 }
 
-long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
+static long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
 {
 	struct btrfs_ioctl_space_args space_args;
 	struct btrfs_ioctl_space_info space;
@@ -1974,6 +1976,142 @@ long btrfs_ioctl_trans_end(struct file *file)
 	return 0;
 }
 
+/*
+ * Retrieve information about access frequency for the given file. Return it in
+ * a userspace-friendly struct for btrfsctl (or another tool) to parse.
+ *
+ * The temperature that is returned can be "live" -- that is, recalculated when
+ * the ioctl is called -- or it can be returned from the hashtable, reflecting
+ * the (possibly old) value that the system will use when considering files
+ * for migration. This behavior is determined by heat_info->live.
+ */
+static long btrfs_ioctl_heat_info(struct file *file, void __user *argp)
+{
+	struct inode *mnt_inode = fdentry(file)->d_inode;
+	struct inode *file_inode;
+	struct file *file_filp;
+	struct btrfs_root *root = BTRFS_I(mnt_inode)->root;
+	struct btrfs_ioctl_heat_info *heat_info;
+	struct hot_inode_tree *hitree;
+	struct hot_inode_item *he;
+	int ret;
+
+	heat_info = kmalloc(sizeof(struct btrfs_ioctl_heat_info),
+			GFP_KERNEL | GFP_NOFS);
+
+	if (copy_from_user((void *) heat_info,
+			  argp,
+			  sizeof(struct btrfs_ioctl_heat_info)) != 0) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	file_filp = filp_open(heat_info->filename, O_RDONLY, 0);
+
+	if (IS_ERR(file_filp)) {
+		ret = (long) file_filp;
+		goto err;
+	}
+
+	file_inode = file_filp->f_dentry->d_inode;
+
+	hitree = &root->hot_inode_tree;
+	read_lock(&hitree->lock);
+	he = lookup_hot_inode_item(hitree, file_inode->i_ino);
+	read_unlock(&hitree->lock);
+
+	if (!he || IS_ERR(he)) {
+		/* we don't have any info on this file yet */
+		ret = -ENODATA;
+		goto err;
+	}
+
+	spin_lock(&he->lock);
+
+	heat_info->avg_delta_reads =
+		(__u64) he->freq_data.avg_delta_reads;
+	heat_info->avg_delta_writes =
+		(__u64) he->freq_data.avg_delta_writes;
+	heat_info->last_read_time =
+		(__u64) timespec_to_ns(&he->freq_data.last_read_time);
+	heat_info->last_write_time =
+		(__u64) timespec_to_ns(&he->freq_data.last_write_time);
+	heat_info->num_reads =
+		(__u32) he->freq_data.nr_reads;
+	heat_info->num_writes =
+		(__u32) he->freq_data.nr_writes;
+
+	if (heat_info->live > 0) {
+		/* got a request for live temperature,
+		 * call btrfs_get_temp to recalculate */
+		heat_info->temperature = btrfs_get_temp(&he->freq_data);
+	} else {
+		/* not live temperature, get it from the hashlist */
+		read_lock(&he->heat_node->hlist->rwlock);
+		heat_info->temperature = he->heat_node->hlist->temperature;
+		read_unlock(&he->heat_node->hlist->rwlock);
+	}
+
+	spin_unlock(&he->lock);
+	free_hot_inode_item(he);
+
+	if (copy_to_user(argp, (void *) heat_info,
+		     sizeof(struct btrfs_ioctl_heat_info))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
+	kfree(heat_info);
+	return 0;
+
+err:
+	kfree(heat_info);
+	return ret;
+}
+
+static long btrfs_ioctl_heat_opts(struct file *file, void __user *argp, int set)
+{
+	struct inode *inode = fdentry(file)->d_inode;
+	int arg, ret = 0;
+
+	if (!set) {
+		arg =	((BTRFS_I(inode)->flags & BTRFS_INODE_NO_HOTDATA_TRACK)
+			? 0 : 1) +
+			((BTRFS_I(inode)->flags & BTRFS_INODE_NO_HOTDATA_MOVE)
+			? 0 : 1);
+
+		if (copy_to_user(argp, (void *) &arg, sizeof(int)) != 0)
+			ret = -EFAULT;
+	} else if (copy_from_user((void *) &arg, argp, sizeof(int)) != 0)
+		ret = -EFAULT;
+	else
+		switch (arg) {
+		case 0: /* track nothing, move nothing */
+			/* set both flags */
+			BTRFS_I(inode)->flags |=
+				BTRFS_INODE_NO_HOTDATA_TRACK |
+				BTRFS_INODE_NO_HOTDATA_MOVE;
+			break;
+		case 1: /* do tracking, don't move anything */
+			/* clear NO_HOTDATA_TRACK, set NO_HOTDATA_MOVE */
+			BTRFS_I(inode)->flags &=
+				~BTRFS_INODE_NO_HOTDATA_TRACK;
+			BTRFS_I(inode)->flags |=
+				BTRFS_INODE_NO_HOTDATA_MOVE;
+			break;
+		case 2: /* track and move */
+			/* clear both flags */
+			BTRFS_I(inode)->flags &=
+				~(BTRFS_INODE_NO_HOTDATA_TRACK |
+				  BTRFS_INODE_NO_HOTDATA_MOVE);
+			break;
+		default:
+			ret = -EINVAL;
+		}
+
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2021,6 +2159,12 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_ino_lookup(file, argp);
 	case BTRFS_IOC_SPACE_INFO:
 		return btrfs_ioctl_space_info(root, argp);
+	case BTRFS_IOC_GET_HEAT_INFO:
+		return btrfs_ioctl_heat_info(file, argp);
+	case BTRFS_IOC_GET_HEAT_OPTS:
+		return btrfs_ioctl_heat_opts(file, argp, 0);
+	case BTRFS_IOC_SET_HEAT_OPTS:
+		return btrfs_ioctl_heat_opts(file, argp, 1);
 	case BTRFS_IOC_SYNC:
 		btrfs_sync_fs(file->f_dentry->d_sb, 1);
 		return 0;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 424694a..8ba775e 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -138,6 +138,18 @@ struct btrfs_ioctl_space_args {
 	struct btrfs_ioctl_space_info spaces[0];
 };
 
+struct btrfs_ioctl_heat_info {
+	__u64 avg_delta_reads;
+	__u64 avg_delta_writes;
+	__u64 last_read_time;
+	__u64 last_write_time;
+	__u32 num_reads;
+	__u32 num_writes;
+	char filename[BTRFS_PATH_NAME_MAX + 1];
+	int temperature;
+	__u8 live;
+};
+
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_DEFRAG _IOW(BTRFS_IOCTL_MAGIC, 2, \
@@ -178,4 +190,13 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
+
+/*
+ * Hot data tracking ioctls:
+ */
+#define BTRFS_IOC_GET_HEAT_INFO _IOWR(BTRFS_IOCTL_MAGIC, 21,	\
+				struct btrfs_ioctl_heat_info)
+#define BTRFS_IOC_SET_HEAT_OPTS _IOW(BTRFS_IOCTL_MAGIC, 22, int)
+#define BTRFS_IOC_GET_HEAT_OPTS _IOR(BTRFS_IOCTL_MAGIC, 23, int)
+
 #endif
-- 
1.7.1

