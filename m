Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7989CC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 08:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D2D214AF
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 08:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfCLIdP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:33:15 -0400
Received: from mout.gmx.net ([212.227.15.19]:55127 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbfCLIdO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 04:33:14 -0400
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MaaOf-1hN4bM1PvV-00KABW; Tue, 12
 Mar 2019 09:33:02 +0100
Subject: Re: [PATCH] btrfs: Check the first key and level for cached extent
 buffer
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190312074558.32393-1-wqu@suse.com>
 <f11bba01-1955-b3ba-f824-d999c18578a6@suse.com>
 <1dbd21a1-1e11-d877-553a-2961b3074c16@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <cd40d9ec-1a9c-fc82-c50c-127b0fa6f44b@gmx.com>
Date:   Tue, 12 Mar 2019 16:32:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <1dbd21a1-1e11-d877-553a-2961b3074c16@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Nkm7U9udbI8DlGlDih6jcbb3xteaZjPrk/XebOSLZk370kHJYL3
 iJH63ow1wxvXJ2fVCg2XXdiYPbqEMZtNqtGIAxxu/VvLFdEFMBWxmQV1ImAylyxuOZAQR9u
 FOxcyG8ThD48+lfF5Kf2UWnyWjtAl+pUfw2lE6nj5h3+7Ft4gbZPS94BTBiYeHMBQVYbGcz
 sMZefzY+vwEBIYk6vjebg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:NvNAKpsFmwQ=:7Y9kLX1g/5UP5+bDm3F31X
 ygctTzv+pxNSDANTSedsXNDs5mE2qu/DyRHm0HE64Emui77OjtXto8yTKuD5dAfamd/ORdf1d
 dEG8OuB27gxRpPPPRHaTDADiY0oB8RuRJUzwbqGDauvpY3bgwGZJZtvJJWxoE4AAitTkYn+z/
 s4AZl/nSz0qoChks+l0P71226utOgjklLiTZlk4sCrc9smxWDW8yqCCTkNgjmiNwvFKlqXfLy
 H48EduMs4z0B/Bhc9/Imm2H48FzA8UTjMNYEheSUBVXXALQev67LNOE51VSp60K9WUkyIQV/8
 NAB3+Tg1nVc1g0zfCGyIIuRL2HWlGKVvNpP2ia1MJcIsSC0miV8iXL94FK4JMSqJti3oIZux4
 X2IWN72hVmQaJXccJXQO7nv5KTmvbLnbIXw2KkmcrzkKPhZ3M0L29ClUiN+h1M/LTo+8PB4Kk
 vUTuFGTFbKOz0l4SWmixdfYv+sFniCdkGFuwMapD8xIEnjUZcTwJAAOHun6vhQxqoXOAN2kG+
 E2Xfko1joX4pQwgwh3qGnK8F+62oa1Z99Uiq/kIXZM9OwXw4LraUlEhbniP4mF7ezpLRkdLDD
 Vg/PQTO5VfFlsx7YtB7ZtCx/WU7h9fu2A16g0UW9AFMvg46JCPGlXMVj5Kx/CFiJo3hkpJDtB
 F4EToVeVuEcO2m9NBUirqn69KE7U1cEXtb0oOsmi30FYcaQQ4fJJsmCkhojYJFuK6yQR+7X/W
 jyAIFYczcAYYN5Cwya+jIUxN29tRj1ZpAg6kN3gMXbBGvibWXZ4lQ0MHcAR3qkx+BjY8dSIUX
 eT4t7gNfUkck8iIhZNQGst+9IcpZYqTKCSMJT0gRP+rpF/4gd9+qtioFdUe39Vl3Y7cD9RFAN
 Ivx4iOai/Ve5lKiNhSGjB2LrGxk0P+ecLmxCY9j/mFkK4mtf6nowNq6g1Lbm5iWdbn57IGCk+
 xQK5i+qVB/Q==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/12 下午4:11, Nikolay Borisov wrote:
> 
> 
> On 12.03.19 г. 9:57 ч., Nikolay Borisov wrote:
>>
>>
>> On 12.03.19 г. 9:45 ч., Qu Wenruo wrote:
>>> [BUG]
>>> When reading a file from a fuzzed image, kernel can panic like:
>>>   BTRFS warning (device loop0): csum failed root 5 ino 270 off 0 csum 0x98f94189 expected csum 0x00000000 mirror 1
>>>   assertion failed: !memcmp_extent_buffer(b, &disk_key, offsetof(struct btrfs_leaf, items[0].key), sizeof(disk_key)), file: fs/btrfs/ctree.c, line: 2544
>>>   ------------[ cut here ]------------
>>>   kernel BUG at fs/btrfs/ctree.h:3500!
>>>   invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
>>>   RIP: 0010:btrfs_search_slot.cold.24+0x61/0x63 [btrfs]
>>>   Call Trace:
>>>    btrfs_lookup_csum+0x52/0x150 [btrfs]
>>>    __btrfs_lookup_bio_sums+0x209/0x640 [btrfs]
>>>    btrfs_submit_bio_hook+0x103/0x170 [btrfs]
>>>    submit_one_bio+0x59/0x80 [btrfs]
>>>    extent_read_full_page+0x58/0x80 [btrfs]
>>>    generic_file_read_iter+0x2f6/0x9d0
>>>    __vfs_read+0x14d/0x1a0
>>>    vfs_read+0x8d/0x140
>>>    ksys_read+0x52/0xc0
>>>    do_syscall_64+0x60/0x210
>>>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>
>>> [CAUSE]
>>> The fuzzed image has a corrupted leaf whose first key doesn't match with its parent:
>>>   checksum tree key (CSUM_TREE ROOT_ITEM 0)
>>>   node 29741056 level 1 items 14 free 107 generation 19 owner CSUM_TREE
>>>   fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
>>>   chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
>>>   	...
>>>           key (EXTENT_CSUM EXTENT_CSUM 79691776) block 29761536 gen 19
>>>
>>>   leaf 29761536 items 1 free space 1726 generation 19 owner CSUM_TREE
>>>   leaf 29761536 flags 0x1(WRITTEN) backref revision 1
>>>   fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
>>>   chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
>>>           item 0 key (EXTENT_CSUM EXTENT_CSUM 8798638964736) itemoff 1751 itemsize 2244
>>>                   range start 8798638964736 end 8798641262592 length 2297856
>>>
>>> For the first time tree read, it will not pass verify_level_key() check.
>>> But the extent buffer will still be cached.
>>>
>>> Also there is a pitfall in read_block_for_search(), where a cached
>>> extent buffer will not be checked for its level and first key.
>>>
>>> There are context where we read tree block without verifying its
>>> first key, such as scrub.
>>>
>>> So in that case, a corrupted leaf can sneak in and screw up the kernel.
>>>
>>> [FIX]
>>> Export verify_level_key() as btrfs_verify_level_key() and call it in
>>> read_block_for_search() to fill the hole.
>>>
>>> Please note, this will cause a lot of extra error message if we have a
>>> bad tree block in any hot tree, but it's still much better to trigger
>>> the final safe net in key_search_validate().
>>>
> 
> <snip>
> 
>>>  				ret = -EIO;
>>> -			else if (verify_level_key(fs_info, eb, level,
>>> -						  first_key, parent_transid))
>>> +			else if (btrfs_verify_level_key(fs_info, eb, level,
>>> +						first_key, parent_transid))
>>>  				ret = -EUCLEAN;
>>
>> Actually why is the buffer still held when we return EUCLEAN since in
>> read_tree_block if btree_read_extent_buffer_pages returns an error
>> free_extent_buffer should be called and it should delete the eb from eb
>> cache, no ? IMO the correct behavior should be to remove the corrupted
>> buffer ASAP and not rely on later validation.
> 
> Actually in this case the call to free_extent_buffer in read_tree_block
> won't really clean the buffer since at this point the buffer has refs =
> 2 (one from alloc_extent_buffer and one from being added to the tree),
> however the code in free_extent_buffer won't execute the atomic_cmpxchg
> to do the decrement nor will it execute the fix up right after the
> spinlock if (refs==2 && EXTENT_BUFFER_STALE) which leaves only a single
> call to atomic_dec_and_test in release_extent_buffer which will return
> false. That's wrong.
> 
> 
> The way to fix it is to either:
> a) add a call to atomic_dec(eb->refs) so that the single call to
> atomic_dec_and_test frees the eb
> 
> b) call free_extent_buffer_stale which does atomic_dec itself, I'm more
> inclined to use this option.

Despite the scrub case I described, there is even a more possible case
to sneak a bad eb into cache tree.

One tree block shared by two snapshots, and one of the parent has bad key.

Anyway, either method you mentioned can't solve either shared tree block
nor the scrub case.

So we still need the check, and keep the key_seach_validate() as final
safe net.

Thanks,
Qu

> 
> 
>>
>>>  			else
>>>  				break;
>>> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
>>> index 987a64bc0c66..67a9fe2d29c7 100644
>>> --- a/fs/btrfs/disk-io.h
>>> +++ b/fs/btrfs/disk-io.h
>>> @@ -39,6 +39,9 @@ static inline u64 btrfs_sb_offset(int mirror)
>>>  struct btrfs_device;
>>>  struct btrfs_fs_devices;
>>>  
>>> +int btrfs_verify_level_key(struct btrfs_fs_info *fs_info,
>>> +			   struct extent_buffer *eb, int level,
>>> +			   struct btrfs_key *first_key, u64 parent_transid);
>>>  struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
>>>  				      u64 parent_transid, int level,
>>>  				      struct btrfs_key *first_key);
>>>
>>
