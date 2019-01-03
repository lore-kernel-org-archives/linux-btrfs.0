Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF31C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 01:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 532222073F
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 01:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfACBKd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 20:10:33 -0500
Received: from mout.gmx.net ([212.227.17.20]:53903 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbfACBKc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 20:10:32 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MTvUT-1gnHgr1v6H-00Qmec; Thu, 03
 Jan 2019 02:10:21 +0100
Subject: Re: [PATCH RFC 0/2] Use new incompat feature BG_TREE to hugely reduce
 mount time
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20181228083745.3134-1-wqu@suse.com>
 <38520a81-e5b0-35b5-bf81-966ea6ef2c45@suse.com>
 <d4ee763f-19b4-e50f-1746-d2ca4152a3c5@gmx.com>
 <20190102162113.GX23615@twin.jikos.cz>
 <e1b30348-71ae-148d-c7c6-9de98edbb6de@gmx.com>
 <59536453-b5f5-9283-bd87-d61e3abf211f@mendix.com>
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
Message-ID: <ee37d670-b5c1-2bb3-7533-06190cc2fa79@gmx.com>
Date:   Thu, 3 Jan 2019 09:10:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <59536453-b5f5-9283-bd87-d61e3abf211f@mendix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:NSPwcI+aYY+KgF7DRfDRUFjqTzcrky52qLKQAQufLqmEmhm8z2B
 bi1JNdUSZ6d5DUpbCpWeqO8cXkLKbEjoE/4TdoAMSrMjuMyaGtLFnJGs8npI9X0TwORf1y9
 90hirI54q5vwEjsv/VZBvIRC6/3u1wP7z9aqec1Sdypv4sP6vEeTl6UMOJ8KLc7I1zNHzV0
 CrthGnLOSJR+jJBWNVglQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zc73LAGEIrg=:xLp08Xbo7/7+e4ry2HQpCU
 LLhnu5ejtmDjdBZ+nBpn8MHMMAjbsSFdqVW5wicczSE9PVbr+fCac/qqJfixuwUqWO/dTJrDo
 /tOfA6M5f+0Re9p9w69Sf2OSPTI4iYhkHJkbRrrjNPtcgWY4EuLUOby2PN0z1tPrEYmCz+yVa
 NReEvwyptA32nSHcKK0caGkfk8b+rdxbDEcFT55KhI4O5ErZp07FnVbCzb5UDg7C5EQ6vM8VU
 c+ouOn4NFuavnTZUzJTl9aRPOmr8oHxd/R3oexBg7YeFIQTatGbruRH7psymGRJGa6c13Oh8i
 0sReobvLRoQoVpwYf44v79++UZRmDAiR6znnq3hXp0AfSFrOowuyGCUEoQSx3TufFV5lJHt7i
 DC/XCNEJvncLqMDQY33a1e7oJ/EZ5AAr4tIqosJtNgWkfQs6ppSaQPteNkuUHriYsQcNaKZ97
 sHxP7u4sEl3BBDiq0Sc3eALqwSjCflFAathtIPE3fIL4eSb7yr9l69fdLJ9sH5CyeGGIvJTfx
 KHmv8Mkvud3RUzHjc+Tg0mXMCKWlEOhILsBRkOpK1j2IJMy64J2WrV8zIrbz9EokorTTxEIzn
 Y8yAS5ZcMiscxbb/1vnFRtn6Fylxqpy2cf0QA+W3vsSeN2ylRiOMNoFmWwORqeLRT6lhVMRoO
 xWMNF16mso1AMiqdD2vNXDfaVbEPsxT+gy2bZy3IGtO+WFrdN41pCjgKYPPU7cqUSjMUa9SyO
 yB+43AVPZiFsTBTMcHK9LFzbxxZvZ3uSxI26IHzwMTeHolDbbd28lFlq7e4rq8Ihz7ceH7O5Z
 /1+Y6CiAoCC6mzAK0QaaLavZCpleYh6EdprZX7Y52AcbjgGhL1hKYmMYVbGCbhrLjVVtxVuui
 29yewCBwqLaVu7J9PsVoyiNWIri23PPnPgzGSumGUEmqsvUKF9Qif75AFWxdQ4UedcftgXb8O
 7YwrK2qvw1w==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/1/3 上午8:57, Hans van Kranenburg wrote:
> Hi,
> 
> On 1/3/19 1:14 AM, Qu Wenruo wrote:
>>
>>
>> On 2019/1/3 上午12:21, David Sterba wrote:
>>> On Fri, Dec 28, 2018 at 05:28:13PM +0800, Qu Wenruo wrote:
>>>> On 2018/12/28 下午5:15, Nikolay Borisov wrote:
>>>>> On 28.12.18 г. 10:37 ч., Qu Wenruo wrote:
>>>>>> This patchset can be fetched from:
>>>>>> https://github.com/adam900710/linux/tree/bg_tree
>>>>>> Which is based on v4.20-rc1 tag.
>>>>>>
>>>>>> This patchset will hugely reduce mount time of large fs by putting all
>>>>>> block group items into its own tree.
> 
> Thanks a lot for writing a proof of concept for this! This is great.

Not PoC anymore. :)
It passes all tests without regression.

