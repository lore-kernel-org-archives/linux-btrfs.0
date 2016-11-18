Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54946 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751180AbcKRCIg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 21:08:36 -0500
Subject: Re: Btrfs Heatmap - v2 - block group internals!
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        <linux-btrfs@vger.kernel.org>
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
 <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
 <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
 <68eecdb7-90e4-a5ba-ca63-f714faf88ede@mendix.com>
 <c067cd99-31ba-9e33-6da6-1d55c1a8c8f5@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <02310b0f-5fed-746a-ca05-d655dce7d57a@cn.fujitsu.com>
Date: Fri, 18 Nov 2016 10:08:27 +0800
MIME-Version: 1.0
In-Reply-To: <c067cd99-31ba-9e33-6da6-1d55c1a8c8f5@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/18/2016 03:27 AM, Austin S. Hemmelgarn wrote:
> On 2016-11-17 13:51, Hans van Kranenburg wrote:
>> Hey,
>>
>> On 11/17/2016 02:27 AM, Qu Wenruo wrote:
>>>
>>> At 11/17/2016 04:30 AM, Hans van Kranenburg wrote:
>>>> In the last two days I've added the --blockgroup option to btrfs
>>>> heatmap
>>>> to let it create pictures of block group internals.
>>>>
>>>> Examples and more instructions are to be found in the README at:
>>>> https://github.com/knorrie/btrfs-heatmap/blob/master/README.md
>>>>
>>>> To use the new functionality it needs a fairly recent python-btrfs for
>>>> the 'skinny' METADATA_ITEM_KEY to be present. Latest python-btrfs
>>>> release is v0.3, created yesterday.
>>>>
>>> Wow, really cool!
>>
>> Thanks!
>>
>>> I always dream about a visualizing tool to represent the chunk and
>>> extent level of btrfs.
>>>
>>> This should really save me from reading the boring dec numbers from
>>> btrfs-debug-tree.
>>>
>>> Although IMHO the full fs output is mixing extent and chunk level
>>> together, which makes it a little hard to represent multi-device case,
>>> it's still an awesome tool!
>>
>> The picture of a full filesystem just appends all devices together into
>> one big space, and then walks the dev_extent tree and associated
>> chunk/blockgroup items for the %used/greyscale value.

My fault, just thought different greyscale means meta/data extents.
I got it confused with block group level output.

Then I'm mostly OK.



Just found one small problem.
After specifying --size 16 to output a given block group (small block 
group, I need large size to make output visible), it takes a full cpu 
and takes a long long long time to run.
So long I don't even want to wait.

I changed size to 10, and it finished much faster.

Is that expected?

>>
>> I don't see what displaying a blockgroup-level aggregate usage number
>> has to do with multi-device, except that the same %usage will appear
>> another time when using RAID1*.

Although in fact, for profiles like RAID0/5/6/10, it's completely 
possible that one dev_extent contains all the data, while another 
dev_extent is almost empty.
Strictly speaking, at full fs or dev level, we should output things at 
dev_extent level, then greyscale should be representing dev_extent 
usage(which is not possible or quite hard to calculate)

Anyway, the greyscale is mostly OK, just as a good addition output for 
full fs graph.


Although if it could output the fs or specific dev without gray scale, I 
think it would be better.
It will be much clearer about the dev_extent level fragments.

>>
>> When generating a picture of a file system with multiple devices,
>> boundaries between the separate devices are not visible now.
>>
>> If someone has a brilliant idea about how to do this without throwing
>> out actual usage data...
>>
> The first thought that comes to mind for me is to make each device be a
> different color, and otherwise obey the same intensity mapping
> correlating to how much data is there.  For example, if you've got a 3
> device FS, the parts of the image that correspond to device 1 would go
> from 0x000000 to 0xFF0000, the parts for device 2 could be 0x000000 to
> 0x00FF00, and the parts for device 3 could be 0x000000 to 0x0000FF. This
> is of course not perfect (you can't tell what device each segment of
> empty space corresponds to), but would probably cover most use cases.
> (for example, with such a scheme, you could look at an image and tell
> whether the data is relatively well distributed across all the devices
> or you might need to re-balance).

What about linear output separated with lines(or just black)?
Like:
X = Used        (While)
O = Unallocated (Gray)
   = Out of dev range (Black)
|-= Separator (Black)
-----------
| | |X| |X|
| |X|O|O|X|
| |O|O|O|O|
| |X|X|X|X|
|O|X|O|O|X|
-----------
  D D D D D
  e e e e e
  v v v v v
  1 2 3 4 5

Or multi vertical line to represent one dev:
----------------
|O |  |X |  |X |
|X |X |O |O |XX|
|XO|O |O |O |OX|
|XO|X |XX|X |XX|
|OX|X |OX|O |XX|
----------------


Thanks,
Qu


