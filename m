Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab3IJEat (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 00:30:49 -0400
Message-Id: <20130910043008.302249211@suse.com>
Date: Tue, 10 Sep 2013 00:24:14 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clmason@fusionio.com, dsterba@suse.cz
Subject: [patch 6/7] btrfs: Add ability to change features via sysfs
References: <20130910042408.335071038@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds the ability to change (set/clear) features while the file
system is mounted. A bitmask is added for each feature set for the
support to set and clear the bits. A message indicating which bit
has been set or cleared is issued when it's been changed and also when
permission or support for a particular bit has been denied.

Since the the attributes can now be writable, we need to introduce
another struct attribute to hold the different permissions.

If neither set or clear is supported, the file will have 0444 permissions.
If either set or clear is supported, the file will have 0644 permissions
and the store handler will filter out the write based on the bitmask.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/sysfs.c |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 104 insertions(+), 1 deletion(-)

--- a/fs/btrfs/sysfs.c	2013-09-10 00:10:13.909312817 -0400
+++ b/fs/btrfs/sysfs.c	2013-09-10 00:12:30.447761188 -0400
@@ -84,6 +84,23 @@ static void init_feature_set_attrs(enum
 	}
 }
 
+static u64 writeable_mask[FEAT_MAX] = {
+	[FEAT_COMPAT] = BTRFS_FEATURE_COMPAT_SAFE_SET |
+			  BTRFS_FEATURE_COMPAT_SAFE_CLEAR,
+	[FEAT_COMPAT_RO] = BTRFS_FEATURE_COMPAT_RO_SAFE_SET |
+			  BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR,
+	[FEAT_INCOMPAT] = BTRFS_FEATURE_INCOMPAT_SAFE_SET |
+			  BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR,
+};
+
+static inline umode_t fa_mode(struct btrfs_feature_attr *fa)
+{
+	umode_t mode = S_IRUGO;
+	if (writeable_mask[fa->feature_set] & fa->feature_bit)
+		mode |= S_IWUSR;
+	return mode;
+}
+
 static void init_feature_attrs(void)
 {
 	int i;
@@ -103,6 +120,7 @@ static void init_feature_attrs(void)
 
 		attr = &btrfs_feature_attrs[fa->feature_set][n].attr;
 		attr->name = fa->attr.name;
+		attr->mode = fa_mode(fa);
 
 		btrfs_feature_names[fa->feature_set][n][0] = '\0';
 	}
@@ -136,8 +154,92 @@ static ssize_t btrfs_feat_show(struct ko
 	return snprintf(buf, PAGE_SIZE, "%u\n", !!(features & fa->feature_bit));
 }
 
+static ssize_t btrfs_feat_store(struct kobject *kobj, struct attribute *attr,
+				const char *buf, size_t count)
+{
+	struct btrfs_fs_info *fs_info;
+	struct btrfs_super_block *disk_super;
+	struct btrfs_feature_attr *fa = to_btrfs_feature_attr(attr);
+	struct btrfs_trans_handle *trans;
+	u64 features, set, clear;
+	unsigned long val;
+	int ret;
+
+	fs_info = container_of(kobj, struct btrfs_fs_info, features.f_kobj);
+	disk_super = fs_info->super_copy;
+	ret = kstrtoul(skip_spaces(buf), 0, &val);
+	if (ret)
+		return ret;
+
+	if (fa->feature_set == FEAT_COMPAT) {
+		set = BTRFS_FEATURE_COMPAT_SAFE_SET;
+		clear = BTRFS_FEATURE_COMPAT_SAFE_CLEAR;
+	} else if (fa->feature_set == FEAT_COMPAT_RO) {
+		set = BTRFS_FEATURE_COMPAT_RO_SAFE_SET;
+		clear = BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR;
+	} else {
+		set = BTRFS_FEATURE_INCOMPAT_SAFE_SET;
+		clear = BTRFS_FEATURE_INCOMPAT_SAFE_CLEAR;
+	}
+
+	if (fa->feature_set == FEAT_COMPAT)
+		features = btrfs_super_compat_flags(disk_super);
+	else if (fa->feature_set == FEAT_COMPAT_RO)
+		features = btrfs_super_compat_ro_flags(disk_super);
+	else
+		features = btrfs_super_incompat_flags(disk_super);
+
+	/* Nothing to do */
+	if ((val && (features & fa->feature_bit)) ||
+	    (!val && !(features & fa->feature_bit)))
+		return count;
+
+	if ((val && !(set & fa->feature_bit)) ||
+	    (!val && !(clear & fa->feature_bit))) {
+		btrfs_info(fs_info,
+			"%sabling feature %s on mounted fs is not supported.",
+			val ? "En" : "Dis", fa->attr.name);
+		return -EPERM;
+	}
+
+	btrfs_info(fs_info, "%s %s feature flag",
+		   val ? "Setting" : "Clearing", fa->attr.name);
+
+	trans = btrfs_start_transaction(fs_info->fs_root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	spin_lock(&fs_info->super_lock);
+	if (fa->feature_set == FEAT_COMPAT)
+		features = btrfs_super_compat_flags(disk_super);
+	else if (fa->feature_set == FEAT_COMPAT_RO)
+		features = btrfs_super_compat_ro_flags(disk_super);
+	else
+		features = btrfs_super_incompat_flags(disk_super);
+
+	if (val)
+		features |= fa->feature_bit;
+	else
+		features &= ~fa->feature_bit;
+
+	if (fa->feature_set == FEAT_COMPAT)
+		btrfs_set_super_compat_flags(disk_super, features);
+	else if (fa->feature_set == FEAT_COMPAT_RO)
+		btrfs_set_super_compat_ro_flags(disk_super, features);
+	else
+		btrfs_set_super_incompat_flags(disk_super, features);
+	spin_unlock(&fs_info->super_lock);
+
+	ret = btrfs_end_transaction(trans, fs_info->fs_root);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
 static const struct sysfs_ops btrfs_feat_attr_ops = {
 	.show	= btrfs_feat_show,
+	.store	= btrfs_feat_store,
 };
 
 static struct kobj_type btrfs_feat_ktype = {
@@ -209,7 +311,8 @@ static int add_per_fs_feature_set(struct
 		u64 features = get_features(fs_info, fa->feature_set);
 		int error;
 
-		if (features & fa->feature_bit) {
+		if ((features & fa->feature_bit) ||
+		    (fa->attr.mode & S_IWUSR)) {
 			error = sysfs_create_file(&fs_info->features.f_kobj,
 						  &fa->attr);
 			if (error)


