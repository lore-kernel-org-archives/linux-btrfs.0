Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17614 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaBZCHM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 21:07:12 -0500
Message-ID: <530D4C3E.2090607@oracle.com>
Date: Wed, 26 Feb 2014 10:06:54 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: latest_devid is not always the probed
 devid
References: <1393242219-18525-1-git-send-email-Anand.Jain@oracle.com> <1393242219-18525-2-git-send-email-Anand.Jain@oracle.com> <20140225172709.GZ16073@twin.jikos.cz>
In-Reply-To: <20140225172709.GZ16073@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26/02/2014 01:27, David Sterba wrote:
> On Mon, Feb 24, 2014 at 07:43:38PM +0800, Anand Jain wrote:
>> @@ -1646,6 +1646,11 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>>   	memset(fi_args, 0, sizeof(*fi_args));
>>
>>   	if (is_block_device(path)) {
>> +
>> +		struct btrfs_super_block *disk_super;
>> +		char *buf;
>> +		u64 devid;
>> +
>>   		/* Ensure it's mounted, then set path to the mountpoint */
>>   		fd = open(path, O_RDONLY);
>>   		if (fd < 0) {
>> @@ -1665,8 +1670,23 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>>   		path = mp;
>>   		/* Only fill in this one device */
>>   		fi_args->num_devices = 1;
>> -		fi_args->max_id = fs_devices_mnt->latest_devid;
>> -		i = fs_devices_mnt->latest_devid;
>> +
>> +		buf = malloc(4096);
>> +		if (!buf) {
>> +			ret = -ENOMEM;
>> +			goto out;
>> +		}
>> +		disk_super = (struct btrfs_super_block *)buf;
>> +		ret = btrfs_read_dev_super(fd, disk_super, BTRFS_SUPER_INFO_OFFSET);
>> +		if (ret < 0) {
>> +			ret = -EIO;
>> +			goto out;
>> +		}
>> +		devid = btrfs_stack_device_id(&disk_super->dev_item);
>> +
>> +		fi_args->max_id = devid;
>> +		i = devid;
>> +
>>   		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
>>   		close(fd);
>
> This is leaking memory, but as this is userspace code we can use the
> staack for the superblock. I've committed this with the following fixup:

  oh no my bad. thanks for the catch.



> --- a/utils.c
> +++ b/utils.c
> @@ -1680,7 +1680,7 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>          if (is_block_device(path)) {
>
>                  struct btrfs_super_block *disk_super;
> -               char *buf;
> +               char buf[BTRFS_SUPER_INFO_SIZE];
>                  u64 devid;
>
>                  /* Ensure it's mounted, then set path to the mountpoint */
> @@ -1703,11 +1703,6 @@ int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>                  /* Only fill in this one device */
>                  fi_args->num_devices = 1;
>
> -               buf = malloc(4096);
> -               if (!buf) {
> -                       ret = -ENOMEM;
> -                       goto out;
> -               }
>                  disk_super = (struct btrfs_super_block *)buf;
>                  ret = btrfs_read_dev_super(fd, disk_super, BTRFS_SUPER_INFO_OFFSET);
>                  if (ret < 0) {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
