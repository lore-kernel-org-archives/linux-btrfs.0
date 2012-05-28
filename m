Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:40209 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752383Ab2E1KGg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 May 2012 06:06:36 -0400
Message-ID: <4FC33208.1000600@gmx.net>
Date: Mon, 28 May 2012 10:06:32 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: WeiFeng Liu <weifeng.liu@hushmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Decrease Metadata Fragment By Using a Caterpillar
 Band Method(intro modified)
References: <20120528060653.8ABFCE6739@smtp.hushmail.com> <4FC33A53.9050607@cn.fujitsu.com>
In-Reply-To: <4FC33A53.9050607@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/28/12 10:41, Liu Bo wrote:
> On 05/28/2012 02:06 PM, WeiFeng Liu wrote:
>
>> On Sunday, May 27, 2012 at 5:44 PM, Liu Bo<liubo2009@cn.fujitsu.com>  wrote:
>>
>>> Hi,
>>>
>>> Thanks for working on this.
>>>
>>> Do you have any performance number?
>>>
>>> The idea is an interesting one, but I have no idea if it really
>>> works, because blocks are
>>> still fragments:
>>>
>>> |   16k     |     16k   |    16k    |
>>> |----|A|----|----|B|----|----|C|----|
>>>
>>>
>>> Or am I missing something?
>>>
>>> thanks,
>>> liubo
>>>
>>
>> Hi, Liu Bo
>>
>> I noticed your graphic and what you said, "still fragments"
>> thanks you.
>>
>> According my patch's logic, any COWs for tree block A will be limited in it's
>> 16k caterpillar band in the example, at least theoretically, and so tree block
>> B, like the following:
>>
>> |<-- A circulated in 16k -->|   |<-- B circulated in 16k -->|
>> |--a-->|--b-->|--c-->|--d-->|   |--a-->|--b-->|--c-->|--d-->|
>> |                           |   |                           |
>> |-------------<-------------|   |-------------<-------------|
>>
>
>> 	Liu Bo, are the fragments you mentioned referenced to the ones in a caterpillar
>> or ones out of a caterpillar? if they are in a caterpillar, nothing would be
>> worried, because they are supposed to stay there forever, and that efficiency
>> is just what I want.
>>
>
>
> Yes, I refer to the space hole between A and B, which may not make readahead happy.
>
> But I'm not that sure, anyway, the performance number will tell us the truth :)

When using spinning drives, this will basically limit us to 1/4th of
platter speed, which is still quite a lot compared to random reads.

But there are more aspects to it. This patch assumes that the layout
that the trees takes on first write is a good one. I'm not sure this
is a valid assumption at all.
Another problem I see is that this loses us the big advantage that
in btrfs all metadata writes can happen sequentially, as all cowed
blocks can be allocated next to each other (as long as there's space).
So I expect writing tree updates to become much more costly.

All in all, in might be a strategy worth looking at in read-mostly
situations.
But again, the benchmarks might prove me wrong ;)

-Arne

>
> thanks,
> liubo
>
>> 	To a certain degree, using a caterpillar for a tree block is somewhat
>> similar with the way superblock runs, a superblock circularly updated in a
>> cluster of DISCONTINUOUS blocks within a large range, and I use a caterpillar
>> band to force a tree block updated circularly in a continuous blocks within a
>> compact area.
>>
>
>> Sorry, I haven't yet take performance test for my patch now, a bit more times
>> are still needed for me to check the possible bugs in code's routes before
>> tests, and any comments are welcome.
>>
>> Thanks all you.
>>
>> WeiFeng Liu
>> 523f28f9b3d9c710cacc31dbba644efb1678cf62
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

