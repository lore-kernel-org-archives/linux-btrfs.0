Return-Path: <SRS0=5FUL=OL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A01C04EB8
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Dec 2018 05:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72E1E206B7
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Dec 2018 05:28:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72E1E206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbeLBF2K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 2 Dec 2018 00:28:10 -0500
Received: from mout.gmx.net ([212.227.17.20]:51827 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbeLBF2K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Dec 2018 00:28:10 -0500
Received: from Damenlys-MBP.lan ([180.111.171.198]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MdK8t-1gk24G1MCB-00IVnE; Sun, 02
 Dec 2018 06:28:04 +0100
Subject: Re: [RFC PATCH 00/17] btrfs: implementation of priority aware
 allocator
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
 <6c19f898-ee15-0670-2094-ce870ae3d513@gmx.com>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <983cb730-2b0c-cf40-c5e4-c23b54c6910f@gmx.com>
Date:   Sun, 2 Dec 2018 13:28:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <6c19f898-ee15-0670-2094-ce870ae3d513@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:s8Kl0IedYKoCdHKjtYIA+VvUcOOn+SLRGnrOV/4+Ry+VKns8Xo6
 nPqN3HGNkGmDi0gBIKGoa0oPtGGQkbkFkmyEtpex6RD1KJMyippXvg/50r8siBWbIzU1mJI
 KRUjAnqj4agQlToJZHw2Sp+2kuOuIt/pUsL0yky8BdoxQrtp7WJXXWEf5zxZ/Pf4sxOCgAI
 RS2ktnyNTUymgrxhX/3fg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xt/Z1lJMHdk=:6Ifa8KPrMWJ+vCB0qljAsx
 VJVMuJJkWbOVH3pQYOtoYpnIw/CsByi+r0kkLufDhYNuW0HaFUKL1oC+QVqK3s2Jzkc2DxvyT
 lbK1Ngnp7fHNYu1CTknAxYcgnnbsTzXz6mtr6F16u38Slqq5sYCZE47LXcNywFXEbo4A9kl20
 VSTGTSxsnLdQlKw9GRRKssc/HVzq6PakIS1I/g24oqLT5Q7LfVZ/BRz9uyPLCMi2q1rwpQvqC
 n5uD/gYjq8SNbJWO+UNw0+1XDiypLrPQWPudek5cHhhCaWRoYAMb3m/qbOYkjugVA2rhxoV+c
 Zm/seP4uRTd9/KgPjMptMn+3fhXq1118l/Cdw5+6r1DkQPBA8F8bd6o45f4zTAVYVQAohGpCI
 EgtcWskBbp6LGdiKIzbWW8jm1QX7MtiMKzlGLn5+etrxpp5Qa6Nnh7VUwmWhD/kcQjhVyxA7e
 6oc9/pMxgvc5NGSEI7kT/amjmwxOSS5gAS82YyuCl2Q7Pp8ztP1eVPRrSgnMNtYfzwaMHn0kv
 AEh3Tbxr+r7bwkcOBzjAs0UZZkHqOum8GGL3rDZvqNYN5UpMKYU9ydxZDr09fsYV56YwNOhnG
 EDWoZ+dE56PcWeuHOQJvoaByN42PIs/eVgu3jcY9qYYgnG6dD3Uigp+EP2V1S/kfP6+fi4PUJ
 31cZJtRaiCqQcul6OlXGYHhAuXjDWbPMkrldFppO+xP1+93YsJSnci0yLtH8xIRH18iYdvJZa
 wZfu65Lpa3pSITFfM9F4fPXUWkY3af3aKE82W/a+Toc2N2n6xBWuxUxRDz1sZ11Des4isHqIb
 KdPbMIR6G9gBxCmdNABouyQNUPn1Jvn41eCP0kBOSyMwyUBamNrwgdU4YGRNX6oj3A8+mpND0
 9ATep81jDCArprZ7iNtA/DdYOQwQg9eLQ4Dm3y3FB/gcyYQWX4pE6LtfNNH11H79pfvJBQsv2
 lP4Ffp1yPNA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/28 12:04 PM, Qu Wenruo wrote:
> 
> 
> On 2018/11/28 上午11:11, Su Yue wrote:
>> This patchset can be fetched from repo:
>> https://github.com/Damenly/btrfs-devel/commits/priority_aware_allocator.
>> Since patchset 'btrfs: Refactor find_free_extent()' does a nice work
>> to simplify find_free_extent(). This patchset dependents on the refactor.
>> The base is the commit in kdave/misc-next:
>>
>> commit fcaaa1dfa81f2f87ad88cbe0ab86a07f9f76073c (kdave/misc-next)
>> Author: Nikolay Borisov <nborisov@suse.com>
>> Date:   Tue Nov 6 16:40:20 2018 +0200
>>
>>      btrfs: Always try all copies when reading extent buffers
>>
>>
>> This patchset introduces a new mount option named 'priority_alloc=%s',
>> %s is supported to be "usage" and "off" now. The mount option changes
>> the way find_free_extent() how to search block groups.
>>
>> Previously, block groups are stored in list of btrfs_space_info
>> by start position. When call find_free_extent() if no hint,
>> block_groups are searched one by one.
>>
>> Design of priority aware allocator:
>> Block group has its own priority. We split priorities to many levels,
>> block groups are split to different trees according priorities.
>> And those trees are sorted by their levels and stored in space_info.
>> Once find_free_extent() is called, try to search block groups in higher
>> priority level then lower level. Then a block group with higher
>> priority is more likely to be used.
>>
>> Pros:
>> 1) Reduce the frequency of balance.
>>     The block group with a higher usage rate will be used preferentially
>>     for allocating extents. Free the empty block groups with pinned bytes
>>     as non-zero.[1]
>>
>> 2) The priority of empty block group with pinned bytes as non-zero
>>     will be set as the lowest.
>>     
>> 3) Support zoned block device.[2]
>>     For metadata allocation, the block group in conventional zones
>>     will be used as much as possible regardless of usage rate.
>>     Will do it in future.
> 
> Personally I'm a big fan of the priority aware extent allocator.
> 
> So nice job!
>

