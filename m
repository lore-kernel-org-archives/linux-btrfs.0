Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47366 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab3IJEat (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Sep 2013 00:30:49 -0400
Message-Id: <20130910043007.783624453@suse.com>
Date: Tue, 10 Sep 2013 00:24:11 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clmason@fusionio.com, dsterba@suse.cz
Subject: [patch 3/7] btrfs: Add per-super attributes to sysfs
References: <20130910042408.335071038@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds per-super attributes to sysfs.

It doesn't publish any attributes yet, but does the proper lifetime
handling as well as the basic infrastructure to add new attributes.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h |    2 +
 fs/btrfs/super.c |   13 +++++++++++-
 fs/btrfs/sysfs.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.h |   19 ++++++++++++++++++
 4 files changed, 91 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ctree.h	2013-09-10 00:09:12.990087784 -0400
+++ b/fs/btrfs/ctree.h	2013-09-10 00:09:35.521794520 -0400
@@ -3694,6 +3694,8 @@ int btrfs_defrag_leaves(struct btrfs_tra
 /* sysfs.c */
 int btrfs_init_sysfs(void);
 void btrfs_exit_sysfs(void);
+int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info);
+void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info);
 
 /* xattr.c */
 ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
--- a/fs/btrfs/super.c	2013-09-10 00:09:12.994087730 -0400
+++ b/fs/btrfs/super.c	2013-09-10 00:09:35.525794464 -0400
@@ -301,6 +301,8 @@ void __btrfs_panic(struct btrfs_fs_info
 
 static void btrfs_put_super(struct super_block *sb)
 {
+	btrfs_sysfs_remove_one(btrfs_sb(sb));
+
 	(void)close_ctree(btrfs_sb(sb)->tree_root);
 	/* FIXME: need to fix VFS to return error? */
 	/* AV: return it _where_?  ->put_super() can be triggered by any number
@@ -1143,8 +1145,17 @@ static struct dentry *btrfs_mount(struct
 	}
 
 	root = !error ? get_default_root(s, subvol_objectid) : ERR_PTR(error);
-	if (IS_ERR(root))
+	if (IS_ERR(root)) {
 		deactivate_locked_super(s);
+		return root;
+	}
+
+	error = btrfs_sysfs_add_one(fs_info);
+	if (error) {
+		dput(root);
+		deactivate_locked_super(s);
+		return ERR_PTR(error);
+	}
 
 	return root;
 
--- a/fs/btrfs/sysfs.c	2013-09-10 00:09:13.002087628 -0400
+++ b/fs/btrfs/sysfs.c	2013-09-10 00:09:49.501616538 -0400
@@ -61,6 +61,64 @@ static struct attribute *btrfs_supp_feat
 	NULL
 };
 
+static struct attribute *btrfs_attrs[] = {
+	NULL,
+};
+
+static void btrfs_fs_info_release(struct kobject *kobj)
+{
+	struct btrfs_fs_info *fs_info;
+	fs_info = container_of(kobj, struct btrfs_fs_info, super_kobj);
+	complete(&fs_info->kobj_unregister);
+}
+
+static ssize_t btrfs_attr_show(struct kobject *kobj,
+			       struct attribute *attr, char *buf)
+{
+	struct btrfs_attr *a = container_of(attr, struct btrfs_attr, attr);
+	struct btrfs_fs_info *fs_info;
+	fs_info = container_of(kobj, struct btrfs_fs_info, super_kobj);
+
+	return a->show ? a->show(a, fs_info, buf) : 0;
+}
+
+static ssize_t btrfs_attr_store(struct kobject *kobj,
+				struct attribute *attr,
+				const char *buf, size_t len)
+{
+	struct btrfs_attr *a = container_of(attr, struct btrfs_attr, attr);
+	struct btrfs_fs_info *fs_info;
+	fs_info = container_of(kobj, struct btrfs_fs_info, super_kobj);
+
+	return a->store ? a->store(a, fs_info, buf, len) : 0;
+}
+
+static const struct sysfs_ops btrfs_attr_ops = {
+	.show = btrfs_attr_show,
+	.store = btrfs_attr_store,
+};
+
+static struct kobj_type btrfs_ktype = {
+	.default_attrs	= btrfs_attrs,
+	.sysfs_ops	= &btrfs_attr_ops,
+	.release	= btrfs_fs_info_release,
+};
+
+int btrfs_sysfs_add_one(struct btrfs_fs_info *fs_info)
+{
+	init_completion(&fs_info->kobj_unregister);
+	fs_info->super_kobj.kset = btrfs_kset;
+	return kobject_init_and_add(&fs_info->super_kobj, &btrfs_ktype, NULL,
+				    "%pU", fs_info->fsid);
+}
+
+void btrfs_sysfs_remove_one(struct btrfs_fs_info *fs_info)
+{
+	kobject_del(&fs_info->super_kobj);
+	kobject_put(&fs_info->super_kobj);
+	wait_for_completion(&fs_info->kobj_unregister);
+}
+
 static void btrfs_supp_feat_release(struct kobject *kobj)
 {
 	complete(&btrfs_feat->f_kobj_unregister);
--- a/fs/btrfs/sysfs.h	2013-09-10 00:09:13.002087628 -0400
+++ b/fs/btrfs/sysfs.h	2013-09-10 00:09:35.525794464 -0400
@@ -8,6 +8,24 @@ enum btrfs_feature_set {
 	FEAT_MAX
 };
 
+struct btrfs_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct btrfs_attr *, struct btrfs_fs_info *, char *);
+	ssize_t (*store)(struct btrfs_attr *, struct btrfs_fs_info *,
+			 const char *, size_t);
+};
+
+#define __INIT_BTRFS_ATTR(_name, _mode, _show, _store)			\
+{									\
+	.attr	= { .name = __stringify(_name), .mode = _mode },	\
+	.show	= _show,						\
+	.store	= _store,						\
+}
+
+#define BTRFS_ATTR(_name, _mode, _show, _store)				\
+static struct btrfs_attr btrfs_attr_##_name =				\
+			__INIT_BTRFS_ATTR(_name, _mode, _show, _store)
+
 struct btrfs_feature_attr {
 	struct attribute attr;			/* global show, no store */
 	enum btrfs_feature_set feature_set;
@@ -31,6 +49,7 @@ static struct btrfs_feature_attr btrfs_a
 #define BTRFS_SUPP_FEAT_LIST(_name)    (&btrfs_attr_##_name.attr),
 
 /* convert from attribute */
+#define to_btrfs_attr(a) container_of(a, struct btrfs_attr, attr)
 #define to_btrfs_feature_attr(a) \
 			container_of(a, struct btrfs_feature_attr, attr)
 


