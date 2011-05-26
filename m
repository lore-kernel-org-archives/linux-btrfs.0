From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v1 3/5] btrfs: initial readahead code and prototypes
Date: Thu, 26 May 2011 18:47:07 +0800
Message-ID: <4DDE2FAB.5060906@cn.fujitsu.com>
References: <cover.1306154794.git.sensille@gmx.net> <320563549be689389d99d47d396290547db94982.1306154794.git.sensille@gmx.net> <20110526101421.GX12709@twin.jikos.cz>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Arne Jansen <sensille@gmx.net>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110526101421.GX12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 26 May 2011 12:14:21 +0200, David Sterba wrote:
> Hi,
> 
> On Mon, May 23, 2011 at 02:59:06PM +0200, Arne Jansen wrote:
>> +static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
>> +					  struct btrfs_device *dev, u64 logical,
>> +					  struct btrfs_multi_bio *multi)
>> +{
>> +	int ret;
>> +	int looped = 0;
>> +	struct reada_zone *zone;
>> +	struct btrfs_block_group_cache *cache = NULL;
>> +	u64 start;
>> +	u64 end;
>> +	int i;
>> +
>> +again:
>> +	zone = NULL;
>> +	spin_lock(&fs_info->reada_lock);
>> +	ret = radix_tree_gang_lookup(&dev->reada_zones, (void **)&zone,
>> +				     logical >> PAGE_CACHE_SHIFT, 1);
>> +	if (ret == 1)
>> +		kref_get(&zone->refcnt);
>> +	spin_unlock(&fs_info->reada_lock);
>> +
>> +	if (ret == 1) {
>> +		if (logical >= zone->start && logical < zone->end)
>> +			return zone;
>> +		spin_lock(&fs_info->reada_lock);
>> +		reada_zone_put(zone);
>> +		spin_unlock(&fs_info->reada_lock);
>> +	}
>> +
>> +	if (looped)
>> +		return NULL;
>> +
>> +	cache = btrfs_lookup_block_group(fs_info, logical);
>> +	if (!cache)
>> +		return NULL;
>> +
>> +	start = cache->key.objectid;
>> +	end = start + cache->key.offset - 1;
>> +	btrfs_put_block_group(cache);
>> +
>> +	zone = kzalloc(sizeof(*zone), GFP_NOFS);
>> +	if (!zone)
>> +		return NULL;
>> +
>> +	zone->start = start;
>> +	zone->end = end;
>> +	INIT_LIST_HEAD(&zone->list);
>> +	spin_lock_init(&zone->lock);
>> +	zone->locked = 0;
>> +	kref_init(&zone->refcnt);
>> +	zone->elems = 0;
>> +	zone->device = dev; /* our device always sits at index 0 */
>> +	for (i = 0; i < multi->num_stripes; ++i) {
>> +		/* bounds have already been checked */
>> +		zone->devs[i] = multi->stripes[i].dev;
>> +	}
>> +	zone->ndevs = multi->num_stripes;
>> +
>> +	spin_lock(&fs_info->reada_lock);
>> +	ret = radix_tree_insert(&dev->reada_zones,
>> +				(unsigned long)zone->end >> PAGE_CACHE_SHIFT,
>> +				zone);
> 
> this can sleep inside a spinlock, you initialize the radix tree with
> GFP_NOFS, which allows __GFP_WAIT.
> 
> Options:
> 1) use GFP_ATOMIC in radix tree init flags
> 2) do the radix_tree_preload/radix_tree_preload_end, GFP_NOFS outside of the
> locked section is ok but __GFP_WAIT has to be masked out (else radix
> tree insert will not use the preloaded node)
> 3) unmask __GFP_WAIT from radix tree init flags
> 
> I'd go for 3, as the atomic context is not required, and is easier
> than 2 to implement.

I like the second one, because it is the general way to fix this problem.

BTW: I think we can use RCU to protect the radix tree on the read side.
Arne, how do you think about?

Thanks
Miao

> 
>> +	spin_unlock(&fs_info->reada_lock);
>> +
>> +	if (ret) {
>> +		kfree(zone);
>> +		looped = 1;
>> +		goto again;
>> +	}
>> +
>> +	return zone;
>> +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