> 
>>>>>> The old behavior will try to read out all block group items at mount
>>>>>> time, however due to the key of block group items are scattered across
>>>>>> tons of extent items, we must call btrfs_search_slot() for each block
>>>>>> group.
>>>>>>
>>>>>> It works fine for small fs, but when number of block groups goes beyond
>>>>>> 200, such tree search will become a random read, causing obvious slow
>>>>>> down.
>>>>>>
>>>>>> On the other hand, btrfs_read_chunk_tree() is still very fast, since we
>>>>>> put CHUNK_ITEMS into their own tree and package them next to each other.
>>>>>>
>>>>>>
>>>>>> Following this idea, we could do the same thing for block group items,
>>>>>> so instead of triggering btrfs_search_slot() for each block group, we
>>>>>> just call btrfs_next_item() and under most case we could finish in
>>>>>> memory, and hugely speed up mount (see BENCHMARK below).
> 
> +many, this is a usability "bug" that comes up regularly on mailing list
> and IRC, people asking why their filesystem takes long to mount.
> 
> I also have some filesystems that I have to set noauto in fstab, and
> then after booting mount manually, and then do some other manual tasks,
> because having them mount automatically during boot causes timeouts and
> stuff.
> 
>>>>>> The only disadvantage is, this method introduce an incompatible feature,
>>>>>> so existing fs can't use this feature directly.
>>>>>> Either specify it at mkfs time, or use btrfs-progs offline convert tool
>>>>>> (*).
>>>>>
>>>>> What if we start recording block group items in the chunk tree?
>>>>
>>>> Then chunk tree will be too hot.
>>>>
>>>> Currently chunk tree is pretty stable, only get modified at bg
>>>> creation/deletion time.
>>>>
>>>> Considering how important chunk tree is, I prefer to make chunk root as
>>>> cold as possible.
> 
> This makes sense.
> 
>>>> On the other hand, block group items are pretty hot (although less hot
>>>> compared to old extent tree), so it still makes sense to put them into
>>>> one tree, allow chunk tree to be as cold as ice, while keep block group
>>>> items relatively safe compared to old extent tree.
>>>
>>> A feature like this should come with an analysis of both approaches in
>>> advance. Both have pros and cons that we need to weigh. Eg. I'm not more
>>> for storing the items in an existing tree, possibly creating a new tree
>>> item that would pack the bg items together at the beginning of the tree.
>>>
>>> The update frequency of the tree is an aspect that I haven't considered
>>> before but I think it's a good point.
>>>
>>> The tree holding the bg items can be considered fundamental and requires
>>> a backup pointer in the superblock. So this would need more work.
>>
>> Right, for backup root it indeed makes sense.
> 
> I don't really understand why this backup roots mechanism keeps being a
> thing, because technically btrfs cannot guarantee at all that there will
> be anything usable left right after the old metadata extents are
> unpinned...?

It's a fail safe feature for btrfs-store or similar recovery method.

But on the other hand, for RO usage, we don't even need block group
items at all, just like my skip_bg mount option.

And for RW mount, if all other trees are OK, btrfs-check should be able
to rebuild it.

> 
>> However for another key type method, I don't really think there is any pro.
>>
>> To pack bg items together, new key type is needed anyway.
> 
> Not if the block group items are the only thing in the tree...?

That's just the method the patchset is using.

> 
>> With new key type, no matter where the new bg items are, older kernel
>> won't be compatible, thus still INCOMPAT feature.
>>
>> And for whatever the tree holding block group items, it will be as hot
>> as extent tree used to be, bring up the corruption possibility to the
>> whatever the existing is. Or slow down the tree.
>>
>> So at least from my respect of view, storing (new) bg items in existing
>> tree doesn't make sense.
>>
>> However I think we should put more discussion on the possible new block
>> group item structure design.
>> E.g. Remove chunk_objectid member, or even each block group has its own
>> tree.
> 
> Just thinking out loud...
> 
> It seems to me that keeping the same key type and btrfs_block_group_item
> struct and same key values as they have in extent tree would be
> desirable if both old and new code has to co-exist in the kernel.

Yes, that the main point of current implementation.

> 
> This is easy to review...
> 
> -	struct btrfs_root *root = fs_info->extent_root;
> +	struct btrfs_root *root;
> 
> [...]
> 
> +	if (btrfs_fs_incompat(fs_info, BG_TREE))
> +		root = fs_info->bg_root;
> +	else
> +		root = fs_info->extent_root;
> 
> ...but creating a new different struct and key type would cause much
> more invasive code changes and duplication (and bugs) all over the
> place, or wrappers to handle either scenario.
> 
> I mean, who cares about some unused chunk_objectid field on a multi-TiB
> filesystem...

Well, we have similar feature already, skinny_metadata reduces metadata
backref size, and it's now already mainlined.

> 
> I'd vote for doing things, and more "design for today".

Makes sense.

> Otherwise the
> same might happen that also happens with some other topics every time...
> it ends up with the idea to rewrite half btrfs and then in the end
> nothing happens at all, and the users are still unhappy. ;-)

Well, in that case I prefer to create another fs, with "better" design
from the very beginning.

Thanks,
Qu

> 
> Even when splitting the extent tree into multiple trees ever, it would
> still be a good idea to have this BG_TREE.
> 
