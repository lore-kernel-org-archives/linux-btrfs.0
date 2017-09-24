Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55179 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752276AbdIXORW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 10:17:22 -0400
Subject: Re: [PATCH] btrfs-progs: check: check invalid extent_inline_ref type
 in lowmem
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20170919083213.9082-1-suy.fnst@cn.fujitsu.com>
 <ab586271-41f9-611f-ec0b-179a3a030f67@gmx.com>
 <e23db2e8-955e-b7bd-7877-9a005ed07ff0@cn.fujitsu.com>
 <8902982e-7a39-e01e-719d-fef2a859b227@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ef97b663-d58d-f065-5b9c-bdffeb4c8ad5@suse.com>
Date: Sun, 24 Sep 2017 17:17:19 +0300
MIME-Version: 1.0
In-Reply-To: <8902982e-7a39-e01e-719d-fef2a859b227@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.09.2017 13:00, Qu Wenruo wrote:
> 
> 
> On 2017年09月19日 17:48, Su Yue wrote:
>>
>>
>> On 09/19/2017 04:48 PM, Qu Wenruo wrote:
>>>
>>>
>>> On 2017年09月19日 16:32, Su Yue wrote:
>>>> Lowmem check does not skip invalid type in extent_inline_ref then
>>>> calls btrfs_extent_inline_ref_size(type) which causes crash.
>>>>
>>>> Example:
>>>> $ ./btrfs-corrupt-block -e -l 20971520 /tmp/data_small
>>>> corrupting extent record: key 20971520 169 0
>>>> $ btrfs check --mode=lowmem  /tmp/data_small
>>>> Checking filesystem on /tmp/data_small
>>>> UUID: ee205d69-8724-4aa2-a4f5-bc8558a62169
>>>> checking extents
>>>> ERROR: extent[20971520 16384] backref type mismatch, missing bit: 2
>>>> ERROR: extent[20971520 16384] backref generation mismatch,
>>>> wanted: 7, have: 0
>>>> ERROR: extent[20971520 16384] is referred by other roots than 3
>>>> ctree.h:1754: btrfs_extent_inline_ref_size: BUG_ON `1` triggered,
>>>> value 1
>>>> btrfs(+0x543db)[0x55fabc2ab3db]
>>>> btrfs(+0x587f7)[0x55fabc2af7f7]
>>>> btrfs(+0x5fa44)[0x55fabc2b6a44]
>>>> btrfs(cmd_check+0x194a)[0x55fabc2bd717]
>>>> btrfs(main+0x88)[0x55fabc2682e0]
>>>> /usr/lib/libc.so.6(__libc_start_main+0xea)[0x7f021c3824ca]
>>>> btrfs(_start+0x2a)[0x55fabc267e7a]
>>>> [1]    5188 abort (core dumped)  btrfs check --mode=lowmem
>>>> /tmp/data_small
>>>>
>>>> Fix it by checking type before obtaining inline_ref size.
>>>>
>>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>>
>>> Code itself looks good.
>>> And test case please.
>>>
>> Thanks for review. I'll add test case in next version.
>>
>>> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>
>>> However, such whac-a-mole fix will finally be a nightmare to maintain.
>>>
>>> What about integrating all of such validation checkers into one place?
>>> So fsck part will only need to check their cross reference without
>>> bothering such corruption.
>>>
>> I was confused how to fix the bug(new checker or little changes
>> in this patch).
>> The reason why I fix it in this way is that most callers do
>> check type before calling btrfs_extent_inline_ref_size().
>>
>> Since you prefer the former, I'm going to do it.
> 
> Current version looks good enough as a fix.>
> Just saying we'd better using an integrated solution later.

I agree with you that we should have an integrated solution but frankly
I'd rather see it sooner rather than later, because history has shown
that if something is not done when it's first talked about it usually
gets bogged down by other work.  With this in mind, Su, might I ask you
that you repost the patch but with the centralised idea of handling the
validation lifted from Qu's kernel side patches.

> 
> Thanks,
> Qu
>>
>> Thanks
>> Su
>>
>>> Just like the kernel patch I submitted some times ago.
>>> https://www.spinics.net/lists/linux-btrfs/msg68498.html
>>>
>>> Thanks,
>>> Qu
>>>
>>>> ---
>>>>   cmds-check.c | 9 +++++++++
>>>>   1 file changed, 9 insertions(+)
>>>>
>>>> diff --git a/cmds-check.c b/cmds-check.c
>>>> index 4e0b0fe4..74c10c75 100644
>>>> --- a/cmds-check.c
>>>> +++ b/cmds-check.c
>>>> @@ -11565,6 +11565,10 @@ static int check_tree_block_ref(struct
>>>> btrfs_root *root,
>>>>                           offset, level + 1, owner,
>>>>                           NULL);
>>>>               }
>>>> +        } else {
>>>> +            error("extent[%llu %u %llu] has unknown ref type: %d",
>>>> +                  key.objectid, key.type, key.offset, type);
>>>> +            break;
>>>>           }
>>>>           if (found_ref)
>>>> @@ -11831,6 +11835,11 @@ static int check_extent_data_item(struct
>>>> btrfs_root *root,
>>>>               found_dbackref = !check_tree_block_ref(root, NULL,
>>>>                   btrfs_extent_inline_ref_offset(leaf, iref),
>>>>                   0, owner, NULL);
>>>> +        } else {
>>>> +            error("extent[%llu %u %llu] has unknown ref type: %d",
>>>> +                  disk_bytenr, BTRFS_EXTENT_DATA_KEY,
>>>> +                  disk_num_bytes, type);
>>>> +            break;
>>>>           }
>>>>           if (found_dbackref)
>>>>
>>>
>>>
>>
>>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
