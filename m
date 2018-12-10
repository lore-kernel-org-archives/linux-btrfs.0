Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFB7CC04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 11:38:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B34820821
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 11:38:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B34820821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbeLJLiF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 06:38:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:47580 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726146AbeLJLiF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 06:38:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7E26AF0F;
        Mon, 10 Dec 2018 11:38:02 +0000 (UTC)
Subject: Re: [PATCH 1/8] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
To:     Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20181206065903.11343-1-wqu@suse.com>
 <20181206065903.11343-2-wqu@suse.com>
 <235ca34f-bcda-128d-dc3d-7465766271c7@suse.com>
 <fc949474-f177-0d8c-2773-8112ff06c3c4@gmx.com>
 <69bbbc9a-9288-d868-ddfa-21a5b6b605d0@suse.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <e53c14bb-bc73-9091-79fc-4112c40de3a1@suse.de>
Date:   Mon, 10 Dec 2018 19:37:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <69bbbc9a-9288-d868-ddfa-21a5b6b605d0@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/10 下午7:32, Nikolay Borisov wrote:
> 
> 
> On 10.12.18 г. 13:20 ч., Qu Wenruo wrote:
>>
>>
>> On 2018/12/10 下午5:48, Nikolay Borisov wrote:
>>>
>>>
>>> On 6.12.18 г. 8:58 ч., Qu Wenruo wrote:
>>>> Current delayed ref interface has several problems:
>>>> - Longer and longer parameter lists
>>>>   bytenr
>>>>   num_bytes
>>>>   parent
>>>>   ref_root
>>>>   owner
>>>>   offset
>>>>   for_reloc << Only qgroup code cares.
>>>>
> 
> <snip>
> 
>>>> +struct btrfs_data_ref {
>>>> +	/*
>>>> +	 * For EXTENT_DATA_REF
>>>> +	 *
>>>> +	 * @ref_root:	current owner of the extent.
>>>> +	 * 		may differ from btrfs_ref::real_root.
>>>
>>> Here 'owner' is a bit ambiguous. Isn't this the root of the owner
>>
>> Well, the @ref_root is a little confusing.
>> Here it could mean "the current btrfs_header_owner(eb)".
>>
>> I don't really know the correct term here.
> 
> My point was that the word owner is being overloaded. I guess the whole
> sentence can be rephrased as:
> 
> "The root this reference originates from. For cases where ref_root
> differs from btrfs_ref::real_root consult btrfs_ref comments".  Or
> something along those lines.
> 
>>
>>>
>>>> +	 * @ino: 	inode number of the owner. 
>>>
>>> And the owner is really the owning inode?
>>
>> Yes, the owning inode.
>>
>>>
>>>> +	 * @offset:	*CALCULATED* offset. Not EXTENT_DATA key offset.
>>>
>>> What does calculated mean here?
>>
>> Because btrfs data backref instead of using the offset of the owning
>> EXTENT_DATA key, it uses key->offset - extent_offset.
> 
> There's no way anyone reading: *CALCULATED* offset could infer that.
> Please reword. Even this sentence is a bit terse. When writing
> documentation assume people who are going to read it will have *very*
> little knowledge of the internal structure of the code.
> 
>>
>>>
>>>> +	 *
>>>> +	 */
>>>
>>> Ugh, this is ugly, why not have a single /* */ line above each member
>>> and document them like that?
>>
>> Because the complexity of @ref_root can't really go one line.
> 
> What I meant is to have the documentation for every member right above
> the respective member, rather than having the documentation in one
> place, followed by the variables. If it takes more than a single line to
> document a member so be it.

Understood.

> 
> <snip>
> 
>>>> +	/*
>>>> +	 * Use full backref(SHARED_BLOCK_REF or SHARED_DATA_REF) for this
>>>> +	 * extent and its children.
>>>> +	 * Set for reloc trees.
>>>> +	 */
>>>> +	unsigned int use_fullback:1;
>>>
>>> 'fullback' is too terse, use_backreferences or something conveying more
>>> information?
>>
>> @use_backreferences looks even stranger to me.
>>
>> Here the point is, if this bit set, all backref will use
>> SHARED_BLOCK_REF or SHARED_DATA_REF subtype, and just leave a pointer to
>> its parent.
>>
>> Any good idea for explaining this?
> 
> What's the alternative if this bit is not set, how would the tree look like?

If not set and @parent is 0, it will goes normal backref like
EXTENT_DATA_REF (root, ino, offset), or TREE_BLOCK_REF (root, level).

If not set and @parent is not 0, it will go SHARED_BLOCK_REF or
SHARED_DATA_REF (parent).

> 
> 
>>
>>> Also please use explicit bool type:
>>>
>>> bool xxxx:1
>>
>> Is this valid? Haven't seen such usage in kernel code IIRC.
> 
> git grep 'bool .*:1' | wc -l
> 417

grep -IR 'bool .*:1' fs/btrfs/ | wc -l
0

So I guess another cleanup?

Thanks,
Qu

> 
> <snip>
>>
