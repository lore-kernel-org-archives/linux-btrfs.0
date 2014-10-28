Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46042 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752636AbaJ1B6b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 21:58:31 -0400
Message-ID: <544EF8AD.2090808@cn.fujitsu.com>
Date: Tue, 28 Oct 2014 10:00:13 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix race that makes btrfs_lookup_extent_info miss
 skinny extent items
References: <1414401592-19476-1-git-send-email-fdmanana@suse.com>	<544E27C5.7060804@cn.fujitsu.com>	<CAL3q7H5K-i60BqYLJweH1+FZbDOKvP=UJ9FEsHJn=yMhA7EPHQ@mail.gmail.com> <CAL3q7H7FOFFLNYc-Sa1Za0v8mUtT_gvfNHN+KDM3u8N8oCxgMw@mail.gmail.com>
In-Reply-To: <CAL3q7H7FOFFLNYc-Sa1Za0v8mUtT_gvfNHN+KDM3u8N8oCxgMw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 27 Oct 2014 13:44:22 +0000, Filipe David Manana wrote:
> On Mon, Oct 27, 2014 at 12:11 PM, Filipe David Manana
> <fdmanana@gmail.com> wrote:
>> On Mon, Oct 27, 2014 at 11:08 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>> On Mon, 27 Oct 2014 09:19:52 +0000, Filipe Manana wrote:
>>>> We have a race that can lead us to miss skinny extent items in the function
>>>> btrfs_lookup_extent_info() when the skinny metadata feature is enabled.
>>>> So basically the sequence of steps is:
>>>>
>>>> 1) We search in the extent tree for the skinny extent, which returns > 0
>>>>    (not found);
>>>>
>>>> 2) We check the previous item in the returned leaf for a non-skinny extent,
>>>>    and we don't find it;
>>>>
>>>> 3) Because we didn't find the non-skinny extent in step 2), we release our
>>>>    path to search the extent tree again, but this time for a non-skinny
>>>>    extent key;
>>>>
>>>> 4) Right after we released our path in step 3), a skinny extent was inserted
>>>>    in the extent tree (delayed refs were run) - our second extent tree search
>>>>    will miss it, because it's not looking for a skinny extent;
>>>>
>>>> 5) After the second search returned (with ret > 0), we look for any delayed
>>>>    ref for our extent's bytenr (and we do it while holding a read lock on the
>>>>    leaf), but we won't find any, as such delayed ref had just run and completed
>>>>    after we released out path in step 3) before doing the second search.
>>>>
>>>> Fix this by removing completely the path release and re-search logic. This is
>>>> safe, because if we seach for a metadata item and we don't find it, we have the
>>>> guarantee that the returned leaf is the one where the item would be inserted,
>>>> and so path->slots[0] > 0 and path->slots[0] - 1 must be the slot where the
>>>> non-skinny extent item is if it exists. The only case where path->slots[0] is
>>>
>>> I think this analysis is wrong if there are some independent shared ref metadata for
>>> a tree block, just like:
>>> +------------------------+-------------+-------------+
>>> | tree block extent item | shared ref1 | shared ref2 |
>>> +------------------------+-------------+-------------+
> 
> Trying to guess what's in your mind.
> 
> Is the concern that if after a non-skinny extent item we have
> non-inlined references, the assumption that path->slots[0] - 1 points
> to the extent item would be wrong when searching for a skinny extent?
> 
> That wouldn't be the case because BTRFS_EXTENT_ITEM_KEY == 168 and
> BTRFS_METADATA_ITEM_KEY == 169, with BTRFS_SHARED_BLOCK_REF_KEY ==
> 182. So in the presence of such non-inlined shared tree block
> reference items, searching for a skinny extent item leaves us at a
> slot that points to the first non-inlined ref (regardless of its type,
> since they're all > 169), and therefore path->slots[0] - 1 is the
> non-skinny extent item.

You are right. I forget to check the value of key type. Sorry.

This patch seems good for me.

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

> 
> thanks.
> 
>>
>> Why does that matters? Can you elaborate why it's not correct?
>>
>> We're looking for the extent item only in btrfs_lookup_extent_info(),
>> and running a delayed ref, independently of being inlined/shared, it
>> implies inserting a new extent item or updating an existing extent
>> item (updating ref count).
>>
>> thanks
>>
>>>
>>> Thanks
>>> Miao
>>>
>>>> zero is when there are no smaller keys in the tree (i.e. no left siblings for
>>>> our leaf), in which case the re-search logic isn't needed as well.
>>>>
>>>> This race has been present since the introduction of skinny metadata (change
>>>> 3173a18f70554fe7880bb2d85c7da566e364eb3c).
>>>>
>>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>>> ---
>>>>  fs/btrfs/extent-tree.c | 8 --------
>>>>  1 file changed, 8 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index 9141b2b..2cedd06 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -780,7 +780,6 @@ search_again:
>>>>       else
>>>>               key.type = BTRFS_EXTENT_ITEM_KEY;
>>>>
>>>> -again:
>>>>       ret = btrfs_search_slot(trans, root->fs_info->extent_root,
>>>>                               &key, path, 0, 0);
>>>>       if (ret < 0)
>>>> @@ -796,13 +795,6 @@ again:
>>>>                           key.offset == root->nodesize)
>>>>                               ret = 0;
>>>>               }
>>>> -             if (ret) {
>>>> -                     key.objectid = bytenr;
>>>> -                     key.type = BTRFS_EXTENT_ITEM_KEY;
>>>> -                     key.offset = root->nodesize;
>>>> -                     btrfs_release_path(path);
>>>> -                     goto again;
>>>> -             }
>>>>       }
>>>>
>>>>       if (ret == 0) {
>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."
> 
> 
> 

