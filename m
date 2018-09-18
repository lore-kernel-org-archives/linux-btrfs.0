Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:29788 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727202AbeIRNZy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 09:25:54 -0400
Subject: Re: [PATCH v3 5/7] btrfs-progs: lowmem: do missing check of last item
 after check_inode_item()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <Damenly_Su@gmx.com>,
        <linux-btrfs@vger.kernel.org>
References: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
 <20180917072852.25831-6-suy.fnst@cn.fujitsu.com>
 <e4ec3fbd-71c3-c59c-1915-0419f06a6c26@gmx.com>
 <c7f2ed73-94d2-23d8-7503-0611469af54c@gmx.com>
 <7a21da5f-efb2-5a17-51ca-2787e52b5bde@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <7c713106-36a9-95a3-3648-80e67d4f5ee6@cn.fujitsu.com>
Date: Tue, 18 Sep 2018 16:01:22 +0800
MIME-Version: 1.0
In-Reply-To: <7a21da5f-efb2-5a17-51ca-2787e52b5bde@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 9/18/18 1:32 PM, Qu Wenruo wrote:
> 
> 
> On 2018/9/17 下午9:24, Su Yue wrote:
>>
>>
>> On 2018/9/17 8:53 PM, Qu Wenruo wrote:
>>>
>>>
>>> On 2018/9/17 下午3:28, Su Yue wrote:
>>>> After call of check_inode_item(), path may point to the last unchecked
>>>> slot of the leaf. The outer walk_up_tree() always treats the position
>>>> as checked slot then skips to the next. The last item will never be
>>>> checked.
>>>>
>>>> While checking backrefs, path passed to walk_up_tree() always
>>>> points to a checked slot.
>>>> While checking fs trees, path passed to walk_up_tree() always
>>>> points to an unchecked slot.
>>>
>>> Can we unify this behavior?
>>> I has considered in three ways:
>> 1) Change logical of the process_one_leaf. After it returns, path
>> points to the next slot checked.
>> To unify it, we can use saved key but will cost one search_slot time
>> during serval nodes(>=1). Or call btrfs_previous_item() after every time
>> check_inode_items() returns.
>>
>> But why? why should we cost some time to swing the path. So I abandoned 1).
>>
>> 2) Change logical of the check_leaf_items(). What does the function
>> is just traverse all items then returns, which seems quite natural.
>> So I abandoned it.
> 
> Well, this can also be interpreted as "it's a pretty good place to
> change the behavior".
> 
> IMHO, since check_leaf_items() are just really simple hub functions, it
> will just need a btrfs_next_item() in its out: tag.
> 
After sometime thinking, sorry, the idea should not work as expected.
In fact, backrefs check and fs check walk a little differently.

Backrefs check always do walk nodes one by one, never skip any nodes.
Fs check will try to skip shared nodes to speed up.

While checking backrefs with your idea,
If the tree has many levels.
Assume before calling btrfs_next_item:
path->slots[0] points to the one past of the last item.
path->slots[1] points to the last slot of nodes[1].
path->slots[2] points to the last slot of nodes[2].
path->slots[3] points to the one *before* last slot of nodes[3].

After btrfs_next_item():
path->slots[0] points to the first item of another leaf.
path->slots[1] points to the first item of another node.
path->slots[2] points to the first item of another node.
path->slots[3] points to the a slot of *old* nodes[3].

Then walk_up_tree() is in, it thinks the slot is unchecked then
returns with *level=0. Then walk_down_tree() just walk from level
to leaf.
Backrefs of new nodes[1,2] will never be checked, the most
obvious negative effect is inaccurate account info.
Although we can do check is slot the first in walk_up_tree(),
it's a magic and worse than this patch.

Thanks,
Su

