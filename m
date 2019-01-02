Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708DCC43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 10:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A1E82171F
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 10:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfABKLa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 05:11:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:49504 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729242AbfABKL3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 05:11:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 85A62AF13;
        Wed,  2 Jan 2019 10:11:27 +0000 (UTC)
Subject: Re: [PATCH 3/3] btrfs-progs: Create uuid tree with proper contents
To:     Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-4-wqu@suse.com>
 <ac1e6b87-f4e3-36c0-af1a-72e3b623c80a@suse.com>
 <ffd4e7af-e595-92eb-b9d5-ac6d4bef1913@gmx.com>
 <7c7a16cf-a40b-39c0-af05-aca5617dac1c@suse.com>
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
Message-ID: <370bbd32-3b5e-cd40-4b1e-95d99f05c62e@suse.de>
Date:   Wed, 2 Jan 2019 18:11:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <7c7a16cf-a40b-39c0-af05-aca5617dac1c@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/1/2 下午6:07, Nikolay Borisov wrote:
> 
> 
> On 2.01.19 г. 12:00 ч., Qu Wenruo wrote:
>>
> 
> <snip>
> 
>>>> +}
>>>>  
>>>> +/*
>>>> + * Create a tree containing an root inode
>>>> + *
>>>> + * Caller must ensure at the time of calling, fs tree only contains 2 items
>>>> + * (one for INODE_ITEM and one for INODE_REF)
>>>> + */
>>>> +int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid)
>>>
>>> This function is really misnamed, since it's creating the
>>> DATA_RELOC_TREE, yet it's called create_inode_tree. Why not simply
>>> create_data_reloc_tree or are you planning on using this function more
>>> than once?
>>
>> In fact this could be used for fs, data reloc, and all subvolume trees.
>>
>> That's my primary reason not naming it create_data_reloc_tree().
>> Although currently it's only used by data reloc tree.
>>
>>>
>>>> +{
>>>> +	struct btrfs_root *fs_root = trans->fs_info->fs_root;
>>>> +
>>>> +	ASSERT(btrfs_header_level(fs_root->node) == 0 &&
>>>> +	       btrfs_header_nritems(fs_root->node) == 2);
>>>> +	return __create_tree(trans, fs_root, objectid);
>>>> +}
>>>> +
>>>> +int create_uuid_tree(struct btrfs_trans_handle *trans)
>>>> +{
>>>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>>>> +	struct btrfs_root *uuid_root = fs_info->uuid_root;
>>>> +	struct btrfs_key key;
>>>> +	int ret;
>>>> +
>>>> +	if (!uuid_root) {
>>>
>>> Isn't this always true,  so the conditional here is redundant?
>> Just a much better solution than ASSERT()/BUG_ON().
>>
>> It won't hurt and will handle wrong calling order.
> 
> What will the wrong calling order be? The only error that's possible is
> if someone calls this function twice or creates the tree outside of this
> api. This could only occur if someone is deliberately touching modifying
> the code in which case a trigger of an ASSERT should suffice to force
> them to think about what they are doing.

OK, I'll change it to ASSERT().

Thanks,
Qu

> 
>>
>> Thanks,
>> Qu
>>
> 
> <snip>
> 
