Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:48288 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbdIQWIL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 18:08:11 -0400
Received: by mail-io0-f174.google.com with SMTP id n69so14763927ioi.5
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 15:08:11 -0700 (PDT)
Date: Sun, 17 Sep 2017 22:08:09 +0000
From: Sargun Dhillon <sargun@sargun.me>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo.btrfs@gmx.com, dsterba@suse.cz
Subject: [PATCH v2 1/1] btrfs: Add mechanism to configure automatic level-0
 qgroup removal
Message-ID: <20170917220807.GA31521@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20170917220756.GA31512@ircssh-2.c.rugged-nimbus-611.internal>

This patch introduces a persisted sysfs knob - qgroup_autoremove.
The purpose of this knob is to cause btrfs (kernel) to automatically
remove level-0 qgroups on subvolume removal. It does not try to
traverse the qgroup tree, and delete other dangling qgroups.

The knob is  disabled by default to avoid breaking userspace.
Once the knob is enabled, it is persisted across remounts in
qgroup_flags.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
---
 fs/btrfs/ctree.h                |  2 +-
 fs/btrfs/ioctl.c                | 14 +++++++
 fs/btrfs/sysfs.c                | 91 ++++++++++++++++++++++++++++++++++++-----
 include/uapi/linux/btrfs_tree.h |  7 ++++
 4 files changed, 103 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9ded3e9154a5..65f8fa246a4d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1018,7 +1018,7 @@ struct btrfs_fs_info {
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	u32 check_integrity_print_mask;
 #endif
-	/* is qgroup tracking in a consistent state? */
+	/* qgroup configuration; is qgroup tracking in a consistent state? */
 	u64 qgroup_flags;
 
 	/* holds configuration and tracking. Protected by qgroup_lock */
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 94934901d58c..d7ef13720374 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2315,6 +2315,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	struct btrfs_ioctl_vol_args *vol_args;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_block_rsv block_rsv;
+	bool remove_qgroup = false;
 	u64 root_flags;
 	u64 qgroup_reserved;
 	int namelen;
@@ -2497,6 +2498,19 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		}
 	}
 
+
+	spin_lock(&fs_info->qgroup_lock);
+	if (fs_info->qgroup_flags & BTRFS_QGROUP_AUTOREMOVE_FLAG)
+		remove_qgroup = true;
+	spin_unlock(&fs_info->qgroup_lock);
+	if (remove_qgroup) {
+		ret = btrfs_remove_qgroup(trans, fs_info,
+					  dest->root_key.objectid);
+		if (ret && ret != -ENOENT)
+			btrfs_warn(fs_info,
+				   "Failed to cleanup qgroup. err: %d", ret);
+	}
+
 out_end_trans:
 	trans->block_rsv = NULL;
 	trans->bytes_reserved = 0;
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index c2d5f3580b4c..9604778038fd 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -90,6 +90,15 @@ static int can_modify_feature(struct btrfs_feature_attr *fa)
 	return val;
 }
 
+static void set_pending_commit(struct btrfs_fs_info *fs_info)
+{
+	/*
+	 * We don't want to do full transaction commit from inside sysfs
+	 */
+	btrfs_set_pending(fs_info, COMMIT);
+	wake_up_process(fs_info->transaction_kthread);
+}
+
 static ssize_t btrfs_feature_attr_show(struct kobject *kobj,
 				       struct kobj_attribute *a, char *buf)
 {
@@ -165,11 +174,7 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	set_features(fs_info, fa->feature_set, features);
 	spin_unlock(&fs_info->super_lock);
 
-	/*
-	 * We don't want to do full transaction commit from inside sysfs
-	 */
-	btrfs_set_pending(fs_info, COMMIT);
-	wake_up_process(fs_info->transaction_kthread);
+	set_pending_commit(fs_info);
 
 	return count;
 }
@@ -405,11 +410,7 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
 	memcpy(fs_info->super_copy->label, buf, p_len);
 	spin_unlock(&fs_info->super_lock);
 
-	/*
-	 * We don't want to do full transaction commit from inside sysfs
-	 */
-	btrfs_set_pending(fs_info, COMMIT);
-	wake_up_process(fs_info->transaction_kthread);
+	set_pending_commit(fs_info);
 
 	return len;
 }
@@ -487,12 +488,82 @@ static ssize_t quota_override_store(struct kobject *kobj,
 
 BTRFS_ATTR_RW(quota_override, quota_override_show, quota_override_store);
 
+static ssize_t qgroup_autoremove_show(struct kobject *kobj,
+				      struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	int qgroup_autoremove = 0;
+
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	/* Check if qgroups are enabled */
+	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
+		goto out;
+	if (!fs_info->quota_root)
+		goto out;
+
+	if (fs_info->qgroup_flags & BTRFS_QGROUP_AUTOREMOVE_FLAG)
+		qgroup_autoremove = 1;
+
+out:
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", qgroup_autoremove);
+}
+
+static ssize_t qgroup_autoremove_store(struct kobject *kobj,
+				       struct kobj_attribute *a,
+				       const char *buf, size_t len)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+	unsigned long knob;
+	int err;
+
+	if (!fs_info)
+		return -EPERM;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	err = kstrtoul(buf, 10, &knob);
+	if (err)
+		return err;
+	if (knob > 1)
+		return -EINVAL;
+
+	err = -EINVAL;
+
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
+	/* Check if qgroups are enabled */
+	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
+		goto error;
+	if (!fs_info->quota_root)
+		goto error;
+
+	spin_lock(&fs_info->qgroup_lock);
+	if (knob)
+		fs_info->qgroup_flags |= BTRFS_QGROUP_AUTOREMOVE_FLAG;
+	else
+		fs_info->qgroup_flags &= ~BTRFS_QGROUP_AUTOREMOVE_FLAG;
+	spin_unlock(&fs_info->qgroup_lock);
+
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	set_pending_commit(fs_info);
+
+	return len;
+
+error:
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	return err;
+}
+
+BTRFS_ATTR_RW(qgroup_autoremove, qgroup_autoremove_show, qgroup_autoremove_store);
+
 static const struct attribute *btrfs_attrs[] = {
 	BTRFS_ATTR_PTR(label),
 	BTRFS_ATTR_PTR(nodesize),
 	BTRFS_ATTR_PTR(sectorsize),
 	BTRFS_ATTR_PTR(clone_alignment),
 	BTRFS_ATTR_PTR(quota_override),
+	BTRFS_ATTR_PTR(qgroup_autoremove),
 	NULL,
 };
 
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 10689e1fdf11..ef17384ea498 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -924,6 +924,13 @@ static inline __u64 btrfs_qgroup_level(__u64 qgroupid)
  * Turning qouta off and on again makes it inconsistent, too.
  */
 #define BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT	(1ULL << 2)
+/*
+ * When the filesystem is mounted with this option enabled
+ * level-0 qgroups will be automatically removed when their
+ * associated subvolume is deleted. If mounted on on an older
+ * version of btrfs, it will be ignored.
+ */
+#define BTRFS_QGROUP_AUTOREMOVE_FLAG		(1ULL << 3)
 
 #define BTRFS_QGROUP_STATUS_VERSION        1
 
-- 
2.11.0

