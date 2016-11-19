Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55466 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752675AbcKSA5s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 19:57:48 -0500
Subject: Re: Btrfs Heatmap - v2 - block group internals!
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
 <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
 <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
 <68eecdb7-90e4-a5ba-ca63-f714faf88ede@mendix.com>
 <c067cd99-31ba-9e33-6da6-1d55c1a8c8f5@gmail.com>
 <02310b0f-5fed-746a-ca05-d655dce7d57a@cn.fujitsu.com>
 <9945f788-2516-007b-43ce-dabcff263cd8@mendix.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b2e58da2-7f47-8827-3179-31ff50c9b6b9@gmx.com>
Date: Sat, 19 Nov 2016 08:57:26 +0800
MIME-Version: 1.0
In-Reply-To: <9945f788-2516-007b-43ce-dabcff263cd8@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/18/2016 11:08 PM, Hans van Kranenburg wrote:
> On 11/18/2016 03:08 AM, Qu Wenruo wrote:
>>
>> Just found one small problem.
>> After specifying --size 16 to output a given block group (small block
>> group, I need large size to make output visible), it takes a full cpu
>> and takes a long long long time to run.
>> So long I don't even want to wait.
>>
>> I changed size to 10, and it finished much faster.
>>
>> Is that expected?
>
> Yes, hilbert curve size increases exponentially when increasing order.
>
> 2**16 = 65536, 65536x65536 = 4294967296 pixels in the png image.
>
> So even if you would have a petabyte filesystem, that would still mean
> that a single pixel in the image represents only ~ 256kB. I don't think
> your small block groups are 256kB big?
>
> Specifying values like this does not make any sense at all, and it
> expected not to work well.
>
>>>> I don't see what displaying a blockgroup-level aggregate usage number
>>>> has to do with multi-device, except that the same %usage will appear
>>>> another time when using RAID1*.
>>
>> Although in fact, for profiles like RAID0/5/6/10, it's completely
>> possible that one dev_extent contains all the data, while another
>> dev_extent is almost empty.
>
> When using something like RAID0 profile, I would expect 50% of the data
> to end up in one dev_extent and 50% in the other?

First I'm mostly OK with current grayscale.
What I'm saying can be considered as nitpicking.

The only concern is, the for full fs output, we are in fact output 
dev_extents of each device.

In that case, we should output info at the same level of dev_extent.

So if we really need to provide *accurate* gray scale, then we should 
base on the %usage of a dev extent.


And for 50%/50% assumption for RAID0, it's not true and we can easily 
create a case where it's 100%/0%

The method is as simple as the following script (Assume the data BG is 
1G, and first write will be allcated to offset 0 of the BG)

# Fill 1G BG with 64K files
for i in $(seq -w 0 16383); do
     xfs_io -f -c "pwrite 0 64k" $mnt/file_$i

     # Sync fs to ensure extent allocation happens
     sync
done

# Remove every each file, to create holes
for i in $(seq -w 0 2 16383); do
     rm $mnt/file_$i
done
btrfs fi sync $mnt

Then, only the 2nd data stripe has data, while the 1st data stripe are free.


Things will become more complicated when RAID5/6 is involved.
>
>> Strictly speaking, at full fs or dev level, we should output things at
>> dev_extent level, then greyscale should be representing dev_extent
>> usage(which is not possible or quite hard to calculate)
>
> That's what it's doing now?
>
>> Anyway, the greyscale is mostly OK, just as a good addition output for
>> full fs graph.
>
> I don't follow.
>
>> Although if it could output the fs or specific dev without gray scale, I
>> think it would be better.
>> It will be much clearer about the dev_extent level fragments.
>
> I have no idea what you mean, sorry.

The point is, for full fs or per-device output, a developer may focus on 
the fragments of unallocated space in each device.

In that case, an almost empty bg will be much like unallocated space.

So I hope if there is any option to disable greyscale at full fs output, 
it would be much better.

Just like the blockgroup output, only black and while, and the example 
in the github is really awesome!

It shows a lot of thing I didn't have a clear view before.
Like batched metadata extents (mostly for csum tree) and fragmented 
metadata for other trees.

Thanks,
Qu
>
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
>
