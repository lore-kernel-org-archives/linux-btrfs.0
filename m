Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:65338 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbcFDK1I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 Jun 2016 06:27:08 -0400
Subject: Re: [PATCH v10 09/21] btrfs: dedupe: Inband in-memory only
 de-duplication implement
To: Josef Bacik <jbacik@fb.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Mark Fasheh <mfasheh@suse.de>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-10-git-send-email-quwenruo@cn.fujitsu.com>
 <20160601220850.GO7633@wotan.suse.de>
 <79288812-9c6a-b74c-7186-47cb5dfac41d@cn.fujitsu.com>
 <8e4e09ce-233a-239f-e03b-4a0f0b33c3cc@fb.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4236b0aa-f516-0a7f-02f3-b398ff5bd7bf@gmx.com>
Date: Sat, 4 Jun 2016 18:26:39 +0800
MIME-Version: 1.0
In-Reply-To: <8e4e09ce-233a-239f-e03b-4a0f0b33c3cc@fb.com>
Content-Type: text/plain; charset=gbk; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/2016 10:27 PM, Josef Bacik wrote:
> On 06/01/2016 09:12 PM, Qu Wenruo wrote:
>>
>>
>> At 06/02/2016 06:08 AM, Mark Fasheh wrote:
>>> On Fri, Apr 01, 2016 at 02:35:00PM +0800, Qu Wenruo wrote:
>>>> Core implement for inband de-duplication.
>>>> It reuse the async_cow_start() facility to do the calculate dedupe
>>>> hash.
>>>> And use dedupe hash to do inband de-duplication at extent level.
>>>>
>>>> The work flow is as below:
>>>> 1) Run delalloc range for an inode
>>>> 2) Calculate hash for the delalloc range at the unit of dedupe_bs
>>>> 3) For hash match(duplicated) case, just increase source extent ref
>>>>    and insert file extent.
>>>>    For hash mismatch case, go through the normal cow_file_range()
>>>>    fallback, and add hash into dedupe_tree.
>>>>    Compress for hash miss case is not supported yet.
>>>>
>>>> Current implement restore all dedupe hash in memory rb-tree, with LRU
>>>> behavior to control the limit.
>>>>
>>>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> ---
>>>>  fs/btrfs/extent-tree.c |  18 ++++
>>>>  fs/btrfs/inode.c       | 235
>>>> ++++++++++++++++++++++++++++++++++++++++++-------
>>>>  fs/btrfs/relocation.c  |  16 ++++
>>>>  3 files changed, 236 insertions(+), 33 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index 53e1297..dabd721 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -37,6 +37,7 @@
>>>>  #include "math.h"
>>>>  #include "sysfs.h"
>>>>  #include "qgroup.h"
>>>> +#include "dedupe.h"
>>>>
>>>>  #undef SCRAMBLE_DELAYED_REFS
>>>>
>>>> @@ -2399,6 +2400,8 @@ static int run_one_delayed_ref(struct
>>>> btrfs_trans_handle *trans,
>>>>
>>>>      if (btrfs_delayed_ref_is_head(node)) {
>>>>          struct btrfs_delayed_ref_head *head;
>>>> +        struct btrfs_fs_info *fs_info = root->fs_info;
>>>> +
>>>>          /*
>>>>           * we've hit the end of the chain and we were supposed
>>>>           * to insert this extent into the tree.  But, it got
>>>> @@ -2413,6 +2416,15 @@ static int run_one_delayed_ref(struct
>>>> btrfs_trans_handle *trans,
>>>>              btrfs_pin_extent(root, node->bytenr,
>>>>                       node->num_bytes, 1);
>>>>              if (head->is_data) {
>>>> +                /*
>>>> +                 * If insert_reserved is given, it means
>>>> +                 * a new extent is revered, then deleted
>>>> +                 * in one tran, and inc/dec get merged to 0.
>>>> +                 *
>>>> +                 * In this case, we need to remove its dedup
>>>> +                 * hash.
>>>> +                 */
>>>> +                btrfs_dedupe_del(trans, fs_info, node->bytenr);
>>>>                  ret = btrfs_del_csums(trans, root,
>>>>                                node->bytenr,
>>>>                                node->num_bytes);
>>>> @@ -6713,6 +6725,12 @@ static int __btrfs_free_extent(struct
>>>> btrfs_trans_handle *trans,
>>>>          btrfs_release_path(path);
>>>>
>>>>          if (is_data) {
>>>> +            ret = btrfs_dedupe_del(trans, info, bytenr);
>>>> +            if (ret < 0) {
>>>> +                btrfs_abort_transaction(trans, extent_root,
>>>> +                            ret);
>>>
>>> I don't see why an error here should lead to a readonly fs.
>>>     --Mark
>>>
>>
>> Because such deletion error can lead to corruption.
>>
>> For example, extent A is already in hash pool.
>> And when freeing extent A, we need to delete its hash, of course.
>>
>> But if such deletion fails, which means the hash is still in the pool,
>> even the extent A no longer exists in extent tree.
>
> Except if we're in in-memory mode only it doesn't matter, so don't abort
> if we're in in-memory mode.  Thanks,
>
> Josef
>

If we can't ensure a hash is delete along with the extent, we will screw 
up the whole fs, as new write can points to non-exist extent.

Although you're right with in-memory mode here, we won't abort trans, as 
inmem_del_hash() won't return error code. It will always return 0.

So still, no need to change anyway.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
