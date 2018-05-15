Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:64844 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbeEOHd0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 03:33:26 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id D3B93AC0174
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 16:33:20 +0900 (JST)
Received: from G01JPEXCHYT18.g01.fujitsu.local (G01JPEXCHYT18.g01.fujitsu.local [10.128.194.57])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 00AA15842F8
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 16:33:20 +0900 (JST)
Subject: [PATCH 2/2] btrfs: sysfs: Add entry which shows rmdir(2) can work for
 subvolume
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a8c4cc11-99f4-2390-b489-340bdc941464@jp.fujitsu.com>
Message-ID: <428b7ee1-bc44-2f2d-1117-6a031759039a@jp.fujitsu.com>
Date: Tue, 15 May 2018 16:33:12 +0900
MIME-Version: 1.0
In-Reply-To: <a8c4cc11-99f4-2390-b489-340bdc941464@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Deletion of a subvolume by rmdir(2) has become allowed by the
'commit cd2decf640b1 ("btrfs: Allow rmdir(2) to delete an empty
subvolume")'.

It is a kind of new feature and this commits add new sysfs entry
  /sys/fs/btrfs/features/rmdir_subvol
to indicate the feature.

Since the behavior is independent of feature bits of superblock,
new type FEAT_KERNEL is added to struct btrfs_feature_set.
Features of FEAT_KERNEL is supposed to be visible only in /sys/fs/features
and not in /sys/fs/UUID/features.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/ctree.h           |  6 ++++++
 fs/btrfs/sysfs.c           | 36 +++++++++++++++++++++++++++---------
 fs/btrfs/sysfs.h           |  5 ++++-
 include/uapi/linux/btrfs.h |  2 ++
 4 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 954bfb5054b1..c98355a468a9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -271,6 +271,12 @@ struct btrfs_super_block {
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
 #define BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR		0ULL
 
+#define BTRFS_FEATURE_KERNEL_SUPP			\
+	BTRFS_FEATURE_KERNEL_RMDIR_SUBVOL
+
+#define BTRFS_FEATURE_KERNEL_SAFE_SET			0ULL
+#define BTRFS_FEATURE_KERNEL_SAFE_CLEAR			0ULL
+
 /*
  * A leaf is full of items. offset and size tell us where to find
  * the item in the leaf (relative to the start of the data area)
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 217d401fe8ae..ce6ba6b204c3 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -30,20 +30,24 @@ static u64 get_features(struct btrfs_fs_info *fs_info,
 		return btrfs_super_compat_flags(disk_super);
 	else if (set == FEAT_COMPAT_RO)
 		return btrfs_super_compat_ro_flags(disk_super);
-	else
+	else if (set == FEAT_INCOMPAT)
 		return btrfs_super_incompat_flags(disk_super);
+	else
+		return BTRFS_FEATURE_KERNEL_SUPP;
 }
 
 static void set_features(struct btrfs_fs_info *fs_info,
 			 enum btrfs_feature_set set, u64 features)
 {
 	struct btrfs_super_block *disk_super = fs_info->super_copy;
+
 	if (set == FEAT_COMPAT)
 		btrfs_set_super_compat_flags(disk_super, features);
 	else if (set == FEAT_COMPAT_RO)
 		btrfs_set_super_compat_ro_flags(disk_super, features);
-	else
+	else if (set == FEAT_INCOMPAT)
 		btrfs_set_super_incompat_flags(disk_super, features);
+	/* Nothing for FEAT_KERNEL for now */
 }
 
 static int can_modify_feature(struct btrfs_feature_attr *fa)
@@ -63,6 +67,10 @@ static int can_modify_feature(struct btrfs_feature_attr *fa)
 		set = BTRFS_FEATURE_INCOMPAT_SAFE_SET;
 		clear = BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
 		break;
+	case FEAT_KERNEL:
+		set = BTRFS_FEATURE_KERNEL_SAFE_SET;
+		clear = BTRFS_FEATURE_KERNEL_SAFE_CLEAR;
+		break;
 	default:
 		pr_warn("btrfs: sysfs: unknown feature set %d\n",
 				fa->feature_set);
@@ -110,6 +118,10 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
 	if (sb_rdonly(fs_info->sb))
 		return -EROFS;
 
+	/* FEAT_KERNEL features cannot be changed at runtime */
+	if (fa->feature_set == FEAT_KERNEL)
+		return -EINVAL;
+
 	ret = kstrtoul(skip_spaces(buf), 0, &val);
 	if (ret)
 		return ret;
