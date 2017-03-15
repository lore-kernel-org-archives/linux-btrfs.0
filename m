Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19269 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750805AbdCOCvk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 22:51:40 -0400
Subject: Re: [PATCH v2 1/7] Btrfs: create a helper for getting chunk map
To: <bo.li.liu@oracle.com>
References: <1489523641-10345-1-git-send-email-bo.li.liu@oracle.com>
 <1489523641-10345-2-git-send-email-bo.li.liu@oracle.com>
 <e0d4503e-c197-029f-8300-e268831a71d4@cn.fujitsu.com>
 <20170315022731.GA16337@lim.localdomain>
CC: <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <96911517-fac6-7971-24f1-c4c1846095e1@cn.fujitsu.com>
Date: Wed, 15 Mar 2017 10:51:32 +0800
MIME-Version: 1.0
In-Reply-To: <20170315022731.GA16337@lim.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/15/2017 10:27 AM, Liu Bo wrote:
> On Wed, Mar 15, 2017 at 08:57:09AM +0800, Qu Wenruo wrote:
>>
>>
>> At 03/15/2017 04:33 AM, Liu Bo wrote:
>>> We have similar code here and there, this merges them into a helper.
>>>
>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>
>> I really hate to delay the merge, but unfortunately it seems that
>> read_one_chunk() still contains the open code.
>>
>> Sorry I didn't find it in previous version.
>>
>
> No worry, I left read_one_chunk as is by intention since it doesn't
> think searching failure as an error, it's called while reading chunk
> tree, so if the chunk has not mapped, then it gets to create it.
>
> Thanks,
>
> -liubo

You're right.

