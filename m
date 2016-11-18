Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33041 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753287AbcKRPat (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 10:30:49 -0500
Received: by mail-oi0-f65.google.com with SMTP id f201so7566053oib.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 07:30:49 -0800 (PST)
Subject: Re: Btrfs Heatmap - v2 - block group internals!
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
 <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
 <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
 <68eecdb7-90e4-a5ba-ca63-f714faf88ede@mendix.com>
 <c067cd99-31ba-9e33-6da6-1d55c1a8c8f5@gmail.com>
 <02310b0f-5fed-746a-ca05-d655dce7d57a@cn.fujitsu.com>
 <9945f788-2516-007b-43ce-dabcff263cd8@mendix.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <64e34b7e-9d34-8697-0d1d-5b5b2c9a903d@gmail.com>
Date: Fri, 18 Nov 2016 10:30:45 -0500
MIME-Version: 1.0
In-Reply-To: <9945f788-2516-007b-43ce-dabcff263cd8@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-18 10:08, Hans van Kranenburg wrote:
> On 11/18/2016 03:08 AM, Qu Wenruo wrote:
>>>> When generating a picture of a file system with multiple devices,
>>>> boundaries between the separate devices are not visible now.
>>>>
>>>> If someone has a brilliant idea about how to do this without throwing
>>>> out actual usage data...
>>>>
>>> The first thought that comes to mind for me is to make each device be a
>>> different color, and otherwise obey the same intensity mapping
>>> correlating to how much data is there.  For example, if you've got a 3
>>> device FS, the parts of the image that correspond to device 1 would go
>>> from 0x000000 to 0xFF0000, the parts for device 2 could be 0x000000 to
>>> 0x00FF00, and the parts for device 3 could be 0x000000 to 0x0000FF. This
>>> is of course not perfect (you can't tell what device each segment of
>>> empty space corresponds to), but would probably cover most use cases.
>>> (for example, with such a scheme, you could look at an image and tell
>>> whether the data is relatively well distributed across all the devices
>>> or you might need to re-balance).
>>
>> What about linear output separated with lines(or just black)?
>
> Linear output does not produce useful images, except for really small
> filesystems.
However, it's how the human brain is hardwired to parse data like this 
(two data points per item, one for value, one for ordering).  That's 
part of the reason that all known writing systems use a linear 
arrangement arrangement of symbols to store information (the other parts 
have to do with things like storage efficiency and error detection (and 
yes, I'm serious, those do play a part in the evolution of language and 
writing)).

As an example of why this is important, imagine showing someone who 
understands the concept of data fragmentation (most people have little 
to no issue understanding this concept) a heatmap of a filesystem with 
no space fragmentation at all without explaining that it uses a a 
Hilbert Curve 2d ordering.  Pretty much 100% of people who aren't 
mathematicians or scientists will look at that and the first thought 
that will come to their mind is almost certainly going to be along the 
lines of 'holy crap that's fragmented really bad in this specific area'.

This is the reason that pretty much nothing outside of scientific or 
mathematical data uses a Hilbert curve based 2d ordering of data (and 
even then, they almost never use it for final presentation of the data).

Data presentation for something like this in a way that laypeople can 
understand is hard, but it's also important.  Take a look at some of the 
graphical tools for filesystem defragmentation.  The presentation 
requirements there are pretty similar, and so is the data being 
conveyed.  They all use a grid oriented linear presentation of 
allocation data.  The difference is that they scale up the blocks so 
that they're easily discernible by sight.  This allows them to represent 
the data in a way that's trivial to explain (read this line-by-line), 
unlike the Hilbert curve (the data follows a complex folded spiral 
pattern which is fractal in nature).

Now, I personally have no issue with the Hilbert ordering, but if there 
were an option to use a linear ordering, I would almost certainly use 
that instead, simply because I could more easily explain the data to people.
