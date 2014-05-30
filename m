Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42588 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbaE3GHd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 02:07:33 -0400
Message-ID: <538820D4.3010808@oracle.com>
Date: Fri, 30 May 2014 14:10:28 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jeffm@suse.com, clm@fb.com
Subject: Re: [PATCH 1/4] btrfs: dev delete should remove sysfs entry
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com> <1401096626-13210-2-git-send-email-anand.jain@oracle.com> <20140529130428.GC29992@twin.jikos.cz>
In-Reply-To: <20140529130428.GC29992@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for the review David.

On 29/05/14 21:04, David Sterba wrote:
> On Mon, May 26, 2014 at 05:30:23PM +0800, Anand Jain wrote:
>> --- a/fs/btrfs/sysfs.c
>> +++ b/fs/btrfs/sysfs.c
>> @@ -572,6 +572,26 @@ static void init_feature_attrs(void)
>>   	}
>>   }
>>
>> +int rm_device_membership(struct btrfs_fs_info *fs_info,
>> +		struct btrfs_device *one_device)
>
> The name is too generic for a non-static function, so it would be good
> to add at least the btrfs_ prefix. Same applies to the change of
> 'add_device_membership' in the next patch.

  Yes indeed. I wanted it to change as well. But the diff became
  unfriendly to read.  I shall do that in a separate patch.


> As this is only a trivial change, consider this
> Reviewed-by: David Sterba <dsterba@suse.cz>
>
>> +{
>> +	struct hd_struct *disk;
>> +	struct kobject *disk_kobj;
>> +
>> +	if (!fs_info->device_dir_kobj)
>> +		return -EINVAL;
>> +
>> +	if (one_device) {
>> +		disk = one_device->bdev->bd_part;
>> +		disk_kobj = &part_to_dev(disk)->kobj;
>> +
>> +		sysfs_remove_link(fs_info->device_dir_kobj,
>> +						disk_kobj->name);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int add_device_membership(struct btrfs_fs_info *fs_info)
>>   {
>>   	int error = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
