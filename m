Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1008C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 04:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3131F205C9
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 04:04:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3131F205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbeK1PE1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 10:04:27 -0500
Received: from mout.gmx.net ([212.227.15.19]:48531 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbeK1PE1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 10:04:27 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MWC9x-1fvE3h1uq9-00XMnO; Wed, 28
 Nov 2018 05:04:13 +0100
Subject: Re: [RFC PATCH 00/17] btrfs: implementation of priority aware
 allocator
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
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
Message-ID: <6c19f898-ee15-0670-2094-ce870ae3d513@gmx.com>
Date:   Wed, 28 Nov 2018 12:04:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:99/dgNzWp5WgATkKrSgWJYHiWLumPWAGdZWEFPUwGGRslQ1lk0d
 elNrWzqpVFASAMuQ0D0RipKNRWbz1vN+1Hp2nC/04mOw/ee2aD7zO73yNi1+72Qo2CIdY9W
 js/6fdLKXzB2MuRgAOt/iJlfSwMudVjMEGCuN8l+pTYz2k9cGkNbeNKutN/gzWqQeBpBhSI
 esH50yi5JIjhgCaeJc+UA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qkfyUXwqefw=:JnGIrktVqCdFhpKOT2/AtW
 OoX8V27xzldKtqRrw3tTYF0p/4kAimBN1gWwv5sPIEdRwh3bdFbWfoTPfjxLHdlPIUPhUV6Se
 d011zeklfUCx+wnEDuNYZDwbjpNg/TgC3X5X7ZL9wuFdhZYaDtO6CHHf/2+eI3hVyXXabTgq7
 YunYCXRh+ZmSwmYZ+BbLVS8dS6ea+khW9M5Ny0IPy7twybc+/WHPSnLfvibNyDF1Vz0spykIw
 16PfEm8gtkv+tZ2so0DkHU4aVM2J7Lxp/lBJSAQoEPuYLgfaC+1RHuDrtbQwGHlm1YO59keND
 R75Q7V/y+YLJbdsUK4gDeyllzmE7OZcvypPaAF5Aq22qZCOsi54A/z8/IBmL3mI16IGaitjPg
 umRqE1URABWa3S7MfTlyLkzXowU6+dV9vlARqLk3TQhp2cfCCYqc7DvdU0gvqrgCf6xRxopCY
 z3nEs4mse82h0VsQr7h54uNysUKnggcuFrRKmJgBVMNqAz7KP593VG+uW3RmN1hU2ooKgbeic
 o4DXyb6Rbd7UKr/YsXBCB+CM3G3zJ7z9J1QDToXXGETdU3EJEP7pPduIPZbthPVjsepYKhfzm
 cY/ajSlNy8qLr0aKWNvy1mNyyHkdYwiqZ4PMIMdmxTifN0c3LMIVnfPhiWz8Uy5mntLADJaad
 kxvEwEQryZHrkicziWSBpOVstWppG6YSPtEVowUytYXgt9gN9RW0ocecA3xGz3S1owvIBIZaV
 S202Ecfo7SbbGGGY3tBVXB9ISxF/ETGIcTU10gudjMo9gCmyP5pRRDphhuEndco0+yfjTqqxi
 ukWGCvnOeDwrEim5HuodeTZHeN8vRX1WgyKsl7TFPZPnh2gpkRjtAHDeUk2HYVFx6EbzKffwg
 NfenJ63Mc0xPz88Jvb4bwVp0yk3pJrdLomRsHxX2a4uez+Wm3lkp0jDUOaUpaE
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/28 上午11:11, Su Yue wrote:
> This patchset can be fetched from repo:
> https://github.com/Damenly/btrfs-devel/commits/priority_aware_allocator.
> Since patchset 'btrfs: Refactor find_free_extent()' does a nice work
> to simplify find_free_extent(). This patchset dependents on the refactor.
> The base is the commit in kdave/misc-next:
> 
> commit fcaaa1dfa81f2f87ad88cbe0ab86a07f9f76073c (kdave/misc-next)
> Author: Nikolay Borisov <nborisov@suse.com>
> Date:   Tue Nov 6 16:40:20 2018 +0200
> 
>     btrfs: Always try all copies when reading extent buffers
> 
> 
> This patchset introduces a new mount option named 'priority_alloc=%s',
> %s is supported to be "usage" and "off" now. The mount option changes
> the way find_free_extent() how to search block groups.
> 
> Previously, block groups are stored in list of btrfs_space_info
> by start position. When call find_free_extent() if no hint,
> block_groups are searched one by one.
> 
> Design of priority aware allocator:
> Block group has its own priority. We split priorities to many levels,
> block groups are split to different trees according priorities.
> And those trees are sorted by their levels and stored in space_info.
> Once find_free_extent() is called, try to search block groups in higher
> priority level then lower level. Then a block group with higher
> priority is more likely to be used.
> 
> Pros:
> 1) Reduce the frequency of balance.
>    The block group with a higher usage rate will be used preferentially
>    for allocating extents. Free the empty block groups with pinned bytes
>    as non-zero.[1]
> 
> 2) The priority of empty block group with pinned bytes as non-zero
>    will be set as the lowest.
>    
> 3) Support zoned block device.[2]
>    For metadata allocation, the block group in conventional zones
>    will be used as much as possible regardless of usage rate.
>    Will do it in future.

