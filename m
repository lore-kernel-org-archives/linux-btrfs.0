Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57545 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753056AbeBVJ1L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 04:27:11 -0500
Subject: Re: [RFC PATCH] btrfs: Speedup btrfs_read_block_groups()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
Cc: "Ellis H . Wilson III" <ellisw@panasas.com>
References: <20180222045215.16426-1-wqu@suse.com>
 <bc11f64d-5e5a-54d0-79c1-1459f3eb7c68@suse.com>
 <4ef8f699-fb40-2116-e640-540b79919412@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1dd70132-513a-c287-dab9-092229560524@suse.com>
Date: Thu, 22 Feb 2018 11:27:03 +0200
MIME-Version: 1.0
In-Reply-To: <4ef8f699-fb40-2116-e640-540b79919412@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.02.2018 11:23, Qu Wenruo wrote:
> 
> 
> [snip]
>>> -}
>>> -
>>>  void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
>>>  {
>>>  	struct btrfs_block_group_cache *block_group;
>>> @@ -9988,12 +9934,15 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>>>  {
>>>  	struct btrfs_path *path;
>>>  	int ret;
>>> +	struct btrfs_mapping_tree *map_tree = &info->mapping_tree;
>>> +	struct btrfs_root *extent_root = info->extent_root;
>>>  	struct btrfs_block_group_cache *cache;
>>>  	struct btrfs_space_info *space_info;
>>>  	struct btrfs_key key;
>>>  	struct btrfs_key found_key;
>>>  	struct extent_buffer *leaf;
>>>  	int need_clear = 0;
>>> +	u64 cur = 0;
>>>  	u64 cache_gen;
>>>  	u64 feature;
>>>  	int mixed;
>>> @@ -10001,13 +9950,9 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>>>  	feature = btrfs_super_incompat_flags(info->super_copy);
>>>  	mixed = !!(feature & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS);
>>>  
>>> -	key.objectid = 0;
>>> -	key.offset = 0;
>>> -	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
>>>  	path = btrfs_alloc_path();
>>>  	if (!path)
>>>  		return -ENOMEM;
>>> -	path->reada = READA_FORWARD;
>>>  
>>>  	cache_gen = btrfs_super_cache_generation(info->super_copy);
>>>  	if (btrfs_test_opt(info, SPACE_CACHE) &&
>>> @@ -10017,10 +9962,30 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>>>  		need_clear = 1;
>>>  
>>>  	while (1) {
>>> -		ret = find_first_block_group(info, path, &key);
>>> -		if (ret > 0)
>>> +		struct extent_map *em;
>>> +
>>> +		read_lock(&map_tree->map_tree.lock);
>>> +		em = lookup_extent_mapping(&map_tree->map_tree, cur,
>>> +					   ((u64)-1) - cur);
>>> +		read_unlock(&map_tree->map_tree.lock);
>>> +		if (!em)
>>>  			break;
>>> -		if (ret != 0)
>>> +
>>> +		key.objectid = em->start;
>>> +		key.offset = em->len;
>>> +		key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
>>> +		cur = em->start + em->len;
>>> +		free_extent_map(em);
>>> +
>>> +		ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
>>> +		if (ret > 0) {
>>> +			WARN(1, KERN_ERR
>>> +			"chunk [%llu %llu) doesn't has its block group item\n",
>>
>> I'd rephrase this to "chunk [%llu %llu) doesn't have matching block
>> group item"
> 
> Sounds good.
> 
> Sorry for my poor English.

No need to apologise neither of us is a native speaker :)

> 
>>
>>> +			     key.objectid, key.objectid + key.offset);
>>> +			ret = -ENOENT;
>>> +			goto error;
>>> +		}
>>
>> Looks good, howevr when the time for merging comes I'd rather have this
>> code be part of a function named find_block_group or some such. Let's
>> see if this code brings any improvements and then bikeshed on the details.
> 
> Isn't that the original find_first_block_group() function?

Yes but since you have removed it and you are not really looking for the
"first" block group but just looking for a block group then the new name
makes more sense and collects the code in one place.

> 
> Thanks,
> Qu
> 
>>
>>> +		if (ret < 0)
>>>  			goto error;
>>>  
>>>  		leaf = path->nodes[0];
>>> @@ -10062,7 +10027,6 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>>>  			goto error;
>>>  		}
>>>  
>>> -		key.objectid = found_key.objectid + found_key.offset;
>>>  		btrfs_release_path(path);
>>>  
>>>  		/*
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