Feel free to add my reviewed tag.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
>
>> Despite that, at least beased on v4.11-rc1 and inside volumes.c, it has no
>> extra lookup_extent_mapping() can be cleaned up then.
>>
>> Thanks,
>> Qu
>>> ---
>>> v2: add @length to the error message in get_chunk_map.
>>>
>>>  fs/btrfs/extent_io.c |   3 +-
>>>  fs/btrfs/volumes.c   | 163 +++++++++++++++++----------------------------------
>>>  fs/btrfs/volumes.h   |   2 +-
>>>  3 files changed, 57 insertions(+), 111 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>> index 28e8192..2eccabf 100644
>>> --- a/fs/btrfs/extent_io.c
>>> +++ b/fs/btrfs/extent_io.c
>>> @@ -2003,14 +2003,13 @@ int repair_io_failure(struct btrfs_inode *inode, u64 start, u64 length,
>>>  	u64 map_length = 0;
>>>  	u64 sector;
>>>  	struct btrfs_bio *bbio = NULL;
>>> -	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>>>  	int ret;
>>>
>>>  	ASSERT(!(fs_info->sb->s_flags & MS_RDONLY));
>>>  	BUG_ON(!mirror_num);
>>>
>>>  	/* we can't repair anything in raid56 yet */
>>> -	if (btrfs_is_parity_mirror(map_tree, logical, length, mirror_num))
>>> +	if (btrfs_is_parity_mirror(fs_info, logical, length, mirror_num))
>>>  		return 0;
>>>
>>>  	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index 73d56ee..758a485 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -2795,10 +2795,38 @@ static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info,
>>>  	return ret;
>>>  }
>>>
>>> +static struct extent_map *get_chunk_map(struct btrfs_fs_info *fs_info,
>>> +					u64 logical, u64 length)
>>> +{
>>> +	struct extent_map_tree *em_tree;
>>> +	struct extent_map *em;
>>> +
>>> +	em_tree = &fs_info->mapping_tree.map_tree;
>>> +	read_lock(&em_tree->lock);
>>> +	em = lookup_extent_mapping(em_tree, logical, length);
>>> +	read_unlock(&em_tree->lock);
>>> +
>>> +	if (!em) {
>>> +		btrfs_crit(fs_info, "unable to find logical %llu length %llu",
>>> +			   logical, length);
>>> +		return ERR_PTR(-EINVAL);
>>> +	}
>>> +
>>> +	if (em->start > logical || em->start + em->len < logical) {
>>> +		btrfs_crit(fs_info,
>>> +			   "found a bad mapping, wanted %llu-%llu, found %llu-%llu",
>>> +			   logical, length, em->start, em->start + em->len);
>>> +		free_extent_map(em);
>>> +		return ERR_PTR(-EINVAL);
>>> +	}
>>> +
>>> +	/* callers are responsible for dropping em's ref. */
>>> +	return em;
>>> +}
>>> +
>>>  int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
>>>  		       struct btrfs_fs_info *fs_info, u64 chunk_offset)
>>>  {
>>> -	struct extent_map_tree *em_tree;
>>>  	struct extent_map *em;
>>>  	struct map_lookup *map;
>>>  	u64 dev_extent_len = 0;
>>> @@ -2806,23 +2834,15 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
>>>  	int i, ret = 0;
>>>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
>>>
>>> -	em_tree = &fs_info->mapping_tree.map_tree;
>>> -
>>> -	read_lock(&em_tree->lock);
>>> -	em = lookup_extent_mapping(em_tree, chunk_offset, 1);
>>> -	read_unlock(&em_tree->lock);
>>> -
>>> -	if (!em || em->start > chunk_offset ||
>>> -	    em->start + em->len < chunk_offset) {
>>> +	em = get_chunk_map(fs_info, chunk_offset, 1);
>>> +	if (IS_ERR(em)) {
>>>  		/*
>>>  		 * This is a logic error, but we don't want to just rely on the
>>>  		 * user having built with ASSERT enabled, so if ASSERT doesn't
>>>  		 * do anything we still error out.
>>>  		 */
>>>  		ASSERT(0);
>>> -		if (em)
>>> -			free_extent_map(em);
>>> -		return -EINVAL;
>>> +		return PTR_ERR(em);
>>>  	}
>>>  	map = em->map_lookup;
>>>  	mutex_lock(&fs_info->chunk_mutex);
>>> @@ -4888,7 +4908,6 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
>>>  	struct btrfs_device *device;
>>>  	struct btrfs_chunk *chunk;
>>>  	struct btrfs_stripe *stripe;
>>> -	struct extent_map_tree *em_tree;
>>>  	struct extent_map *em;
>>>  	struct map_lookup *map;
>>>  	size_t item_size;
>>> @@ -4897,24 +4916,9 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
>>>  	int i = 0;
>>>  	int ret = 0;
>>>
>>> -	em_tree = &fs_info->mapping_tree.map_tree;
>>> -	read_lock(&em_tree->lock);
>>> -	em = lookup_extent_mapping(em_tree, chunk_offset, chunk_size);
>>> -	read_unlock(&em_tree->lock);
>>> -
>>> -	if (!em) {
>>> -		btrfs_crit(fs_info, "unable to find logical %Lu len %Lu",
>>> -			   chunk_offset, chunk_size);
>>> -		return -EINVAL;
>>> -	}
>>> -
>>> -	if (em->start != chunk_offset || em->len != chunk_size) {
>>> -		btrfs_crit(fs_info,
>>> -			   "found a bad mapping, wanted %Lu-%Lu, found %Lu-%Lu",
>>> -			    chunk_offset, chunk_size, em->start, em->len);
>>> -		free_extent_map(em);
>>> -		return -EINVAL;
>>> -	}
>>> +	em = get_chunk_map(fs_info, chunk_offset, chunk_size);
>>> +	if (IS_ERR(em))
>>> +		return PTR_ERR(em);
>>>
>>>  	map = em->map_lookup;
>>>  	item_size = btrfs_chunk_item_size(map->num_stripes);
>>> @@ -5055,15 +5059,12 @@ int btrfs_chunk_readonly(struct btrfs_fs_info *fs_info, u64 chunk_offset)
>>>  {
>>>  	struct extent_map *em;
>>>  	struct map_lookup *map;
>>> -	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>>>  	int readonly = 0;
>>>  	int miss_ndevs = 0;
>>>  	int i;
>>>
>>> -	read_lock(&map_tree->map_tree.lock);
>>> -	em = lookup_extent_mapping(&map_tree->map_tree, chunk_offset, 1);
>>> -	read_unlock(&map_tree->map_tree.lock);
>>> -	if (!em)
>>> +	em = get_chunk_map(fs_info, chunk_offset, 1);
>>> +	if (IS_ERR(em))
>>>  		return 1;
>>>
>>>  	map = em->map_lookup;
>>> @@ -5117,34 +5118,19 @@ void btrfs_mapping_tree_free(struct btrfs_mapping_tree *tree)
>>>
>>>  int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>>>  {
>>> -	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>>>  	struct extent_map *em;
>>>  	struct map_lookup *map;
>>> -	struct extent_map_tree *em_tree = &map_tree->map_tree;
>>>  	int ret;
>>>
>>> -	read_lock(&em_tree->lock);
>>> -	em = lookup_extent_mapping(em_tree, logical, len);
>>> -	read_unlock(&em_tree->lock);
>>> -
>>> -	/*
>>> -	 * We could return errors for these cases, but that could get ugly and
>>> -	 * we'd probably do the same thing which is just not do anything else
>>> -	 * and exit, so return 1 so the callers don't try to use other copies.
>>> -	 */
>>> -	if (!em) {
>>> -		btrfs_crit(fs_info, "No mapping for %Lu-%Lu", logical,
>>> -			    logical+len);
>>> -		return 1;
>>> -	}
>>> -
>>> -	if (em->start > logical || em->start + em->len < logical) {
>>> -		btrfs_crit(fs_info, "Invalid mapping for %Lu-%Lu, got %Lu-%Lu",
>>> -			   logical, logical+len, em->start,
>>> -			   em->start + em->len);
>>> -		free_extent_map(em);
>>> +	em = get_chunk_map(fs_info, logical, len);
>>> +	if (IS_ERR(em))
>>> +		/*
>>> +		 * We could return errors for these cases, but that could get
>>> +		 * ugly and we'd probably do the same thing which is just not do
>>> +		 * anything else and exit, so return 1 so the callers don't try
>>> +		 * to use other copies.
>>> +		 */
>>>  		return 1;
>>> -	}
>>>
>>>  	map = em->map_lookup;
>>>  	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
>>> @@ -5173,15 +5159,11 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
>>>  {
>>>  	struct extent_map *em;
>>>  	struct map_lookup *map;
>>> -	struct extent_map_tree *em_tree = &map_tree->map_tree;
>>>  	unsigned long len = fs_info->sectorsize;
>>>
>>> -	read_lock(&em_tree->lock);
>>> -	em = lookup_extent_mapping(em_tree, logical, len);
>>> -	read_unlock(&em_tree->lock);
>>> -	BUG_ON(!em);
>>> +	em = get_chunk_map(fs_info, logical, len);
>>> +	BUG_ON(IS_ERR(em));
>>>
>>> -	BUG_ON(em->start > logical || em->start + em->len < logical);
>>>  	map = em->map_lookup;
>>>  	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
>>>  		len = map->stripe_len * nr_data_stripes(map);
>>> @@ -5189,20 +5171,16 @@ unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
>>>  	return len;
>>>  }
>>>
>>> -int btrfs_is_parity_mirror(struct btrfs_mapping_tree *map_tree,
>>> +int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
>>>  			   u64 logical, u64 len, int mirror_num)
>>>  {
>>>  	struct extent_map *em;
>>>  	struct map_lookup *map;
>>> -	struct extent_map_tree *em_tree = &map_tree->map_tree;
>>>  	int ret = 0;
>>>
>>> -	read_lock(&em_tree->lock);
>>> -	em = lookup_extent_mapping(em_tree, logical, len);
>>> -	read_unlock(&em_tree->lock);
>>> -	BUG_ON(!em);
>>> +	em = get_chunk_map(fs_info, logical, len);
>>> +	BUG_ON(IS_ERR(em));
>>>
>>> -	BUG_ON(em->start > logical || em->start + em->len < logical);
>>>  	map = em->map_lookup;
>>>  	if (map->type & BTRFS_BLOCK_GROUP_RAID56_MASK)
>>>  		ret = 1;
>>> @@ -5322,8 +5300,6 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>>>  {
>>>  	struct extent_map *em;
>>>  	struct map_lookup *map;
>>> -	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>>> -	struct extent_map_tree *em_tree = &map_tree->map_tree;
>>>  	u64 offset;
>>>  	u64 stripe_offset;
>>>  	u64 stripe_end_offset;
>>> @@ -5345,23 +5321,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
>>>  	u64 physical_to_patch_in_first_stripe = 0;
>>>  	u64 raid56_full_stripe_start = (u64)-1;
>>>
>>> -	read_lock(&em_tree->lock);
>>> -	em = lookup_extent_mapping(em_tree, logical, *length);
>>> -	read_unlock(&em_tree->lock);
>>> -
>>> -	if (!em) {
>>> -		btrfs_crit(fs_info, "unable to find logical %llu len %llu",
>>> -			logical, *length);
>>> -		return -EINVAL;
>>> -	}
>>> -
>>> -	if (em->start > logical || em->start + em->len < logical) {
>>> -		btrfs_crit(fs_info,
>>> -			   "found a bad mapping, wanted %Lu, found %Lu-%Lu",
>>> -			   logical, em->start, em->start + em->len);
>>> -		free_extent_map(em);
>>> -		return -EINVAL;
>>> -	}
>>> +	em = get_chunk_map(fs_info, logical, *length);
>>> +	if (IS_ERR(em))
>>> +		return PTR_ERR(em);
>>>
>>>  	map = em->map_lookup;
>>>  	offset = logical - em->start;
>>> @@ -5897,8 +5859,6 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
>>>  		     u64 chunk_start, u64 physical, u64 devid,
>>>  		     u64 **logical, int *naddrs, int *stripe_len)
>>>  {
>>> -	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>>> -	struct extent_map_tree *em_tree = &map_tree->map_tree;
>>>  	struct extent_map *em;
>>>  	struct map_lookup *map;
>>>  	u64 *buf;
>>> @@ -5908,24 +5868,11 @@ int btrfs_rmap_block(struct btrfs_fs_info *fs_info,
>>>  	u64 rmap_len;
>>>  	int i, j, nr = 0;
>>>
>>> -	read_lock(&em_tree->lock);
>>> -	em = lookup_extent_mapping(em_tree, chunk_start, 1);
>>> -	read_unlock(&em_tree->lock);
>>> -
>>> -	if (!em) {
>>> -		btrfs_err(fs_info, "couldn't find em for chunk %Lu",
>>> -			chunk_start);
>>> +	em = get_chunk_map(fs_info, chunk_start, 1);
>>> +	if (IS_ERR(em))
>>>  		return -EIO;
>>> -	}
>>>
>>> -	if (em->start != chunk_start) {
>>> -		btrfs_err(fs_info, "bad chunk start, em=%Lu, wanted=%Lu",
>>> -		       em->start, chunk_start);
>>> -		free_extent_map(em);
>>> -		return -EIO;
>>> -	}
>>>  	map = em->map_lookup;
>>> -
>>>  	length = em->len;
>>>  	rmap_len = map->stripe_len;
>>>
>>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>>> index 59be812..6e93de0 100644
>>> --- a/fs/btrfs/volumes.h
>>> +++ b/fs/btrfs/volumes.h
>>> @@ -475,7 +475,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>>>  void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
>>>  					      struct btrfs_device *tgtdev);
>>>  void btrfs_scratch_superblocks(struct block_device *bdev, const char *device_path);
>>> -int btrfs_is_parity_mirror(struct btrfs_mapping_tree *map_tree,
>>> +int btrfs_is_parity_mirror(struct btrfs_fs_info *fs_info,
>>>  			   u64 logical, u64 len, int mirror_num);
>>>  unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
>>>  				    struct btrfs_mapping_tree *map_tree,
>>>
>>
>>
>
>


