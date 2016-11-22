Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60568 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754734AbcKVICJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 03:02:09 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 5E68547AC8B4
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Nov 2016 16:02:07 +0800 (CST)
Subject: Re: [RFC] btrfs: make max inline data can be equal to sectorsize
To: <linux-btrfs@vger.kernel.org>
References: <20161011064742.17364-1-wangxg.fnst@cn.fujitsu.com>
 <20161111202210.GB30930@dhcp-whq-twvpn-1-vpnpool-10-159-131-21.vpn.oracle.com>
 <1bbc9b5f-9bdb-d8b6-bbd5-7718ea33dcef@cn.fujitsu.com>
 <20161116161023.GU12522@twin.jikos.cz>
 <147397a2-0401-82c2-069b-ce21e2d07484@fb.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <5833F9C2.4030308@cn.fujitsu.com>
Date: Tue, 22 Nov 2016 15:54:42 +0800
MIME-Version: 1.0
In-Reply-To: <147397a2-0401-82c2-069b-ce21e2d07484@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 11/19/2016 04:58 AM, Chris Mason wrote:
>
>
> On 11/16/2016 11:10 AM, David Sterba wrote:
>> On Mon, Nov 14, 2016 at 09:55:34AM +0800, Qu Wenruo wrote:
>>> At 11/12/2016 04:22 AM, Liu Bo wrote:
>>>> On Tue, Oct 11, 2016 at 02:47:42PM +0800, Wang Xiaoguang wrote:
>>>>> If we use mount option "-o max_inline=sectorsize", say 4096, indeed
>>>>> even for a fresh fs, say nodesize is 16k, we can not make the first
>>>>> 4k data completely inline, I found this conditon causing this issue:
>>>>>   !compressed_size && (actual_end & (root->sectorsize - 1)) == 0
>>>>>
>>>>> If it retuns true, we'll not make data inline. For 4k sectorsize,
>>>>> 0~4094 dara range, we can make it inline, but 0~4095, it can not.
>>>>> I don't think this limition is useful, so here remove it which will
>>>>> make max inline data can be equal to sectorsize.
>>>>
>>>> It's difficult to tell whether we need this, I'm not a big fan of 
>>>> using
>>>> max_inline size more than the default size 2048, given that most 
>>>> reports
>>>> about ENOSPC is due to metadata and inline may make it worse.
>>>
>>> IMHO if we can use inline data extents to trigger ENOSPC more easily,
>>> then we should allow it to dig the problem further.
>>>
>>> Just ignoring it because it may cause more bug will not solve the real
>>> problem anyway.
>>
>> Not allowing the full 4k value as max_inline looks artificial to me.
>> We've removed other similar limitation in the past so I'd tend to agree
>> to do the same here. There's no significant use for it as far as I can
>> tell, if you want to exhaust metadata, the difference to max_inline=4095
>> would be really tiny in the end. So, I'm okay with merging it. If
>> anybody feels like adding his reviewed-by, please do so.
>
> The check is there because in practice it doesn't make sense to inline 
> an extent if it fits perfectly in a data block. 
I see, thanks for this clarification.

> You could argue its saving seeks, but we're also adding seeks by 
> spreading out the metadata in general.  So, I'd want to see benchmarks 
> before deciding.
I had tried to construct some benchmark tests, such as create and read 
plenty of
small files, copy linux source codes, I don't see any obvious 
difference, it maybe
reasonable, after all, this patch just results in one bytes difference.

>
> If we're using it for debugging, I'd rather stick with max_inline=4095.
I was just curious that we could make inline for 4095, but not allow 
4096 before,
just one bytes :)

Regards,
Xiaoguang Wang

>
> -chris
>
>



