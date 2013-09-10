Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab3IJEau (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 00:30:50 -0400
Message-Id: <20130910043007.611089647@suse.com>
Date: Tue, 10 Sep 2013 00:24:10 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clmason@fusionio.com, dsterba@suse.cz
Subject: [patch 2/7] btrfs: export supported featured to sysfs
References: <20130910042408.335071038@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds the ability to publish supported features to sysfs under
/sys/fs/btrfs/features.

The files are module-wide and export which features the kernel supports.

The content, for now, is just "0\n".

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/sysfs.c |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.h |   37 +++++++++++++++++++++
 2 files changed, 131 insertions(+)

--- a/fs/btrfs/sysfs.c	2013-09-10 00:07:58.567116997 -0400
+++ b/fs/btrfs/sysfs.c	2013-09-10 00:08:31.714646494 -0400
@@ -26,20 +26,114 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
+#include "sysfs.h"
 
 /* /sys/fs/btrfs/ entry */
 static struct kset *btrfs_kset;
 
+struct btrfs_features {
+	struct kobject f_kobj;
+	struct completion f_kobj_unregister;
+};
+
+struct btrfs_features *btrfs_feat;
+
+BTRFS_FEAT_ATTR_INCOMPAT(mixed_backref, MIXED_BACKREF);
+BTRFS_FEAT_ATTR_INCOMPAT(default_subvol, DEFAULT_SUBVOL);
+BTRFS_FEAT_ATTR_INCOMPAT(mixed_groups, MIXED_GROUPS);
+BTRFS_FEAT_ATTR_INCOMPAT(compress_lzo, COMPRESS_LZO);
+BTRFS_FEAT_ATTR_INCOMPAT(compress_lzov2, COMPRESS_LZOv2);
+BTRFS_FEAT_ATTR_INCOMPAT(big_metadata, BIG_METADATA);
+BTRFS_FEAT_ATTR_INCOMPAT(extended_iref, EXTENDED_IREF);
+BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
+BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
+
+static struct attribute *btrfs_supp_feature_attrs[] = {
+	BTRFS_SUPP_FEAT_LIST(mixed_backref)
+	BTRFS_SUPP_FEAT_LIST(default_subvol)
+	BTRFS_SUPP_FEAT_LIST(mixed_groups)
+	BTRFS_SUPP_FEAT_LIST(compress_lzo)
+	BTRFS_SUPP_FEAT_LIST(compress_lzov2)
+	BTRFS_SUPP_FEAT_LIST(big_metadata)
+	BTRFS_SUPP_FEAT_LIST(extended_iref)
+	BTRFS_SUPP_FEAT_LIST(raid56)
+	BTRFS_SUPP_FEAT_LIST(skinny_metadata)
+	NULL
+};
+
+static void btrfs_supp_feat_release(struct kobject *kobj)
+{
+	complete(&btrfs_feat->f_kobj_unregister);
+}
+
+static ssize_t btrfs_supp_attr_show(struct kobject *kobj, struct attribute *a,
+				    char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0\n");
+}
+
+static const struct sysfs_ops btrfs_supp_attr_ops = {
+	.show = btrfs_supp_attr_show,
+};
+
+static struct kobj_type btrfs_supp_feat_ktype = {
+	.default_attrs	= btrfs_supp_feature_attrs,
+	.sysfs_ops	= &btrfs_supp_attr_ops,
+	.release	= btrfs_supp_feat_release,
+};
+
+static int __init btrfs_init_feat_adverts(void)
+{
+	struct btrfs_features *bf;
+	int ret = -ENOMEM;
+
+	bf = kzalloc(sizeof(struct btrfs_features), GFP_KERNEL);
+	if (!bf)
+		goto out;
+
+	bf->f_kobj.kset = btrfs_kset;
+	init_completion(&bf->f_kobj_unregister);
+
+	ret = kobject_init_and_add(&bf->f_kobj, &btrfs_supp_feat_ktype, NULL,
+				   "features");
+	if (ret) {
+		kfree(bf);
+		goto out;
+	}
+
+	btrfs_feat = bf;
+	ret = 0;
+out:
+	return ret;
+}
+
+static void btrfs_exit_feat_adverts(void)
+{
+	kobject_del(&btrfs_feat->f_kobj);
+	kobject_put(&btrfs_feat->f_kobj);
+	wait_for_completion(&btrfs_feat->f_kobj_unregister);
+	kfree(btrfs_feat);
+}
+
 int btrfs_init_sysfs(void)
 {
+	int ret;
 	btrfs_kset = kset_create_and_add("btrfs", NULL, fs_kobj);
 	if (!btrfs_kset)
 		return -ENOMEM;
+
+	ret = btrfs_init_feat_adverts();
+	if (ret) {
+		kset_unregister(btrfs_kset);
+		return ret;
+	}
+
 	return 0;
 }
 
 void btrfs_exit_sysfs(void)
 {
+	btrfs_exit_feat_adverts();
 	kset_unregister(btrfs_kset);
 }
 
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/fs/btrfs/sysfs.h	2013-09-10 00:09:00.778250180 -0400
@@ -0,0 +1,37 @@
+#ifndef _BTRFS_SYSFS_H_
+#define _BTRFS_SYSFS_H_
+
+enum btrfs_feature_set {
+	FEAT_COMPAT,
+	FEAT_COMPAT_RO,
+	FEAT_INCOMPAT,
+	FEAT_MAX
+};
+
+struct btrfs_feature_attr {
+	struct attribute attr;			/* global show, no store */
+	enum btrfs_feature_set feature_set;
+	u64 feature_bit;
+};
+
+#define BTRFS_FEAT_ATTR(_name, _feature_set, _prefix, _feature_bit)	     \
+static struct btrfs_feature_attr btrfs_attr_##_name = {			     \
+	.attr		= { .name = __stringify(_name), .mode = S_IRUGO, },  \
+	.feature_set	= _feature_set,					     \
+	.feature_bit	= _prefix ##_## _feature_bit,			     \
+}
+
+#define BTRFS_FEAT_ATTR_COMPAT(name, feature) \
+	BTRFS_FEAT_ATTR(name, FEAT_COMPAT, BTRFS_FEATURE_COMPAT, feature)
+#define BTRFS_FEAT_ATTR_COMPAT_RO(name, feature) \
+	BTRFS_FEAT_ATTR(name, FEAT_COMPAT_RO, BTRFS_FEATURE_COMPAT, feature)
+#define BTRFS_FEAT_ATTR_INCOMPAT(name, feature) \
+	BTRFS_FEAT_ATTR(name, FEAT_INCOMPAT, BTRFS_FEATURE_INCOMPAT, feature)
+
+#define BTRFS_SUPP_FEAT_LIST(_name)    (&btrfs_attr_##_name.attr),
+
+/* convert from attribute */
+#define to_btrfs_feature_attr(a) \
+			container_of(a, struct btrfs_feature_attr, attr)
+
+#endif /* _BTRFS_SYSFS_H_ */


