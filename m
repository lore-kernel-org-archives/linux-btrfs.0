Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60581 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750707AbeEVHtn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 03:49:43 -0400
Subject: Re: [PATCH] btrfs: Use btrfs_add_unused_bgs() to replace open code
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180522072914.27301-1-wqu@suse.com>
 <c56276ee-1491-f2c1-9575-0bbc68b83b82@suse.com>
 <6868d577-7ea9-a596-ad84-058dc55373b0@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <694cc81e-de0a-7cc4-64dd-b3c35050fe17@suse.com>
Date: Tue, 22 May 2018 10:49:41 +0300
MIME-Version: 1.0
In-Reply-To: <6868d577-7ea9-a596-ad84-058dc55373b0@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.05.2018 10:45, Qu Wenruo wrote:
> 
> 
> On 2018年05月22日 15:37, Nikolay Borisov wrote:
>>
>>
>> On 22.05.2018 10:29, Qu Wenruo wrote:
>>> Introduce a small helper, btrfs_add_unused_bgs(), to accquire needed
>>
>> This function name sounds a bit awkard, mainly because you use the
>> plural form. How about btrfs_mark_bg_unused() ? The name seems more
>> unambiguous.
> 
> Sounds much better.
> 
>>
>>> locks and add a block group to unused_bgs list.
>>>
>>> No functional modification, and only 3 callers are involved.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> This patch should provide the basis for later block group auto-removal
>>> to get more info (mostly transid) to determine should one block group
>>> being removed in current trans.
>>> ---
>>>  fs/btrfs/ctree.h       |  1 +
>>>  fs/btrfs/extent-tree.c | 35 ++++++++++++++++-------------------
>>>  fs/btrfs/scrub.c       |  9 +--------
>>>  3 files changed, 18 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index bbb358143ded..701a52034ec6 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -2827,6 +2827,7 @@ void check_system_chunk(struct btrfs_trans_handle *trans,
>>>  			struct btrfs_fs_info *fs_info, const u64 type);
>>>  u64 add_new_free_space(struct btrfs_block_group_cache *block_group,
>>>  		       u64 start, u64 end);
>>> +void btrfs_add_unused_bgs(struct btrfs_block_group_cache *bg);
>>>  
>>>  /* ctree.c */
>>>  int btrfs_bin_search(struct extent_buffer *eb, const struct btrfs_key *key,
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index ccf2690f7ca1..484c9d11e5b6 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -6312,16 +6312,8 @@ static int update_block_group(struct btrfs_trans_handle *trans,
>>>  		 * dirty list to avoid races between cleaner kthread and space
>>>  		 * cache writeout.
>>>  		 */
>>> -		if (!alloc && old_val == 0) {
>>> -			spin_lock(&info->unused_bgs_lock);
>>> -			if (list_empty(&cache->bg_list)) {
>>> -				btrfs_get_block_group(cache);
>>> -				trace_btrfs_add_unused_block_group(cache);
>>> -				list_add_tail(&cache->bg_list,
>>> -					      &info->unused_bgs);
>>> -			}
>>> -			spin_unlock(&info->unused_bgs_lock);
>>> -		}
>>> +		if (!alloc && old_val == 0)
>>> +			btrfs_add_unused_bgs(cache);
>>>  
>>>  		btrfs_put_block_group(cache);
>>>  		total -= num_bytes;
>>> @@ -10144,15 +10136,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
>>>  		if (btrfs_chunk_readonly(info, cache->key.objectid)) {
>>>  			inc_block_group_ro(cache, 1);
>>>  		} else if (btrfs_block_group_used(&cache->item) == 0) {
>>> -			spin_lock(&info->unused_bgs_lock);
>>> -			/* Should always be true but just in case. */
>>> -			if (list_empty(&cache->bg_list)) {
>>> -				btrfs_get_block_group(cache);
>>> -				trace_btrfs_add_unused_block_group(cache);
>>> -				list_add_tail(&cache->bg_list,
>>> -					      &info->unused_bgs);
>>> -			}
>>> -			spin_unlock(&info->unused_bgs_lock);
>>> +			btrfs_add_unused_bgs(cache);
>>>  		}
>>>  	}
>>>  
>>> @@ -11071,3 +11055,16 @@ void btrfs_wait_for_snapshot_creation(struct btrfs_root *root)
>>>  			       !atomic_read(&root->will_be_snapshotted));
>>>  	}
>>>  }
>>> +
>>> +void btrfs_add_unused_bgs(struct btrfs_block_group_cache *bg)
>>> +{
>>> +	struct btrfs_fs_info *fs_info = bg->fs_info;
>>> +
>>> +	spin_lock(&fs_info->unused_bgs_lock);
>>> +	if (list_empty(&bg->bg_list)) {
>>
>> Given the comment in btrfs_read_block_groups:
>>
>> /* Should always be true but just in case. */
>>
>> How about you make it ASSERT(list_empty(&bg->bg_list));
>>
>> /* code to add the bg */
>>
>> So right now either :
>>
>> a) The comment is bogus and it is indeed required to check if this bg
>> has already been marked unused.
>>
>> or
>>
>> b) The comment is correct and it's in fact a bug to try and mark a bg as
>> unused twice.
> 
> Not exactly.
> 
> 1) bg_list is kind of abused.
>    Not only fs_info->unused_bgs, but also transaction->deleted_bgs, and
>    even transaction->new_bgs could use bg_cache->bg_list.
>    So it's not only used to detect unused bgs.
>    And it's possible some bg get moved to deleted_bgs list.

I haven't looked at the code but if this is indeed the case then doesn't
it make sense to try and fix this abuse, otherwise don't we risk
processing a bg in the wrong context? In other words, shouldn't bgs have
1 list member for every list they could be part of?I guess a single list
member would have made sense IFF there was 1 central place where this
list manipulation was performed, which currently there isn't, yes?

> 
> 2) That is comment only works for caller in btrfs_read_block_groups().
>    As at that timing, there is no race at all since we're still mounting
>    the fs.
>    But may not work for other callers.
> 
> Thus I just kept the code while removed the comment, since in the
> extracted function, it may no longer be the case.
> (And my focus is later auto-removal generation check, so I just left
> code as is)
> 
> Thanks,
> Qu
> 
>>
>>> +		btrfs_get_block_group(bg);
>>> +		trace_btrfs_add_unused_block_group(bg);
>>> +		list_add_tail(&bg->bg_list, &fs_info->unused_bgs);
>>> +	}
>>> +	spin_unlock(&fs_info->unused_bgs_lock);
>>> +}
>>> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
>>> index a59005862010..1044ab2fc71c 100644
>>> --- a/fs/btrfs/scrub.c
>>> +++ b/fs/btrfs/scrub.c
>>> @@ -3981,14 +3981,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
>>>  		if (!cache->removed && !cache->ro && cache->reserved == 0 &&
>>>  		    btrfs_block_group_used(&cache->item) == 0) {
>>>  			spin_unlock(&cache->lock);
>>> -			spin_lock(&fs_info->unused_bgs_lock);
>>> -			if (list_empty(&cache->bg_list)) {
>>> -				btrfs_get_block_group(cache);
>>> -				trace_btrfs_add_unused_block_group(cache);
>>> -				list_add_tail(&cache->bg_list,
>>> -					      &fs_info->unused_bgs);
>>> -			}
>>> -			spin_unlock(&fs_info->unused_bgs_lock);
>>> +			btrfs_add_unused_bgs(cache);
>>>  		} else {
>>>  			spin_unlock(&cache->lock);
>>>  		}
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
