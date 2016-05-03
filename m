Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32363 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbcECKBd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 06:01:33 -0400
Subject: Re: [PATCH v2] btrfs: cleanup assigning next active device with a
 check
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1460978752-27375-1-git-send-email-anand.jain@oracle.com>
 <1462143728-3000-1-git-send-email-anand.jain@oracle.com>
 <20160502152618.GK29353@suse.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <572876FB.4070208@oracle.com>
Date: Tue, 3 May 2016 18:01:31 +0800
MIME-Version: 1.0
In-Reply-To: <20160502152618.GK29353@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/02/2016 11:26 PM, David Sterba wrote:
> On Mon, May 02, 2016 at 07:02:08AM +0800, Anand Jain wrote:
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -569,11 +569,9 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>>   	ASSERT(list_empty(&src_device->resized_list));
>>   	tgt_device->commit_total_bytes = src_device->commit_total_bytes;
>>   	tgt_device->commit_bytes_used = src_device->bytes_used;
>> -	if (fs_info->sb->s_bdev &&
>> -		(fs_info->sb->s_bdev == src_device->bdev))
>> -		fs_info->sb->s_bdev = tgt_device->bdev;
>
> What's the base of this patch?

  It was on master. But now the V3 which is based on your for-next.

> The above code is not in my for-next so
> I could be missing some important bits.

  Yes. That was added by this patch.

  [PATCH] btrfs: s_bdev is not null after missing replace

  While here can also integrate this.

  [PATCH 1/1] btrfs: fix lock dep warning move scratch super outside of 
chunk_mutex

------
git status
On branch for-next
Your branch is ahead of 'origin/for-next' by 3 commits.
(use "git push" to publish your local commits)
nothing to commit, working directory clean

git log --oneline | head -n 3
ac3fd7a65d23 btrfs: cleanup assigning next active device with a check
0fbd788ec3d9 btrfs: s_bdev is not null after missing replace
8362f084ffd6 btrfs: fix lock dep warning move scratch super outside of 
chunk_mutex
-----

I have run xfstests on for-next I don't see any unusual failures.


Thanks,
Anand


>> -	if (fs_info->fs_devices->latest_bdev == src_device->bdev)
>> -		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
>> +
>> +	btrfs_assign_next_active_device(fs_info, src_device, tgt_device);
>> +
>>   	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
>>   	fs_info->fs_devices->rw_devices++;
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 5f70c1235466..0bb15da2da40 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1742,10 +1742,49 @@ out:
>>   	return ret;
>>   }
>>
>> +struct btrfs_device *btrfs_find_next_active_device(struct btrfs_fs_devices *fs_devs,
>> +					struct btrfs_device *device)
>> +{
>> +	struct btrfs_device *next_device;
>> +
>> +	list_for_each_entry(next_device, &fs_devs->devices, dev_list) {
>> +		if (next_device != device &&
>> +			!next_device->missing && next_device->bdev)
>> +			return next_device;
>> +	}
>> +	return NULL;
>> +}
>> +
>> +/*
>> + * Helper function to check if the given device is part of
>> + * s_bdev / latest_bdev and replace it with the provided or
>> + * the next active device, in the context where this function
>> + * called, there should be always be another device which is
>> + * active.
>> + */
>> +void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
>> +		struct btrfs_device *device, struct btrfs_device *this_dev)
>> +{
>> +	struct btrfs_device *next_device;
>> +
>> +	if (this_dev)
>> +		next_device = this_dev;
>> +	else
>> +		next_device = btrfs_find_next_active_device(fs_info->fs_devices,
>> +								device);
>> +	BUG_ON(!next_device); /* Logic error */
>
> Please make it an ASSERT.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
