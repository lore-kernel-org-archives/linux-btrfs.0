Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:41100 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934540AbaEFLOM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 07:14:12 -0400
Received: by mail-ee0-f48.google.com with SMTP id e49so5096770eek.21
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 04:14:11 -0700 (PDT)
Message-ID: <5368C412.8040908@googlemail.com>
Date: Tue, 06 May 2014 13:14:26 +0200
From: Hendrik Siedelmann <hendrik.siedelmann@googlemail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs raid allocator
References: <5368BC62.2020701@googlemail.com> <20140506105907.GV24298@carfax.org.uk>
In-Reply-To: <20140506105907.GV24298@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06.05.2014 12:59, Hugo Mills wrote:
> On Tue, May 06, 2014 at 12:41:38PM +0200, Hendrik Siedelmann wrote:
>> Hello all!
>>
>> I would like to use btrfs (or anyting else actually) to maximize raid0
>> performance. Basically I have a relatively constant stream of data that
>> simply has to be written out to disk. So my question is, how is the block
>> allocator deciding on which device to write, can this decision be dynamic
>> and could it incorporate timing/troughput decisions? I'm willing to write
>> code, I just have no clue as to how this works right now. I read somewhere
>> that the decision is based on free space, is this still true?
>
>     For (current) RAID-0 allocation, the block group allocator will use
> as many chunks as there are devices with free space (down to a minimum
> of 2). Data is then striped across those chunks in 64 KiB stripes.
> Thus, the first block group will be N GiB of usable space, striped
> across N devices.

So do I understand this correctly that (assuming we have enough space) 
data will be spread equally between the disks independend of write 
speeds? So one slow device would slow down the whole raid?

>     There's a second level of allocation (which I haven't looked at at
> all), which is how the FS decides where to put data within the
> allocated block groups. I think it will almost certainly be beneficial
> in your case to use prealloc extents, which will turn your continuous
> write into large contiguous sections of striping.

Why does prealloc change anything? For me latency does not matter, only 
continuous troughput!

>     I would recommend thoroughly benchmarking your application with the
> FS first though, just to see how it's going to behave for you.
>
>     Hugo.
>

Of course - it's just that I do not yet have the hardware, but I plan to 
test with a small model - I just try to find out how it actually works 
first, so I know what look out for.

Hendrik

