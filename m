Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:54422 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752079AbcKRPIk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 10:08:40 -0500
Subject: Re: Btrfs Heatmap - v2 - block group internals!
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
 <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
 <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
 <68eecdb7-90e4-a5ba-ca63-f714faf88ede@mendix.com>
 <c067cd99-31ba-9e33-6da6-1d55c1a8c8f5@gmail.com>
 <02310b0f-5fed-746a-ca05-d655dce7d57a@cn.fujitsu.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <9945f788-2516-007b-43ce-dabcff263cd8@mendix.com>
Date: Fri, 18 Nov 2016 16:08:38 +0100
MIME-Version: 1.0
In-Reply-To: <02310b0f-5fed-746a-ca05-d655dce7d57a@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/18/2016 03:08 AM, Qu Wenruo wrote:
> 
> Just found one small problem.
> After specifying --size 16 to output a given block group (small block
> group, I need large size to make output visible), it takes a full cpu
> and takes a long long long time to run.
> So long I don't even want to wait.
> 
> I changed size to 10, and it finished much faster.
> 
> Is that expected?

Yes, hilbert curve size increases exponentially when increasing order.

2**16 = 65536, 65536x65536 = 4294967296 pixels in the png image.

So even if you would have a petabyte filesystem, that would still mean
that a single pixel in the image represents only ~ 256kB. I don't think
your small block groups are 256kB big?

Specifying values like this does not make any sense at all, and it
expected not to work well.

>>> I don't see what displaying a blockgroup-level aggregate usage number
>>> has to do with multi-device, except that the same %usage will appear
>>> another time when using RAID1*.
> 
> Although in fact, for profiles like RAID0/5/6/10, it's completely
> possible that one dev_extent contains all the data, while another
> dev_extent is almost empty.

When using something like RAID0 profile, I would expect 50% of the data
to end up in one dev_extent and 50% in the other?

> Strictly speaking, at full fs or dev level, we should output things at
> dev_extent level, then greyscale should be representing dev_extent
> usage(which is not possible or quite hard to calculate)

That's what it's doing now?

> Anyway, the greyscale is mostly OK, just as a good addition output for
> full fs graph.

I don't follow.

> Although if it could output the fs or specific dev without gray scale, I
> think it would be better.
> It will be much clearer about the dev_extent level fragments.

I have no idea what you mean, sorry.

>>> When generating a picture of a file system with multiple devices,
>>> boundaries between the separate devices are not visible now.
>>>
>>> If someone has a brilliant idea about how to do this without throwing
>>> out actual usage data...
>>>
>> The first thought that comes to mind for me is to make each device be a
>> different color, and otherwise obey the same intensity mapping
>> correlating to how much data is there.  For example, if you've got a 3
>> device FS, the parts of the image that correspond to device 1 would go
>> from 0x000000 to 0xFF0000, the parts for device 2 could be 0x000000 to
>> 0x00FF00, and the parts for device 3 could be 0x000000 to 0x0000FF. This
>> is of course not perfect (you can't tell what device each segment of
>> empty space corresponds to), but would probably cover most use cases.
>> (for example, with such a scheme, you could look at an image and tell
>> whether the data is relatively well distributed across all the devices
>> or you might need to re-balance).
> 
> What about linear output separated with lines(or just black)?

Linear output does not produce useful images, except for really small
filesystems.

-- 
Hans van Kranenburg
