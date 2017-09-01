Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62731 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751607AbdIAMTZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 08:19:25 -0400
Subject: Re: [btrfs-progs] Bug in mkfs.btrfs -r
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, kreijack@inwind.it,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7d08fad3-1a73-08c1-dbb1-e845f88cf039@libero.it>
 <113498a8-e9c4-0a9e-c9b0-14489512ee49@gmx.com>
 <6faf4ff6-6913-bfce-6e48-f161452a713a@gmail.com>
 <20381200-2f35-2edc-a20b-8852744ed050@gmx.com>
 <c3b7396a-f3c6-40e8-f85e-32fa1150046c@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d819f106-b073-444d-7d71-1eff2bd3a896@gmx.com>
Date: Fri, 1 Sep 2017 20:19:13 +0800
MIME-Version: 1.0
In-Reply-To: <c3b7396a-f3c6-40e8-f85e-32fa1150046c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月01日 20:05, Austin S. Hemmelgarn wrote:
> On 2017-09-01 07:49, Qu Wenruo wrote:
>>
>> On 2017年09月01日 19:28, Austin S. Hemmelgarn wrote:
>>> On 2017-08-31 20:13, Qu Wenruo wrote:
>>>>
>>>> On 2017年09月01日 01:27, Goffredo Baroncelli wrote:
>>>>> Hi All,
>>>>>
>>>>> I found a bug in mkfs.btrfs, when it is used the option '-r'. It 
>>>>> seems that it is not visible the full disk.
>>>>
>>>> Despite the new bug you found, -r has several existing bugs.
>>> Is this actually a bug though?  Every other filesystem creation  tool 
>>> that I know of that offers functionality like this generates the 
>>> filesystem just large enough to contain the data you want in it, so I 
>>> would argue that making this use the whole device is actually 
>>> breaking consistency with other tools, not to mention removing 
>>> functionality that is useful (even aside from the system image 
>>> generation use case I mentioned, there are other practical 
>>> applications (seed 'device' generation comes to mind).
>>
>> Well, then documentation bug.
>>
>> And I'm not sure the chunk size is correct or optimized.
>> Even for btrfs-convert, which will make data chunks very scattered, we 
>> still try to make a large chunk to cover scattered data extents.
> For a one-shot or read-only filesystem though, a maximally sized chunk 
> is probably suboptimal.

Not exactly.
Current kernel (and btrfs-progs also tries to follow kernel chunk 
allocator's behavior) will not make a chunk larger than 10% of RW space.
So for small filesystem chunk won't be too maximally sized.

>  Suppose you use this to generate a base image 
> for a system in the form of a seed device.  This actually ends up being 
> a pretty easy way to get factory reset functionality.  It's also a case 
> where you want the base image to take up as little space as possible, so 
> that the end-user usable storage space is as much as possible.  In that 
> case, if your base image doesn't need an exact multiple of 1GB for data 
> chunks, then using 1GB data chunks is not the best choice for at least 
> the final data chunk (because the rest of that 1GB gets wasted).  A 
> similar argument applies for metadata.

Yes, your example makes sense. (despite of above 10% limit I mentioned).

The problem is, no one really knows how the image will be used.
Maybe it will be used as normal btrfs (with fi resize), or with your 
purpose.

For normal btrfs case, although it may not cause much problem, but it 
will not be the optimized use case and may need extra manual balance.

>>
>> At least to me, it's not the case for chunk created by -r option.
>>
>> BTW, seed device is RO anyway, how much or how less spare space we 
>> have is not a problem at all.
> That really depends on how you look at it.  Aside from the above 
> example, there's the rather specific question of why you would not want 
> to avoid wasting space.  The filesystem is read-only, which means that 
> any 'free space' on that filesystem is completely unusable, can't be 
> reclaimed for anything else, and in general is just a waste.

Still same problem above.
What if the seed device is de-attached and then be used as normal btrfs?

>>
>> So to me, even follow other tools -r, we should follow the normal 
>> extent allocator behavior to create data/metadata, and then set the 
>> device size to end of its dev extents.
> I don't entirely agree, but I think I've made my point well enough above.

Yes, you did make your point clear, and I agree that use cases you 
mentioned exist and wasted space also exists.

But since we don't really know what the image will be used, I prefer to 
keep everything to use kernel (or btrfs-progs) chunk allocator to make 
the behavior consistent.

So my point is more about consistent behavior of btrfs-progs and kernel, 
and less maintenance.
(That's to say, my goal for mkfs.btrfs -r is just to do mkfs, mount, cp 
without privilege)

Thanks,
Qu

>>>>
>>>> For example it will create dev extent starting from physical offset 
>>>> 0, while kernel and mkfs will avoid that range, as 0~1M on each 
>>>> device is reserved.
>>>>
>>>> According to the code, -r will modify chunk layout by itself, not 
>>>> the traditional way kernel is doing.
>>>>
>>>> I'll fix them (if I'm not a lazybone), before that fix, please don't 
>>>> use -r option as it's not well maintained or fully tested.
>>> FWIW, based on my own testing, filesystems generated with '-r' work 
>>> just fine as long as you don't try to embed boot code in the FS itself.
>>
>> It works fine because btrfs extent allocator will try to avoid 
>> superblock.
>> But it doesn't mean we should put dev extents into 0~1M range.
>>
>> In fact, there is a deprecated mount option, alloc_start, to set how 
>> many bytes we should reserve for *each* device.
>> And since it's deprecated, we'd better follow the 1M reservation for 
>> each device.
>>
>> Anyway, kernel balance and plain mkfs won't create chunk stripe in 
>> 0~1M range of each device, mkfs -r should also follow it.
> Agreed, although the comments I made above about wasted space do still 
> apply here (albeit to a lesser degree, 1MB is not going to make much of 
> a difference for most people).
> 
