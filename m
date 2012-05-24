Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:5371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab2EXCKw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 22:10:52 -0400
Message-ID: <4FBD99C8.8090000@cn.fujitsu.com>
Date: Thu, 24 May 2012 10:15:36 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: resize all devices when we dont assign a specific
 device id
References: <1337256489-20887-1-git-send-email-liubo2009@cn.fujitsu.com> <1337256489-20887-2-git-send-email-liubo2009@cn.fujitsu.com> <4FBC73C6.5030708@libero.it>
In-Reply-To: <4FBC73C6.5030708@libero.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/23/2012 01:21 PM, Goffredo Baroncelli wrote:

> Hi
> 
> On 05/17/2012 02:08 PM, Liu Bo wrote:
>> This patch fixes two bugs:
>>
>> When we do not assigne a device id for the resizer,
>> - it will only take one device to resize, which is supposed to apply on
>>   all available devices.
>> - it will take 'id 1' device as default, and this will cause a bug as we
>>   may have removed the 'id 1' device from the filesystem.
>>
>> After this patch, we can find all available devices by searching the
>> chunk tree and resize them:
> 
> 
> I am not sure that this is a sane default for all resizing.
> 
> If the user want to resize to MAX, I agree that it is a sane default,
> but when the user want to shrink or enlarge of a fixed quantity, the
> user should specific the dev id. Because the shrinking and or the
> enlarging should be evaluated case by case.
> 
> My suggestion is to change the code at kernel level so in case of
> multi-volume file-system the user *has* to specify the device to shrink
> and/or enlarge.
> Should be the user space btrfs tool to handle the check and the growing
> (i.e: if the new size is max, automatically grow all the device up to
> max; otherwise the user should specific the device to shrink and/or
> enlarge).
> 


Hi,

It is quite easy to do what you expect, but IMO that will confuse users a lot...

With this patch, you can still assign a specific dev id to resize what you want :)

thanks,
liubo

