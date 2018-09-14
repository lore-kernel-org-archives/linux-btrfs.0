Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42714 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726831AbeINLkC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 07:40:02 -0400
Subject: Re: [PATCH v2 4/7] btrfs-progs: lowmem: search key of root again
 after check_fs_root() under repair
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        damenly.su@gmail.com, linux-btrfs@vger.kernel.org
References: <20180912204924.10089-1-suy.fnst@cn.fujitsu.com>
 <20180912204924.10089-5-suy.fnst@cn.fujitsu.com>
 <070c1e5b-1ce8-f69a-fc49-426d51d5703b@gmx.com>
 <b0ea17c4-5040-3560-d135-54006e378c6d@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <8572ed9f-3b9d-9df2-b596-d3362fc9b8f2@suse.com>
Date: Fri, 14 Sep 2018 09:27:00 +0300
MIME-Version: 1.0
In-Reply-To: <b0ea17c4-5040-3560-d135-54006e378c6d@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.09.2018 03:58, Su Yue wrote:
> 
> 
> On 09/14/2018 07:37 AM, Qu Wenruo wrote:
>>
>>
>> On 2018/9/13 上午4:49, damenly.su@gmail.com wrote:
>>> From: Su Yue <suy.fnst@cn.fujitsu.com>
>>>
>>> In check_fs_roots_lowmem(), we do search and follow the resulted path
>>> to call check_fs_root(), then call btrfs_next_item() to check next
>>> root.
>>> However, if repair is enabled, the root tree can be cowed, the
>>> existed path can cause strange errors.
>>>
>>> Solution:
>>>    If repair, save the key before calling check_fs_root,
>>>    search the saved key again before checking next root.
>>
>> Both reason and solution looks good.
>>
>>>
>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>> ---
>>>   check/mode-lowmem.c | 15 +++++++++++++++
>>>   1 file changed, 15 insertions(+)
>>>
>>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>>> index 89a304bbdd69..8fc9edab1d66 100644
>>> --- a/check/mode-lowmem.c
>>> +++ b/check/mode-lowmem.c
>>> @@ -4967,9 +4967,13 @@ int check_fs_roots_lowmem(struct btrfs_fs_info
>>> *fs_info)
>>>       }
>>>         while (1) {
>>> +        struct btrfs_key saved_key;
>>> +
>>>           node = path.nodes[0];
>>>           slot = path.slots[0];
>>>           btrfs_item_key_to_cpu(node, &key, slot);
>>> +        if (repair)
>>> +            saved_key = key;
>>>           if (key.objectid > BTRFS_LAST_FREE_OBJECTID)
>>>               goto out;
>>>           if (key.type == BTRFS_ROOT_ITEM_KEY &&
>>> @@ -5000,6 +5004,17 @@ int check_fs_roots_lowmem(struct btrfs_fs_info
>>> *fs_info)
>>>               err |= ret;
>>>           }
>>>   next:
>>> +        /*
>>> +         * Since root tree can be cowed during repair,
>>> +         * here search the saved key again.
>>> +         */
>>> +        if (repair) {
>>> +            btrfs_release_path(&path);
>>> +            ret = btrfs_search_slot(NULL, fs_info->tree_root,
>>> +                        &saved_key, &path, 0, 0);
>>> +            /* Repair never deletes trees, search must succeed. */
>>> +            BUG_ON(ret);
>>
>> But this doesn't look good to me.
>>
>> Your assumption here is valid (at least for now), but it's possible that
>> some tree blocks get corrupted in a large root tree, and in that case,
>> we could still read part of the root tree, but btrfs_search_slot() could
>> still return -EIO for certain search key.
>>
>> So I still prefer to do some error handling other than BUG_ON(ret).
>>
> Okay, will try it.

Just to emphasize Qu's point - we should strive to remove existing
BUG_ON and should never introduce new ones. btrfs-progs is already quite
messy and we should be improving that.

> 
> Thanks,
> Su
>> Thanks,
>> Qu
>>
>>> +        }
>>>           ret = btrfs_next_item(tree_root, &path);
>>>           if (ret > 0)
>>>               goto out;
>>>
>>
>>
> 
> 
> 
