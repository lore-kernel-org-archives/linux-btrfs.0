Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i2.italiaonline.it ([212.48.25.210]:56741 "EHLO
	smtp-36.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752817AbaLAR3P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 12:29:15 -0500
Message-ID: <547CA567.7020801@inwind.it>
Date: Mon, 01 Dec 2014 18:29:11 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC v2] btrfs: add sysfs layout to show volume info
References: <1416814173-16945-1-git-send-email-anand.jain@oracle.com> <1417455190-8778-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1417455190-8778-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

On 12/01/2014 06:33 PM, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> Not yet ready for integration, but for review and testing of the new sysfs layout
> which is currently under /sys/fs/btrfs/by_fsid
> 
> This patch makes btrfs_fs_devices and btrfs_device information readable
> from sysfs. This uses the sysfs group visible entry point to mark
> certain attributes visible/hidden depending the FS state (mount/unmounted).
> 
> The new layout is as shown below.
> 
> /sys/fs/btrfs/by_fsid*
> 	./7b047f4d-c2ce-4f22-94a3-68c09057f1bf*
> 		status
> 		fsid*
> 		missing_devices
> 		num_devices*
> 		open_devices
> 		opened*
> 		rotating
> 		rw_devices
> 		seeding
> 		total_devices*
> 		total_rw_bytes
> 		./e6701882-220a-4416-98ac-a99f095bddcc*
> 			active_pending
> 			bdev
> 			bytes_used
> 			can_discard
> 			devid*
> 			dev_root_fsid
> 			devstats_valid
> 			dev_totalbytes
> 			generation*
> 			in_fs_metadata
> 			io_align
> 			io_width
> 			missing
> 			name*
> 			nobarriers
> 			replace_tgtdev
> 			sector_size
> 			total_bytes
> 			type
> 			uuid*
> 			writeable
> 
> (* indicates that attribute will be visible even when device is
> unmounted but registered with btrfs kernel)

Thanks, for working on that; I really like the idea to export more information.
- it is possible to put the device uuid under a directory like: by_dev_uuid/, 
this will help the parsing via script
- it is possible to make a directory under /sys/fs/btrfs/by_dev_uuid where
a link links to the related device; i.e.:
/sys/fs/btrfs/by_dev_uuid/e6701882-220a-4416-98ac-a99f095bddcc ->
	../by_fsid/7b047f4d-c2ce-4f22-94a3-68c09057f1bf/by_dev_uuid/e6701882-220a-4416-98ac-a99f095bddc


This would help to know which devices are registered by the kernel


> 
> The old kobject <fsid> will be merged into this new 'by_fsid' kobject,
> so that older attributes under <fsid> and newer attributed under by_fsid
> will be merged together as well.

It would be fully backward compatible ? I really like your layout more
than the current one, but I think that the current sysfs is like a
binary API and so it has to be maintained forever