@@ -174,7 +186,10 @@ static umode_t btrfs_feature_visible(struct kobject *kobj,
 		fa = attr_to_btrfs_feature_attr(attr);
 		features = get_features(fs_info, fa->feature_set);
 
-		if (can_modify_feature(fa))
+		/* Do not show FEAT_KERNEL features in /sys/fs/UUID/features */
+		if (fa->feature_set == FEAT_KERNEL)
+			mode = 0;
+		else if (can_modify_feature(fa))
 			mode |= S_IWUSR;
 		else if (!(features & fa->feature_bit))
 			mode = 0;
@@ -194,6 +209,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
 BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
+BTRFS_FEAT_ATTR_KERNEL(rmdir_subvol, RMDIR_SUBVOL);
 
 static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(mixed_backref),
@@ -207,6 +223,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(skinny_metadata),
 	BTRFS_FEAT_ATTR_PTR(no_holes),
 	BTRFS_FEAT_ATTR_PTR(free_space_tree),
+	BTRFS_FEAT_ATTR_PTR(rmdir_subvol),
 	NULL
 };
 
@@ -515,10 +532,11 @@ static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj)
 
 #define NUM_FEATURE_BITS 64
 #define BTRFS_FEATURE_NAME_MAX 13
-static char btrfs_unknown_feature_names[FEAT_MAX][NUM_FEATURE_BITS][BTRFS_FEATURE_NAME_MAX];
-static struct btrfs_feature_attr btrfs_feature_attrs[FEAT_MAX][NUM_FEATURE_BITS];
+/* These are for features related to feature bit and FEAT_KERNEL is excluded */
+static char btrfs_unknown_feature_names[FEAT_MAX-1][NUM_FEATURE_BITS][BTRFS_FEATURE_NAME_MAX];
+static struct btrfs_feature_attr btrfs_feature_attrs[FEAT_MAX-1][NUM_FEATURE_BITS];
 
-static const u64 supported_feature_masks[FEAT_MAX] = {
+static const u64 supported_feature_masks[FEAT_MAX-1] = {
 	[FEAT_COMPAT]    = BTRFS_FEATURE_COMPAT_SUPP,
 	[FEAT_COMPAT_RO] = BTRFS_FEATURE_COMPAT_RO_SUPP,
 	[FEAT_INCOMPAT]  = BTRFS_FEATURE_INCOMPAT_SUPP,
@@ -528,7 +546,7 @@ static int addrm_unknown_feature_attrs(struct btrfs_fs_info *fs_info, bool add)
 {
 	int set;
 
-	for (set = 0; set < FEAT_MAX; set++) {
+	for (set = 0; set < FEAT_MAX-1; set++) {
 		int i;
 		struct attribute *attrs[2];
 		struct attribute_group agroup = {
@@ -610,7 +628,7 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, NULL);
 }
 
-const char * const btrfs_feature_set_names[FEAT_MAX] = {
+const char * const btrfs_feature_set_names[FEAT_MAX-1] = {
 	[FEAT_COMPAT]	 = "compat",
 	[FEAT_COMPAT_RO] = "compat_ro",
 	[FEAT_INCOMPAT]	 = "incompat",
@@ -666,7 +684,7 @@ static void init_feature_attrs(void)
 		fa->kobj_attr.attr.name = sfa->kobj_attr.attr.name;
 	}
 
-	for (set = 0; set < FEAT_MAX; set++) {
+	for (set = 0; set < FEAT_MAX-1; set++) {
 		for (i = 0; i < ARRAY_SIZE(btrfs_feature_attrs[set]); i++) {
 			char *name = btrfs_unknown_feature_names[set][i];
 			fa = &btrfs_feature_attrs[set][i];
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 40716b357c1d..e8547a46ce13 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -12,6 +12,7 @@ enum btrfs_feature_set {
 	FEAT_COMPAT,
 	FEAT_COMPAT_RO,
 	FEAT_INCOMPAT,
+	FEAT_KERNEL, /* Kernel feature indepenedent of feature bits */
 	FEAT_MAX
 };
 
@@ -57,6 +58,8 @@ static struct btrfs_feature_attr btrfs_attr_features_##_name = {	     \
 	BTRFS_FEAT_ATTR(name, FEAT_COMPAT_RO, BTRFS_FEATURE_COMPAT_RO, feature)
 #define BTRFS_FEAT_ATTR_INCOMPAT(name, feature) \
 	BTRFS_FEAT_ATTR(name, FEAT_INCOMPAT, BTRFS_FEATURE_INCOMPAT, feature)
+#define BTRFS_FEAT_ATTR_KERNEL(name, feature) \
+	BTRFS_FEAT_ATTR(name, FEAT_KERNEL, BTRFS_FEATURE_KERNEL, feature)
 
 /* convert from attribute */
 static inline struct btrfs_feature_attr *
@@ -77,7 +80,7 @@ attr_to_btrfs_feature_attr(struct attribute *attr)
 }
 
 char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
-extern const char * const btrfs_feature_set_names[FEAT_MAX];
+extern const char * const btrfs_feature_set_names[FEAT_MAX-1];
 extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
 int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index c8d99b9ca550..631061f42745 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -270,6 +270,8 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
 
+#define BTRFS_FEATURE_KERNEL_RMDIR_SUBVOL	(1ULL << 0)
+
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
 	__u64 compat_ro_flags;
-- 
2.14.3

