Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51206 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752524AbcFGAmw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jun 2016 20:42:52 -0400
Subject: Re: [PATCH v10 09/21] btrfs: dedupe: Inband in-memory only
 de-duplication implement
To: Mark Fasheh <mfasheh@suse.de>, Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-10-git-send-email-quwenruo@cn.fujitsu.com>
 <20160601220850.GO7633@wotan.suse.de>
 <79288812-9c6a-b74c-7186-47cb5dfac41d@cn.fujitsu.com>
 <8e4e09ce-233a-239f-e03b-4a0f0b33c3cc@fb.com>
 <4236b0aa-f516-0a7f-02f3-b398ff5bd7bf@gmx.com>
 <20160606195427.GV7633@wotan.suse.de>
CC: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e9f6169c-d79f-4401-362f-1a5606fa3a21@cn.fujitsu.com>
Date: Tue, 7 Jun 2016 08:42:46 +0800
MIME-Version: 1.0
In-Reply-To: <20160606195427.GV7633@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/07/2016 03:54 AM, Mark Fasheh wrote:
> On Sat, Jun 04, 2016 at 06:26:39PM +0800, Qu Wenruo wrote:
>>
>>
>> On 06/03/2016 10:27 PM, Josef Bacik wrote:
>>> On 06/01/2016 09:12 PM, Qu Wenruo wrote:
>>>>
>>>>
>>>> At 06/02/2016 06:08 AM, Mark Fasheh wrote:
>>>>> On Fri, Apr 01, 2016 at 02:35:00PM +0800, Qu Wenruo wrote:
>>>>>> Core implement for inband de-duplication.
>>>>>> It reuse the async_cow_start() facility to do the calculate dedupe
>>>>>> hash.
>>>>>> And use dedupe hash to do inband de-duplication at extent level.
>>>>>>
>>>>>> The work flow is as below:
>>>>>> 1) Run delalloc range for an inode
>>>>>> 2) Calculate hash for the delalloc range at the unit of dedupe_bs
>>>>>> 3) For hash match(duplicated) case, just increase source extent ref
>>>>>>   and insert file extent.
>>>>>>   For hash mismatch case, go through the normal cow_file_range()
>>>>>>   fallback, and add hash into dedupe_tree.
>>>>>>   Compress for hash miss case is not supported yet.
>>>>>>
>>>>>> Current implement restore all dedupe hash in memory rb-tree, with LRU
>>>>>> behavior to control the limit.
>>>>>>
>>>>>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>>>> ---
>>>>>> fs/btrfs/extent-tree.c |  18 ++++
>>>>>> fs/btrfs/inode.c       | 235
>>>>>> ++++++++++++++++++++++++++++++++++++++++++-------
>>>>>> fs/btrfs/relocation.c  |  16 ++++
>>>>>> 3 files changed, 236 insertions(+), 33 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>>>> index 53e1297..dabd721 100644
>>>>>> --- a/fs/btrfs/extent-tree.c
>>>>>> +++ b/fs/btrfs/extent-tree.c
>>>>>> @@ -37,6 +37,7 @@
>>>>>> #include "math.h"
>>>>>> #include "sysfs.h"
>>>>>> #include "qgroup.h"
>>>>>> +#include "dedupe.h"
>>>>>>
>>>>>> #undef SCRAMBLE_DELAYED_REFS
>>>>>>
>>>>>> @@ -2399,6 +2400,8 @@ static int run_one_delayed_ref(struct
>>>>>> btrfs_trans_handle *trans,
>>>>>>
>>>>>>     if (btrfs_delayed_ref_is_head(node)) {
>>>>>>         struct btrfs_delayed_ref_head *head;
>>>>>> +        struct btrfs_fs_info *fs_info = root->fs_info;
>>>>>> +
>>>>>>         /*
>>>>>>          * we've hit the end of the chain and we were supposed
>>>>>>          * to insert this extent into the tree.  But, it got
>>>>>> @@ -2413,6 +2416,15 @@ static int run_one_delayed_ref(struct
>>>>>> btrfs_trans_handle *trans,
>>>>>>             btrfs_pin_extent(root, node->bytenr,
>>>>>>                      node->num_bytes, 1);
>>>>>>             if (head->is_data) {
>>>>>> +                /*
>>>>>> +                 * If insert_reserved is given, it means
>>>>>> +                 * a new extent is revered, then deleted
>>>>>> +                 * in one tran, and inc/dec get merged to 0.
>>>>>> +                 *
>>>>>> +                 * In this case, we need to remove its dedup
>>>>>> +                 * hash.
>>>>>> +                 */
>>>>>> +                btrfs_dedupe_del(trans, fs_info, node->bytenr);
>>>>>>                 ret = btrfs_del_csums(trans, root,
>>>>>>                               node->bytenr,
>>>>>>                               node->num_bytes);
>>>>>> @@ -6713,6 +6725,12 @@ static int __btrfs_free_extent(struct
>>>>>> btrfs_trans_handle *trans,
>>>>>>         btrfs_release_path(path);
>>>>>>
>>>>>>         if (is_data) {
>>>>>> +            ret = btrfs_dedupe_del(trans, info, bytenr);
>>>>>> +            if (ret < 0) {
>>>>>> +                btrfs_abort_transaction(trans, extent_root,
>>>>>> +                            ret);
>>>>>
>>>>> I don't see why an error here should lead to a readonly fs.
>>>>>    --Mark
>>>>>
>>>>
>>>> Because such deletion error can lead to corruption.
>>>>
>>>> For example, extent A is already in hash pool.
>>>> And when freeing extent A, we need to delete its hash, of course.
>>>>
>>>> But if such deletion fails, which means the hash is still in the pool,
>>>> even the extent A no longer exists in extent tree.
>>>
>>> Except if we're in in-memory mode only it doesn't matter, so don't abort
>>> if we're in in-memory mode.  Thanks,
>>>
>>> Josef
>>>
>>
>> If we can't ensure a hash is delete along with the extent, we will
>> screw up the whole fs, as new write can points to non-exist extent.
>>
>> Although you're right with in-memory mode here, we won't abort
>> trans, as inmem_del_hash() won't return error code. It will always
>> return 0.
>
> Until a third party comes along and changes it to return an error code and
> neither you or I are there to remind them to fix this check (or have simply
> forgotten).
>
>
>> So still, no need to change anyway.
>
> Personally I'd call this 'defensive coding' and do a check for in-memory
> only before our abort_trans().  This would have no effect on our running
> code but avoids the problem I stated above.  Alternatively, you could
> clearly comment the exception. I don't like leaving it as-is for the reason
> I stated above.
>
> Thanks,
> 	--Mark
>

The whole 'defensive coding' is here just because the V10 patchset comes 
with full function, including 2 backends and other things later.

A lot of code like this is here because we know what will be added later.
So this is true that it looks ridiculous until one knows there is an 
on-disk backend to be added.

I'm OK to move the check to btrfs_dedupe_del(), but this makes me 
curious about the correct coding style for adding new function.


If we have a clear view of the future functions , should we leave such 
interfaces for them?
Or add them when adding the new functions?

And what level of integration should be done inside btrfs codes?
Should any caller of an exported btrfs function knows all possible 
return value and its condition?
Or caller only needs to check the definition without digging into the 
implementation?
(yes, isolation vs integrations things)

If we have a clear idea on this, we could avoid such embarrassing situation.

Thanks,
Qu

> --
> Mark Fasheh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


