Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3KUPip (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 10:38:45 -0500
Message-ID: <528E28AC.9000306@suse.com>
Date: Thu, 21 Nov 2013 10:37:16 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@gmail.com>
Cc: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH v2] btrfs: fix leaks during sysfs teardown
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filipe noticed that we were leaking the features attribute group
after umount. His fix of just calling sysfs_remove_group() wasn't enough
since that removes just the supported features and not the unsupported
features.

This patch changes the unknown feature handling to add them individually
so we can skip the kmalloc and uses the same iteration to tear them down
later.

We also fix the error handling during mount so that we catch the
failing creation of the per-super kobject, and handle proper teardown
of a half-setup sysfs context.

Tested properly with kmemleak enabled this time.

Reported-by: Filipe David Borba Manana <fdmanana@gmail.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/sysfs.c |  133 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 73 insertions(+), 60 deletions(-)

--- a/fs/btrfs/sysfs.c	2013-11-21 09:31:53.764350456 -0500
+++ b/fs/btrfs/sysfs.c	2013-11-21 10:29:48.199104683 -0500
@@ -417,28 +417,84 @@ static inline struct btrfs_fs_info *to_f
 	return container_of(kobj, struct btrfs_fs_info, super_kobj);
 }
 
-void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
+#define NUM_FEATURE_BITS 64
+static char btrfs_unknown_feature_names[3][NUM_FEATURE_BITS][13];
+static struct btrfs_feature_attr btrfs_feature_attrs[3][NUM_FEATURE_BITS];
+
+static u64 supported_feature_masks[3] = {
+	[FEAT_COMPAT]    = BTRFS_FEATURE_COMPAT_SUPP,
+	[FEAT_COMPAT_RO] = BTRFS_FEATURE_COMPAT_RO_SUPP,
+	[FEAT_INCOMPAT]  = BTRFS_FEATURE_INCOMPAT_SUPP,
+};
+
+static int addrm_unknown_feature_attrs(struct btrfs_fs_info *fs_info, bool add)
+{
+	int set;
+
+	for (set = 0; set < FEAT_MAX; set++) {
+		int i;
+		struct attribute *attrs[2];
+		struct attribute_group agroup = {
+			.name = "features",
+			.attrs = attrs,
+		};
+		u64 features = get_features(fs_info, set);
+		features &= ~supported_feature_masks[set];
+
+		if (!features)
+			continue;
+
+		attrs[1] = NULL;
+		for (i = 0; i < NUM_FEATURE_BITS; i++) {
+			struct btrfs_feature_attr *fa;
+
+			if (!(features & (1ULL << i)))
+				continue;
+
+			fa = &btrfs_feature_attrs[set][i];
+			attrs[0] = &fa->kobj_attr.attr;
+			if (add) {
+				int ret;
+				ret = sysfs_merge_group(&fs_info->super_kobj,
+							&agroup);
+				if (ret)
+					return ret;
+			} else
+				sysfs_unmerge_group(&fs_info->super_kobj,
+						    &agroup);
+		}
+
+	}
+	return 0;
+}
+
+static void __btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
 {
-	sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
-	kobject_del(fs_info->device_dir_kobj);
-	kobject_put(fs_info->device_dir_kobj);
-	kobject_del(fs_info->space_info_kobj);
-	kobject_put(fs_info->space_info_kobj);
 	kobject_del(&fs_info->super_kobj);
 	kobject_put(&fs_info->super_kobj);
 	wait_for_completion(&fs_info->kobj_unregister);
 }
 
+void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
+{
+	if (fs_info->space_info_kobj) {
+		sysfs_remove_files(fs_info->space_info_kobj, allocation_attrs);
+		kobject_del(fs_info->space_info_kobj);
+		kobject_put(fs_info->space_info_kobj);
+	}
+	kobject_del(fs_info->device_dir_kobj);
+	kobject_put(fs_info->device_dir_kobj);
+	addrm_unknown_feature_attrs(fs_info, false);
+	sysfs_remove_group(&fs_info->super_kobj, &btrfs_feature_attr_group);
+	__btrfs_sysfs_remove_one(fs_info);
+}
+
 const char * const btrfs_feature_set_names[3] = {
 	[FEAT_COMPAT]	 = "compat",
 	[FEAT_COMPAT_RO] = "compat_ro",
 	[FEAT_INCOMPAT]	 = "incompat",
 };
 
-#define NUM_FEATURE_BITS 64
-static char btrfs_unknown_feature_names[3][NUM_FEATURE_BITS][13];
-static struct btrfs_feature_attr btrfs_feature_attrs[3][NUM_FEATURE_BITS];
-
 char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags)
 {
 	size_t bufsize = 4096; /* safe max, 64 names * 64 bytes */
@@ -508,53 +564,6 @@ static void init_feature_attrs(void)
 	}
 }
 
-static u64 supported_feature_masks[3] = {
-	[FEAT_COMPAT]    = BTRFS_FEATURE_COMPAT_SUPP,
-	[FEAT_COMPAT_RO] = BTRFS_FEATURE_COMPAT_RO_SUPP,
-	[FEAT_INCOMPAT]  = BTRFS_FEATURE_INCOMPAT_SUPP,
-};
-
-static int add_unknown_feature_attrs(struct btrfs_fs_info *fs_info)
-{
-	int set;
-
-	for (set = 0; set < FEAT_MAX; set++) {
-		int i, count, ret, index = 0;
-		struct attribute **attrs;
-		struct attribute_group agroup = {
-			.name = "features",
-		};
-		u64 features = get_features(fs_info, set);
-		features &= ~supported_feature_masks[set];
-
-		count = hweight64(features);
-
-		if (!count)
-			continue;
-
-		attrs = kcalloc(count + 1, sizeof(void *), GFP_KERNEL);
-
-		for (i = 0; i < NUM_FEATURE_BITS; i++) {
-			struct btrfs_feature_attr *fa;
-
-			if (!(features & (1ULL << i)))
-				continue;
-
-			fa = &btrfs_feature_attrs[set][i];
-			attrs[index++] = &fa->kobj_attr.attr;
-		}
-
-		attrs[index] = NULL;
-		agroup.attrs = attrs;
-
-		ret = sysfs_merge_group(&fs_info->super_kobj, &agroup);
-		kfree(attrs);
-		if (ret)
-			return ret;
-	}
-	return 0;
-}
-
 static int add_device_membership(struct btrfs_fs_info *fs_info)
 {
 	int error = 0;
@@ -590,13 +599,17 @@ int btrfs_sysfs_add_one(struct btrfs_fs_
 	fs_info->super_kobj.kset = btrfs_kset;
 	error = kobject_init_and_add(&fs_info->super_kobj, &btrfs_ktype, NULL,
 				     "%pU", fs_info->fsid);
+	if (error)
+		return error;
 
 	error = sysfs_create_group(&fs_info->super_kobj,
 				   &btrfs_feature_attr_group);
-	if (error)
-		goto failure;
+	if (error) {
+		__btrfs_sysfs_remove_one(fs_info);
+		return error;
+	}
 
-	error = add_unknown_feature_attrs(fs_info);
+	error = addrm_unknown_feature_attrs(fs_info, true);
 	if (error)
 		goto failure;
 

-- 
Jeff Mahoney
SUSE Labs
