Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7B0C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 00:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 886CA20874
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 00:15:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfACAPR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 19:15:17 -0500
Received: from mout.gmx.net ([212.227.17.20]:35265 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfACAPR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 19:15:17 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LaJWs-1h2g962VcE-00m4R6; Thu, 03
 Jan 2019 01:14:43 +0100
Subject: Re: [PATCH RFC 0/2] Use new incompat feature BG_TREE to hugely reduce
 mount time
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181228083745.3134-1-wqu@suse.com>
 <38520a81-e5b0-35b5-bf81-966ea6ef2c45@suse.com>
 <d4ee763f-19b4-e50f-1746-d2ca4152a3c5@gmx.com>
 <20190102162113.GX23615@twin.jikos.cz>
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
Message-ID: <e1b30348-71ae-148d-c7c6-9de98edbb6de@gmx.com>
Date:   Thu, 3 Jan 2019 08:14:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20190102162113.GX23615@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:POzV6m78Zs2fCtyje3JZgUEQcxPAYT7YnYDIBaAWOsu67Oe1x5h
 Pubwd42SClWhhiysQ9uOiy8tkv5lLgb2kPh+ZwQBi3MEeZA134cb2LbrcIHsqiew6CVKy0K
 Yz7sQp/vCqH/Wv1taFu/+qISkMjaRGq6vKZMHwyVdgrpvWFxmV7sbn/Zr1rwKDCqeJKeA8G
 6hlN+5Up52XXUlZyAAgmg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:uwB1Uprrr6o=:0uRtMO89tr14eFgy6a1RO9
 TOSB8+6hLGStvkzvL811A1h+V1nhQjYK0zud7TXPrzL2gS2OldWQJsyQj6GcQ6f2XcNqsK8yc
 bfsOE2/F02kdyOvQfQmQvxPA4baDzCS4NNq1c80fQ8EIM4vOCcr6cyeSUSdNSyFGZipEcfWW1
 pEB9RL3eUgSIlDNrZwxuxu4cpQAmLhfawYfDHjHNIIpFJWp1hVOocZ/HinxFgGfML15d0ULhI
 XzRhAnF3mSwh9d0MsTOWc8T+hxCWf9buOXtYVTtJceU2FuYyxJ9PmyzqLbk3ZyYIjJ3lXFjoO
 qgROdg3B2z2pp/DWF1fIRP0UpnzgKJDV2UcUo1Se0iy+0byuQJydmU3obZA4Foy+GBVAeC/Hv
 2kCdZ6HfKH9S7NS+dju2Fm3sYPhTT8F24QROgrSIfnCLfCJWbVvVmYGnFL6daEaEl4LsCioH2
 W/xTjl1GjN5fpzKJfHq/B4Wmc9oQ0irph/7jcKdEKWUzRZ11KtE9F71i7w+MPhO/nqjbC3rVo
 EVYJFAaK5VbVlVHW6hDT2SZOThWZEyElzyPwVSSKz+9Qq/ljs6W1O3lhuHj0CzNf88EN9tFVK
 y8TYkB/P5pPaSShyhIGnG1JUtIlWRCmO+KUhf2yatlooFRTtlepdjWlDH4ftFfG/Ykwi+Z2h4
 sxUBP0OHbHiZuHQQ4bnHOgSelD8DcQ4t22rI0KSVJfuAxqa31EVM3CBuFgVjuIluC1VVY4xIY
 mADwoA2urBwX+6qEhMJ0hkYKMa44FvXNUIk67D+7mtOUMXEs9g9VZj2aTcJlWz4Ga+LuZ+oaQ
 eYT7h/D5qqMpxK+p/ehYHsgpmaO5Ts5FYv8EHnTpWvp0cKfJuKZLVL/MA5dy5B0be89KIazPV
 a2y49KTkS3MCpBxrEJlME0J3b9AZYw51YkNXHLAuiadsRgusnAE/FN/cNS1D1Gb5jl8rG6N5K
 zsEk04l0G1g==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/1/3 上午12:21, David Sterba wrote:
> On Fri, Dec 28, 2018 at 05:28:13PM +0800, Qu Wenruo wrote:
>> On 2018/12/28 下午5:15, Nikolay Borisov wrote:
>>> On 28.12.18 г. 10:37 ч., Qu Wenruo wrote:
>>>> This patchset can be fetched from:
>>>> https://github.com/adam900710/linux/tree/bg_tree
>>>> Which is based on v4.20-rc1 tag.
>>>>
>>>> This patchset will hugely reduce mount time of large fs by putting all
>>>> block group items into its own tree.
>>>>
>>>> The old behavior will try to read out all block group items at mount
>>>> time, however due to the key of block group items are scattered across
>>>> tons of extent items, we must call btrfs_search_slot() for each block
>>>> group.
>>>>
>>>> It works fine for small fs, but when number of block groups goes beyond
>>>> 200, such tree search will become a random read, causing obvious slow
>>>> down.
>>>>
>>>> On the other hand, btrfs_read_chunk_tree() is still very fast, since we
>>>> put CHUNK_ITEMS into their own tree and package them next to each other.
>>>>
>>>>
>>>> Following this idea, we could do the same thing for block group items,
>>>> so instead of triggering btrfs_search_slot() for each block group, we
>>>> just call btrfs_next_item() and under most case we could finish in
>>>> memory, and hugely speed up mount (see BENCHMARK below).
>>>>
>>>> The only disadvantage is, this method introduce an incompatible feature,
>>>> so existing fs can't use this feature directly.
>>>> Either specify it at mkfs time, or use btrfs-progs offline convert tool
>>>> (*).
>>>
>>> What if we start recording block group items in the chunk tree?
>>
>> Then chunk tree will be too hot.
>>
>> Currently chunk tree is pretty stable, only get modified at bg
>> creation/deletion time.
>>
>> Considering how important chunk tree is, I prefer to make chunk root as
>> cold as possible.
>>
>> On the other hand, block group items are pretty hot (although less hot
>> compared to old extent tree), so it still makes sense to put them into
>> one tree, allow chunk tree to be as cold as ice, while keep block group
>> items relatively safe compared to old extent tree.
> 
> A feature like this should come with an analysis of both approaches in
> advance. Both have pros and cons that we need to weigh. Eg. I'm not more
> for storing the items in an existing tree, possibly creating a new tree
> item that would pack the bg items together at the beginning of the tree.
> 
> The update frequency of the tree is an aspect that I haven't considered
> before but I think it's a good point.
> 
> The tree holding the bg items can be considered fundamental and requires
> a backup pointer in the superblock. So this would need more work.

Right, for backup root it indeed makes sense.

However for another key type method, I don't really think there is any pro.

To pack bg items together, new key type is needed anyway.
With new key type, no matter where the new bg items are, older kernel
won't be compatible, thus still INCOMPAT feature.

And for whatever the tree holding block group items, it will be as hot
as extent tree used to be, bring up the corruption possibility to the
whatever the existing is. Or slow down the tree.

So at least from my respect of view, storing (new) bg items in existing
tree doesn't make sense.

However I think we should put more discussion on the possible new block
group item structure design.
E.g. Remove chunk_objectid member, or even each block group has its own
tree.

Thanks,
Qu
