Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:43205 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751064AbeDYF3I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Apr 2018 01:29:08 -0400
Subject: Re: [PATCH 3/3] btrfs-progs: do not merge tree block refs have
 different root_id
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <20180424055233.6420-3-suy.fnst@cn.fujitsu.com>
 <5de2f409-32e4-7e23-3589-e89c2e7510c3@gmx.com>
 <c40ab3ef-5495-74be-489c-1704eac9f77f@cn.fujitsu.com>
 <ae2fa324-0e8b-9641-d957-37c941344321@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <ebb7fe99-6b0c-e3ed-c16d-bd1064545e36@cn.fujitsu.com>
Date: Wed, 25 Apr 2018 13:34:41 +0800
MIME-Version: 1.0
In-Reply-To: <ae2fa324-0e8b-9641-d957-37c941344321@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/24/2018 02:50 PM, Qu Wenruo wrote:
> 
> 
> On 2018年04月24日 14:43, Su Yue wrote:
>>
>>
>> On 04/24/2018 02:17 PM, Qu Wenruo wrote:
>>>
>>>
>>> On 2018年04月24日 13:52, Su Yue wrote:
>>>> For an extent item which contains many tree block backrefs, like
>>>> ===============================================================
>>>> In 020-extent-ref-cases/keyed_block_ref.img
>>>>
>>>> item 10 key (29470720 METADATA_ITEM 0) itemoff 3450 itemsize 222
>>>>                   refs 23 gen 10 flags TREE_BLOCK
>>>>                   tree block skinny level 0
>>>>                   tree block backref root 278
>>>>                   tree block backref root 277
>>>>                   tree block backref root 276
>>>>                   tree block backref root 275
>>>>                   tree block backref root 274
>>>>                   tree block backref root 273
>>>>                   tree block backref root 272
>>>>                   tree block backref root 271
>>>>                   tree block backref root 270
>>>>                   tree block backref root 269
>>>>                   tree block backref root 268
>>>>                   tree block backref root 267
>>>>                   tree block backref root 266
>>>>                   tree block backref root 265
>>>>                   tree block backref root 264
>>>>                   tree block backref root 263
>>>>                   tree block backref root 262
>>>>                   tree block backref root 261
>>>>                   tree block backref root 260
>>>>                   tree block backref root 259
>>>>                   tree block backref root 258
>>>>                   tree block backref root 257
>>>> ===============================================================
>>>> In find_parent_nodes(), these refs's parents are 0, then __merge_refs
>>>> will merge refs to one ref. It causes only one root to be returned.
>>>
>>> This is a pretty big problem, and it would cause qgroup verification
>>> code to cause false alerts.
>>>
>>> So a new test case would do great help here.
>>>
>> Let me think how to construct a test case a while.
>> If I remember correctly, the function is called rarely only
>> in check/lowmem check.
>> Check calls it in a very corner case.
>> As you know, extent check in lowmme is buggy which I'm try to fix.
> 
> I mean, if the problem is find_parent_nodes() can only return one root,
> it would definitely cause problem for qgroup_verify_all() function, then
> it should be pretty easy to craft a test image.
> 

Unfortunately, qgroup_verify_all() uses another version
find_parent_roots() written by itself own.
The test case is hard to create.

The best solution still is porting codes from kernel to btrfs-progs.
But the work needs some time to do.
The v2.1 version of this patch is temporary fix at present.

Thanks,
Su
> Thanks,
> Qu
> 
>>
>>>>
>>>> So, if both parents are 0, do not merge refs.
>>>>
>>>> Lowmem check calls find_parent_nodes frequently to decide whether.
>>>> check an extent buffer or not. These bug influences bytes accounting.
>>>
>>> Although it looks good so far, and would fix the problem you found, but
>>
>> Fixing another bug in lowmem, found it by accident.
>>
>>> I strongly recommend to port kernel backref code to btrfs-progs here, as
>>> kernel backref code is more tested than btrfs-progs backref code.
>>>
>> It's a fact. Seen backref.c in btrfs-progs, there are many useless codes
>> and confusing logicals.
>> I agree that port kernel backref code to btrfs-progs.
>>
>>> I'm pretty sure we have more bugs in btrfs-progs backref, and I'm not a
>>> big fan of playing whac-a-mole here.
>>>
>>>>
>>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>>> ---
>>>>    backref.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/backref.c b/backref.c
>>>> index 51553c702187..daadb6299c79 100644
>>>> --- a/backref.c
>>>> +++ b/backref.c
>>>> @@ -507,6 +507,8 @@ static void __merge_refs(struct pref_state
>>>> *prefstate, int mode)
>>>>                } else {
>>>>                    if (ref1->parent !=ef2->parent)
>>>>                        continue;
>>>> +                if (ref1->parent =0)
>>>> +                    continue;
>>>
>>> It's better to put it above (ref1->parent !=ef2->parent).
>>> As parent =0 means we haven't resolve the parent bytenr yet, so can't
>>> be merged nor compared.
>>
>> Ok, will do it in V2.
>>
>> Thanks,
>> Su
>>>
>>> Thanks,
>>> Qu
>>>
>>>>                }
>>>>                  eie =ef1->inode_list;
>>>>
>>>
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