Personally I'm a big fan of the priority aware extent allocator.

So nice job!

>    
> Cons:
> 1) Expectable performance regression.
>    The degree of the decline is temporarily unknown.
>    The user can disable block group priority to get the full performance.
> 
> TESTS:
> 
> If use usage as priority(the only available option), empty block group
> is much harder to be reused.
> 
> About block group usage:
>   Disk: 4 x 1T HDD gathered in LVM.
> 
>   Run script to create files and delete files randomly in loop.
>   The num of files to create are double than to delete.
> 
>   Default mount option result:
>   https://i.loli.net/2018/11/28/5bfdfdf08c760.png
> 
>   Priority aware allocator(usage) result:
>   https://i.loli.net/2018/11/28/5bfdfdf0c1b11.png
> 
>   X coordinate means total disk usage, Y coordinate means avg block
>   group usage.
> 
>   Due to fragmentation of extents, the different are not obvious,
>   only about 1% improvement....

I think you're using the wrong indicator to show the difference.

The real indicator should not be overall block group usage, but:
1) Number of block groups
2) Usage distribution of the block groups

If the number of block groups isn't much different, then we should go
check the distribution.
E.g. all bgs with 97% usage is not as good mostly 100% bgs and several
near 10% bgs.

And we should check the usage distribution between metadata and data bgs.
For data bg, we could hit some fragmentation problem, while for meta bgs
all extents are in the same size, thus may have a better performance for
metadata.

Thus we could do better for the test result.

>   						   
> Performance regression:
>    I have ran sysbench on our machine with SSD in multi combinations,
>    no obvious regression found.
>    However in theory, the new allocator may cost more time in some
>    cases.

Isn't that a good news? :)

> 
> [1] https://www.spinics.net/lists/linux-btrfs/msg79508.html
> [2] https://lkml.org/lkml/2018/8/16/174
> 
> ---
> Due to some reasons includes time and hardware, the use-case is not
> outstanding enough.

As discussed offline, another cause would be data extent fragmentations.
E.g we have a lot of small 4K holes but the request is a big 128M.
In that case btrfs_reserve_extent() could still trigger a new data chunk
other than return the 4K holes found.

Thanks,
Qu

> And some codes are dirty but I can't found another
> way. So I named it as RFC.
>      Any comments and suggestions are welcome.
>      
> Su Yue (17):
>   btrfs: priority alloc: prepare of priority aware allocator
>   btrfs: add mount definition BTRFS_MOUNT_PRIORITY_USAGE
>   btrfs: priority alloc: introduce compute_block_group_priority/usage
>   btrfs: priority alloc: add functions to create/remove priority trees
>   btrfs: priority alloc: introduce functions to add block group to
>     priority tree
>   btrfs: priority alloc: introduce three macros to mark block group
>     status
>   btrfs: priority alloc: add functions to remove block group from
>     priority tree
>   btrfs: priority alloc: add btrfs_update_block_group_priority()
>   btrfs: priority alloc: call create/remove_priority_trees in space_info
>   btrfs: priority alloc: call add_block_group_priority while reading or
>     making block group
>   btrfs: priority alloc: remove block group from priority tree while
>     removing block group
>   btrfs: priority alloc: introduce find_free_extent_search()
>   btrfs: priority alloc: modify find_free_extent() to fit priority
>     allocator
>   btrfs: priority alloc: introduce btrfs_set_bg_updating and call
>     btrfs_update_block_group_prioriy
>   btrfs: priority alloc: write bg->priority_groups_sem while waiting
>     reservation
>   btrfs: priority alloc: write bg->priority_tree->groups_sem to avoid
>     race in btrfs_delete_unused_bgs()
>   btrfs: add mount option "priority_alloc=%s"
> 
>  fs/btrfs/ctree.h            |  28 ++
>  fs/btrfs/extent-tree.c      | 672 +++++++++++++++++++++++++++++++++---
>  fs/btrfs/free-space-cache.c |   3 +
>  fs/btrfs/super.c            |  18 +
>  fs/btrfs/transaction.c      |   1 +
>  5 files changed, 681 insertions(+), 41 deletions(-)
> 
