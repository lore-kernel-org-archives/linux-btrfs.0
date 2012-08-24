Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:33110 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759477Ab2HXN6B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 09:58:01 -0400
Received: from venice.bhome (151.24.44.165) by smtp208.alice.it (8.6.023.02) (authenticated as kreijack@alice.it)
        id 500F3F940558C1B2 for linux-btrfs@vger.kernel.org; Fri, 24 Aug 2012 15:58:00 +0200
Subject: [PATCH v1 1/4] Add support for sysfs to btrfs.
To: linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Date: Fri, 24 Aug 2012 15:58:43 +0200
Message-ID: <20120824135807.20478.9407.stgit@venice.bhome>
In-Reply-To: <20120824135322.20478.88578.stgit@venice.bhome>
References: <20120824135322.20478.88578.stgit@venice.bhome>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Export via sysfs some information about the btrfs devices and
filesystem.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 fs/btrfs/sysfs.c |  938 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/sysfs.h |   31 ++
 2 files changed, 964 insertions(+), 5 deletions(-)
 create mode 100644 fs/btrfs/sysfs.h

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index daac9ae..bfaa7ea 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -24,23 +24,951 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 
+#include <linux/list.h>
+
+
 #include "ctree.h"
+#include "volumes.h"
 #include "disk-io.h"
 #include "transaction.h"
+#include "rcu-string.h"
+
+#include "sysfs.h"
+
+#ifdef CONFIG_BTRFS_FS_SYSFS
+
+static struct kobject *btrfs_kobject;
+static struct kobject *btrfs_devices_kobj;
+static struct kobject *btrfs_filesystems_kobj;
+
+struct btrfs_sysfs_device {
+	struct kobject		kobj;
+	struct list_head	list;
+	struct btrfs_device	*dev;
+};
+
+struct btrfs_sysfs_filesystem {
+	struct kobject		kobj;
+	struct list_head	list;
+	struct btrfs_fs_info	*fs_info;
+};
+
+struct btrfs_sysfs_fs_devices {
+	struct kobject		kobj;
+	struct list_head	list;
+	struct btrfs_fs_devices	*fs_devices;
+};
+
+struct btrfs_sysfs_fsid {
+	struct kobject		*kobj;
+	struct list_head	list;
+	u8			fsid[BTRFS_FSID_SIZE];
+};
+
+static struct list_head btrfs_sysfs_device_list;
+static struct list_head btrfs_sysfs_fs_devices_list;
+static struct list_head btrfs_sysfs_filesystem_list;
+static struct list_head btrfs_sysfs_fsid_list;
+
+void uuid_unparse(u8 *uuid, char *out)
+{
+
+	static char	*i2x = "0123456789abcdef";
+	static int	lengths[] = {4, 2, 2, 2, 6, 0};
+	int		i;
+
+	for (i = 0; ; i++) {
+		int j;
+		for (j = 0; j < lengths[i] ; j++, uuid++) {
+			*out++ = i2x[*uuid >> 4];
+			*out++ = i2x[*uuid & 0x0f];
+		}
+		if (!lengths[i+1]) {
+			*out = 0;
+			break;
+		} else {
+			*out++ = '-';
+		}
+	}
+}
+
+static struct btrfs_sysfs_fsid *find_fsid(u8 *fsid)
+{
+	struct btrfs_sysfs_fsid *bs_fsid;
+	list_for_each_entry(bs_fsid, &btrfs_sysfs_fsid_list, list)
+		if (!memcmp(bs_fsid->fsid, fsid, BTRFS_FSID_SIZE))
+			return bs_fsid;
+
+	return NULL;
+}
+
+static struct btrfs_sysfs_fsid *add_fsid(u8 *fsid)
+{
+
+	struct btrfs_sysfs_fsid	*o_fsid;
+	char buf[BTRFS_FSID_SIZE*2+5];
+
+	o_fsid = find_fsid(fsid);
+	if (o_fsid)
+		return o_fsid;
+
+	uuid_unparse(fsid, buf);
+	o_fsid = kzalloc(sizeof(struct btrfs_sysfs_fsid), GFP_NOFS);
+	if (!o_fsid) {
+		pr_crit("btrfs_sysfs: cannot register the fsid '%s'\n", buf);
+		return NULL;
+	}
 
-/* /sys/fs/btrfs/ entry */
-static struct kset *btrfs_kset;
+	o_fsid->kobj = kobject_create_and_add(buf, btrfs_filesystems_kobj);
+	if (!o_fsid->kobj) {
+		pr_crit("btrfs_sysfs: cannot allocate the kobject fsid '%s'\n",
+			buf);
+		kfree(o_fsid);
+		return NULL;
+	}
+	memcpy(o_fsid->fsid, fsid, BTRFS_FSID_SIZE);
+	list_add(&o_fsid->list, &btrfs_sysfs_fsid_list);
+
+	return o_fsid;
+}
+
+static void del_fsid(u8 *fsid)
+{
+	struct btrfs_sysfs_fsid		*o_fsid;
+	struct btrfs_sysfs_device	*bs_dev;
+
+	o_fsid = find_fsid(fsid);
+	if (!o_fsid) {
+		pr_warn("btrfs_sysfs: cannot find the fsid to remove\n");
+		return;
+	}
+
+	/* check if the fsid is still in use from another device */
+	list_for_each_entry(bs_dev, &btrfs_sysfs_device_list, list) {
+		if (!bs_dev->dev)
+			continue;
+		if (!memcmp(bs_dev->dev->fs_devices->fsid,
+				fsid, BTRFS_FSID_SIZE))
+			return;
+	}
+
+	kobject_put(o_fsid->kobj);
+	kfree(o_fsid);
+	list_del_init(&o_fsid->list);
+}
 
 int btrfs_init_sysfs(void)
 {
-	btrfs_kset = kset_create_and_add("btrfs", NULL, fs_kobj);
-	if (!btrfs_kset)
+	btrfs_kobject = NULL;
+	btrfs_devices_kobj = NULL;
+	btrfs_filesystems_kobj = NULL;
+
+	btrfs_kobject = kobject_create_and_add("btrfs", fs_kobj);
+	if (!btrfs_kobject) {
+		btrfs_exit_sysfs();
+		return -ENOMEM;
+	}
+	btrfs_devices_kobj = kobject_create_and_add("devices", btrfs_kobject);
+	btrfs_filesystems_kobj = kobject_create_and_add("filesystems",
+		btrfs_kobject);
+	if (!btrfs_devices_kobj || !btrfs_filesystems_kobj) {
+		btrfs_exit_sysfs();
 		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&btrfs_sysfs_device_list);
+	INIT_LIST_HEAD(&btrfs_sysfs_fs_devices_list);
+	INIT_LIST_HEAD(&btrfs_sysfs_filesystem_list);
+	INIT_LIST_HEAD(&btrfs_sysfs_fsid_list);
 	return 0;
 }
 
