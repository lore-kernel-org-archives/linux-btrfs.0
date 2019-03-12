Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6AEC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 08:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DF6B214AF
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 08:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfCLIjc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:39:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:47902 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727173AbfCLIjc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 04:39:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D9889B06B;
        Tue, 12 Mar 2019 08:39:28 +0000 (UTC)
Subject: Re: [PATCH] btrfs: Check the first key and level for cached extent
 buffer
To:     Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190312074558.32393-1-wqu@suse.com>
 <f11bba01-1955-b3ba-f824-d999c18578a6@suse.com>
 <1dbd21a1-1e11-d877-553a-2961b3074c16@suse.com>
 <cd40d9ec-1a9c-fc82-c50c-127b0fa6f44b@gmx.com>
 <6241e720-af13-2445-cfb7-3d5a794b8044@suse.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <3ab6481a-4b55-54ec-d180-d0b952deec8d@suse.de>
Date:   Tue, 12 Mar 2019 16:39:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <6241e720-af13-2445-cfb7-3d5a794b8044@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/12 下午4:34, Nikolay Borisov wrote:
> 
> 
> On 12.03.19 г. 10:32 ч., Qu Wenruo wrote:
>>
>>
>> On 2019/3/12 下午4:11, Nikolay Borisov wrote:
>>>
>>>
>>> On 12.03.19 г. 9:57 ч., Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 12.03.19 г. 9:45 ч., Qu Wenruo wrote:
>>>>> [BUG]
>>>>> When reading a file from a fuzzed image, kernel can panic like:
>>>>>   BTRFS warning (device loop0): csum failed root 5 ino 270 off 0 csum 0x98f94189 expected csum 0x00000000 mirror 1
>>>>>   assertion failed: !memcmp_extent_buffer(b, &disk_key, offsetof(struct btrfs_leaf, items[0].key), sizeof(disk_key)), file: fs/btrfs/ctree.c, line: 2544
>>>>>   ------------[ cut here ]------------
>>>>>   kernel BUG at fs/btrfs/ctree.h:3500!
>>>>>   invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>>>>>   RIP: 0010:btrfs_search_slot.cold.24+0x61/0x63 [btrfs]
>>>>>   Call Trace:
>>>>>    btrfs_lookup_csum+0x52/0x150 [btrfs]
>>>>>    __btrfs_lookup_bio_sums+0x209/0x640 [btrfs]
>>>>>    btrfs_submit_bio_hook+0x103/0x170 [btrfs]
>>>>>    submit_one_bio+0x59/0x80 [btrfs]
>>>>>    extent_read_full_page+0x58/0x80 [btrfs]
>>>>>    generic_file_read_iter+0x2f6/0x9d0
>>>>>    __vfs_read+0x14d/0x1a0
>>>>>    vfs_read+0x8d/0x140
>>>>>    ksys_read+0x52/0xc0
>>>>>    do_syscall_64+0x60/0x210
>>>>>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>>>
>>>>> [CAUSE]
>>>>> The fuzzed image has a corrupted leaf whose first key doesn't match with its parent:
>>>>>   checksum tree key (CSUM_TREE ROOT_ITEM 0)
>>>>>   node 29741056 level 1 items 14 free 107 generation 19 owner CSUM_TREE
>>>>>   fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
>>>>>   chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
>>>>>   	...
>>>>>           key (EXTENT_CSUM EXTENT_CSUM 79691776) block 29761536 gen 19
>>>>>
>>>>>   leaf 29761536 items 1 free space 1726 generation 19 owner CSUM_TREE
>>>>>   leaf 29761536 flags 0x1(WRITTEN) backref revision 1
>>>>>   fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
>>>>>   chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
>>>>>           item 0 key (EXTENT_CSUM EXTENT_CSUM 8798638964736) itemoff 1751 itemsize 2244
>>>>>                   range start 8798638964736 end 8798641262592 length 2297856
>>>>>
>>>>> For the first time tree read, it will not pass verify_level_key() check.
>>>>> But the extent buffer will still be cached.
>>>>>
>>>>> Also there is a pitfall in read_block_for_search(), where a cached
>>>>> extent buffer will not be checked for its level and first key.
>>>>>
>>>>> There are context where we read tree block without verifying its
>>>>> first key, such as scrub.
>>>>>
>>>>> So in that case, a corrupted leaf can sneak in and screw up the kernel.
>>>>>
>>>>> [FIX]
>>>>> Export verify_level_key() as btrfs_verify_level_key() and call it in
>>>>> read_block_for_search() to fill the hole.
>>>>>
>>>>> Please note, this will cause a lot of extra error message if we have a
>>>>> bad tree block in any hot tree, but it's still much better to trigger
>>>>> the final safe net in key_search_validate().
>>>>>
>>>
>>> <snip>
>>>
>>>>>  				ret = -EIO;
>>>>> -			else if (verify_level_key(fs_info, eb, level,
>>>>> -						  first_key, parent_transid))
>>>>> +			else if (btrfs_verify_level_key(fs_info, eb, level,
>>>>> +						first_key, parent_transid))
>>>>>  				ret = -EUCLEAN;
>>>>
>>>> Actually why is the buffer still held when we return EUCLEAN since in
>>>> read_tree_block if btree_read_extent_buffer_pages returns an error
>>>> free_extent_buffer should be called and it should delete the eb from eb
>>>> cache, no ? IMO the correct behavior should be to remove the corrupted
>>>> buffer ASAP and not rely on later validation.
>>>
>>> Actually in this case the call to free_extent_buffer in read_tree_block
>>> won't really clean the buffer since at this point the buffer has refs =
>>> 2 (one from alloc_extent_buffer and one from being added to the tree),
>>> however the code in free_extent_buffer won't execute the atomic_cmpxchg
>>> to do the decrement nor will it execute the fix up right after the
>>> spinlock if (refs==2 && EXTENT_BUFFER_STALE) which leaves only a single
>>> call to atomic_dec_and_test in release_extent_buffer which will return
>>> false. That's wrong.
>>>
>>>
>>> The way to fix it is to either:
>>> a) add a call to atomic_dec(eb->refs) so that the single call to
>>> atomic_dec_and_test frees the eb
>>>
>>> b) call free_extent_buffer_stale which does atomic_dec itself, I'm more
>>> inclined to use this option.
>>
>> Despite the scrub case I described, there is even a more possible case
>> to sneak a bad eb into cache tree.
>>
>> One tree block shared by two snapshots, and one of the parent has bad key.
>>
>> Anyway, either method you mentioned can't solve either shared tree block
>> nor the scrub case.
>>
>> So we still need the check, and keep the key_seach_validate() as final
>> safe net.
> 
> Still, there seems to be a bug in the way failed eb's are handled during
> normal read. Also your commit log doesn't describe how those ebs can
> sneak in. Please describe the call chains in v2

Sure, I'll add that part and describe the reason why we need to do the
check here.

In fact after I send out the btrfs-progs patch to discard bad tree
blocks, I tried the same way in kernel, but as you mentioned, it's
different in kernel and needs extra care to handle.

Thanks,
Qu

> 
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>>>
>>>>>  			else
>>>>>  				break;
>>>>> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
>>>>> index 987a64bc0c66..67a9fe2d29c7 100644
>>>>> --- a/fs/btrfs/disk-io.h
>>>>> +++ b/fs/btrfs/disk-io.h
>>>>> @@ -39,6 +39,9 @@ static inline u64 btrfs_sb_offset(int mirror)
>>>>>  struct btrfs_device;
>>>>>  struct btrfs_fs_devices;
>>>>>  
>>>>> +int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
>>>>> +			   struct extent_buffer *eb, int level,
>>>>> +			   struct btrfs_key *first_key, u64 parent_transid);
>>>>>  struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
>>>>>  				      u64 parent_transid, int level,
>>>>>  				      struct btrfs_key *first_key);
>>>>>
>>>>
>>
