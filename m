From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 9/9] btrfs: Push up non-looped btrfs_start_transaction
 failures
Date: Wed, 10 Aug 2011 22:32:18 -0400
Message-ID: <4E433F32.6060604@suse.com>
References: <20110810232027.129702612@suse.com> <20110810232123.600894199@suse.com> <4E433013.3010600@jp.fujitsu.com> <4E433728.8060406@suse.com> <4E433BF1.4090203@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Cc: linux-btrfs@vger.kernel.org
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E433BF1.4090203@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/10/2011 10:18 PM, Tsutomu Itoh wrote:
> (2011/08/11 10:58), Jeff Mahoney wrote:
>> On 08/10/2011 09:27 PM, Tsutomu Itoh wrote:
>>> Hi, Jeff,
>>>
>>> (2011/08/11 8:20), Jeff Mahoney wrote:
>>>>    This patch handles btrfs_start_transaction failures that don't occur
>>>>    in a loop and are obvious to simply push up. In all cases except the
>>>>    mark_garbage_root case, the error is already handled by BUG_ON in the
>>>>    caller.
>>>>
>>>> Signed-off-by: Jeff Mahoney<jeffm@suse.com>
>>>> ---
>>>>    fs/btrfs/extent-tree.c |    6 +++++-
>>>>    fs/btrfs/relocation.c  |    6 ++++--
>>>>    fs/btrfs/tree-log.c    |    5 ++++-
>>>>    fs/btrfs/volumes.c     |    3 ++-
>>>>    4 files changed, 15 insertions(+), 5 deletions(-)
>>>>
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -6319,7 +6319,11 @@ int btrfs_drop_snapshot(struct btrfs_roo
>>>>    	}
>>>>
>>>>    	trans = btrfs_start_transaction(tree_root, 0);
>>>> -	BUG_ON(IS_ERR(trans));
>>>> +	if (IS_ERR(trans)) {
>>>> +		kfree(wc);
>>>> +		btrfs_free_path(path);
>>>> +		return PTR_ERR(trans);
>>>> +	}
>>>
>>> The caller of btrfs_drop_snapshot() ignore the error. So, I don't think
>>> that it is significant even if the error is returned to the caller.
>>
>>   I'd actually consider that a separate issue since btrfs_drop_snapshot
>> also returns -ENOMEM. The errors should be properly caught or BUG_ON'd
>> in the caller. My patchset usually catches cases like this but since
>> btrfs_drop_snapshot already returned an error, I mistakenly assumed it
>> was handled by the caller.
>>
>>> I think that it should make the filesystem readonly when becoming an error
>>> in btrfs_start_transaction().
>>
>> For -ENOMEM, I don't think that's the way to handle it. Some transaction
>> start failures can be caught and handled (e.g. just creating a file)
>> easily by returning errors to the user. Other cases, deep in the code,
>> may be too complex to unwind and recover from and then a ROFS is the
>> next-best answer. The callers should be responsible for determining the
>> correct course of action.
> 
> OK.
> Could you please append BUG_ON() in the caller or correctly handle the error
> of btrfs_start_transaction()?

Yep. I'll add that in. Thanks for the review.

-Jef

>> -Jeff
>>
>>> Thanks,
>>> Tsutomu
>>>
>>>>
>>>>    	if (block_rsv)
>>>>    		trans->block_rsv = block_rsv;
>>>> --- a/fs/btrfs/relocation.c
>>>> +++ b/fs/btrfs/relocation.c
>>>> @@ -4096,7 +4096,8 @@ static noinline_for_stack int mark_garba
>>>>    	int ret;
>>>>
>>>>    	trans = btrfs_start_transaction(root->fs_info->tree_root, 0);
>>>> -	BUG_ON(IS_ERR(trans));
>>>> +	if (IS_ERR(trans))
>>>> +		return PTR_ERR(trans);
>>>>
>>>>    	memset(&root->root_item.drop_progress, 0,
>>>>    		sizeof(root->root_item.drop_progress));
>>>> @@ -4176,7 +4177,8 @@ int btrfs_recover_relocation(struct btrf
>>>>    					err = ret;
>>>>    					goto out;
>>>>    				}
>>>> -				mark_garbage_root(reloc_root);
>>>> +				ret = mark_garbage_root(reloc_root);
>>>> +				BUG_ON(ret);
>>>>    			}
>>>>    		}
>>>>
>>>> --- a/fs/btrfs/tree-log.c
>>>> +++ b/fs/btrfs/tree-log.c
>>>> @@ -3151,7 +3151,10 @@ int btrfs_recover_log_trees(struct btrfs
>>>>    	fs_info->log_root_recovering = 1;
>>>>
>>>>    	trans = btrfs_start_transaction(fs_info->tree_root, 0);
>>>> -	BUG_ON(IS_ERR(trans));
>>>> +	if (IS_ERR(trans)) {
>>>> +		btrfs_free_path(path);
>>>> +		return PTR_ERR(trans);
>>>> +	}
>>>>
>>>>    	wc.trans = trans;
>>>>    	wc.pin = 1;
>>>> --- a/fs/btrfs/volumes.c
>>>> +++ b/fs/btrfs/volumes.c
>>>> @@ -1876,7 +1876,8 @@ static int btrfs_relocate_chunk(struct b
>>>>    		return ret;
>>>>
>>>>    	trans = btrfs_start_transaction(root, 0);
>>>> -	BUG_ON(IS_ERR(trans));
>>>> +	if (IS_ERR(trans))
>>>> +		return PTR_ERR(trans);
>>>>
>>>>    	lock_chunks(root);
>>>>
>>>
> 


-- 
Jeff Mahoney
SuSE Labs
