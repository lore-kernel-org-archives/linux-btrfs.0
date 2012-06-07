Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:26144 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2FGMfw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2012 08:35:52 -0400
Message-ID: <4FD0A02B.1020009@giantdisaster.de>
Date: Thu, 07 Jun 2012 14:35:55 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 2/3] Btrfs-progs: make two utility functions globally
 available
References: <1337954838-10140-1-git-send-email-sbehrens@giantdisaster.de> <1337954838-10140-3-git-send-email-sbehrens@giantdisaster.de> <20120606181626.GR15986@carfax.org.uk>
In-Reply-To: <20120606181626.GR15986@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 6 Jun 2012 19:16:26 +0100, Hugo Mills wrote:
> On Fri, May 25, 2012 at 04:07:17PM +0200, Stefan Behrens wrote:
>> Two convenient utility functions that have so far been local to scrub are
>> moved to utils.c.
>> They will be used in the device stats code in a following commit.
>>
> [snip]
>> -
>> -static int scrub_fs_info(int fd, char *path,
>> -				struct btrfs_ioctl_fs_info_args *fi_args,
>> -				struct btrfs_ioctl_dev_info_args **di_ret)
>> -{
>> -	int ret = 0;
>> -	int ndevs = 0;
>> -	int i = 1;
>> -	struct btrfs_fs_devices *fs_devices_mnt = NULL;
>> -	struct btrfs_ioctl_dev_info_args *di_args;
>> -	char mp[BTRFS_PATH_NAME_MAX + 1];
>> -
>> -	memset(fi_args, 0, sizeof(*fi_args));
>> -
>> -	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
>> -	if (ret && errno == EINVAL) {
> 
>    what's removed here...
> 
>> -		/* path is no mounted btrfs. try if it's a device */
>> -		ret = check_mounted_where(fd, path, mp, sizeof(mp),
>> -						&fs_devices_mnt);
>> -		if (!ret)
>> -			return -EINVAL;
>> -		if (ret < 0)
>> -			return ret;
>> -		fi_args->num_devices = 1;
>> -		fi_args->max_id = fs_devices_mnt->latest_devid;
>> -		i = fs_devices_mnt->latest_devid;
>> -		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
>> -		close(fd);
>> -		fd = open_file_or_dir(mp);
>> -		if (fd < 0)
>> -			return -errno;
>> -	} else if (ret) {
>> -		return -errno;
>> -	}
>> -
>> -	if (!fi_args->num_devices)
>> -		return 0;
>> -
>> -	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
>> -	if (!di_args)
>> -		return -errno;
>> -
>> -	for (; i <= fi_args->max_id; ++i) {
>> -		BUG_ON(ndevs >= fi_args->num_devices);
>> -		ret = scrub_device_info(fd, i, &di_args[ndevs]);
>> -		if (ret == -ENODEV)
>> -			continue;
>> -		if (ret)
>> -			return ret;
>> -		++ndevs;
>> -	}
> 
> [snip]
> 
>> diff --git a/utils.c b/utils.c
>> index 6157115..037f64b 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -1233,3 +1233,69 @@ int open_file_or_dir(const char *fname)
>>  	return fd;
>>  }
>>  
>> +int get_device_info(int fd, u64 devid,
>> +		    struct btrfs_ioctl_dev_info_args *di_args)
>> +{
>> +	int ret;
>> +
>> +	di_args->devid = devid;
>> +	memset(&di_args->uuid, '\0', sizeof(di_args->uuid));
>> +
>> +	ret = ioctl(fd, BTRFS_IOC_DEV_INFO, di_args);
>> +	return ret ? -errno : 0;
>> +}
>> +
>> +int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>> +		struct btrfs_ioctl_dev_info_args **di_ret)
>> +{
>> +	int ret = 0;
>> +	int ndevs = 0;
>> +	int i = 1;
>> +	struct btrfs_fs_devices *fs_devices_mnt = NULL;
>> +	struct btrfs_ioctl_dev_info_args *di_args;
>> +	char mp[BTRFS_PATH_NAME_MAX + 1];
>> +
>> +	memset(fi_args, 0, sizeof(*fi_args));
>> +
>> +	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
>> +	if (ret && (errno == EINVAL || errno == ENOTTY)) {
> 
>    ... isn't what's added here. (And the same for the function name).
> It's possibly a minor point, but I did end up having to do a diff with
> a Mark-I eyeball just to get a merge of this code right.
> 
>    Hugo.

Your displeasure with these "hidden" changes is understood. Thanks!


> 
>> +		/* path is not a mounted btrfs. Try if it's a device */
>> +		ret = check_mounted_where(fd, path, mp, sizeof(mp),
>> +					  &fs_devices_mnt);
>> +		if (!ret)
>> +			return -EINVAL;
>> +		if (ret < 0)
>> +			return ret;
>> +		fi_args->num_devices = 1;
>> +		fi_args->max_id = fs_devices_mnt->latest_devid;
>> +		i = fs_devices_mnt->latest_devid;
>> +		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
>> +		close(fd);
>> +		fd = open_file_or_dir(mp);
>> +		if (fd < 0)
>> +			return -errno;
>> +	} else if (ret) {
>> +		return -errno;
>> +	}
>> +
>> +	if (!fi_args->num_devices)
>> +		return 0;
>> +
>> +	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
>> +	if (!di_args)
>> +		return -errno;
>> +
>> +	for (; i <= fi_args->max_id; ++i) {
>> +		BUG_ON(ndevs >= fi_args->num_devices);
>> +		ret = get_device_info(fd, i, &di_args[ndevs]);
>> +		if (ret == -ENODEV)
>> +			continue;
>> +		if (ret)
>> +			return ret;
>> +		ndevs++;
>> +	}
>> +
>> +	BUG_ON(ndevs == 0);
>> +
>> +	return 0;
>> +}
>> diff --git a/utils.h b/utils.h
>> index e281002..e33c231 100644
>> --- a/utils.h
>> +++ b/utils.h
>> @@ -49,4 +49,8 @@ int get_mountpt(char *dev, char *mntpt, size_t size);
>>  
>>  int btrfs_scan_block_devices(int run_ioctl);
>>  int open_file_or_dir(const char *fname);
>> +int get_device_info(int fd, u64 devid,
>> +		    struct btrfs_ioctl_dev_info_args *di_args);
>> +int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>> +		struct btrfs_ioctl_dev_info_args **di_ret);
>>  #endif
> 
