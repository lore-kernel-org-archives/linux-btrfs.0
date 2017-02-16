Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46373 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751583AbdBPJB6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 04:01:58 -0500
Subject: Re: [PATCH v2] btrfs: qgroup: Move half of the qgroup accounting time
 out of commit trans
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <20170215024303.26907-1-quwenruo@cn.fujitsu.com>
 <cc13d0b2-9355-e61b-04c4-49f354aada58@gmail.com>
 <f12289c2-7a2f-59d5-756a-5a6e7700b773@cn.fujitsu.com>
 <754d5182-6a5a-09bd-ebcd-4470ca95fdfd@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <fe11cf35-e0c5-ea9e-fa85-bce82571d5f2@cn.fujitsu.com>
Date: Thu, 16 Feb 2017 17:01:42 +0800
MIME-Version: 1.0
In-Reply-To: <754d5182-6a5a-09bd-ebcd-4470ca95fdfd@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/16/2017 04:56 PM, Nikolay Borisov wrote:
>
>
> On 16.02.2017 10:50, Qu Wenruo wrote:
>>
>>
>> At 02/16/2017 04:45 PM, Nikolay Borisov wrote:
>>> Just a minor nit.
>>>
>>> On 15.02.2017 04:43, Qu Wenruo wrote:
>>>> Just as Filipe pointed out, the most time consuming parts of qgroup are
>>>> btrfs_qgroup_account_extents() and
>>>> btrfs_qgroup_prepare_account_extents().
>>>> Which both call btrfs_find_all_roots() to get old_roots and new_roots
>>>> ulist.
>>>>
>>>> What makes things worse is, we're calling that expensive
>>>> btrfs_find_all_roots() at transaction committing time with
>>>> TRANS_STATE_COMMIT_DOING, which will blocks all incoming transaction.
>>>>
>>>> Such behavior is necessary for @new_roots search as current
>>>> btrfs_find_all_roots() can't do it correctly so we do call it just
>>>> before switch commit roots.
>>>>
>>>> However for @old_roots search, it's not necessary as such search is
>>>> based on commit_root, so it will always be correct and we can move it
>>>> out of transaction committing.
>>>>
>>>> This patch moves the @old_roots search part out of
>>>> commit_transaction(), so in theory we can half the time qgroup time
>>>> consumption at commit_transaction().
>>>>
>>>> But please note that, this won't speedup qgroup overall, the total time
>>>> consumption is still the same, just reduce the performance stall.
>>>>
>>>> Cc: Filipe Manana <fdmanana@suse.com>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> ---
>>>> v2:
>>>>   Update commit message to make it more clear.
>>>>   Don't call btrfs_find_all_roots() before insert qgroup extent record,
>>>>   so we can avoid wasting CPU for already inserted qgroup extent record.
>>>>
>>>> PS:
>>>> If and only if we have fixed and proved btrfs_find_all_roots() can
>>>> get correct result with current root, then we can move all
>>>> expensive btrfs_find_all_roots() out of transaction committing.
>>>>
>>>> However I strongly doubt if it's possible with current delayed ref,
>>>> and without such prove, move btrfs_find_all_roots() for @new_roots
>>>> out of transaction committing will just screw up qgroup accounting.
>>>>
>>>> ---
>>>>  fs/btrfs/delayed-ref.c | 20 ++++++++++++++++----
>>>>  fs/btrfs/qgroup.c      | 33 +++++++++++++++++++++++++++++----
>>>>  fs/btrfs/qgroup.h      | 33 ++++++++++++++++++++++++++++++---
>>>>  3 files changed, 75 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
>>>> index ef724a5fc30e..0ee927ef5a71 100644
>>>> --- a/fs/btrfs/delayed-ref.c
>>>> +++ b/fs/btrfs/delayed-ref.c
>>>> @@ -550,13 +550,14 @@ add_delayed_ref_head(struct btrfs_fs_info
>>>> *fs_info,
>>>>               struct btrfs_delayed_ref_node *ref,
>>>>               struct btrfs_qgroup_extent_record *qrecord,
>>>>               u64 bytenr, u64 num_bytes, u64 ref_root, u64 reserved,
>>>> -             int action, int is_data)
>>>> +             int action, int is_data, int *qrecord_inserted_ret)
>>>>  {
>>>>      struct btrfs_delayed_ref_head *existing;
>>>>      struct btrfs_delayed_ref_head *head_ref = NULL;
>>>>      struct btrfs_delayed_ref_root *delayed_refs;
>>>>      int count_mod = 1;
>>>>      int must_insert_reserved = 0;
>>>> +    int qrecord_inserted = 0;
>>>
>>> Why use an integer when you only require a boolean value? I doubt it
>>> will make much difference at asm level if you switch to bool but at
>>> least it will make it more apparent it's being used as a true|false
>>> variable. The same comment applies to other functions where you've used
>>> similar variable.
>>
>> In fact I didn't see the point to use bool in most case.
>> And we are using int as bool almost everywhere, just like
>> must_insert_reserved and is_data.
>>
>> Or is there some coding style documentation prohibiting us to use int as
>> bool?
>
> There most certainly isn't. It's just more of a personal preference so
> that's why I don't have a very strong opinion on this. In this case then
> it's better to use int for the sake of consistency.

I'll keep it in mind if I'm going to create some new functions.

Although this makes sense for readability, in this case I prefer 
consistency more.

Thanks,
Qu

>
>>
>> Thanks,
>> Qu
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