> 
> v2: added support for device add/delete/replace
>     rebase on the latest integration branch
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/dev-replace.c |   7 +
>  fs/btrfs/super.c       |  15 ++
>  fs/btrfs/sysfs.c       | 383 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/sysfs.h       |   6 +
>  fs/btrfs/volumes.c     |  42 ++++++
>  fs/btrfs/volumes.h     |   6 +
>  6 files changed, 459 insertions(+)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 715a115..31ce3a9 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -474,6 +474,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  	u8 uuid_tmp[BTRFS_UUID_SIZE];
>  	struct btrfs_trans_handle *trans;
>  	int ret = 0;
> +	char uuid_buf[BTRFS_UUID_UNPARSED_SIZE];
>  
>  	/* don't allow cancel or unmount to disturb the finishing procedure */
>  	mutex_lock(&dev_replace->lock_finishing_cancel_unmount);
> @@ -595,7 +596,13 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  	/* replace the sysfs entry */
>  	btrfs_kobj_rm_device(fs_info, src_device);
>  	btrfs_kobj_add_device(fs_info, tgt_device);
> +	btrfs_destroy_dev_sysfs(src_device);
>  	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
> +	snprintf(uuid_buf, BTRFS_UUID_UNPARSED_SIZE, "%pU",
> +						tgt_device->uuid);
> +	if (kobject_rename(&tgt_device->dev_kobj, uuid_buf))
> +		printk(KERN_ERR "BTRFS: sysfs uuid %s rename error\n",
> +							uuid_buf);
>  
>  	/* write back the superblocks */
>  	trans = btrfs_start_transaction(root, 0);
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 017d92d..918eb9d 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1389,6 +1389,11 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  		goto error_sec_opts;
>  	}
>  
> +	error = btrfs_update_by_fsid_sysfs_group(fs_devices);
> +	if (error)
> +		btrfs_warn(fs_info, "sysfs update error during mount: %d",
> +			error);
> +
>  	return root;
>  
>  error_close_devices:
> @@ -1885,8 +1890,18 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  static void btrfs_kill_super(struct super_block *sb)
>  {
>  	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
> +	struct btrfs_fs_devices *fs_devs = fs_info->fs_devices;
> +	int error;
> +
> +	set_bit(BTRFS_FS_DEVS_UNMOUNTING, &fs_devs->flags);
> +	error = btrfs_update_by_fsid_sysfs_group(fs_devs);
> +	if (error)
> +		btrfs_warn(fs_info, "sysfs update error during unmount: %d",
> +			error);
> +
>  	kill_anon_super(sb);
>  	free_fs_info(fs_info);
> +	clear_bit(BTRFS_FS_DEVS_UNMOUNTING, &fs_devs->flags);
>  }
>  
>  static struct file_system_type btrfs_fs_type = {
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 92db3f6..b658812 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -25,6 +25,7 @@
>  #include <linux/bug.h>
>  #include <linux/genhd.h>
>  #include <linux/debugfs.h>
> +#include <linux/rcustring.h>
>  
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -32,6 +33,18 @@
>  #include "sysfs.h"
>  #include "volumes.h"
>  
> +struct kobject *by_fsid;
> +static ssize_t btrfs_dev_attr_show(struct kobject *kobj,
> +				       struct kobj_attribute *a, char *buf);
> +static ssize_t btrfs_dev_attr_store(struct kobject *kobj,
> +					struct kobj_attribute *a,
> +					const char *buf, size_t count);
> +static ssize_t btrfs_fs_devs_attr_show(struct kobject *kobj,
> +				       struct kobj_attribute *a, char *buf);
> +static ssize_t btrfs_fs_devs_attr_store(struct kobject *kobj,
> +					struct kobj_attribute *a,
> +					const char *buf, size_t count);
> +
>  static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj);
>  
>  static u64 get_features(struct btrfs_fs_info *fs_info,
> @@ -738,13 +751,383 @@ int btrfs_init_sysfs(void)
>  	init_feature_attrs();
>  	ret = sysfs_create_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
>  
> +	by_fsid = kobject_create_and_add("by_fsid", &btrfs_kset->kobj);
> +
>  	return ret;
>  }
>  
>  void btrfs_exit_sysfs(void)
>  {
> +	kobject_put(by_fsid);
>  	sysfs_remove_group(&btrfs_kset->kobj, &btrfs_feature_attr_group);
>  	kset_unregister(btrfs_kset);
>  	debugfs_remove_recursive(btrfs_debugfs_root_dentry);
>  }
>  
> +
> +/******* Add support for by_fsid *******/
> +static ssize_t btrfs_show_uuid(u8 *valptr, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%pU\n", valptr);
> +}
> +
> +static ssize_t btrfs_show_str(char *strptr, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%s\n", strptr);
> +}
> +
> +static ssize_t btrfs_show_u(uint val, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%u\n", val);
> +}
> +
> +static ssize_t btrfs_show_d(int val, char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", val);
> +}
> +
> +static void release_by_fsid_kobj(struct kobject *kobj)
> +{
> +
> +}
> +
> +struct kobj_type btrfs_by_fsid_ktype = {
> +	.sysfs_ops = &kobj_sysfs_ops,
> +	.release = release_by_fsid_kobj,
> +};
> +
> +struct btrfs_fs_devs_attr {
> +	struct kobj_attribute kobj_attr;
> +};
> +
> +#define to_btrfs_fs_devices(_kobj) container_of(_kobj, struct btrfs_fs_devices, fs_devs_kobj)
> +
> +#define BTRFS_FS_DEV_ATTR(_name)\
> +	static struct btrfs_fs_devs_attr btrfs_fs_devs_attr_##_name = {\
> +		.kobj_attr = __INIT_KOBJ_ATTR(_name, S_IRUGO,\
> +					btrfs_fs_devs_attr_show,\
> +					btrfs_fs_devs_attr_store),\
> +	}
> +
> +BTRFS_FS_DEV_ATTR(fsid);
> +BTRFS_FS_DEV_ATTR(num_devices);
> +BTRFS_FS_DEV_ATTR(open_devices);
> +BTRFS_FS_DEV_ATTR(rw_devices);
> +BTRFS_FS_DEV_ATTR(missing_devices);
> +BTRFS_FS_DEV_ATTR(total_rw_bytes);
> +BTRFS_FS_DEV_ATTR(total_devices);
> +BTRFS_FS_DEV_ATTR(opened);
> +BTRFS_FS_DEV_ATTR(seeding);
> +BTRFS_FS_DEV_ATTR(rotating);
> +
> +#define BTRFS_FS_DEV_ATTR_PTR(_name) (&btrfs_fs_devs_attr_##_name.kobj_attr.attr)
> +
> +static struct attribute *btrfs_fs_devs_attrs[] = {
> +	BTRFS_FS_DEV_ATTR_PTR(fsid),
> +	BTRFS_FS_DEV_ATTR_PTR(num_devices),
> +	BTRFS_FS_DEV_ATTR_PTR(open_devices),
> +	BTRFS_FS_DEV_ATTR_PTR(rw_devices),
> +	BTRFS_FS_DEV_ATTR_PTR(missing_devices),
> +	BTRFS_FS_DEV_ATTR_PTR(total_rw_bytes),
> +	BTRFS_FS_DEV_ATTR_PTR(total_devices),
> +	BTRFS_FS_DEV_ATTR_PTR(opened),
> +	BTRFS_FS_DEV_ATTR_PTR(seeding),
> +	BTRFS_FS_DEV_ATTR_PTR(rotating),
> +	NULL
> +};
> +
> +#define BTRFS_FS_DEVS_GET_ATTR_UUID(attr, name, valprt, buf)\
> +	if (attr == BTRFS_FS_DEV_ATTR_PTR(name))\
> +		return btrfs_show_uuid(valprt, buf)
> +#define BTRFS_FS_DEVS_GET_ATTR_STR(attr, name, strprt, buf)\
> +	if (attr == BTRFS_FS_DEV_ATTR_PTR(name))\
> +		return btrfs_show_str(strprt, buf)
> +#define BTRFS_FS_DEVS_GET_ATTR_U64(attr, name, valprt, buf)\
> +	if (attr == BTRFS_FS_DEV_ATTR_PTR(name))\
> +		return btrfs_show_u64(valprt, NULL, buf)
> +#define BTRFS_FS_DEVS_GET_ATTR_U(attr, name, val, buf)\
> +	if (attr == BTRFS_FS_DEV_ATTR_PTR(name))\
> +		return btrfs_show_u(val, buf)
> +#define BTRFS_FS_DEVS_GET_ATTR_D(attr, name, val, buf)\
> +	if (attr == BTRFS_FS_DEV_ATTR_PTR(name))\
> +		return btrfs_show_d(val, buf)
> +
> +static ssize_t btrfs_fs_devs_attr_show(struct kobject *kobj,
> +				       struct kobj_attribute *a, char *buf)
> +{
> +	struct btrfs_fs_devices *fs_devs = to_btrfs_fs_devices(kobj);
> +
> +	BTRFS_FS_DEVS_GET_ATTR_UUID(&a->attr, fsid, fs_devs->fsid, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, num_devices, &fs_devs->num_devices, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, open_devices, &fs_devs->open_devices, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, rw_devices, &fs_devs->rw_devices, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, missing_devices, &fs_devs->missing_devices, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, total_rw_bytes, &fs_devs->total_rw_bytes, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, total_devices, &fs_devs->total_devices, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_D(&a->attr, opened, fs_devs->opened, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_D(&a->attr, seeding, fs_devs->seeding, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_D(&a->attr, rotating, fs_devs->rotating, buf);
> +
> +	return 0;
> +}
> +
> +static ssize_t btrfs_fs_devs_attr_store(struct kobject *kobj,
> +					struct kobj_attribute *a,
> +					const char *buf, size_t count)
> +{
> +	/*
> +	 * we might need some of the parameter to be writable
> +	 * but as of now just deny all
> +	 */
> +	return -EPERM;
> +}
> +
> +
> +static umode_t btrfs_fs_devs_attr_visible(struct kobject *kobj,
> +				     struct attribute *attr, int unused)
> +{
> +	struct btrfs_fs_devices *fs_devs = to_btrfs_fs_devices(kobj);
> +
> +	/* if device is mounted then all is visible */
> +	if (fs_devs->opened &&
> +		!(test_bit(BTRFS_FS_DEVS_UNMOUNTING, &fs_devs->flags)))
> +		return attr->mode|S_IWUSR;
> +
> +	/* when device is unmounted(ing) show only following set*/
> +	if (attr == BTRFS_FS_DEV_ATTR_PTR(num_devices))
> +		return attr->mode|S_IWUSR;
> +	else if (attr == BTRFS_FS_DEV_ATTR_PTR(total_devices))
> +		return attr->mode|S_IWUSR;
> +	else if (attr == BTRFS_FS_DEV_ATTR_PTR(opened))
> +		return attr->mode|S_IWUSR;
> +	else if (attr == BTRFS_FS_DEV_ATTR_PTR(fsid))
> +		return attr->mode|S_IWUSR;
> +
> +	return 0;
> +}
> +
> +static const struct attribute_group btrfs_fs_devs_attr_group = {
> +	.attrs = btrfs_fs_devs_attrs,
> +	.is_visible = btrfs_fs_devs_attr_visible,
> +};
> +
> +int btrfs_create_fs_devs_sysfs(struct btrfs_fs_devices *fs_devs)
> +{
> +	int rc;
> +
> +	rc = kobject_init_and_add(&fs_devs->fs_devs_kobj, &btrfs_by_fsid_ktype,
> +			by_fsid, "%pU", fs_devs->fsid);
> +
> +	rc = sysfs_create_group(&fs_devs->fs_devs_kobj, &btrfs_fs_devs_attr_group);
> +	return rc;
> +}
> +
> +int btrfs_update_fs_devs_sysfs(struct btrfs_fs_devices *fs_devs)
> +{
> +	int rc;
> +
> +	rc = sysfs_update_group(&fs_devs->fs_devs_kobj, &btrfs_fs_devs_attr_group);
> +
> +	return rc;
> +}
> +
> +/**** Do the same for the btrfs_device ****/
> +
> +static void release_btrfs_dev_kobj(struct kobject *kobj)
> +{
> +
> +}
> +
> +struct kobj_type btrfs_dev_ktype = {
> +	.sysfs_ops = &kobj_sysfs_ops,
> +	.release = release_btrfs_dev_kobj,
> +};
> +
> +struct btrfs_dev_attr {
> +	struct kobj_attribute kobj_attr;
> +};
> +
> +#define to_btrfs_device(_kobj) container_of(_kobj, struct btrfs_device, dev_kobj)
> +
> +#define BTRFS_DEV_ATTR(_name)\
> +	static struct btrfs_dev_attr btrfs_dev_attr_##_name = {\
> +		.kobj_attr = __INIT_KOBJ_ATTR(_name, S_IRUGO,\
> +					btrfs_dev_attr_show,\
> +					btrfs_dev_attr_store),\
> +	}
> +
> +BTRFS_DEV_ATTR(uuid);
> +BTRFS_DEV_ATTR(name);
> +BTRFS_DEV_ATTR(devid);
> +BTRFS_DEV_ATTR(dev_root_fsid);
> +BTRFS_DEV_ATTR(generation);
> +BTRFS_DEV_ATTR(total_bytes);
> +BTRFS_DEV_ATTR(dev_totalbytes);
> +BTRFS_DEV_ATTR(bytes_used);
> +BTRFS_DEV_ATTR(type);
> +BTRFS_DEV_ATTR(io_align);
> +BTRFS_DEV_ATTR(io_width);
> +BTRFS_DEV_ATTR(sector_size);
> +BTRFS_DEV_ATTR(writeable);
> +BTRFS_DEV_ATTR(in_fs_metadata);
> +BTRFS_DEV_ATTR(missing);
> +BTRFS_DEV_ATTR(can_discard);
> +BTRFS_DEV_ATTR(replace_tgtdev);
> +BTRFS_DEV_ATTR(active_pending);
> +BTRFS_DEV_ATTR(nobarriers);
> +BTRFS_DEV_ATTR(devstats_valid);
> +BTRFS_DEV_ATTR(bdev);
> +
> +#define BTRFS_DEV_ATTR_PTR(_name) (&btrfs_dev_attr_##_name.kobj_attr.attr)
> +
> +static struct attribute *btrfs_dev_attrs[] = {
> +	BTRFS_DEV_ATTR_PTR(uuid),
> +	BTRFS_DEV_ATTR_PTR(name),
> +	BTRFS_DEV_ATTR_PTR(devid),
> +	BTRFS_DEV_ATTR_PTR(dev_root_fsid),
> +	BTRFS_DEV_ATTR_PTR(generation),
> +	BTRFS_DEV_ATTR_PTR(total_bytes),
> +	BTRFS_DEV_ATTR_PTR(dev_totalbytes),
> +	BTRFS_DEV_ATTR_PTR(bytes_used),
> +	BTRFS_DEV_ATTR_PTR(type),
> +	BTRFS_DEV_ATTR_PTR(io_align),
> +	BTRFS_DEV_ATTR_PTR(io_width),
> +	BTRFS_DEV_ATTR_PTR(sector_size),
> +	BTRFS_DEV_ATTR_PTR(writeable),
> +	BTRFS_DEV_ATTR_PTR(in_fs_metadata),
> +	BTRFS_DEV_ATTR_PTR(missing),
> +	BTRFS_DEV_ATTR_PTR(can_discard),
> +	BTRFS_DEV_ATTR_PTR(replace_tgtdev),
> +	BTRFS_DEV_ATTR_PTR(active_pending),
> +	BTRFS_DEV_ATTR_PTR(nobarriers),
> +	BTRFS_DEV_ATTR_PTR(devstats_valid),
> +	BTRFS_DEV_ATTR_PTR(bdev),
> +	NULL
> +};
> +
> +#define BTRFS_DEV_GET_ATTR_UUID(attr, name, valprt, buf)\
> +	if (attr == BTRFS_DEV_ATTR_PTR(name))\
> +		return btrfs_show_uuid(valprt, buf)
> +#define BTRFS_DEV_GET_ATTR_STR(attr, name, strprt, buf)\
> +	if (attr == BTRFS_DEV_ATTR_PTR(name))\
> +		return btrfs_show_str(strprt, buf)
> +#define BTRFS_DEV_GET_ATTR_U64(attr, name, valprt, buf)\
> +	if (attr == BTRFS_DEV_ATTR_PTR(name))\
> +		return btrfs_show_u64(valprt, NULL, buf)
> +#define BTRFS_DEV_GET_ATTR_U(attr, name, val, buf)\
> +	if (attr == BTRFS_DEV_ATTR_PTR(name))\
> +		return btrfs_show_u(val, buf)
> +#define BTRFS_DEV_GET_ATTR_D(attr, name, val, buf)\
> +	if (attr == BTRFS_DEV_ATTR_PTR(name))\
> +		return btrfs_show_d(val, buf)
> +#define BTRFS_DEV_CHECK_ATTR(attr, name)\
> +		attr == BTRFS_DEV_ATTR_PTR(name)
> +
> +static ssize_t btrfs_dev_attr_show(struct kobject *kobj,
> +				       struct kobj_attribute *a, char *buf)
> +{
> +	struct btrfs_device *dev = to_btrfs_device(kobj);
> +
> +	/* Todo: handle the missing device case */
> +	BTRFS_DEV_GET_ATTR_STR(&a->attr, name, rcu_string_dereference(dev->name), buf);
> +	BTRFS_DEV_GET_ATTR_UUID(&a->attr, uuid, dev->uuid, buf);
> +	BTRFS_DEV_GET_ATTR_U64(&a->attr, devid, &dev->devid, buf);
> +	BTRFS_DEV_GET_ATTR_UUID(&a->attr, dev_root_fsid, dev->dev_root->fs_info->fsid, buf);
> +	BTRFS_DEV_GET_ATTR_U64(&a->attr, generation, &dev->generation, buf);
> +	BTRFS_DEV_GET_ATTR_U64(&a->attr, total_bytes, &dev->total_bytes, buf);
> +	BTRFS_DEV_GET_ATTR_U64(&a->attr, dev_totalbytes, &dev->disk_total_bytes, buf);
> +	BTRFS_DEV_GET_ATTR_U64(&a->attr, bytes_used, &dev->bytes_used, buf);
> +	BTRFS_DEV_GET_ATTR_U64(&a->attr, type, &dev->type, buf);
> +	BTRFS_DEV_GET_ATTR_U(&a->attr, io_align, dev->io_align, buf);
> +	BTRFS_DEV_GET_ATTR_U(&a->attr, sector_size, dev->sector_size, buf);
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, writeable, dev->writeable, buf);
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, in_fs_metadata, dev->in_fs_metadata, buf);
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, missing, dev->missing, buf);
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, can_discard, dev->can_discard, buf);
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, replace_tgtdev, dev->is_tgtdev_for_dev_replace, buf);
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, active_pending, dev->running_pending, buf);
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, nobarriers, dev->nobarriers, buf);
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, devstats_valid, dev->dev_stats_valid, buf);
> +	BTRFS_DEV_GET_ATTR_STR(&a->attr, bdev, dev->bdev ? "not_null":"null", buf);
> +
> +	return 0;
> +}
> +
> +static ssize_t btrfs_dev_attr_store(struct kobject *kobj,
> +					struct kobj_attribute *a,
> +					const char *buf, size_t count)
> +{
> +	/*
> +	 * we might need some of the parameter to be writable
> +	 * but as of now just deny all
> +	 */
> +	return -EPERM;
> +}
> +
> +static umode_t btrfs_dev_attr_visible(struct kobject *kobj,
> +				     struct attribute *attr, int unused)
> +{
> +	struct btrfs_fs_devices *fs_devs = to_btrfs_device(kobj)->fs_devices;
> +
> +	/* if device is mounted then all is visible */
> +	if (fs_devs->opened &&
> +		!(test_bit(BTRFS_FS_DEVS_UNMOUNTING, &fs_devs->flags)))
> +		return attr->mode|S_IWUSR;
> +
> +	/* when device is unmounted  only the below attributes are visible */
> +	if (attr == BTRFS_DEV_ATTR_PTR(uuid))
> +		return attr->mode|S_IWUSR;
> +	if (attr == BTRFS_DEV_ATTR_PTR(name))
> +		return attr->mode|S_IWUSR;
> +	else if (attr == BTRFS_DEV_ATTR_PTR(devid))
> +		return attr->mode|S_IWUSR;
> +	else if (attr == BTRFS_DEV_ATTR_PTR(generation))
> +		return attr->mode|S_IWUSR;
> +
> +	return 0;
> +}
> +
> +static const struct attribute_group btrfs_dev_attr_group = {
> +	.attrs = btrfs_dev_attrs,
> +	.is_visible = btrfs_dev_attr_visible,
> +};
> +
> +void btrfs_destroy_dev_sysfs(struct btrfs_device *dev)
> +{
> +	sysfs_remove_group(&dev->dev_kobj, &btrfs_dev_attr_group);
> +	kobject_del(&dev->dev_kobj);
> +	kobject_put(&dev->dev_kobj);
> +}
> +
> +int btrfs_create_dev_sysfs(struct btrfs_device *dev)
> +{
> +	int rc;
> +
> +	rc = kobject_init_and_add(&dev->dev_kobj, &btrfs_by_fsid_ktype,
> +			&dev->fs_devices->fs_devs_kobj, "%pU", dev->uuid);
> +
> +	rc = sysfs_create_group(&dev->dev_kobj, &btrfs_dev_attr_group);
> +	if (rc)
> +		kobject_put(&dev->dev_kobj);
> +
> +	return rc;
> +
> +}
> +
> +int btrfs_update_dev_sysfs(struct btrfs_device *dev)
> +{
> +	int rc;
> +
> +	rc = sysfs_update_group(&dev->dev_kobj, &btrfs_dev_attr_group);
> +
> +	return rc;
> +}
> +
> +void btrfs_migrate_dev_kobj(struct kobject *src, struct kobject *dst)
> +{
> +	struct btrfs_device *dev = to_btrfs_device(src);
> +	btrfs_destroy_dev_sysfs(dev);
> +
> +	dev = to_btrfs_device(dst);
> +	btrfs_create_dev_sysfs(dev);
> +}
> diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
> index f7dd298..9b03f9a 100644
> --- a/fs/btrfs/sysfs.h
> +++ b/fs/btrfs/sysfs.h
> @@ -74,4 +74,10 @@ int btrfs_kobj_add_device(struct btrfs_fs_info *fs_info,
>  		struct btrfs_device *one_device);
>  int btrfs_kobj_rm_device(struct btrfs_fs_info *fs_info,
>                  struct btrfs_device *one_device);
> +int btrfs_create_fs_devs_sysfs(struct btrfs_fs_devices *fs_devices);
> +int btrfs_create_dev_sysfs(struct btrfs_device *dev);
> +int btrfs_update_fs_devs_sysfs(struct btrfs_fs_devices *fs_devs);
> +int btrfs_update_dev_sysfs(struct btrfs_device *dev);
> +void btrfs_destroy_dev_sysfs(struct btrfs_device *dev);
> +void btrfs_migrate_dev_kobj(struct kobject *src, struct kobject *dst);
>  #endif /* _BTRFS_SYSFS_H_ */
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index d13b253..2f9ea3a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -53,6 +53,11 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
>  DEFINE_MUTEX(uuid_mutex);
>  static LIST_HEAD(fs_uuids);
>  
> +struct list_head *btrfs_get_fs_uuids(void)
> +{
> +	return &fs_uuids;
> +}
> +
>  static void lock_chunks(struct btrfs_root *root)
>  {
>  	mutex_lock(&root->fs_info->chunk_mutex);
> @@ -478,6 +483,9 @@ static noinline int device_list_add(const char *path,
>  
>  		list_add(&fs_devices->list, &fs_uuids);
>  
> +		if (btrfs_create_fs_devs_sysfs(fs_devices))
> +			printk(KERN_ERR "BTRFS: create fs_devices sysfs entry failed\n");
> +
>  		device = NULL;
>  	} else {
>  		device = __find_device(&fs_devices->devices, devid,
> @@ -509,6 +517,9 @@ static noinline int device_list_add(const char *path,
>  
>  		ret = 1;
>  		device->fs_devices = fs_devices;
> +
> +		if (btrfs_create_dev_sysfs(device))
> +			printk(KERN_ERR "BTRFS: create btrfs_dev sysfs entry failed\n");
>  	} else if (!device->name || strcmp(device->name->str, path)) {
>  		/*
>  		 * When FS is already mounted.
> @@ -741,6 +752,16 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>  		list_replace_rcu(&device->dev_list, &new_device->dev_list);
>  		new_device->fs_devices = device->fs_devices;
>  
> +		/*
> +		 * Todo:
> +		 * its bit ugly that btrfs_device is being deleted and recreated
> +		 * for which we need to delete the sysfs kobject and create it
> +		 * again. which means if users cwd is this sysfs dir, then it
> +		 * would be staled. - need to avoid deleting btrfs_device when
> +		 * closing.
> +		 */
> +		btrfs_migrate_dev_kobj(&device->dev_kobj, &new_device->dev_kobj);
> +
>  		call_rcu(&device->rcu, free_device);
>  	}
>  	mutex_unlock(&fs_devices->device_list_mutex);
> @@ -1703,6 +1724,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>  		/* remove sysfs entry */
>  		btrfs_kobj_rm_device(root->fs_info, device);
>  	}
> +	btrfs_destroy_dev_sysfs(device);
>  
>  	call_rcu(&device->rcu, free_device);
>  
> @@ -2207,6 +2229,9 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>  
>  	/* add sysfs device entry */
>  	btrfs_kobj_add_device(root->fs_info, device);
> +	/* add the kobject for the new by_fsid layout */
> +	if (btrfs_create_dev_sysfs(device))
> +		printk(KERN_ERR "BTRFS: create btrfs_dev sysfs entry failed\n");
>  
>  	/*
>  	 * we've got more storage, clear any full flags on the space
> @@ -2381,6 +2406,10 @@ int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
>  	list_add(&device->dev_list, &fs_info->fs_devices->devices);
>  	fs_info->fs_devices->num_devices++;
>  	fs_info->fs_devices->open_devices++;
> +
> +	if (btrfs_create_dev_sysfs(device))
> +		printk(KERN_ERR "BTRFS: sysfs dev create failed for transit device\n");
> +
>  	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
>  
>  	*device_out = device;
> @@ -6691,3 +6720,16 @@ void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
>  	}
>  	unlock_chunks(root);
>  }
> +
> +int btrfs_update_by_fsid_sysfs_group(struct btrfs_fs_devices *fs_devs)
> +{
> +	int rc;
> +	struct btrfs_device *dev;
> +
> +	rc = btrfs_update_fs_devs_sysfs(fs_devs);
> +
> +	list_for_each_entry(dev, &fs_devs->devices, dev_list)
> +		rc = btrfs_update_dev_sysfs(dev);
> +
> +	return rc;
> +}
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 6e04f27..bada662 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -28,6 +28,8 @@ extern struct mutex uuid_mutex;
>  
>  #define BTRFS_STRIPE_LEN	(64 * 1024)
>  
> +#define BTRFS_FS_DEVS_UNMOUNTING	(1ULL << 0)
> +
>  struct buffer_head;
>  struct btrfs_pending_bios {
>  	struct bio *head;
> @@ -150,6 +152,7 @@ struct btrfs_device {
>  	/* Counter to record the change of device stats */
>  	atomic_t dev_stats_ccnt;
>  	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
> +	struct kobject dev_kobj;
>  };
>  
>  /*
> @@ -253,6 +256,8 @@ struct btrfs_fs_devices {
>  	 * nonrot flag set
>  	 */
>  	int rotating;
> +	struct kobject fs_devs_kobj;
> +	unsigned long flags;
>  };
>  
>  #define BTRFS_BIO_INLINE_CSUM_SIZE	64
> @@ -523,4 +528,5 @@ static inline void btrfs_dev_stat_reset(struct btrfs_device *dev,
>  void btrfs_update_commit_device_size(struct btrfs_fs_info *fs_info);
>  void btrfs_update_commit_device_bytes_used(struct btrfs_root *root,
>  					struct btrfs_transaction *transaction);
> +int btrfs_update_by_fsid_sysfs_group(struct btrfs_fs_devices *fs_devs);
>  #endif
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