> By that we can unify the behavior of them to all points to the next
> *unchecked* slot.
> And no need for the extra parameter.
> 
> Thanks,
> Qu
> 
>>
>>
>> 3) It's what the patch does. The extra argument may seems strange,
>> I preferred to this way.
>>
>> Maybe we can do something after check_leaf_items() returns, is it
>> acceptable? I have no idea.
>>
>> Thanks,
>> Su
>>
>>> E.g, always points to an unchecked slot.
>>>
>>> It would make things easier and no need for the extra parameter.
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> Solution:
>>>> Add an argument @is_checked to walk_up_tree() to decide whether
>>>> to skip current slot.
>>>>
>>>> Fixes: 5e2dc770471b ("btrfs-progs: check: skip shared node or leaf
>>>> check for low_memory mode")
>>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>>> ---
>>>>    check/mode-lowmem.c | 37 +++++++++++++++++++++++++++++++++----
>>>>    1 file changed, 33 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>>>> index db44456fd85b..612e5e28e45b 100644
>>>> --- a/check/mode-lowmem.c
>>>> +++ b/check/mode-lowmem.c
>>>> @@ -4597,22 +4597,38 @@ static int walk_down_tree(struct btrfs_root
>>>> *root, struct btrfs_path *path,
>>>>        return err;
>>>>    }
>>>>    +/*
>>>> + * Walk up throuh the path. Make path point to next slot to be checked.
>>>> + * walk_down_tree() should be called after this function.
>>>> + *
>>>> + * @root:    root of the tree
>>>> + * @path:    will point to next slot to check for walk_down_tree()
>>>> + * @level:    returns with level of next node to be checked
>>>> + * @is_checked:    means is the current node checked or not
>>>> + *        if false, the slot is unchecked, do not increase the slot
>>>> + *        if true, means increase the slot of the current node
>>>> + *
>>>> + * Returns 0 means success.
>>>> + * Returns >0 means the whole loop of walk up/down should be broken.
>>>> + */
>>>>    static int walk_up_tree(struct btrfs_root *root, struct btrfs_path
>>>> *path,
>>>> -            int *level)
>>>> +            int *level, bool is_checked)
>>>>    {
>>>>        int i;
>>>>        struct extent_buffer *leaf;
>>>> +    int skip_cur =s_checked ? 1 : 0;
>>>>          for (i =level; i < BTRFS_MAX_LEVEL - 1 && path->nodes[i]; i++) {
>>>>            leaf =ath->nodes[i];
>>>> -        if (path->slots[i] + 1 < btrfs_header_nritems(leaf)) {
>>>> -            path->slots[i]++;
>>>> +        if (path->slots[i] + skip_cur < btrfs_header_nritems(leaf)) {
>>>> +            path->slots[i] +=kip_cur;
>>>>                *level =;
>>>>                return 0;
>>>>            }
>>>>            free_extent_buffer(path->nodes[*level]);
>>>>            path->nodes[*level] =ULL;
>>>>            *level = + 1;
>>>> +        skip_cur =;
>>>>        }
>>>>        return 1;
>>>>    }
>>>> @@ -4815,7 +4831,20 @@ static int check_btrfs_root(struct btrfs_root
>>>> *root, int check_all)
>>>>                break;
>>>>            }
>>>>    -        ret =alk_up_tree(root, &path, &level);
>>>> +        /*
>>>> +         * The logical of walk trees are shared between backrefs
>>>> +         * check and fs trees check.
>>>> +         * In checking backrefs(check_all is true), after
>>>> +         * check_leaf_items() returns, path points to
>>>> +         * last checked item.
>>>> +         * In checking fs roots(check_all is false), after
>>>> +         * process_one_leaf() returns, path points to unchecked item.
>>>> +         *
>>>> +         * walk_up_tree() is reponsible to make path point to next
>>>> +         * slot to be checked, above case is handled in
>>>> +         * walk_up_tree().
>>>> +         */
>>>> +        ret =alk_up_tree(root, &path, &level, check_all);
>>>>            if (ret !=) {
>>>>                /* Normal exit, reset ret to err */
>>>>                ret =rr;
>>>>
> 
> 
