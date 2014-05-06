Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:43290 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934617AbaEFL0a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 07:26:30 -0400
Received: by mail-ee0-f45.google.com with SMTP id d49so2239232eek.18
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 04:26:29 -0700 (PDT)
Message-ID: <5368C6F4.1010008@googlemail.com>
Date: Tue, 06 May 2014 13:26:44 +0200
From: Hendrik Siedelmann <hendrik.siedelmann@googlemail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs raid allocator
References: <5368BC62.2020701@googlemail.com> <20140506105907.GV24298@carfax.org.uk> <5368C412.8040908@googlemail.com> <20140506111922.GX24298@carfax.org.uk>
In-Reply-To: <20140506111922.GX24298@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06.05.2014 13:19, Hugo Mills wrote:
> On Tue, May 06, 2014 at 01:14:26PM +0200, Hendrik Siedelmann wrote:
>> On 06.05.2014 12:59, Hugo Mills wrote:
>>> On Tue, May 06, 2014 at 12:41:38PM +0200, Hendrik Siedelmann wrote:
>>>> Hello all!
>>>>
>>>> I would like to use btrfs (or anyting else actually) to maximize raid0
>>>> performance. Basically I have a relatively constant stream of data that
>>>> simply has to be written out to disk. So my question is, how is the block
>>>> allocator deciding on which device to write, can this decision be dynamic
>>>> and could it incorporate timing/troughput decisions? I'm willing to write
>>>> code, I just have no clue as to how this works right now. I read somewhere
>>>> that the decision is based on free space, is this still true?
>>>
>>>     For (current) RAID-0 allocation, the block group allocator will use
>>> as many chunks as there are devices with free space (down to a minimum
>>> of 2). Data is then striped across those chunks in 64 KiB stripes.
>>> Thus, the first block group will be N GiB of usable space, striped
>>> across N devices.
>>
>> So do I understand this correctly that (assuming we have enough space) data
>> will be spread equally between the disks independend of write speeds? So one
>> slow device would slow down the whole raid?
>
>     Yes. Exactly the same as it would be with DM RAID-0 on the same
> configuration. There's not a lot we can do about that at this point.

So striping is fixed but which disk takes part with a chunk is dynamic? 
But for large workloads slower disks could 'skip a chunk' as chunk 
allocation is dynamic, correct?

>>>     There's a second level of allocation (which I haven't looked at at
>>> all), which is how the FS decides where to put data within the
>>> allocated block groups. I think it will almost certainly be beneficial
>>> in your case to use prealloc extents, which will turn your continuous
>>> write into large contiguous sections of striping.
>>
>> Why does prealloc change anything? For me latency does not matter, only
>> continuous troughput!
>
>     It makes the extent allocation algorithm much simpler, because it
> can then allocate in larger chunks and do more linear writes

Is this still true if I do very large writes? Or do those get broken 
down by the kernel somewhere?

>>>     I would recommend thoroughly benchmarking your application with the
>>> FS first though, just to see how it's going to behave for you.
>>>
>>>     Hugo.
>>>
>>
>> Of course - it's just that I do not yet have the hardware, but I plan to
>> test with a small model - I just try to find out how it actually works
>> first, so I know what look out for.
>
>     Good luck. :)
>
>     Hugo.
>

Thanks!
Hendrik

