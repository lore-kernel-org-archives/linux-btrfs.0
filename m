Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbcHIBB0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Aug 2016 21:01:26 -0400
Subject: Re: [PATCH v2 1/3] btrfs: qgroup: Refactor
 btrfs_qgroup_insert_dirty_extent()
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20160805022923.6170-1-quwenruo@cn.fujitsu.com>
 <20160805022923.6170-2-quwenruo@cn.fujitsu.com>
 <e3bae83d-bb48-48ef-4614-963b7119c4e4@suse.com>
 <25363e5c-3f2b-2364-5ad4-3f87c3c9af61@cn.fujitsu.com>
 <5c5e1789-6588-b0d8-2cc8-2981fa3260f7@suse.de>
 <05f5ef10-9b7f-cef5-b857-dab781194d70@cn.fujitsu.com>
Cc: Mark Fasheh <mfasheh@suse.de>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <990ca11e-f6d9-37c7-abf8-d4f455325222@suse.de>
Date: Mon, 8 Aug 2016 20:01:22 -0500
MIME-Version: 1.0
In-Reply-To: <05f5ef10-9b7f-cef5-b857-dab781194d70@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/08/2016 07:26 PM, Qu Wenruo wrote:
> 
> 
> At 08/08/2016 10:54 AM, Goldwyn Rodrigues wrote:
>>
>>
>> On 08/07/2016 07:39 PM, Qu Wenruo wrote:
>>>
>>>
>>> At 08/07/2016 01:19 AM, Goldwyn Rodrigues wrote:
>>>> Thanks Qu,
>>>>
>>>> This patch set fixes all the reported problems. However, I have some
>>>> minor issues with coding style.
>>>>
>>>
>>> Thanks for the test.
>>>
>>>>
>>>> On 08/04/2016 09:29 PM, Qu Wenruo wrote:
>>>>> Refactor btrfs_qgroup_insert_dirty_extent() function, to two
>>>>> functions:
>>>>> 1. _btrfs_qgroup_insert_dirty_extent()
>>>>>    Almost the same with original code.
>>>>>    For delayed_ref usage, which has delayed refs locked.
>>>>>
>>>>>    Change the return value type to int, since caller never needs the
>>>>>    pointer, but only needs to know if they need to free the allocated
>>>>>    memory.
>>>>>
>>>>> 2. btrfs_qgroup_record_dirty_extent()
>>>>>    The more encapsulated version.
>>>>>
>>>>>    Will do the delayed_refs lock, memory allocation, quota enabled
>>>>> check
>>>>>    and other misc things.
>>>>>
>>>>> The original design is to keep exported functions to minimal, but
>>>>> since
>>>>> more btrfs hacks exposed, like replacing path in balance, needs us to
>>>>> record dirty extents manually, so we have to add such functions.
>>>>>
>>>>> Also, add comment for both functions, to info developers how to keep
>>>>> qgroup correct when doing hacks.
>>>>>
>>>>> Cc: Mark Fasheh <mfasheh@suse.de>
>>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>> ---
>>>>>  fs/btrfs/delayed-ref.c |  5 +----
>>>>>  fs/btrfs/extent-tree.c | 36 +++++-------------------------------
>>>>>  fs/btrfs/qgroup.c      | 39 ++++++++++++++++++++++++++++++++++-----
>>>>>  fs/btrfs/qgroup.h      | 44
>>>>> +++++++++++++++++++++++++++++++++++++++++---
>>>>>  4 files changed, 81 insertions(+), 43 deletions(-)
>>>>>
>>>>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>>>>> index 430b368..5eed597 100644
>>>>> --- a/fs/btrfs/delayed-ref.c
>>>>> +++ b/fs/btrfs/delayed-ref.c
>>>>> @@ -541,7 +541,6 @@ add_delayed_ref_head(struct btrfs_fs_info
>>>>> *fs_info,
>>>>>      struct btrfs_delayed_ref_head *existing;
>>>>>      struct btrfs_delayed_ref_head *head_ref = NULL;
>>>>>      struct btrfs_delayed_ref_root *delayed_refs;
>>>>> -    struct btrfs_qgroup_extent_record *qexisting;
>>>>>      int count_mod = 1;
>>>>>      int must_insert_reserved = 0;
>>>>>
>>>>> @@ -606,9 +605,7 @@ add_delayed_ref_head(struct btrfs_fs_info
>>>>> *fs_info,
>>>>>          qrecord->num_bytes = num_bytes;
>>>>>          qrecord->old_roots = NULL;
>>>>>
>>>>> -        qexisting = btrfs_qgroup_insert_dirty_extent(delayed_refs,
>>>>> -                                 qrecord);
>>>>> -        if (qexisting)
>>>>> +        if(_btrfs_qgroup_insert_dirty_extent(delayed_refs, qrecord))
>>>>>              kfree(qrecord);
>>>>>      }
>>>>>
>>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>>> index 9fcb8c9..47c85ff 100644
>>>>> --- a/fs/btrfs/extent-tree.c
>>>>> +++ b/fs/btrfs/extent-tree.c
>>>>> @@ -8519,34 +8519,6 @@ reada:
>>>>>      wc->reada_slot = slot;
>>>>>  }
>>>>>
>>>>> -/*
>>>>> - * These may not be seen by the usual inc/dec ref code so we have to
>>>>> - * add them here.
>>>>> - */
>>>>> -static int record_one_subtree_extent(struct btrfs_trans_handle
>>>>> *trans,
>>>>> -                     struct btrfs_root *root, u64 bytenr,
>>>>> -                     u64 num_bytes)
>>>>> -{
>>>>> -    struct btrfs_qgroup_extent_record *qrecord;
>>>>> -    struct btrfs_delayed_ref_root *delayed_refs;
>>>>> -
>>>>> -    qrecord = kmalloc(sizeof(*qrecord), GFP_NOFS);
>>>>> -    if (!qrecord)
>>>>> -        return -ENOMEM;
>>>>> -
>>>>> -    qrecord->bytenr = bytenr;
>>>>> -    qrecord->num_bytes = num_bytes;
>>>>> -    qrecord->old_roots = NULL;
>>>>> -
>>>>> -    delayed_refs = &trans->transaction->delayed_refs;
>>>>> -    spin_lock(&delayed_refs->lock);
>>>>> -    if (btrfs_qgroup_insert_dirty_extent(delayed_refs, qrecord))
>>>>> -        kfree(qrecord);
>>>>> -    spin_unlock(&delayed_refs->lock);
>>>>> -
>>>>> -    return 0;
>>>>> -}
>>>>> -
>>>>>  static int account_leaf_items(struct btrfs_trans_handle *trans,
>>>>>                    struct btrfs_root *root,
>>>>>                    struct extent_buffer *eb)
>>>>> @@ -8580,7 +8552,8 @@ static int account_leaf_items(struct
>>>>> btrfs_trans_handle *trans,
>>>>>
>>>>>          num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
>>>>>
>>>>> -        ret = record_one_subtree_extent(trans, root, bytenr,
>>>>> num_bytes);
>>>>> +        ret = btrfs_qgroup_record_dirty_extent(trans, root->fs_info,
>>>>> +                bytenr, num_bytes, GFP_NOFS);
>>>>>          if (ret)
>>>>>              return ret;
>>>>>      }
>>>>> @@ -8729,8 +8702,9 @@ walk_down:
>>>>>              btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
>>>>>              path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
>>>>>
>>>>> -            ret = record_one_subtree_extent(trans, root,
>>>>> child_bytenr,
>>>>> -                            root->nodesize);
>>>>> +            ret = btrfs_qgroup_record_dirty_extent(trans,
>>>>> +                    root->fs_info, child_bytenr,
>>>>> +                    root->nodesize, GFP_NOFS);
>>>>>              if (ret)
>>>>>                  goto out;
>>>>>          }
>>>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>>>> index 9d4c05b..76d4f67 100644
>>>>> --- a/fs/btrfs/qgroup.c
>>>>> +++ b/fs/btrfs/qgroup.c
>>>>> @@ -1453,9 +1453,9 @@ int btrfs_qgroup_prepare_account_extents(struct
>>>>> btrfs_trans_handle *trans,
>>>>>      return ret;
>>>>>  }
>>>>>
>>>>> -struct btrfs_qgroup_extent_record
>>>>> -*btrfs_qgroup_insert_dirty_extent(struct btrfs_delayed_ref_root
>>>>> *delayed_refs,
>>>>> -                  struct btrfs_qgroup_extent_record *record)
>>>>> +int _btrfs_qgroup_insert_dirty_extent(
>>>>> +        struct btrfs_delayed_ref_root *delayed_refs,
>>>>> +        struct btrfs_qgroup_extent_record *record)
>>>>
>>>> Why do you rename the function preceding with an underscore? just leave
>>>> it as it is.
>>>
>>> Because these two functions have different usage.
>>
>> Where is the "other" function used? AFAICS, you are replacing the
>> function name.
> 
> See 2nd and 3rd patch.
> Or be more specific, dirty hack fixes, which is the case where we need
> to do manual tracking for qgroup.

I still don't see it. Can you be more specific with function names to
help me understand?

All you are doing is adding is btrfs_qgroup_record_dirty_extent() which
calls _btrfs_qgroup_insert_dirty_extent() with the locks. Is that what
you are referring to?


> 
>>
>>>
>>> the underscore one are used when caller has already acquired needed
>>> lock, which is used by delayed-refs code.
>>>
>>> And the one without underscore is for other usage.
>>
>> What/Where is the "other usage"? Please don't say "previous".
>>
> 
> See above.
> 
>>>
>>> Despite the lock, these two functions are all the same.
>>>
>>> So I prefer to use underscore.
>>
>> BTW, you missed include/trace/events/btrfs.h, the reference to
>> btrfs_qgroup_insert_dirty_extent in DEFINE_EVENT.
>>
> 
> Since btrfs_qgroup_insert_dirty_extent() is just calling the underscore
> one with proper lock content, so the trace is not affected.

There is NO btrfs_qgroup_insert_dirty_extent(). Your patches REMOVED it
and replaced it with _btrfs_qgroup_insert_dirty_extent(). Only
btrfs_qgroup_record_dirty_extent() which is not in trace.


<snipped>

-- 
Goldwyn
