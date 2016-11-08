Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45854 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752883AbcKHMjE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 07:39:04 -0500
Subject: Re: [PATCH] btrfs: Introduce device pool sysfs attributes
References: <1444412783-7070-1-git-send-email-anand.jain@oracle.com>
 <1444412783-7070-2-git-send-email-anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
To: dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <cb33a940-1f3c-1a01-50a9-33461f5b6cb0@oracle.com>
Date: Tue, 8 Nov 2016 20:41:18 +0800
MIME-Version: 1.0
In-Reply-To: <1444412783-7070-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


David,

  Any comments on this patch ?
  It would need rebase though, I shall do it based on your inputs.

  sysfs was most challenging to get correct. (There are defunct procfs
  and ioctl based patches as well which does the same thing).

Thanks, Anand


On 10/10/15 01:46, Anand Jain wrote:
> This patch provides, sysfs attributes for user land to read device and pool
> related informations, form the btrfs kernel. Internally these informations
> are from the struct btrfs_fs_devices and btrfs_device.
> As sysfs would reflect the state of the devices within btrfs kernel, and
> so will help to develop user land tools without having to use ioctl.
>
> This uses sysfs group visible API to mask certain attributes depending on
> the FS state. As shown below, the * indicates that the kobject/attribute
> will also be visible when the device is unmounted. (note in the example
> below the old kobject and attributes are hand deleted, so to show only
> the new kobject and attributes).
>
> /sys/fs/btrfs/
> 	./7b047f4d-c2ce-4f22-94a3-68c09057f1bf*
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
> 		devices/
> 		   ./1-sdc*
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
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/dev-replace.c |   6 +
>  fs/btrfs/disk-io.c     |  12 --
>  fs/btrfs/sysfs.c       | 533 ++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/btrfs/sysfs.h       |  12 +-
>  fs/btrfs/volumes.c     |  45 ++++-
>  fs/btrfs/volumes.h     |  10 +
>  6 files changed, 575 insertions(+), 43 deletions(-)
>
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 02df419..7df4275 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -394,6 +394,10 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
>  	if (ret)
>  		btrfs_err(root->fs_info, "kobj add dev failed %d\n", ret);
>
> +	ret = btrfs_sysfs_add_device_attr(tgt_device);
> +	if (ret && ret != -EEXIST)
> +		btrfs_err(root->fs_info, "sysfs create dev failed %d\n", ret);
> +
>  	btrfs_wait_ordered_roots(root->fs_info, -1);
>
>  	/* force writing the updated state information to disk */
> @@ -583,6 +587,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  	if (src_device->fs_devices->seeding &&
>  				!src_device->fs_devices->num_devices)
>  		btrfs_sysfs_remove_fsid(src_device->fs_devices);
> +	else
> +		btrfs_sysfs_rm_device_attr(src_device);
>  	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
>
>  	/* write back the superblocks */
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index ebeea0f..e522773 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2922,18 +2922,6 @@ retry_root_backup:
>
>  	btrfs_close_extra_devices(fs_devices, 1);
>
> -	ret = btrfs_sysfs_add_fsid(fs_devices, NULL, 1);
> -	if (ret && ret != -EEXIST) {
> -		pr_err("BTRFS: failed to init sysfs fsid interface: %d\n", ret);
> -		goto fail_block_groups;
> -	}
> -
> -	ret = btrfs_sysfs_add_device(fs_devices, 1);
> -	if (ret) {
> -		pr_err("BTRFS: failed to init sysfs device interface: %d\n", ret);
> -		goto fail_fsdev_sysfs;
> -	}
> -
>  	ret = btrfs_sysfs_add_mounted(fs_info);
>  	if (ret) {
>  		pr_err("BTRFS: failed to init sysfs interface: %d\n", ret);
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index c155d34..25e8e71 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -25,15 +25,18 @@
>  #include <linux/bug.h>
>  #include <linux/genhd.h>
>  #include <linux/debugfs.h>
> +#include <linux/string.h>
>
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "transaction.h"
>  #include "sysfs.h"
>  #include "volumes.h"
> +#include "rcu-string.h"
>
>  static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj);
>  static inline struct btrfs_fs_devices *to_fs_devs(struct kobject *kobj);
> +static inline struct btrfs_device *to_btrfs_dev(struct kobject *kobj);
>
>  static u64 get_features(struct btrfs_fs_info *fs_info,
>  			enum btrfs_feature_set set)
> @@ -523,12 +526,14 @@ static void __btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs)
>  	}
>
>  	if (fs_devs->device_dir_kobj) {
> +		btrfs_sysfs_rm_devices_attr(fs_devs);
>  		kobject_del(fs_devs->device_dir_kobj);
>  		kobject_put(fs_devs->device_dir_kobj);
>  		fs_devs->device_dir_kobj = NULL;
>  	}
>
>  	if (fs_devs->fsid_kobj.state_initialized) {
> +		btrfs_sysfs_rm_fsid_attr(fs_devs);
>  		kobject_del(&fs_devs->fsid_kobj);
>  		kobject_put(&fs_devs->fsid_kobj);
>  		wait_for_completion(&fs_devs->kobj_unregister);
> @@ -563,6 +568,7 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
>  	sysfs_remove_group(&fs_info->fs_devices->fsid_kobj, &btrfs_feature_attr_group);
>  	sysfs_remove_files(&fs_info->fs_devices->fsid_kobj, btrfs_attrs);
>  	btrfs_sysfs_rm_device_link(fs_info->fs_devices, NULL, 1);
> +	btrfs_sysfs_update_fsid_devices_attr(fs_info->fs_devices, 1);
>  }
>
>  const char * const btrfs_feature_set_names[3] = {
> @@ -679,21 +685,16 @@ int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
>  	return 0;
>  }
>
> -int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs, int follow_seed)
> +int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs)
>  {
> -	while (fs_devs) {
> -		if (!fs_devs->device_dir_kobj)
> -			fs_devs->device_dir_kobj = kobject_create_and_add(
> +	if (!fs_devs->device_dir_kobj)
> +		fs_devs->device_dir_kobj = kobject_create_and_add(
>  					"devices", &fs_devs->fsid_kobj);
>
> -		if (!fs_devs->device_dir_kobj)
> -			return -ENOMEM;
> -
> -		if (!follow_seed)
> -			return 0;
> +	if (!fs_devs->device_dir_kobj)
> +		return -ENOMEM;
>
> -		fs_devs = fs_devs->seed;
> -	}
> +	BUG_ON(!fs_devs->device_dir_kobj->state_initialized);
>
>  	return 0;
>  }
> @@ -769,29 +770,20 @@ u64 btrfs_debugfs_test;
>   * And parent can be specified for seed device
>   */
>  int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
> -				struct kobject *parent, int follow_seed)
> +					struct kobject *parent)
>  {
>  	int error = 0;
>
> -add_seed:
>  	if (!fs_devs->fsid_kobj.state_initialized) {
>  		init_completion(&fs_devs->kobj_unregister);
>  		fs_devs->fsid_kobj.kset = btrfs_kset;
>  		error = kobject_init_and_add(&fs_devs->fsid_kobj,
>  			&btrfs_ktype, parent, "%pU", fs_devs->fsid);
> +		error = btrfs_sysfs_add_fsid_attr(fs_devs);
>  	} else {
>  		error = -EEXIST;
>  	}
> -
> -	if (!follow_seed || !fs_devs->seed)
> -		return error;
> -
> -	btrfs_sysfs_add_seed_dir(fs_devs);
> -
> -	parent = fs_devs->seed_dir_kobj;
> -	fs_devs = fs_devs->seed;
> -
> -	goto add_seed;
> +	return error;
>  }
>
>  int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
> @@ -812,6 +804,8 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
>  		return error;
>  	}
>
> +	btrfs_sysfs_update_fsid_devices_attr(fs_devs, 1);
> +
>  	error = sysfs_create_group(fsid_kobj,
>  				   &btrfs_feature_attr_group);
>  	if (error)
> @@ -919,7 +913,7 @@ void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
>  	if (!fs_devices->seed_dir_kobj)
>  		btrfs_sysfs_add_seed_dir(fs_devices);
>
> -	btrfs_sysfs_add_fsid(seed_devices, fs_devices->seed_dir_kobj, 0);
> +	btrfs_sysfs_add_fsid(seed_devices, fs_devices->seed_dir_kobj);
>
>  	if (kobject_move(fs_devices->device_dir_kobj,
>  					&seed_devices->fsid_kobj))
> @@ -927,7 +921,7 @@ void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
>
>  	seed_devices->device_dir_kobj = fs_devices->device_dir_kobj;
>  	fs_devices->device_dir_kobj = NULL;
> -	btrfs_sysfs_add_device(fs_devices, 0);
> +	btrfs_sysfs_add_device(fs_devices);
>
>  	/*
>  	 * the kobj dev and devices attribute will be created
> @@ -942,6 +936,491 @@ void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
>  			pr_warn("Btrfs: sysfs: kobject move failed\n");
>  	}
>
> -	btrfs_sysfs_add_fsid(old_devices, NULL, 0);
> -	btrfs_sysfs_add_device(old_devices, 0);
> +	btrfs_sysfs_add_fsid(old_devices, NULL);
> +	btrfs_sysfs_add_device(old_devices);
> +	btrfs_sysfs_add_devices_attr(old_devices);
> +}
> +
> +
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
> +
> +/* btrfs_fs_devices attributes */
> +struct btrfs_fs_devs_attr {
> +	struct kobj_attribute kobj_attr;
> +};
> +
> +static ssize_t btrfs_fs_devs_attr_show(struct kobject *kobj,
> +				       struct kobj_attribute *a, char *buf);
> +
> +static ssize_t btrfs_fs_devs_attr_store(struct kobject *kobj,
> +					struct kobj_attribute *a,
> +					const char *buf, size_t count);
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
> +#define BTRFS_FS_DEV_ATTR_PTR(_name)\
> +	(&btrfs_fs_devs_attr_##_name.kobj_attr.attr)
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
> +	struct btrfs_fs_devices *fs_devs = to_fs_devs(kobj);
> +
> +	BTRFS_FS_DEVS_GET_ATTR_UUID(&a->attr, fsid, fs_devs->fsid, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, num_devices, &fs_devs->num_devices, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, open_devices, &fs_devs->open_devices, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, rw_devices, &fs_devs->rw_devices, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, missing_devices,
> +							&fs_devs->missing_devices, buf);
> +	BTRFS_FS_DEVS_GET_ATTR_U64(&a->attr, total_rw_bytes,
> +							&fs_devs->total_rw_bytes, buf);
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
> +static umode_t btrfs_sysfs_visible_fs_devs_attr(struct kobject *kobj,
> +				     struct attribute *attr, int unused)
> +{
> +	struct btrfs_fs_devices *fs_devs = to_fs_devs(kobj);
> +	struct btrfs_fs_info *fs_info = fs_devs->fs_info;
> +
> +	/* if device is mounted then all is visible */
> +	if (fs_devs->opened && fs_info && !fs_info->closing)
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
> +	.is_visible = btrfs_sysfs_visible_fs_devs_attr,
> +};
> +
> +void btrfs_sysfs_rm_fsid_attr(struct btrfs_fs_devices *fs_devs)
> +{
> +	sysfs_remove_group(&fs_devs->fsid_kobj,
> +				&btrfs_fs_devs_attr_group);
> +}
> +
> +int btrfs_sysfs_add_fsid_attr(struct btrfs_fs_devices *fs_devs)
> +{
> +	int rc;
> +
> +	rc = sysfs_create_group(&fs_devs->fsid_kobj,
> +				&btrfs_fs_devs_attr_group);
> +	return rc;
> +}
> +
> +static int btrfs_sysfs_update_fsid_attr(struct btrfs_fs_devices *fs_devs)
> +{
> +	int rc;
> +
> +	rc = sysfs_update_group(&fs_devs->fsid_kobj,
> +				&btrfs_fs_devs_attr_group);
> +
> +	return rc;
> +}
> +
> +/**** btrfs_device kobject and attributes ****/
> +static ssize_t btrfs_dev_attr_show(struct kobject *kobj,
> +			       struct kobj_attribute *a, char *buf);
> +static ssize_t btrfs_dev_attr_store(struct kobject *kobj,
> +				struct kobj_attribute *a,
> +				const char *buf, size_t count);
> +
> +struct btrfs_dev_attr {
> +	struct kobj_attribute kobj_attr;
> +};
> +
> +static void btrfs_release_dev_kobj(struct kobject *kobj)
> +{
> +	struct btrfs_device *dev = to_btrfs_dev(kobj);
> +
> +	kfree(dev->dev_kobjp);
> +	dev->dev_kobjp = NULL;
> +	complete(&dev->dev_kobj_unregister);
> +}
> +
> +static struct kobj_type btrfs_dev_ktype = {
> +	.sysfs_ops	= &kobj_sysfs_ops,
> +	.release	= btrfs_release_dev_kobj,
> +};
> +
> +static inline struct btrfs_device *to_btrfs_dev(struct kobject *kobj)
> +{
> +	struct btrfs_device_kobj *dev_kobj;
> +
> +	if (kobj->ktype != &btrfs_dev_ktype)
> +		return NULL;
> +
> +	dev_kobj = container_of(kobj, struct btrfs_device_kobj, dev_kobj);
> +	return dev_kobj->device;
> +}
> +
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
> +#define BTRFS_DEV_ATTR_PTR(_name)\
> +		(&btrfs_dev_attr_##_name.kobj_attr.attr)
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
> +	struct btrfs_device *dev = to_btrfs_dev(kobj);
> +	char bdev_state[10];
> +
> +	/* Todo: handle the missing device case */
> +	BTRFS_DEV_GET_ATTR_STR(&a->attr, name, rcu_str_deref(dev->name), buf);
> +	BTRFS_DEV_GET_ATTR_UUID(&a->attr, uuid, dev->uuid, buf);
> +	BTRFS_DEV_GET_ATTR_U64(&a->attr, devid, &dev->devid, buf);
> +	BTRFS_DEV_GET_ATTR_UUID(&a->attr, dev_root_fsid,
> +					dev->dev_root->fs_info->fsid, buf);
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
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, replace_tgtdev,
> +						dev->is_tgtdev_for_dev_replace, buf);
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, active_pending, dev->running_pending, buf);
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, nobarriers, dev->nobarriers, buf);
> +	BTRFS_DEV_GET_ATTR_D(&a->attr, devstats_valid, dev->dev_stats_valid, buf);
> +	if (dev->bdev)
> +		strcpy(bdev_state, "not_null");
> +	else
> +		strcpy(bdev_state, "null");
> +	BTRFS_DEV_GET_ATTR_STR(&a->attr, bdev, bdev_state, buf);
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
> +static umode_t btrfs_sysfs_visible_dev_attr(struct kobject *kobj,
> +				     struct attribute *attr, int unused)
> +{
> +	struct btrfs_fs_devices *fs_devs;
> +	struct btrfs_fs_info *fs_info;
> +
> +	fs_devs = to_btrfs_dev(kobj)->fs_devices;
> +	if (!fs_devs) {
> +		BUG_ON(fs_devs == NULL);
> +		return 0;
> +	}
> +	fs_info = fs_devs->fs_info;
> +
> +	/* if device is mounted then all is visible */
> +	if (fs_devs->opened && fs_info && !fs_info->closing)
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
> +	.is_visible = btrfs_sysfs_visible_dev_attr,
> +};
> +
> +void btrfs_sysfs_rm_device_attr(struct btrfs_device *dev)
> +{
> +	if (dev->dev_kobjp) {
> +		struct kobject *kobj = &dev->dev_kobjp->dev_kobj;
> +
> +		if (kobj->state_initialized) {
> +			sysfs_remove_group(kobj, &btrfs_dev_attr_group);
> +			kobject_del(kobj);
> +			kobject_put(kobj);
> +			wait_for_completion(&dev->dev_kobj_unregister);
> +			return;
> +		}
> +	}
> +	pr_warn("Btrfs: sysfs: dev destroy called for non init kobj\n");
> +	return;
> +}
> +
> +void btrfs_sysfs_rm_devices_attr(struct btrfs_fs_devices *fs_devs)
> +{
> +	struct btrfs_device *dev;
> +
> +	list_for_each_entry(dev, &fs_devs->devices, dev_list) {
> +		btrfs_sysfs_rm_device_attr(dev);
> +	}
> +}
> +
> +int btrfs_sysfs_add_device_attr(struct btrfs_device *dev)
> +{
> +	int rc;
> +	struct kobject *kobj;
> +
> +	if (!dev->dev_kobjp)
> +		dev->dev_kobjp = kzalloc(sizeof(struct btrfs_device_kobj),
> +								GFP_NOFS);
> +	else
> +		return -EEXIST;
> +
> +	if (!dev->dev_kobjp)
> +		return -ENOMEM;
> +
> +	dev->dev_kobjp->device = dev;
> +	kobj = &dev->dev_kobjp->dev_kobj;
> +
> +	init_completion(&dev->dev_kobj_unregister);
> +
> +	if (dev->name) {
> +		char *sdname;
> +		sdname = strrchr(rcu_str_deref(dev->name), '/');
> +		sdname++;
> +
> +		rc = kobject_init_and_add(kobj, &btrfs_dev_ktype,
> +				dev->fs_devices->device_dir_kobj,
> +				"%llu-%s", dev->devid, sdname);
> +	} else {
> +		rc = kobject_init_and_add(kobj, &btrfs_dev_ktype,
> +				dev->fs_devices->device_dir_kobj,
> +				"%llu", dev->devid);
> +	}
> +	if (!rc)
> +		rc = sysfs_create_group(kobj, &btrfs_dev_attr_group);
> +
> +	return rc;
> +}
> +
> +void btrfs_sysfs_add_devices_attr(struct btrfs_fs_devices *fs_devs)
> +{
> +	struct btrfs_device *dev;
> +
> +	list_for_each_entry(dev, &fs_devs->devices, dev_list) {
> +		if (btrfs_sysfs_add_device_attr(dev))
> +			printk(KERN_WARNING "BTRFS: create dev sysfs failed\n");
> +	}
> +}
> +
> +static int btrfs_sysfs_update_device_attr(struct btrfs_device *dev)
> +{
> +	struct kobject *kobj = &dev->dev_kobjp->dev_kobj;
> +
> +	if (!kobj)
> +		return -EINVAL;
> +
> +	return sysfs_update_group(kobj, &btrfs_dev_attr_group);
> +}
> +
> +static int btrfs_sysfs_update_devices_attr(struct btrfs_fs_devices *fs_devs)
> +{
> +	int rc;
> +	struct btrfs_device *dev;
> +
> +	list_for_each_entry(dev, &fs_devs->devices, dev_list) {
> +		if (!dev->dev_kobjp)
> +			continue;
> +		rc = btrfs_sysfs_update_device_attr(dev);
> +		if (rc) {
> +			pr_warn("BTRFS: update dev sysfs failed\n");
> +			return rc;
> +		}
> +	}
> +	return 0;
> +}
> +
> +int btrfs_sysfs_update_fsid_devices_attr(struct btrfs_fs_devices *fs_devs,
> +							int follow_seed)
> +{
> +	int rc;
> +
> +again_for_seeds:
> +	rc = btrfs_sysfs_update_fsid_attr(fs_devs);
> +	rc = btrfs_sysfs_update_devices_attr(fs_devs);
> +
> +	if (follow_seed && fs_devs->seed) {
> +		fs_devs = fs_devs->seed;
> +		goto again_for_seeds;
> +	}
> +
> +	return rc;
>  }
> diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
> index 0a592f2..29e96b9 100644
> --- a/fs/btrfs/sysfs.h
> +++ b/fs/btrfs/sysfs.h
> @@ -87,12 +87,20 @@ int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
>  int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
>                  struct btrfs_device *one_device, int follow_seed);
>  int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
> -				struct kobject *parent, int follow_seed);
> +					struct kobject *parent);
>  void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
> -int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs, int follow_seed);
> +int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs);
>  int btrfs_sysfs_add_seed_dir(struct btrfs_fs_devices *fs_devs);
>  void btrfs_sysfs_rm_seed_dir(struct btrfs_fs_devices *fs_devs);
>  void btrfs_sysfs_prepare_sprout(struct btrfs_fs_devices *fs_devices,
>  				struct btrfs_fs_devices *seed_devices,
>  				struct btrfs_fs_devices *old_devices);
> +int btrfs_sysfs_add_device_attr(struct btrfs_device *dev);
> +void btrfs_sysfs_rm_device_attr(struct btrfs_device *dev);
> +void btrfs_sysfs_add_devices_attr(struct btrfs_fs_devices *fs_devs);
> +void btrfs_sysfs_rm_devices_attr(struct btrfs_fs_devices *fs_devs);
> +int btrfs_sysfs_add_fsid_attr(struct btrfs_fs_devices *fs_devs);
> +void btrfs_sysfs_rm_fsid_attr(struct btrfs_fs_devices *fs_devs);
> +int btrfs_sysfs_update_fsid_devices_attr(struct btrfs_fs_devices *fs_devs,
> +							int follow_seed);
>  #endif /* _BTRFS_SYSFS_H_ */
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e93daec..b2ddc6d 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -491,6 +491,7 @@ void btrfs_free_stale_device(struct btrfs_device *cur_dev)
>  				free_fs_devices(fs_devs);
>  			} else {
>  				fs_devs->num_devices--;
> +				btrfs_sysfs_rm_device_attr(dev);
>  				list_del(&dev->dev_list);
>  				rcu_string_free(dev->name);
>  				kfree(dev);
> @@ -528,9 +529,9 @@ static noinline int device_list_add(const char *path,
>  		list_add(&fs_devices->list, &fs_uuids);
>
>  		device = NULL;
> -		if (btrfs_sysfs_add_fsid(fs_devices, NULL, 0))
> +		if (btrfs_sysfs_add_fsid(fs_devices, NULL))
>  			printk(KERN_WARNING "Btrfs: sysfs add fsid failed\n");
> -		if (btrfs_sysfs_add_device(fs_devices, 0))
> +		if (btrfs_sysfs_add_device(fs_devices))
>  			printk(KERN_WARNING "Btrfs: sysfs add device failed\n");
>  	} else {
>  		device = __find_device(&fs_devices->devices, devid,
> @@ -562,6 +563,10 @@ static noinline int device_list_add(const char *path,
>
>  		ret = 1;
>  		device->fs_devices = fs_devices;
> +
> +		if (btrfs_sysfs_add_device_attr(device))
> +			pr_warn("Btrfs: sysfs create dev failed\n");
> +
>  	} else if (!device->name || strcmp(device->name->str, path)) {
>  		/*
>  		 * When FS is already mounted.
> @@ -1765,6 +1770,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
>  		/* remove sysfs entry */
>  		btrfs_sysfs_rm_device_link(root->fs_info->fs_devices, device, 0);
>  	}
> +	btrfs_sysfs_rm_device_attr(device);
>
>  	call_rcu(&device->rcu, free_device);
>
> @@ -2260,6 +2266,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
>
>  	/* add sysfs device entry */
>  	btrfs_sysfs_add_device_link(root->fs_info->fs_devices, device, 0);
> +	btrfs_sysfs_add_device_attr(device);
>
>  	/*
>  	 * we've got more storage, clear any full flags on the space
> @@ -5961,6 +5968,8 @@ static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
>  	device->missing = 1;
>  	fs_devices->missing_devices++;
>
> +	btrfs_sysfs_add_device_attr(device);
> +
>  	return device;
>  }
>
> @@ -6181,6 +6190,31 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_root *root,
>  	fs_devices->seed = root->fs_info->fs_devices->seed;
>  	root->fs_info->fs_devices->seed = fs_devices;
>
> +	if (!root->fs_info->fs_devices->fsid_kobj.state_initialized) {
> +		pr_err("BTRFS: sysfs base fsid uninitialized\n");
> +		goto out;
> +	}
> +
> +	btrfs_sysfs_add_seed_dir(root->fs_info->fs_devices);
> +	ret = btrfs_sysfs_add_fsid(fs_devices,
> +				root->fs_info->fs_devices->seed_dir_kobj);
> +	if (!ret || ret == -EEXIST) {
> +		if (fs_devices->seed) {
> +			btrfs_sysfs_add_seed_dir(fs_devices);
> +			if (kobject_move(&fs_devices->seed->fsid_kobj,
> +						fs_devices->seed_dir_kobj))
> +				pr_warn("Btrfs: sysfs: kobj move failed for seed\n");
> +		}
> +
> +		ret = btrfs_sysfs_add_device(fs_devices);
> +		if (ret)
> +			pr_err("BTRFS: failed to init sysfs device dir: %d\n", ret);
> +
> +		btrfs_sysfs_add_devices_attr(fs_devices);
> +	} else {
> +		pr_err("BTRFS: failed to init sysfs fsid: %d\n", ret);
> +	}
> +
>  out:
>  	return fs_devices;
>  }
> @@ -6808,5 +6842,12 @@ void btrfs_close_one_device(struct btrfs_device *device)
>  	list_replace_rcu(&device->dev_list, &new_device->dev_list);
>  	new_device->fs_devices = device->fs_devices;
>
> +	if (device->dev_kobjp) {
> +		new_device->dev_kobjp = device->dev_kobjp;
> +		new_device->dev_kobjp->device = new_device;
> +		device->dev_kobjp = NULL;
> +	}
> +	init_completion(&new_device->dev_kobj_unregister);
> +
>  	call_rcu(&device->rcu, free_device);
>  }
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index 4150d9d..f431ae6 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -47,6 +47,11 @@ struct btrfs_pending_bios {
>  #define btrfs_device_data_ordered_init(device) do { } while (0)
>  #endif
>
> +struct btrfs_device_kobj {
> +	struct kobject dev_kobj;
> +	struct btrfs_device *device;
> +};
> +
>  struct btrfs_device {
>  	struct list_head dev_list;
>  	struct list_head dev_alloc_list;
> @@ -150,6 +155,9 @@ struct btrfs_device {
>  	/* Counter to record the change of device stats */
>  	atomic_t dev_stats_ccnt;
>  	atomic_t dev_stat_values[BTRFS_DEV_STAT_VALUES_MAX];
> +
> +	struct btrfs_device_kobj *dev_kobjp;
> +	struct completion dev_kobj_unregister;
>  };
>
>  /*
> @@ -260,6 +268,8 @@ struct btrfs_fs_devices {
>  	struct kobject fsid_kobj;
>  	struct kobject *device_dir_kobj;
>  	struct completion kobj_unregister;
> +
> +	long unsigned int state;
>  };
>
>  #define BTRFS_BIO_INLINE_CSUM_SIZE	64
>
