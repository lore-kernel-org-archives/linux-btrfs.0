Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48800 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964816AbdIYNJh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 09:09:37 -0400
Subject: Re: [PATCH 2/3] btrfs: cleanup btrfs_init_new_device()
From: Nikolay Borisov <nborisov@suse.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170925123104.16526-1-anand.jain@oracle.com>
 <20170925123104.16526-3-anand.jain@oracle.com>
 <6af9ec03-712a-d78e-6ad5-f4aff0f0dd61@suse.com>
Message-ID: <bbd6b15b-146a-9373-7242-f69a69bd0c4f@suse.com>
Date: Mon, 25 Sep 2017 16:09:35 +0300
MIME-Version: 1.0
In-Reply-To: <6af9ec03-712a-d78e-6ad5-f4aff0f0dd61@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.09.2017 16:07, Nikolay Borisov wrote:
> 
> 
> On 25.09.2017 15:31, Anand Jain wrote:
>> Moves btrfs_abort_transaction() to the error goto and renames
>> error_trans to error_sysfs. This is a preparatory patch to
>> remove the BUG_ON() in btrfs_init_new_device().
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>  fs/btrfs/volumes.c | 23 +++++++++--------------
>>  1 file changed, 9 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 9d64700cc9b6..5c34eea9d12d 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -2443,26 +2443,20 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>>  		mutex_lock(&fs_info->chunk_mutex);
>>  		ret = init_first_rw_device(trans, fs_info);
>>  		mutex_unlock(&fs_info->chunk_mutex);
>> -		if (ret) {
>> -			btrfs_abort_transaction(trans, ret);
>> -			goto error_trans;
>> -		}
>> +		if (ret)
>> +			goto error_sysfs;
>>  	}
>>  
>>  	ret = btrfs_add_device(trans, fs_info, device);
>> -	if (ret) {
>> -		btrfs_abort_transaction(trans, ret);
>> -		goto error_trans;
>> -	}
>> +	if (ret)
>> +		goto error_sysfs;
>>  
>>  	if (seeding_dev) {
>>  		char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
>>  
>>  		ret = btrfs_finish_sprout(trans, fs_info);
>> -		if (ret) {
>> -			btrfs_abort_transaction(trans, ret);
>> -			goto error_trans;
>> -		}
>> +		if (ret)
>> +			goto error_sysfs;
>>  
>>  		/* Sprouting would change fsid of the mounted root,
>>  		 * so rename the fsid on the sysfs
>> @@ -2500,12 +2494,13 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>>  	update_dev_time(device_path);
>>  	return ret;
>>  
>> -error_trans:
>> +error_sysfs:
>> +	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
> 
> Any reason why you move btrfs_sysfs_rm_device_link?
> 
>>  	if (seeding_dev)
>>  		sb->s_flags |= MS_RDONL> +	btrfs_abort_transaction(trans, ret);
>>  	btrfs_end_transaction(trans);
>>  	rcu_string_free(device->name);
>> -	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
>>  	kfree(device);>  error:
>>  	blkdev_put(bdev, FMODE_EXCL);
> 
> Also which branch is your code based on since in Linus' master the error
> handling (before your patch) looks a bit different. E.g. the MS_RDONL
> stuff look wrong.
> 
> error_trans:
> 
>         btrfs_end_transaction(trans);
> 
>         rcu_string_free(device->name);
> 
>         btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
> 
>         kfree(device);
> 
> error:
> 
>         blkdev_put(bdev, FMODE_EXCL);
> 
>         if (seeding_dev) {
> 
>                 mutex_unlock(&uuid_mutex);
> 
>                 up_write(&sb->s_umount);
> 
>         }
> 
>         return ret;

Ok, turned out I hadn't received 1/3 so this answers this question. The
sysfs rm stands though


> 
>>
