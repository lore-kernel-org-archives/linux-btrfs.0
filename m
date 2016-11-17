Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33675 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbcKQT1w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 14:27:52 -0500
Received: by mail-it0-f68.google.com with SMTP id c20so17286564itb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Nov 2016 11:27:39 -0800 (PST)
Subject: Re: Btrfs Heatmap - v2 - block group internals!
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
 <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
 <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
 <68eecdb7-90e4-a5ba-ca63-f714faf88ede@mendix.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c067cd99-31ba-9e33-6da6-1d55c1a8c8f5@gmail.com>
Date: Thu, 17 Nov 2016 14:27:36 -0500
MIME-Version: 1.0
In-Reply-To: <68eecdb7-90e4-a5ba-ca63-f714faf88ede@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-17 13:51, Hans van Kranenburg wrote:
> Hey,
>
> On 11/17/2016 02:27 AM, Qu Wenruo wrote:
>>
>> At 11/17/2016 04:30 AM, Hans van Kranenburg wrote:
>>> In the last two days I've added the --blockgroup option to btrfs heatmap
>>> to let it create pictures of block group internals.
>>>
>>> Examples and more instructions are to be found in the README at:
>>> https://github.com/knorrie/btrfs-heatmap/blob/master/README.md
>>>
>>> To use the new functionality it needs a fairly recent python-btrfs for
>>> the 'skinny' METADATA_ITEM_KEY to be present. Latest python-btrfs
>>> release is v0.3, created yesterday.
>>>
>> Wow, really cool!
>
> Thanks!
>
>> I always dream about a visualizing tool to represent the chunk and
>> extent level of btrfs.
>>
>> This should really save me from reading the boring dec numbers from
>> btrfs-debug-tree.
>>
>> Although IMHO the full fs output is mixing extent and chunk level
>> together, which makes it a little hard to represent multi-device case,
>> it's still an awesome tool!
>
> The picture of a full filesystem just appends all devices together into
> one big space, and then walks the dev_extent tree and associated
> chunk/blockgroup items for the %used/greyscale value.
>
> I don't see what displaying a blockgroup-level aggregate usage number
> has to do with multi-device, except that the same %usage will appear
> another time when using RAID1*.
>
> When generating a picture of a file system with multiple devices,
> boundaries between the separate devices are not visible now.
>
> If someone has a brilliant idea about how to do this without throwing
> out actual usage data...
>
The first thought that comes to mind for me is to make each device be a 
different color, and otherwise obey the same intensity mapping 
correlating to how much data is there.  For example, if you've got a 3 
device FS, the parts of the image that correspond to device 1 would go 
from 0x000000 to 0xFF0000, the parts for device 2 could be 0x000000 to 
0x00FF00, and the parts for device 3 could be 0x000000 to 0x0000FF. 
This is of course not perfect (you can't tell what device each segment 
of empty space corresponds to), but would probably cover most use cases. 
(for example, with such a scheme, you could look at an image and tell 
whether the data is relatively well distributed across all the devices 
or you might need to re-balance).
