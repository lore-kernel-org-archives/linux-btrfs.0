Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60793 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750853AbdGNITg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 04:19:36 -0400
Subject: Re: [PATCH v4 1/6] btrfs: Introduce a function to check if all chunks
 a OK for degraded rw mount
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: ahferroin7@gmail.com, kilobyte@angband.pl, demfloro@demfloro.ru,
        Anand Jain <anand.jain@oracle.com>
References: <20170628054335.18806-1-quwenruo@cn.fujitsu.com>
 <20170628054335.18806-2-quwenruo@cn.fujitsu.com>
 <aebaca38-e283-17bf-c488-bb0d3ac96876@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ff9f521c-8a4b-3b15-47ab-db49ef3fde97@gmx.com>
Date: Fri, 14 Jul 2017 16:19:07 +0800
MIME-Version: 1.0
In-Reply-To: <aebaca38-e283-17bf-c488-bb0d3ac96876@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年07月14日 15:44, Nikolay Borisov wrote:
> 
> 
> On 28.06.2017 08:43, Qu Wenruo wrote:
>> Introduce a new function, btrfs_check_rw_degradable(), to check if all
>> chunks in btrfs is OK for degraded rw mount.
>>
>> It provides the new basis for accurate btrfs mount/remount and even
>> runtime degraded mount check other than old one-size-fit-all method.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/volumes.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/btrfs/volumes.h |  1 +
>>   2 files changed, 59 insertions(+)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index c95f018d4a1e..7a72fbdb8262 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -6817,6 +6817,64 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
>>   	return -EIO;
>>   }
>>   
>> +/*
>> + * Check if all chunks in the fs is OK for read-write degraded mount
>> + *
>> + * Return true if all chunks meet the minimal RW mount requirement.
>> + * Return false if any chunk doesn't meet the minimal RW mount requirement.
>> + */
>> +bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info)
>> +{
>> +	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>> +	struct extent_map *em;
>> +	u64 next_start = 0;
>> +	bool ret = true;
>> +
>> +	read_lock(&map_tree->map_tree.lock);
>> +	em = lookup_extent_mapping(&map_tree->map_tree, 0, (u64)-1);
>> +	read_unlock(&map_tree->map_tree.lock);
>> +	/* No chunk at all? Return false anyway */
>> +	if (!em) {
>> +		ret = false;
>> +		goto out;
>> +	}
>> +	while (em) {
>> +		struct map_lookup *map;
>> +		int missing = 0;
>> +		int max_tolerated;
>> +		int i;
>> +
>> +		map = em->map_lookup;
>> +		max_tolerated =
>> +			btrfs_get_num_tolerated_disk_barrier_failures(
>> +					map->type);
>> +		for (i = 0; i < map->num_stripes; i++) {
>> +			struct btrfs_device *dev = map->stripes[i].dev;
>> +
>> +			if (!dev || !dev->bdev || dev->missing ||
>> +			    dev->last_flush_error)
>> +				missing++;
>> +		}
>> +		if (missing > max_tolerated) {
>> +			ret = false;
>> +			btrfs_warn(fs_info,
>> +	"chunk %llu missing %d devices, max tolerance is %d for writeble mount",
>> +				   em->start, missing, max_tolerated);
>> +			free_extent_map(em);
>> +			goto out;
>> +		}
>> +		next_start = extent_map_end(em);
>> +		free_extent_map(em);
>> +
>> +		read_lock(&map_tree->map_tree.lock);
>> +		em = lookup_extent_mapping(&map_tree->map_tree, next_start,
>> +					   (u64)(-1) - next_start);
>> +		read_unlock(&map_tree->map_tree.lock);
>> +	}
>> +out:
>> +	return ret;
>> +}
>> +
> 
> Nit but I think in this function it would be best to directly return
> true/false based on context rather than having the superfluous goto.

Right, the goto out is not necessary as it's original design to handle 
extent map unlock.
But the final patch uses the current method to free extent map.

Indeed just returning true and false will be better, but goto out also 
seems fine to me.

Thanks,
Qu

> 
>>   int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
>>   {
>>   	struct btrfs_root *root = fs_info->chunk_root;
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 6f45fd60d15a..a5897c7a7e86 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -543,4 +543,5 @@ struct list_head *btrfs_get_fs_uuids(void);
>>   void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
>>   void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
>>   
>> +bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info);
>>   #endif
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