+static void destroy_all_devices(void)
+{
+	struct btrfs_sysfs_device	*bs_dev, *next;
+	list_for_each_entry_safe(bs_dev, next,
+				 &btrfs_sysfs_device_list, list) {
+
+		list_del_init(&bs_dev->list);
+		bs_dev->dev = NULL;
+		kobject_put(&bs_dev->kobj);
+
+	}
+}
+
+static void destroy_all_fsid(void)
+{
+	struct btrfs_sysfs_fsid	*o_fsid, *next;
+	list_for_each_entry_safe(o_fsid, next,
+				 &btrfs_sysfs_fsid_list, list) {
+		list_del_init(&o_fsid->list);
+		kobject_put(o_fsid->kobj);
+	}
+}
+
+
+static void destroy_all_fs_devices(void)
+{
+	struct btrfs_sysfs_fs_devices	*bs_fsd, *next;
+	list_for_each_entry_safe(bs_fsd, next,
+				 &btrfs_sysfs_fs_devices_list, list) {
+		bs_fsd->fs_devices = NULL;
+		kobject_put(&bs_fsd->kobj);
+		list_del_init(&bs_fsd->list);
+	}
+}
+
+static void destroy_all_filesystem(void)
+{
+	struct btrfs_sysfs_filesystem	*bs_fs, *next;
+	list_for_each_entry_safe(bs_fs, next,
+				 &btrfs_sysfs_filesystem_list, list) {
+		bs_fs->fs_info = NULL;
+		kobject_put(&bs_fs->kobj);
+		list_del_init(&bs_fs->list);
+	}
+}
+
+void btrfs_exit_sysfs(void)
+{
+	destroy_all_filesystem();
+	destroy_all_fs_devices();
+	destroy_all_devices();
+	destroy_all_fsid();
+
+	if (btrfs_filesystems_kobj)
+		kobject_put(btrfs_filesystems_kobj);
+	if (btrfs_devices_kobj)
+		kobject_put(btrfs_devices_kobj);
+	if (btrfs_kobject)
+		kobject_put(btrfs_kobject);
+
+	btrfs_filesystems_kobj = NULL;
+	btrfs_devices_kobj = NULL;
+	btrfs_kobject = NULL;
+
+}
+
+/*
+ *  *******************************************************************
+ *	Sysfs code related to the fs_devices info
+ *  *******************************************************************
+ */
+
+struct sysfs_fs_devices_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct btrfs_sysfs_fs_devices *bs_fs,
+			struct sysfs_fs_devices_attribute *attr, char *buf);
+	ssize_t (*store)(struct btrfs_sysfs_fs_devices *bs_fs,
+			struct sysfs_fs_devices_attribute *attr,
+			const char *buf, size_t count);
+};
+
+/*
+ * The default show function that must be passed to sysfs.  This will be
+ * called by sysfs for whenever a show function is called by the user on a
+ * sysfs file associated with the kobjects we have registered.  We need to
+ * transpose back from a "default" kobject to our custom struct foo_obj and
+ * then call the show function for that specific object.
+ */
+static ssize_t sysfs_fs_devices_attr_show(struct kobject *kobj,
+			     struct attribute *attr,
+			     char *buf)
+{
+	struct sysfs_fs_devices_attribute *attribute;
+	struct btrfs_sysfs_fs_devices *bs_fsd;
+
+	attribute = container_of(attr, struct sysfs_fs_devices_attribute, attr);
+	bs_fsd = container_of(kobj, struct btrfs_sysfs_fs_devices, kobj);
+
+	if (!attribute->show)
+		return -EIO;
+
+	return attribute->show(bs_fsd, attribute, buf);
+}
+
+/*
+ * Just like the default show function above, but this one is for when the
+ * sysfs "store" is requested (when a value is written to a file.)
+ */
+static ssize_t sysfs_fs_devices_attr_store(struct kobject *kobj,
+			      struct attribute *attr,
+			      const char *buf, size_t len)
+{
+	struct sysfs_fs_devices_attribute *attribute;
+	struct btrfs_sysfs_fs_devices *bs_fsd;
+
+	attribute = container_of(attr, struct sysfs_fs_devices_attribute, attr);
+	bs_fsd = container_of(kobj, struct btrfs_sysfs_fs_devices, kobj);
+
+	if (!attribute->store)
+		return -EIO;
+
+	return attribute->store(bs_fsd, attribute, buf, len);
+}
+
+/* Our custom sysfs_ops that we will associate with our ktype later on */
+static const struct sysfs_ops sysfs_fs_devices_ops = {
+	.show =  sysfs_fs_devices_attr_show,
+	.store =  sysfs_fs_devices_attr_store,
+};
+
+/*
+ * The release function for our object.  This is REQUIRED by the kernel to
+ * have.  We free the memory held in our object here.
+ *
+ * NEVER try to get away with just a "blank" release function to try to be
+ * smarter than the kernel.  Turns out, no one ever is...
+ */
+static void sysfs_fs_devices_release(struct kobject *kobj)
+{
+	struct btrfs_sysfs_fs_devices *bs_fsd;
+
+	bs_fsd = container_of(kobj, struct btrfs_sysfs_fs_devices, kobj);
+	kfree(bs_fsd);
+}
+
+#define GEN_SHOW_FUNC_SFD_EX(NAME, FIELD, FMT)				\
+static ssize_t sfd_##NAME##_show(					\
+		struct btrfs_sysfs_fs_devices		*bs_fsd,	\
+		struct sysfs_fs_devices_attribute	*attr,		\
+		char *buf)						\
+{									\
+	if (!bs_fsd->fs_devices)					\
+		return 0;						\
+									\
+	return sprintf(buf, FMT, FIELD);				\
+}									\
+									\
+static struct sysfs_fs_devices_attribute sfd_##NAME##_attribute =	\
+	__ATTR(NAME, 0666, sfd_##NAME##_show, 0);
+
+
+#define GEN_SHOW_FUNC_SFD(FIELD, FMT) \
+	GEN_SHOW_FUNC_SFD_EX(FIELD, bs_fsd->fs_devices->FIELD, FMT)
+
+GEN_SHOW_FUNC_SFD(opened, "%d")
+GEN_SHOW_FUNC_SFD(seeding, "%d")
+GEN_SHOW_FUNC_SFD(latest_devid, "%llu")
+GEN_SHOW_FUNC_SFD(latest_trans, "%llu")
+GEN_SHOW_FUNC_SFD(open_devices, "%llu")
+GEN_SHOW_FUNC_SFD(rw_devices, "%llu")
+GEN_SHOW_FUNC_SFD(missing_devices, "%llu")
+GEN_SHOW_FUNC_SFD(total_rw_bytes, "%llu")
+GEN_SHOW_FUNC_SFD(num_can_discard, "%llu")
+
+/*
+ * Create a group of attributes so that we can create and destroy them all
+ * at once.
+ */
+static struct attribute *sysfs_fs_devices_attrs[] = {
+
+	&sfd_opened_attribute.attr,
+	&sfd_seeding_attribute.attr,
+	&sfd_latest_devid_attribute.attr,
+	&sfd_latest_trans_attribute.attr,
+	&sfd_open_devices_attribute.attr,
+	&sfd_rw_devices_attribute.attr,
+	&sfd_total_rw_bytes_attribute.attr,
+	&sfd_missing_devices_attribute.attr,
+	&sfd_num_can_discard_attribute.attr,
+
+	NULL,	/* need to NULL terminate the list of attributes */
+};
+
+static struct kobj_type btrfs_sysfs_fs_devices_ktype = {
+	.sysfs_ops = &sysfs_fs_devices_ops,
+	.release = sysfs_fs_devices_release,
+	.default_attrs = sysfs_fs_devices_attrs
+};
+
+static struct btrfs_sysfs_fs_devices *btrfs_sysfs_find_fs_devices(
+					struct btrfs_fs_devices *fs_devices) {
+	struct btrfs_sysfs_fs_devices *bs_fsd;
+
+	list_for_each_entry(bs_fsd, &btrfs_sysfs_fs_devices_list, list) {
+		if (bs_fsd && fs_devices == bs_fsd->fs_devices)
+			return bs_fsd;
+	}
+
+	return NULL;
+}
+
+/* register new fs_devices */
+static void btrfs_sysfs_add_fs_devices(struct btrfs_fs_devices *fs_devices)
+{
+	struct btrfs_sysfs_fs_devices	*bs_fsd;
+	struct btrfs_sysfs_fsid		*o_fsid;
+
+	/* check if the device is already registered */
+	if (btrfs_sysfs_find_fs_devices(fs_devices))
+		return;
+
+	o_fsid = add_fsid(fs_devices->fsid);
+	if (!o_fsid) {
+		pr_crit("btrfs_sysfs: cannot add a fsid !!!\n");
+		return;
+	}
+
+	bs_fsd = kzalloc(sizeof(struct btrfs_sysfs_fs_devices), GFP_NOFS);
+	if (!bs_fsd) {
+		pr_crit("btrfs_sysfs: cannot register a fs_devices\n");
+		return;
+	}
+
+	pr_info("btrfs_sysfs: register fs_devices\n");
+	if (kobject_init_and_add(&bs_fsd->kobj,
+			&btrfs_sysfs_fs_devices_ktype,
+			o_fsid->kobj,
+			 "%s", "fs_devices")) {
+		kobject_put(&bs_fsd->kobj);
+		pr_crit("btrfs_sysfs: cannot add a fs_devices\n");
+		kfree(bs_fsd);
+		return;
+
+	}
+
+	list_add(&bs_fsd->list, &btrfs_sysfs_fs_devices_list);
+	bs_fsd->fs_devices = fs_devices;
+}
+
+/* unregister a fs_devices */
+static void btrfs_sysfs_remove_fs_devices(struct btrfs_fs_devices *fs_devices)
+{
+	struct btrfs_sysfs_fs_devices	*bs_fsd;
+	struct btrfs_sysfs_device	*bs_dev;
+
+	/* check if the fs_devices is still in use from another device */
+	list_for_each_entry(bs_dev, &btrfs_sysfs_device_list, list) {
+		if (!bs_dev->dev)
+			continue;
+		if (bs_dev->dev->fs_devices == fs_devices)
+			return;
+	}
+
+	while ((bs_fsd = btrfs_sysfs_find_fs_devices(fs_devices)) != NULL) {
+		bs_fsd->fs_devices = 0;
+		kobject_put(&bs_fsd->kobj);
+		list_del_init(&bs_fsd->list);
+	}
+
+	del_fsid(fs_devices->fsid);
+}
+
+/*
+ *  *******************************************************************
+ *	Sysfs code related to the devices
+ *  *******************************************************************
+ */
+
+struct sysfs_device_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct btrfs_sysfs_device *bs_dev,
+			struct sysfs_device_attribute *attr, char *buf);
+	ssize_t (*store)(struct btrfs_sysfs_device *bs_dev,
+			struct sysfs_device_attribute *attr,
+			const char *buf, size_t count);
+};
+
+/*
+ * The default show function that must be passed to sysfs.  This will be
+ * called by sysfs for whenever a show function is called by the user on a
+ * sysfs file associated with the kobjects we have registered.  We need to
+ * transpose back from a "default" kobject to our custom struct foo_obj and
+ * then call the show function for that specific object.
+ */
+static ssize_t sysfs_device_attr_show(struct kobject *kobj,
+			     struct attribute *attr,
+			     char *buf)
+{
+	struct sysfs_device_attribute *attribute;
+	struct btrfs_sysfs_device *bs_dev;
+
+	attribute = container_of(attr, struct sysfs_device_attribute, attr);
+	bs_dev = container_of(kobj, struct btrfs_sysfs_device, kobj);
+
+	if (!attribute->show)
+		return -EIO;
+
+	return attribute->show(bs_dev, attribute, buf);
+}
+
+/*
+ * Just like the default show function above, but this one is for when the
+ * sysfs "store" is requested (when a value is written to a file.)
+ */
+static ssize_t sysfs_device_attr_store(struct kobject *kobj,
+			      struct attribute *attr,
+			      const char *buf, size_t len)
+{
+	struct sysfs_device_attribute *attribute;
+	struct btrfs_sysfs_device *bs_dev;
+
+	attribute = container_of(attr, struct sysfs_device_attribute, attr);
+	bs_dev = container_of(kobj, struct btrfs_sysfs_device, kobj);
+
+	if (!attribute->store)
+		return -EIO;
+
+	return attribute->store(bs_dev, attribute, buf, len);
+}
+
+/* Our custom sysfs_ops that we will associate with our ktype later on */
+static const struct sysfs_ops sysfs_device_ops = {
+	.show =  sysfs_device_attr_show,
+	.store =  sysfs_device_attr_store,
+};
+
+/*
+ * The release function for our object.  This is REQUIRED by the kernel to
+ * have.  We free the memory held in our object here.
+ *
+ * NEVER try to get away with just a "blank" release function to try to be
+ * smarter than the kernel.  Turns out, no one ever is...
+ */
+static void sysfs_device_release(struct kobject *kobj)
+{
+	struct btrfs_sysfs_device *bs_dev;
+
+	bs_dev = container_of(kobj, struct btrfs_sysfs_device, kobj);
+	kfree(bs_dev);
+}
+
+#define GEN_SHOW_FUNC_SD_EX(NAME, CHECK, FIELD, FMT)		\
+static ssize_t sd_##NAME##_show(				\
+		struct btrfs_sysfs_device	*bs_dev,	\
+		struct sysfs_device_attribute	*attr,		\
+		char *buf)					\
+{								\
+	if (!bs_dev->dev)					\
+		return 0;					\
+								\
+	if (!(CHECK))						\
+		return 0;					\
+								\
+	return sprintf(buf, (FMT), (FIELD));			\
+}								\
+								\
+static struct sysfs_device_attribute sd_##NAME##_attribute =	\
+	__ATTR(NAME, 0666, sd_##NAME##_show, 0);
+
+
+#define GEN_SHOW_FUNC_SD(FIELD, FMT) \
+	GEN_SHOW_FUNC_SD_EX(FIELD, 1, bs_dev->dev->FIELD, FMT)
+
+GEN_SHOW_FUNC_SD(generation, "%llu\n")
+GEN_SHOW_FUNC_SD(devid, "%llu\n")
+GEN_SHOW_FUNC_SD(missing, "%d\n")
+GEN_SHOW_FUNC_SD(writeable, "%d\n")
+GEN_SHOW_FUNC_SD(total_bytes, "%llu\n")
+GEN_SHOW_FUNC_SD(disk_total_bytes, "%llu\n")
+GEN_SHOW_FUNC_SD(bytes_used, "%llu\n")
+
+static ssize_t sd_fsid_show(struct btrfs_sysfs_device	  *bs_dev,
+			    struct sysfs_device_attribute *attr,
+			    char *buf)
+{
+	if (!bs_dev->dev)
+		return 0;
+
+	/* TODO: should we lock something ? */
+	uuid_unparse(bs_dev->dev->fs_devices->fsid, buf);
+	buf[BTRFS_UUID_SIZE*2+4] = '\n';
+	return BTRFS_UUID_SIZE*2+4+1;
+}
+
+static struct sysfs_device_attribute sd_fsid_attribute =
+	__ATTR(fsid, 0666, sd_fsid_show, 0);
+
+GEN_SHOW_FUNC_SD_EX(major, bs_dev->dev->bdev,
+	MAJOR(bs_dev->dev->bdev->bd_dev), "%u\n")
+GEN_SHOW_FUNC_SD_EX(minor, bs_dev->dev->bdev,
+	MINOR(bs_dev->dev->bdev->bd_dev), "%u\n")
+GEN_SHOW_FUNC_SD_EX(write_errors,
+	bs_dev->dev->dev_stats_valid,
+	btrfs_dev_stat_read(bs_dev->dev, BTRFS_DEV_STAT_WRITE_ERRS),
+	"%u\n")
+GEN_SHOW_FUNC_SD_EX(read_errors,
+	bs_dev->dev->dev_stats_valid,
+	btrfs_dev_stat_read(bs_dev->dev, BTRFS_DEV_STAT_READ_ERRS),
+	"%u\n")
+GEN_SHOW_FUNC_SD_EX(flush_errors,
+	bs_dev->dev->dev_stats_valid,
+	btrfs_dev_stat_read(bs_dev->dev, BTRFS_DEV_STAT_FLUSH_ERRS),
+	"%u\n")
+GEN_SHOW_FUNC_SD_EX(corruption_errors,
+	bs_dev->dev->dev_stats_valid,
+	btrfs_dev_stat_read(bs_dev->dev, BTRFS_DEV_STAT_CORRUPTION_ERRS),
+	"%u\n")
+GEN_SHOW_FUNC_SD_EX(generation_errors,
+	bs_dev->dev->dev_stats_valid,
+	btrfs_dev_stat_read(bs_dev->dev, BTRFS_DEV_STAT_GENERATION_ERRS),
+	"%u\n")
+
+
+static ssize_t sd_name_show(struct btrfs_sysfs_device	   *bs_dev,
+			    struct sysfs_device_attribute  *attr,
+			    char *buf)
+{
+	int n;
+
+	if (!bs_dev->dev)
+		return 0;
+
+	rcu_read_lock();
+	n = sprintf(buf, "%s\n", rcu_str_deref(bs_dev->dev->name));
+	rcu_read_unlock();
+	return n;
+}
+
+static struct sysfs_device_attribute sd_name_attribute =
+	__ATTR(name, 0666, sd_name_show, 0);
+
+/*
+ * Create a group of attributes so that we can create and destroy them all
+ * at once.
+ */
+static struct attribute *sysfs_device_attrs[] = {
+	&sd_generation_attribute.attr,
+	&sd_devid_attribute.attr,
+	&sd_writeable_attribute.attr,
+	&sd_missing_attribute.attr,
+	&sd_total_bytes_attribute.attr,
+	&sd_disk_total_bytes_attribute.attr,
+	&sd_bytes_used_attribute.attr,
+	&sd_fsid_attribute.attr,
+	&sd_name_attribute.attr,
+	&sd_major_attribute.attr,
+	&sd_minor_attribute.attr,
+	&sd_write_errors_attribute.attr,
+	&sd_read_errors_attribute.attr,
+	&sd_flush_errors_attribute.attr,
+	&sd_corruption_errors_attribute.attr,
+	&sd_generation_errors_attribute.attr,
+
+	NULL,	/* need to NULL terminate the list of attributes */
+};
+
+static struct kobj_type btrfs_sysfs_device_ktype = {
+	.sysfs_ops = &sysfs_device_ops,
+	.release = sysfs_device_release,
+	.default_attrs = sysfs_device_attrs
+};
+
+static struct btrfs_sysfs_device *btrfs_sysfs_find_device(
+					struct btrfs_device *dev) {
+	struct btrfs_sysfs_device *bs_dev;
+
+	list_for_each_entry(bs_dev, &btrfs_sysfs_device_list, list) {
+		if (dev == bs_dev->dev)
+			return bs_dev;
+	}
+
+	return NULL;
+}
+
+void btrfs_sysfs_add_device(struct btrfs_device *dev)
+{
+
+	struct btrfs_sysfs_device	*bs_dev;
+	char				uuid_buf[BTRFS_UUID_SIZE*2+5];
+
+	/* check if the device is already registered */
+	if (btrfs_sysfs_find_device(dev))
+		return;
+
+	bs_dev = kzalloc(sizeof(struct btrfs_sysfs_device), GFP_NOFS);
+	if (!bs_dev) {
+		pr_crit("btrfs_sysfs: cannot register a device\n");
+		return;
+	}
+
+	uuid_unparse(dev->uuid, uuid_buf);
+	pr_info("btrfs_sysfs: register device '%s'\n", uuid_buf);
+	if (kobject_init_and_add(&bs_dev->kobj,
+			&btrfs_sysfs_device_ktype,
+			btrfs_devices_kobj,
+			"%s", uuid_buf)) {
+		pr_crit("btrfs_sysfs: cannot add a device\n");
+		kfree(bs_dev);
+		return;
+	}
+
+	btrfs_sysfs_add_fs_devices(dev->fs_devices);
+	list_add(&bs_dev->list, &btrfs_sysfs_device_list);
+	bs_dev->dev = dev;
+}
+
+void btrfs_sysfs_remove_device(struct btrfs_device *dev)
+{
+	struct btrfs_sysfs_device *bs_dev;
+
+
+	while ((bs_dev = btrfs_sysfs_find_device(dev)) != NULL) {
+		bs_dev->dev = 0;
+		kobject_put(&bs_dev->kobj);
+		list_del_init(&bs_dev->list);
+	}
+	btrfs_sysfs_remove_fs_devices(dev->fs_devices);
+
+}
+
+
+/*
+ *  *******************************************************************
+ *	Sysfs code related to the filesystem
+ *  *******************************************************************
+ */
+
+struct sysfs_filesystem_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct btrfs_sysfs_filesystem *bs_fs,
+			struct sysfs_filesystem_attribute *attr, char *buf);
+	ssize_t (*store)(struct btrfs_sysfs_filesystem *bs_fs,
+			struct sysfs_filesystem_attribute *attr,
+			const char *buf, size_t count);
+};
+
+/*
+ * The default show function that must be passed to sysfs.  This will be
+ * called by sysfs for whenever a show function is called by the user on a
+ * sysfs file associated with the kobjects we have registered.  We need to
+ * transpose back from a "default" kobject to our custom struct foo_obj and
+ * then call the show function for that specific object.
+ */
+static ssize_t sysfs_filesystem_attr_show(struct kobject *kobj,
+			     struct attribute *attr,
+			     char *buf)
+{
+	struct sysfs_filesystem_attribute *attribute;
+	struct btrfs_sysfs_filesystem *bs_fs;
+
+	attribute = container_of(attr, struct sysfs_filesystem_attribute, attr);
+	bs_fs = container_of(kobj, struct btrfs_sysfs_filesystem, kobj);
+
+	if (!attribute->show)
+		return -EIO;
+
+	return attribute->show(bs_fs, attribute, buf);
+}
+
+/*
+ * Just like the default show function above, but this one is for when the
+ * sysfs "store" is requested (when a value is written to a file.)
+ */
+static ssize_t sysfs_filesystem_attr_store(struct kobject *kobj,
+			      struct attribute *attr,
+			      const char *buf, size_t len)
+{
+	struct sysfs_filesystem_attribute *attribute;
+	struct btrfs_sysfs_filesystem *bs_fs;
+
+	attribute = container_of(attr, struct sysfs_filesystem_attribute, attr);
+	bs_fs = container_of(kobj, struct btrfs_sysfs_filesystem, kobj);
+
+	if (!attribute->store)
+		return -EIO;
+
+	return attribute->store(bs_fs, attribute, buf, len);
+}
+
+/* Our custom sysfs_ops that we will associate with our ktype later on */
+static const struct sysfs_ops sysfs_filesystem_ops = {
+	.show =  sysfs_filesystem_attr_show,
+	.store =  sysfs_filesystem_attr_store,
+};
+
+/*
+ * The release function for our object.  This is REQUIRED by the kernel to
+ * have.  We free the memory held in our object here.
+ *
+ * NEVER try to get away with just a "blank" release function to try to be
+ * smarter than the kernel.  Turns out, no one ever is...
+ */
+static void sysfs_filesystem_release(struct kobject *kobj)
+{
+	struct btrfs_sysfs_filesystem *bs_fs;
+
+	bs_fs = container_of(kobj, struct btrfs_sysfs_filesystem, kobj);
+	kfree(bs_fs);
+}
+
+#define GEN_SHOW_FUNC_SF_EX(NAME, FIELD, FMT) \
+static ssize_t sf_##NAME##_show(struct btrfs_sysfs_filesystem	  *bs_fs,  \
+				struct sysfs_filesystem_attribute *attr,   \
+				char *buf)				   \
+{									   \
+	if (!bs_fs->fs_info)						   \
+		return 0;						   \
+									   \
+	return sprintf(buf, FMT, FIELD);				   \
+}									   \
+									   \
+static struct sysfs_filesystem_attribute sf_##NAME##_attribute =	   \
+	__ATTR(NAME, 0666, sf_##NAME##_show, 0);
+
+
+#define GEN_SHOW_FUNC_SF(FIELD, FMT) \
+	GEN_SHOW_FUNC_SF_EX(FIELD, bs_fs->fs_info->FIELD, FMT)
+
+
+static ssize_t sf_label_show(struct btrfs_sysfs_filesystem	*bs_fs,
+			     struct sysfs_filesystem_attribute	*attr,
+			     char *buf)
+{
+	struct btrfs_super_block *bsb;
+
+	if (!bs_fs->fs_info)
+		return 0;
+
+	bsb = bs_fs->fs_info->super_for_commit;
+	if (!bsb)
+		bsb = bs_fs->fs_info->super_copy;
+	if (bsb)
+		return sprintf(buf, "%s\n", bsb->label);
+	else
+		return 0;
+}
+
+static struct sysfs_filesystem_attribute sf_label_attribute =
+	__ATTR(label, 0666, sf_label_show, 0);
+
+GEN_SHOW_FUNC_SF(generation, "%llu")
+GEN_SHOW_FUNC_SF(last_trans_committed, "%llu")
+GEN_SHOW_FUNC_SF(fs_state, "0x%016llx")
+GEN_SHOW_FUNC_SF_EX(balance_running,
+			atomic_read(&bs_fs->fs_info->balance_running), "%d")
+GEN_SHOW_FUNC_SF_EX(balance_pause_req,
+			atomic_read(&bs_fs->fs_info->balance_pause_req), "%d")
+GEN_SHOW_FUNC_SF_EX(balance_cancel_req,
+			atomic_read(&bs_fs->fs_info->balance_cancel_req), "%d")
+GEN_SHOW_FUNC_SF_EX(scrubs_running,
+			atomic_read(&bs_fs->fs_info->scrubs_running), "%d")
+GEN_SHOW_FUNC_SF_EX(scrub_pause_req,
+			atomic_read(&bs_fs->fs_info->scrub_pause_req), "%d")
+GEN_SHOW_FUNC_SF_EX(scrubs_paused,
+			atomic_read(&bs_fs->fs_info->scrubs_paused), "%d")
+GEN_SHOW_FUNC_SF_EX(scrub_cancel_req,
+			atomic_read(&bs_fs->fs_info->scrub_cancel_req), "%d")
+
+/*
+ * Create a group of attributes so that we can create and destroy them all
+ * at once.
+ */
+static struct attribute *sysfs_filesystem_attrs[] = {
+
+	&sf_label_attribute.attr,
+	&sf_generation_attribute.attr,
+	&sf_last_trans_committed_attribute.attr,
+	&sf_fs_state_attribute.attr,
+	&sf_balance_running_attribute.attr,
+	&sf_balance_pause_req_attribute.attr,
+	&sf_balance_cancel_req_attribute.attr,
+	&sf_scrubs_running_attribute.attr,
+	&sf_scrub_pause_req_attribute.attr,
+	&sf_scrubs_paused_attribute.attr,
+	&sf_scrub_cancel_req_attribute.attr,
+
+	NULL,	/* need to NULL terminate the list of attributes */
+};
+
+static struct kobj_type btrfs_sysfs_filesystem_ktype = {
+	.sysfs_ops = &sysfs_filesystem_ops,
+	.release = sysfs_filesystem_release,
+	.default_attrs = sysfs_filesystem_attrs
+};
+
+static struct btrfs_sysfs_filesystem *btrfs_sysfs_find_filesystem(
+						struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_sysfs_filesystem *bs_fs;
+
+	list_for_each_entry(bs_fs, &btrfs_sysfs_filesystem_list, list) {
+			if (fs_info == bs_fs->fs_info)
+				return bs_fs;
+	}
+
+	return NULL;
+}
+
+/* register new filesystem */
+void btrfs_sysfs_add_filesystem(struct btrfs_fs_info *fs_info)
+{
+		struct btrfs_sysfs_filesystem	*bs_fs;
+		char				uuid_buf[BTRFS_UUID_SIZE*2+5];
+		struct btrfs_sysfs_fsid		*o_fsid;
+
+		/* check if the device is already registered */
+		if (btrfs_sysfs_find_filesystem(fs_info))
+			return;
+
+		uuid_unparse(fs_info->fsid, uuid_buf);
+		o_fsid = find_fsid(fs_info->fsid);
+		if (!o_fsid) {
+			pr_crit("btrfs_sysfs: cannot find the fsid '%s'\n",
+				uuid_buf);
+			return;
+		}
+
+		bs_fs = kzalloc(sizeof(struct btrfs_sysfs_filesystem),
+				GFP_NOFS);
+		if (!bs_fs) {
+			pr_crit("btrfs_sysfs: cannot register a filesystem\n");
+			return;
+		}
+
+		pr_info("btrfs_sysfs: register filesystem '%s'\n", uuid_buf);
+		if (kobject_init_and_add(&bs_fs->kobj,
+					 &btrfs_sysfs_filesystem_ktype,
+					 o_fsid->kobj,
+					 "%s", "fs_info")) {
+			pr_crit("btrfs_sysfs: cannot add a filesystem\n");
+			kfree(bs_fs);
+			return;
+
+		}
+
+		list_add(&bs_fs->list, &btrfs_sysfs_filesystem_list);
+
+		bs_fs->fs_info = fs_info;
+}
+
+/* unregister a filesystem */
+void btrfs_sysfs_remove_filesystem(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_sysfs_filesystem *bs_fs;
+
+	while ((bs_fs = btrfs_sysfs_find_filesystem(fs_info)) != NULL) {
+		bs_fs->fs_info = 0;
+		kobject_put(&bs_fs->kobj);
+		list_del_init(&bs_fs->list);
+	}
+}
+
+#else
+
+static struct kobject *btrfs_kobject;
+
 void btrfs_exit_sysfs(void)
 {
-	kset_unregister(btrfs_kset);
+	if (btrfs_kobject)
+		kobject_put(btrfs_kobject);
+	btrfs_kobject = NULL;
+}
+
+
+int btrfs_init_sysfs(void)
+{
+	btrfs_kobject = kobject_create_and_add("btrfs", fs_kobj);
+	if (!btrfs_kobject) {
+		btrfs_exit_sysfs();
+		return -ENOMEM;
+	}
+	return 0;
 }
 
+void btrfs_sysfs_add_device(struct btrfs_device *dev)			{ }
+void btrfs_sysfs_remove_device(struct btrfs_device *dev)		{ }
+void btrfs_sysfs_add_filesystem(struct btrfs_fs_info *fs_info)		{ }
+void btrfs_sysfs_remove_filesystem(struct btrfs_fs_info *fs_info)	{ }
+#endif
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
new file mode 100644
index 0000000..2db7c9e
--- /dev/null
+++ b/fs/btrfs/sysfs.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright (C) 2012 G.Baroncelli.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include "ctree.h"
+
+/* register new device */
+void btrfs_sysfs_add_device(struct btrfs_device *dev);
+
+/* unregister a device */
+void btrfs_sysfs_remove_device(struct btrfs_device *dev);
+
+/* register new filesystem */
+void btrfs_sysfs_add_filesystem(struct btrfs_fs_info *fs_info);
+
+/* unregister a filesystem */
+void btrfs_sysfs_remove_filesystem(struct btrfs_fs_info *fs_info);

