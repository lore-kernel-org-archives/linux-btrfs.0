Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab3IJEat (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 00:30:49 -0400
Message-Id: <20130910043007.956617343@suse.com>
Date: Tue, 10 Sep 2013 00:24:12 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clmason@fusionio.com, dsterba@suse.cz
Subject: [patch 4/7] btrfs: publish per-super features to sysfs
References: <20130910042408.335071038@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch publishes information on which features are enabled in the
file system on a per-super basis. At this point, it only publishes
information on features supported by the file system implementation.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h |    6 +++
 fs/btrfs/sysfs.c |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/sysfs.h |    2 -
 3 files changed, 110 insertions(+), 8 deletions(-)

--- a/fs/btrfs/ctree.h	2013-09-09 21:33:17.560730541 -0400
+++ b/fs/btrfs/ctree.h	2013-09-09 21:34:19.067859674 -0400
@@ -1295,6 +1295,11 @@ struct btrfs_stripe_hash_table {
 
 #define BTRFS_STRIPE_HASH_TABLE_BITS 11
 
+struct btrfs_features {
+	struct kobject f_kobj;
+	struct completion f_kobj_unregister;
+};
+
 /* fs_info */
 struct reloc_control;
 struct btrfs_device;
@@ -1513,6 +1518,7 @@ struct btrfs_fs_info {
 
 	struct kobject super_kobj;
 	struct completion kobj_unregister;
+	struct btrfs_features features;
 	int do_barriers;
 	int closing;
 	int log_root_recovering;
--- a/fs/btrfs/sysfs.c	2013-09-09 21:33:17.560730541 -0400
+++ b/fs/btrfs/sysfs.c	2013-09-09 23:03:36.030266481 -0400
@@ -31,11 +31,6 @@
 /* /sys/fs/btrfs/ entry */
 static struct kset *btrfs_kset;
 
-struct btrfs_features {
-	struct kobject f_kobj;
-	struct completion f_kobj_unregister;
-};
-
 struct btrfs_features *btrfs_feat;
 
 BTRFS_FEAT_ATTR_INCOMPAT(mixed_backref, MIXED_BACKREF);
@@ -61,6 +56,43 @@ static struct attribute *btrfs_supp_feat
 	NULL
 };
 
+static void btrfs_feature_release(struct kobject *kobj)
+{
+	struct btrfs_features *feat;
+	feat = container_of(kobj, struct btrfs_features, f_kobj);
+	complete(&feat->f_kobj_unregister);
+}
+
+static ssize_t btrfs_feat_show(struct kobject *kobj, struct attribute *attr,
+			       char *buf)
+{
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_super_block *disk_super;
+	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(attr);
+	u64 features;
+
+	fs_info = container_of(kobj, struct btrfs_fs_info, features.f_kobj);
+	disk_super = fs_info->super_copy;
+
+	if (fa->feature_set == FEAT_COMPAT)
+		features = btrfs_super_compat_flags(disk_super);
+	else if (fa->feature_set == FEAT_COMPAT_RO)
+		features = btrfs_super_compat_ro_flags(disk_super);
+	else
+		features = btrfs_super_incompat_flags(disk_super);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", !!(features & fa->feature_bit));
+}
+
+static const struct sysfs_ops btrfs_feat_attr_ops = {
+	.show	= btrfs_feat_show,
+};
+
+static struct kobj_type btrfs_feat_ktype = {
+	.sysfs_ops	= &btrfs_feat_attr_ops,
+	.release	= btrfs_feature_release,
+};
+
 static struct attribute *btrfs_attrs[] = {
 	NULL,
 };
@@ -104,16 +136,80 @@ static struct kobj_type btrfs_ktype = {
 	.release	= btrfs_fs_info_release,
 };
 
+static u64 get_features(struct btrfs_fs_info *fs_info,
+			enum btrfs_feature_set set)
+{
+	struct btrfs_super_block *disk_super = fs_info->super_copy;
+	if (set == FEAT_COMPAT)
+		return btrfs_super_compat_flags(disk_super);
+	else if (set == FEAT_COMPAT_RO)
+		return btrfs_super_compat_ro_flags(disk_super);
+	else
+		return btrfs_super_incompat_flags(disk_super);
+}
+
+static int add_per_fs_features(struct btrfs_fs_info *fs_info)
+{
+	int i;
+	for (i = 0; btrfs_supp_feature_attrs[i]; i++) {
+		struct attribute *attr = btrfs_supp_feature_attrs[i];
+		struct btrfs_feature_attr *fa = to_btrfs_feature_attr(attr);
+		u64 features = get_features(fs_info, fa->feature_set);
+		int error;
+
+		if (features & fa->feature_bit) {
+			error = sysfs_create_file(&fs_info->features.f_kobj,
+						  &fa->attr);
+			if (error)
+				return error;
+		}
+	}
+	return 0;
+}
+
 int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
 {
+	int error;
+
 	init_completion(&fs_info->kobj_unregister);
 	fs_info->super_kobj.kset = btrfs_kset;
-	return kobject_init_and_add(&fs_info->super_kobj, &btrfs_ktype, NULL,
-				    "%pU", fs_info->fsid);
+	error = kobject_init_and_add(&fs_info->super_kobj, &btrfs_ktype, NULL,
+				     "%pU", fs_info->fsid);
+	if (error)
+		return error;
+
+	init_completion(&fs_info->features.f_kobj_unregister);
+	error = kobject_init_and_add(&fs_info->features.f_kobj,
+				     &btrfs_feat_ktype,
+				     &fs_info->super_kobj,
+				     "features");
+	if (error)
+		goto out_super;
+
+	error = add_per_fs_features(fs_info);
+	if (error)
+		goto out_features;
+
+	return 0;
+
+out_features:
+	kobject_del(&fs_info->features.f_kobj);
+	kobject_put(&fs_info->features.f_kobj);
+	wait_for_completion(&fs_info->features.f_kobj_unregister);
+out_super:
+	kobject_del(&fs_info->super_kobj);
+	kobject_put(&fs_info->super_kobj);
+	wait_for_completion(&fs_info->kobj_unregister);
+
+	return error;
 }
 
 void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 {
+	kobject_del(&fs_info->features.f_kobj);
+	kobject_put(&fs_info->features.f_kobj);
+	wait_for_completion(&fs_info->features.f_kobj_unregister);
+
 	kobject_del(&fs_info->super_kobj);
 	kobject_put(&fs_info->super_kobj);
 	wait_for_completion(&fs_info->kobj_unregister);
--- a/fs/btrfs/sysfs.h	2013-09-09 21:33:17.560730541 -0400
+++ b/fs/btrfs/sysfs.h	2013-09-09 22:48:51.634164572 -0400
@@ -27,7 +27,7 @@ static struct btrfs_attr btrfs_attr_##_n
 			__INIT_BTRFS_ATTR(_name, _mode, _show, _store)
 
 struct btrfs_feature_attr {
-	struct attribute attr;			/* global show, no store */
+	struct attribute attr;		/* per-fs/global show, no store */
 	enum btrfs_feature_set feature_set;
 	u64 feature_bit;
 };


