Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17280 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751130AbcILHnL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 03:43:11 -0400
Subject: Re: [PATCH v3] btrfs: should block unused block groups deletion work
 when allocating data space
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        <linux-btrfs@vger.kernel.org>, Naohiro Aota <naohiro.aota@hgst.com>
References: <20160909081748.26540-1-wangxg.fnst@cn.fujitsu.com>
 <pan$db9b8$41125892$42517798$e874738e@applied-asynchrony.com>
 <57D29579.1080700@applied-asynchrony.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57D65B6C.4030400@cn.fujitsu.com>
Date: Mon, 12 Sep 2016 15:38:20 +0800
MIME-Version: 1.0
In-Reply-To: <57D29579.1080700@applied-asynchrony.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 09/09/2016 06:56 PM, Holger Hoffstätte wrote:
> On 09/09/16 12:18, Holger Hoffstätte wrote:
>> On Fri, 09 Sep 2016 16:17:48 +0800, Wang Xiaoguang wrote:
>>
>>> cleaner_kthread() may run at any time, in which it'll call btrfs_delete_unused_bgs()
>>> to delete unused block groups. Because this work is asynchronous, it may also result
>>> in false ENOSPC error.
>> <snip>
>>
>> With this v3 I can now no longer balance (tested only with metadata).
>> New chunks are allocated (as balance does) but nothing ever shrinks, until
>> after unmount/remount, when the cleaner eventually kicks in.
>>
>> This might be related to the recent patch by Naohiro Aota:
>> "btrfs: let btrfs_delete_unused_bgs() to clean relocated bgs"
>>
>> which by itself doesn't seem to do any harm (i.e. everything still seems
>> to work as expected).
> Actually even that is not true; both patches seem to be wrong in subtle
> ways. Naohiro's patch seems to prevent the deletion during balance, whereas
> yours prevents the cleaner from kicking in.
Indeed in my patch, I just change "struct mutex delete_unused_bgs_mutex"
to "struct rw_semaphore bg_delete_sem", and try to get bg_delete_sem when
we allocate data space, so this patch should work as before :)

>
> As a simple reproducer you can convert from -mdup to -msingle (to create
> bloat) and then balance with -musage=10. Depending on which of the two
> patches are applied, you end with bloat that only grows and never shrinks,
> or bloat that ends up in mixed state (dup and single).
Can you give me a simple test script to reproduce your problem.
(I can write it myself, but I'm afraid I may misunderstand you :) )

Regards,
Xiaoguang Wang
>
> Undoing both makes both balancing and cleaning work again.
>
> -h
>
>
>