Thanks for the offline help.

>>     
>> Cons:
>> 1) Expectable performance regression.
>>     The degree of the decline is temporarily unknown.
>>     The user can disable block group priority to get the full performance.
>>
>> TESTS:
>>
>> If use usage as priority(the only available option), empty block group
>> is much harder to be reused.
>>
>> About block group usage:
>>    Disk: 4 x 1T HDD gathered in LVM.
>>
>>    Run script to create files and delete files randomly in loop.
>>    The num of files to create are double than to delete.
>>
>>    Default mount option result:
>>    https://i.loli.net/2018/11/28/5bfdfdf08c760.png
>>
>>    Priority aware allocator(usage) result:
>>    https://i.loli.net/2018/11/28/5bfdfdf0c1b11.png
>>
>>    X coordinate means total disk usage, Y coordinate means avg block
>>    group usage.
>>
>>    Due to fragmentation of extents, the different are not obvious,
>>    only about 1% improvement....
> 
> I think you're using the wrong indicator to show the difference.
> 
> The real indicator should not be overall block group usage, but:
> 1) Number of block groups
> 2) Usage distribution of the block groups
> 
> If the number of block groups isn't much different, then we should go
> check the distribution.
> E.g. all bgs with 97% usage is not as good mostly 100% bgs and several
> near 10% bgs.
>

Took some time to write scripts for summary:
Avg of percentage of block groups during disk usage from 0% to 100%

For block groups whose usage >= 98%, default: 31.09%, priorty_alloc: 46.73%


For block groups whose usage >= 95%, default: 57.69%, priorty_alloc: 64.24%


For block groups whose usage >= 90%, default: 79.87%, priorty_alloc: 80.2%

So this patchset does work in improvement of block groups usages.


> And we should check the usage distribution between metadata and data bgs.
> For data bg, we could hit some fragmentation problem, while for meta bgs
> all extents are in the same size, thus may have a better performance for
> metadata.
> 
> Thus we could do better for the test result.
> 
>>    						
>> Performance regression:
>>     I have ran sysbench on our machine with SSD in multi combinations,
>>     no obvious regression found.
>>     However in theory, the new allocator may cost more time in some
>>     cases.
> 
> Isn't that a good news? :)
> 

Yeah.
>>
>> [1] https://www.spinics.net/lists/linux-btrfs/msg79508.html
>> [2] https://lkml.org/lkml/2018/8/16/174
>>
>> ---
>> Due to some reasons includes time and hardware, the use-case is not
>> outstanding enough.
> 
> As discussed offline, another cause would be data extent fragmentations.
> E.g we have a lot of small 4K holes but the request is a big 128M.
> In that case btrfs_reserve_extent() could still trigger a new data chunk
> other than return the 4K holes found.
> 

IMO, this is another business. Doing it in another patchset is prefered.

Thanks,
Su

> Thanks,
> Qu
> 
>> And some codes are dirty but I can't found another
>> way. So I named it as RFC.
>>       Any comments and suggestions are welcome.
>>       
>> Su Yue (17):
>>    btrfs: priority alloc: prepare of priority aware allocator
>>    btrfs: add mount definition BTRFS_MOUNT_PRIORITY_USAGE
>>    btrfs: priority alloc: introduce compute_block_group_priority/usage
>>    btrfs: priority alloc: add functions to create/remove priority trees
>>    btrfs: priority alloc: introduce functions to add block group to
>>      priority tree
>>    btrfs: priority alloc: introduce three macros to mark block group
>>      status
>>    btrfs: priority alloc: add functions to remove block group from
>>      priority tree
>>    btrfs: priority alloc: add btrfs_update_block_group_priority()
>>    btrfs: priority alloc: call create/remove_priority_trees in space_info
>>    btrfs: priority alloc: call add_block_group_priority while reading or
>>      making block group
>>    btrfs: priority alloc: remove block group from priority tree while
>>      removing block group
>>    btrfs: priority alloc: introduce find_free_extent_search()
>>    btrfs: priority alloc: modify find_free_extent() to fit priority
>>      allocator
>>    btrfs: priority alloc: introduce btrfs_set_bg_updating and call
>>      btrfs_update_block_group_prioriy
>>    btrfs: priority alloc: write bg->priority_groups_sem while waiting
>>      reservation
>>    btrfs: priority alloc: write bg->priority_tree->groups_sem to avoid
>>      race in btrfs_delete_unused_bgs()
>>    btrfs: add mount option "priority_alloc=%s"
>>
>>   fs/btrfs/ctree.h            |  28 ++
>>   fs/btrfs/extent-tree.c      | 672 +++++++++++++++++++++++++++++++++---
>>   fs/btrfs/free-space-cache.c |   3 +
>>   fs/btrfs/super.c            |  18 +
>>   fs/btrfs/transaction.c      |   1 +
>>   5 files changed, 681 insertions(+), 41 deletions(-)
>>
