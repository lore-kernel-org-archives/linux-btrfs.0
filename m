Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35930 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752136AbcKRMgu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 07:36:50 -0500
Received: by mail-oi0-f66.google.com with SMTP id 128so10439455oih.3
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 04:36:50 -0800 (PST)
Subject: Re: Btrfs Heatmap - v2 - block group internals!
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
 <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
 <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
 <68eecdb7-90e4-a5ba-ca63-f714faf88ede@mendix.com>
 <c067cd99-31ba-9e33-6da6-1d55c1a8c8f5@gmail.com>
 <0b5c943f-4f4b-3844-22d5-6e0f8dc5eb6e@mendix.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <eee07943-1bf6-fd87-abb2-23cf48ccab01@gmail.com>
Date: Fri, 18 Nov 2016 07:36:46 -0500
MIME-Version: 1.0
In-Reply-To: <0b5c943f-4f4b-3844-22d5-6e0f8dc5eb6e@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-17 16:08, Hans van Kranenburg wrote:
> On 11/17/2016 08:27 PM, Austin S. Hemmelgarn wrote:
>> On 2016-11-17 13:51, Hans van Kranenburg wrote:
>>>
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
> "most use cases" -> what are those use cases? If you want to know how
> much total GiB or TiB is present on all devices, a simple btrfs fi show
> does suffice.
Visualizing how the data patterning differs across devices would be the 
biggest one that comes to mind.
>
> Another option is to just write three images, one for each of the
> devices. :) Those are more easily compared.
That would actually be more useful probably, as you can then do pretty 
much whatever post-processing you want, and it would cover the above use 
case just as well.
>
> The first idea with color that I had was to use two different colors for
> data and metadata. When also using separate colors for devices, it might
> all together become a big mess really quickly, or, maybe a beautiful
> rainbow.
I actually like that idea a lot better than using color for 
differentiating between devices.
>
> But, the fun with visualizations of data is that you learn whether they
> just work(tm) or don't as soon as you see them. Mathematical or
> algorithmic beauty is not always a good recipe for beauty as seen by the
> human eye.
>
> So, let's gather a bunch of ideas which we can try out and then observe
> the result.
>
> Before doing so, I'm going to restructure the code a bit more so I can
> write another script in the same directory, just doing import heatmap
> and calling a few functions in there to quickly try stuff, bypassing the
> normal cli api.
>
> Also, the png writing handling is now done by some random png library
> that I found, which requires me to build (or copy/resize) an entire
> pixel grid in memory, explicitely listing all pixel values, which is a
> bit of a memory hog for bigger pictures, so I want to see if something
> can be done there also.
I haven't had a chance to look at the code yet, but do you have an 
option to control how much data a pixel represents?  On a multi TB 
filesystem for example, you may not care about exact data, just an 
overall view of the data, in which case making each pixel represent a 
larger chunk of data (and thus reducing the resolution of the image) 
would almost certainly save some memory on big filesystems.