> BR
> Goffredo
> 
> 
>> $ mkfs.btrfs /dev/sdb7
>> $ mount /dev/sdb7 /mnt/btrfs/
>> $ btrfs dev add /dev/sdb8 /mnt/btrfs/
>>
>> $ btrfs fi resize -100m /mnt/btrfs/
>> then we can get from dmesg:
>> btrfs: new size for /dev/sdb7 is 980844544
>> btrfs: new size for /dev/sdb8 is 980844544
>>
>> $ btrfs fi resize max /mnt/btrfs
>> then we can get from dmesg:
>> btrfs: new size for /dev/sdb7 is 1085702144
>> btrfs: new size for /dev/sdb8 is 1085702144
>>
>> $ btrfs fi resize 1:-100m /mnt/btrfs
>> then we can get from dmesg:
>> btrfs: resizing devid 1
>> btrfs: new size for /dev/sdb7 is 980844544
>>
>> $ btrfs fi resize 1:-100m /mnt/btrfs
>> then we can get from dmesg:
>> btrfs: resizing devid 2
>> btrfs: new size for /dev/sdb8 is 980844544
>>
>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
>> ---
>>  fs/btrfs/ioctl.c |  101 ++++++++++++++++++++++++++++++++++++++++++++----------
>>  1 files changed, 83 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index ec2245d..d9a4fa8 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -1250,12 +1250,51 @@ out_ra:
>>  	return ret;
>>  }
>>  
>> +static struct btrfs_device *get_avail_device(struct btrfs_root *root, u64 devid)
>> +{
>> +	struct btrfs_key key;
>> +	struct btrfs_path *path;
>> +	struct btrfs_dev_item *dev_item;
>> +	struct btrfs_device *device = NULL;
>> +	int ret;
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
>> +	key.offset = devid;
>> +	key.type = BTRFS_DEV_ITEM_KEY;
>> +
>> +	ret = btrfs_search_slot(NULL, root->fs_info->chunk_root, &key,
>> +				path, 0, 0);
>> +	if (ret < 0) {
>> +		device = ERR_PTR(ret);
>> +		goto out;
>> +	}
>> +	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>> +	if (key.objectid != BTRFS_DEV_ITEMS_OBJECTID ||
>> +	    key.type != BTRFS_DEV_ITEM_KEY) {
>> +		device = NULL;
>> +		goto out;
>> +	}
>> +	dev_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
>> +				  struct btrfs_dev_item);
>> +	devid = btrfs_device_id(path->nodes[0], dev_item);
>> +
>> +	device = btrfs_find_device(root, devid, NULL, NULL);
>> +out:
>> +	btrfs_free_path(path);
>> +	return device;
>> +}
>> +
>>  static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
>>  					void __user *arg)
>>  {
>> -	u64 new_size;
>> +	u64 new_size = 0;
>>  	u64 old_size;
>> -	u64 devid = 1;
>> +	u64 orig_new_size = 0;
>> +	u64 devid = (-1ULL);
>>  	struct btrfs_ioctl_vol_args *vol_args;
>>  	struct btrfs_trans_handle *trans;
>>  	struct btrfs_device *device = NULL;
>> @@ -1263,6 +1302,8 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
>>  	char *devstr = NULL;
>>  	int ret = 0;
>>  	int mod = 0;
>> +	int scan_all = 1;
>> +	int use_max = 0;
>>  
>>  	if (root->fs_info->sb->s_flags & MS_RDONLY)
>>  		return -EROFS;
>> @@ -1295,8 +1336,31 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
>>  		devid = simple_strtoull(devstr, &end, 10);
>>  		printk(KERN_INFO "btrfs: resizing devid %llu\n",
>>  		       (unsigned long long)devid);
>> +		scan_all = 0;
>>  	}
>> -	device = btrfs_find_device(root, devid, NULL, NULL);
>> +
>> +	if (!strcmp(sizestr, "max")) {
>> +		use_max = 1;
>> +	} else {
>> +		if (sizestr[0] == '-') {
>> +			mod = -1;
>> +			sizestr++;
>> +		} else if (sizestr[0] == '+') {
>> +			mod = 1;
>> +			sizestr++;
>> +		}
>> +		orig_new_size = memparse(sizestr, NULL);
>> +		if (orig_new_size == 0) {
>> +			ret = -EINVAL;
>> +			goto out_free;
>> +		}
>> +	}
>> +
>> +	if (devid < (-1ULL))
>> +		device = btrfs_find_device(root, devid, NULL, NULL);
>> +	else
>> +		device = get_avail_device(root, 0);
>> +again:
>>  	if (!device) {
>>  		printk(KERN_INFO "btrfs: resizer unable to find device %llu\n",
>>  		       (unsigned long long)devid);
>> @@ -1310,22 +1374,10 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
>>  		goto out_free;
>>  	}
>>  
>> -	if (!strcmp(sizestr, "max"))
>> +	if (use_max)
>>  		new_size = device->bdev->bd_inode->i_size;
>> -	else {
>> -		if (sizestr[0] == '-') {
>> -			mod = -1;
>> -			sizestr++;
>> -		} else if (sizestr[0] == '+') {
>> -			mod = 1;
>> -			sizestr++;
>> -		}
>> -		new_size = memparse(sizestr, NULL);
>> -		if (new_size == 0) {
>> -			ret = -EINVAL;
>> -			goto out_free;
>> -		}
>> -	}
>> +	else
>> +		new_size = orig_new_size;
>>  
>>  	old_size = device->total_bytes;
>>  
>> @@ -1365,7 +1417,20 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
>>  	} else if (new_size < old_size) {
>>  		ret = btrfs_shrink_device(device, new_size);
>>  	}
>> +	if (ret)
>> +		goto out_free;
>>  
>> +	if (scan_all) {
>> +		/* next available device */
>> +		device = get_avail_device(root, device->devid + 1);
>> +		if (!device)
>> +			goto out_free;
>> +		if (IS_ERR(device)) {
>> +			ret = PTR_ERR(device);
>> +			goto out_free;
>> +		}
>> +		goto again;
>> +	}
>>  out_free:
>>  	kfree(vol_args);
>>  out:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


