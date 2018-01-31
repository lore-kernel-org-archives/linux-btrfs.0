Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41554 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbeAaJFT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 04:05:19 -0500
Subject: Re: [PATCH 1/2] btrfs: add mount option read_mirror_policy
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180130063020.14850-1-anand.jain@oracle.com>
 <20180130063020.14850-2-anand.jain@oracle.com>
 <f55fe4f5-cf50-d251-e147-3d6b6d20f496@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ad2a20c8-a049-2844-dc42-b1319f591141@oracle.com>
Date: Wed, 31 Jan 2018 17:06:34 +0800
MIME-Version: 1.0
In-Reply-To: <f55fe4f5-cf50-d251-e147-3d6b6d20f496@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/31/2018 04:06 PM, Nikolay Borisov wrote:

>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 1a462ab85c49..4759e988b0df 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1100,6 +1100,8 @@ struct btrfs_fs_info {
>>   	spinlock_t ref_verify_lock;
>>   	struct rb_root block_tree;
>>   #endif
>> +	/* Policy to balance read across mirrored devices */
>> +	int read_mirror_policy;
> 
> make that member enum btrfs_read_mirror_type

  yep. Will do.

::

>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index a61715677b67..39ba59832f38 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -5269,7 +5269,13 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
>>   	else
>>   		num = map->num_stripes;
>>   
>> -	optimal = first + current->pid % num;
>> +	switch(fs_info->read_mirror_policy) {
>> +	case BTRFS_READ_MIRROR_DEFAULT:
>> +	case BTRFS_READ_MIRROR_BY_PID:
>> +	default:
>> +		optimal = first + current->pid % num;
>> +		break;
>> +	}
> 
> Why not factor out this code in a separate function with descriptive
> name and some documentation. It seems you have plans how to extend this
> mechanism further so let's try and make it maintainable from the get-go.

   This is in fact restoring the original design, will add comments.
   In the long term we may have up couple of more choices (like LBA),
   will move it to a function.

Thanks, Anand
