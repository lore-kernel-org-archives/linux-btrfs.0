Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36152 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751813AbdIAMrT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 08:47:19 -0400
Received: by mail-io0-f178.google.com with SMTP id f99so563787ioi.3
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 05:47:19 -0700 (PDT)
Subject: Re: [btrfs-progs] Bug in mkfs.btrfs -r
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, kreijack@inwind.it,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7d08fad3-1a73-08c1-dbb1-e845f88cf039@libero.it>
 <113498a8-e9c4-0a9e-c9b0-14489512ee49@gmx.com>
 <6faf4ff6-6913-bfce-6e48-f161452a713a@gmail.com>
 <20381200-2f35-2edc-a20b-8852744ed050@gmx.com>
 <c3b7396a-f3c6-40e8-f85e-32fa1150046c@gmail.com>
 <d819f106-b073-444d-7d71-1eff2bd3a896@gmx.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <eebf3457-9ba2-6267-9d75-dc5752cab11f@gmail.com>
Date: Fri, 1 Sep 2017 08:47:12 -0400
MIME-Version: 1.0
In-Reply-To: <d819f106-b073-444d-7d71-1eff2bd3a896@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-01 08:19, Qu Wenruo wrote:
> 
> 
> On 2017年09月01日 20:05, Austin S. Hemmelgarn wrote:
>> On 2017-09-01 07:49, Qu Wenruo wrote:
>>>
>>> On 2017年09月01日 19:28, Austin S. Hemmelgarn wrote:
>>>> On 2017-08-31 20:13, Qu Wenruo wrote:
>>>>>
>>>>> On 2017年09月01日 01:27, Goffredo Baroncelli wrote:
>>>>>> Hi All,
>>>>>>
>>>>>> I found a bug in mkfs.btrfs, when it is used the option '-r'. It 
>>>>>> seems that it is not visible the full disk.
>>>>>
>>>>> Despite the new bug you found, -r has several existing bugs.
>>>> Is this actually a bug though?  Every other filesystem creation  
>>>> tool that I know of that offers functionality like this generates 
>>>> the filesystem just large enough to contain the data you want in it, 
>>>> so I would argue that making this use the whole device is actually 
>>>> breaking consistency with other tools, not to mention removing 
>>>> functionality that is useful (even aside from the system image 
>>>> generation use case I mentioned, there are other practical 
>>>> applications (seed 'device' generation comes to mind).
>>>
>>> Well, then documentation bug.
>>>
>>> And I'm not sure the chunk size is correct or optimized.
>>> Even for btrfs-convert, which will make data chunks very scattered, 
>>> we still try to make a large chunk to cover scattered data extents.
>> For a one-shot or read-only filesystem though, a maximally sized chunk 
>> is probably suboptimal.
> 
> Not exactly.
> Current kernel (and btrfs-progs also tries to follow kernel chunk 
> allocator's behavior) will not make a chunk larger than 10% of RW space.
> So for small filesystem chunk won't be too maximally sized.
Are you sure about this?  I've got a couple of sub 10GB BTRFS volumes 
that definitely have more than one 1GB data chunk.
> 
>>   Suppose you use this to generate a base image for a system in the 
>> form of a seed device.  This actually ends up being a pretty easy way 
>> to get factory reset functionality.  It's also a case where you want 
>> the base image to take up as little space as possible, so that the 
>> end-user usable storage space is as much as possible.  In that case, 
>> if your base image doesn't need an exact multiple of 1GB for data 
>> chunks, then using 1GB data chunks is not the best choice for at least 
>> the final data chunk (because the rest of that 1GB gets wasted).  A 
>> similar argument applies for metadata.
> 
> Yes, your example makes sense. (despite of above 10% limit I mentioned).
> 
> The problem is, no one really knows how the image will be used.
> Maybe it will be used as normal btrfs (with fi resize), or with your 
> purpose.
We can't save users from making poor choices.  If we could, we wouldn't 
have anywhere near as many e-mails on the list from people who are 
trying to recover data from their broken filesystems because they have 
no backups.

The only case I can find where '-r' is a win is when you need the 
filesystem to be as small as possible with no free space.  The moment 
you need free space, it's actually faster to just create the filesystem, 
resize it to the desired size, and then copy in your data (I've actually 
benchmarked this, and while it's not _much_ difference in time spent, 
there is a measurable difference, with my guess being that the 
allocation code is doing more work in userspace than in the kernel).  At 
a minimum, I think it's probably worth documenting this fact.
> For normal btrfs case, although it may not cause much problem, but it 
> will not be the optimized use case and may need extra manual balance.
Actually, until the first write to the filesystem, it will still be an 
optimal layout.  Once you start writing to any BTRFS filesystem that has 
an optimal layout though, it immediately becomes non-optimal, and 
there's not really anything we can do about that unless we allow chunks 
that are already allocated to be resized on the fly (which is a bad idea 
for multiple reasons).
> 
>>>
>>> At least to me, it's not the case for chunk created by -r option.
>>>
>>> BTW, seed device is RO anyway, how much or how less spare space we 
>>> have is not a problem at all.
>> That really depends on how you look at it.  Aside from the above 
>> example, there's the rather specific question of why you would not 
>> want to avoid wasting space.  The filesystem is read-only, which means 
>> that any 'free space' on that filesystem is completely unusable, can't 
>> be reclaimed for anything else, and in general is just a waste.
> 
> Still same problem above.
> What if the seed device is de-attached and then be used as normal btrfs?
> 
>>>
>>> So to me, even follow other tools -r, we should follow the normal 
>>> extent allocator behavior to create data/metadata, and then set the 
>>> device size to end of its dev extents.
>> I don't entirely agree, but I think I've made my point well enough above.
> 
> Yes, you did make your point clear, and I agree that use cases you 
> mentioned exist and wasted space also exists.
> 
> But since we don't really know what the image will be used, I prefer to 
> keep everything to use kernel (or btrfs-progs) chunk allocator to make 
> the behavior consistent.
> 
> So my point is more about consistent behavior of btrfs-progs and kernel, 
> and less maintenance.
> (That's to say, my goal for mkfs.btrfs -r is just to do mkfs, mount, cp 
> without privilege)
Perhaps we could add some tool then to take a BTRFS filesystem and 
restructure it to have an optimal layout?  On first examination, the 
resize command actually sounds like a reasonable place to do this, 
possibly add a 'min' keyword (similar to 'max') that can also adjust 
chunk sizes to get the smallest possible filesystem.  The biggest thing 
I'm worried about here is that there are numerous use cases for optimal 
filesystems of minimal size, and changing the behavior of the -r option 
will remove the only currently available way to get such filesystems.
