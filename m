Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54001 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753158AbeGDJq5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 05:46:57 -0400
Subject: Re: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com>
 <1a63a1cc-516c-c5f4-3125-c2652950c0c2@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d73ee949-5641-4a07-1547-adab6b104d47@gmx.com>
Date: Wed, 4 Jul 2018 17:46:42 +0800
MIME-Version: 1.0
In-Reply-To: <1a63a1cc-516c-c5f4-3125-c2652950c0c2@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月04日 15:08, Nikolay Borisov wrote:
> 
> 
> On  3.07.2018 12:10, Qu Wenruo wrote:
>> If a crafted btrfs has missing block group items, it could cause
>> unexpected behavior and breaks our expectation on 1:1
>> chunk<->block group mapping.
>>
>> Although we added block group -> chunk mapping check, we still need
>> chunk -> block group mapping check.
>>
>> This patch will do extra check to ensure each chunk has its
>> corresponding block group.
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199847
>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 52 +++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 51 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 82b446f014b9..746095034ca2 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -10038,6 +10038,56 @@ static int check_exist_chunk(struct btrfs_fs_info *fs_info, u64 start, u64 len,
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Iterate all chunks and verify each of them has corresponding block group
>> + */
>> +static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
>> +{
>> +	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
>> +	struct extent_map *em;
>> +	struct btrfs_block_group_cache *bg;
>> +	u64 start = 0;
>> +	int ret = 0;
>> +
>> +	while (1) {
>> +		read_lock(&map_tree->map_tree.lock);
>> +		em = lookup_extent_mapping(&map_tree->map_tree, start,
>> +					   (u64)-1 - start);
> len parameter of lookup_extent_mapping eventually ends up in range_end.
> Meaning it will just return -1. Why not use just -1 for len. Looking at
> the rest of the code this seems to be the convention. But then there are
> several places where 1 is passed as well. Hm, in any case a single
> number is simpler than an expression.

I still like to be accurate here, since it's @len, then we should follow
its naming.
Although we have range_end() for correct careless caller, it still
doesn't sound good just passing -1 as @len.

> 
>> +		read_unlock(&map_tree->map_tree.lock);
>> +		if (!em)
>> +			break;
>> +
>> +		bg = btrfs_lookup_block_group(fs_info, em->start);
>> +		if (!bg) {
>> +			btrfs_err_rl(fs_info,
>> +	"chunk start=%llu len=%llu doesn't have corresponding block group",
>> +				     em->start, em->len);
>> +			ret = -ENOENT;
>> +			free_extent_map(em);
>> +			break;
>> +		}
>> +		if (bg->key.objectid != em->start ||
>> +		    bg->key.offset != em->len ||
>> +		    (bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK) !=
>> +		    (em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
>> +			btrfs_err_rl(fs_info,
>> +"chunk start=%llu len=%llu flags=0x%llx doesn't match with block group start=%llu len=%llu flags=0x%llx",
>> +				em->start, em->len,
>> +				em->map_lookup->type & BTRFS_BLOCK_GROUP_TYPE_MASK,
>> +				bg->key.objectid, bg->key.offset,
>> +				bg->flags & BTRFS_BLOCK_GROUP_TYPE_MASK);
>> +			ret = -EUCLEAN;
>> +			free_extent_map(em);
>> +			btrfs_put_block_group(bg);
>> +			break;
>> +		}
>> +		start = em->start + em->len;
>> +		free_extent_map(em);
>> +		btrfs_put_block_group(bg);
>> +	}
>> +	return ret;
>> +}
>> +
>>  int btrfs_read_block_groups(struct btrfs_fs_info *info)
>>  {
>>  	struct btrfs_path *path;
>> @@ -10227,7 +10277,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>>  
>>  	btrfs_add_raid_kobjects(info);
>>  	init_global_block_rsv(info);
>> -	ret = 0;
>> +	ret = check_chunk_block_group_mappings(info);
> 
> Rather than doing that can we just get the count of chunks. Then if we
> have as many chunks as BG have been read in and we know the BG -> chunk
> mapping check has passed we can assume that chunks also map to BG
> without going through all chunks.

Nope, just as the checks done in that function, we must ensure not only
the number of bgs/chunks matches, but *each* chunk must have a block
group with the same size, length and type flags.

If we have a block group doesn't match its size/length, it's pretty
possible that the corrupted block group may overlap with other block
groups, causing undefined behavior.
So the same for type flags.

This means the only reliable check is the one used in this and previous
check.
(Check bg->chunk matches, and then check chunk->bg matches, using size +
len + type flags as material)

Thanks,
Qu

> 
>>  error:
>>  	btrfs_free_path(path);
>>  	return ret;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
