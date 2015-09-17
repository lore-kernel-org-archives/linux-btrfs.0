Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35803 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbbIQJiv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 05:38:51 -0400
Message-ID: <55FA89CE.4040005@oracle.com>
Date: Thu, 17 Sep 2015 17:37:18 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Do per-chunk degrade mode check at mount time
References: <1442375031-18212-1-git-send-email-quwenruo@cn.fujitsu.com> <55FA1BD5.7020400@cn.fujitsu.com>
In-Reply-To: <55FA1BD5.7020400@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi Qu,

On 09/17/2015 09:48 AM, Qu Wenruo wrote:
> To Anand Jain,
>
> Any feedback on this method to allow single chunk still be degraded
> mountable?
>
> It should be much better than allowing degraded mount for any missing
> device case.

yeah. this changes the way missing devices are counted and its more fine 
grained. makes sense to me.


> Thanks,
> Qu
>
> Qu Wenruo wrote on 2015/09/16 11:43 +0800:
>> Btrfs supports different raid profile for meta/data/sys, and as
>> different profile support different tolerated missing device, it's
>> better to check if it can be mounted degraded at a per-chunk base.
>>
>> So this patch will add check for read_one_chunk() against its profile,
>> other than checking it against with the lowest duplication profile.
>>
>> Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> Reported-by: Anand Jain <anand.jain@oracle.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   fs/btrfs/volumes.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 644e070..3272187 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -6164,12 +6164,15 @@ static int read_one_chunk(struct btrfs_root
>> *root, struct btrfs_key *key,
>>                 struct btrfs_chunk *chunk)
>>   {
>>       struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
>> +    struct super_block *sb = root->fs_info->sb;
>>       struct map_lookup *map;
>>       struct extent_map *em;
>>       u64 logical;
>>       u64 length;
>>       u64 devid;
>>       u8 uuid[BTRFS_UUID_SIZE];
>> +    int missing = 0;
>> +    int max_tolerated;
>>       int num_stripes;
>>       int ret;
>>       int i;
>> @@ -6238,7 +6241,21 @@ static int read_one_chunk(struct btrfs_root
>> *root, struct btrfs_key *key,
>>               btrfs_warn(root->fs_info, "devid %llu uuid %pU is missing",
>>                           devid, uuid);
>>           }
>> +        if (map->stripes[i].dev->missing)
>> +            missing++;
>>           map->stripes[i].dev->in_fs_metadata = 1;
>> +
>> +    }
>> +
>> +    /* XXX: Why the function name is SO LOOOOOOOOOOOOOOOOONG?! */
>> +    max_tolerated =
>> +        btrfs_get_num_tolerated_disk_barrier_failures(map->type);
>> +    if (missing > max_tolerated && !(sb->s_flags & MS_RDONLY)) {
>> +        free_extent_map(em);
>> +        btrfs_error(root->fs_info, -EIO,
>> +            "missing device(%d) exceeds the limit(%d), writeable
>> mount is not allowed\n",

  \n is not required.

Thanks, Anand

>> +            missing, max_tolerated);
>> +        return -EIO;
>>       }
>>
>>       write_lock(&map_tree->map_tree.lock);
>>
