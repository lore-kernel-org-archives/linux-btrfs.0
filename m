Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38491 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbcC1UbA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 16:31:00 -0400
Received: by mail-wm0-f44.google.com with SMTP id 20so31006515wmh.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 13:30:59 -0700 (PDT)
Received: from [192.168.1.38] (166.red-83-52-1.dynamicip.rima-tde.net. [83.52.1.166])
        by smtp.gmail.com with ESMTPSA id s66sm11627269wmb.6.2016.03.28.13.30.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 28 Mar 2016 13:30:57 -0700 (PDT)
Subject: Re: Raid 0 setup doubt.
To: linux-btrfs@vger.kernel.org
References: <56F7B77F.9050306@gmail.com>
 <pan$8fc2c$862a26c8$c5af9279$b4bfa8ec@cox.net>
From: Jose Otero <jose.manuel.otero@gmail.com>
Message-ID: <56F99480.2090707@gmail.com>
Date: Mon, 28 Mar 2016 22:30:56 +0200
MIME-Version: 1.0
In-Reply-To: <pan$8fc2c$862a26c8$c5af9279$b4bfa8ec@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks a lot Duncan, Chris Murphy, James Johnston, and Austin.

Thanks for the clear answer and the extra information to chew on.

Duncan, you are right. I have 8 GB of RAM, and the most memory intensive
thing I'll be doing is a VM for Windows. Now I double boot, but rarely
go into Win, only to play some game occasionally. So, I think I'll be
better off with Linux flat out and Win in a VM.

I'm probably overshooting too much with the 16 GiB swap, so I may be
ending up with 8 GiB swap. And I'll read up the splitting thing with the
priority trick because sounds nice. Thanks for the tip.

Take care everybody,

JM.



On 03/28/2016 02:56 AM, Duncan wrote:
> Jose Otero posted on Sun, 27 Mar 2016 12:35:43 +0200 as excerpted:
> 
>> Hello,
>>
>> --------------------------------------
>> I apologize beforehand if I'm asking a too basic question for the
>> mailing list, or if it has been already answered at nauseam.
>> --------------------------------------
> 
> Actually, looks like pretty reasonable questions, to me. =:^)
> 
>> I have two hdd (Western Digital 750 GB approx. 700 GiB each), and I
>> planning to set up a RAID 0 through btrfs. UEFI firmware/boot, no dual
>> boot, only linux.
>>
>> My question is, given the UEFI partition plus linux swap partition, I
>> won't have two equal sized partitions for setting up the RAID 0 array.
>> So, I'm not quite sure how to do it. I'll have:
>>
>> /dev/sda:
>>
>>        16 KiB (GPT partition table)
>> sda1:  512 MiB (EFI, fat32)
>> sda2:  16 GiB (linux-swap)
>> sda3:  rest of the disk /  (btrfs)
>>
>> /dev/sdb:
>>
>> sdb1:  (btrfs)
>>
>> The btrfs partitions on each hdd are not of the same size (admittedly by
>> an small difference, but still). Even if a backup copy of the EFI
>> partition is created in the second hdd (i.e. sdb) which it may be, not
>> sure, because the linux-swap partion is still left out.
>>
>> Should I stripe both btrfs partitions together no matter the size?
> 
> That should work without issue.
> 
>> mkfs.btrfs -m raid0 -d raid0 /dev/sda3 /dev/sdb1
>>
>> How will btrfs manage the difference in size?
> 
> Btrfs raid0 requires two devices, minimum, striping each chunk across the 
> two.  Therefore, with two devices, to the extent that one device is 
> larger, the larger (as partitioned) device will leave the difference in 
> space unusable, as there's no second device to stripe with.
> 
>> Or should I partition out the extra size of /dev/sdb for trying to match
>> equally sized partions? in other words:
>>
>> /dev/sdb:
>>
>> sdb1:  17 GiB approx. free or for whatever I want.
>> sdb2:  (btrfs)
>>
>> and then:
>>
>> mkfs.btrfs -m raid0 -d raid0 /dev/sda3 /dev/sdb2
> 
> This should work as well.
> 
> 
> But there's another option you didn't mention, that may be useful, 
> depending on your exact need and usage of that swap:
> 
> Split your swap space in half, say (roughly, you can make one slightly 
> larger than the other to allow for the EFI on one device) 8 GiB on each 
> of the hdds.  Then, in your fstab or whatever you use to list the swap 
> options, put the option priority=100 (or whatever number you find 
> appropriate) on /both/ swap partitions.
> 
> With an equal priority on both swaps and with both active, the kernel 
> will effectively raid0 your swap as well (until one runs out, of course), 
> which, given that on spinning rust the device speed is the definite 
> performance bottleneck for swap, should roughly double your swap 
> performance. =:^)  Given that swap on spinning rust is slower than real 
> RAM by several orders of magnitude, it'll still be far slower than real 
> RAM, but twice as fast as it would be is better than otherwise, so...
> 
> 
> Tho how much RAM /do/ you have, and are you sure you really need swap at 
> all?  Many systems today have enough RAM that they don't really need swap 
> (at least as swap, see below), unless they're going to be used for 
> something extremely memory intensive, where the much lower speed of swap 
> isn't a problem.
> 
> If you have 8 GiB of RAM or more, this may well be your situation.  With 
> 4 GiB, you probably have more than enough RAM for normal operation, but 
> it may still be useful to have at least some swap, so Linux can keep more 
> recently used files cached while swapping out some seldom used 
> application RAM, but by 8 GiB you likely have enough RAM for reasonable 
> cache AND all your apps and won't actually use swap much at all.
> 
> Tho if you frequently edit GiB+ video files and/or work with many virtual 
> machines, 8 GiB RAM will likely be actually used, and 16 GiB may be the 
> point at which you don't use swap much at all.  And of course if you are 
> using LOTS of VMs or doing heavy 4K video editing, 16 GiB or more may 
> well still be in heavy use, but with that kind of memory-intensive usage, 
> 32 GiB of RAM or more would likely be a good investment.
> 
> Anyway, for systems with enough memory to not need swap in /normal/ 
> circumstances, in the event that something's actually leaking memory 
> badly enough that swap is needed, there's a very good chance that you'll 
> never outrun the leak with swap anyway, as if it's really leaking gigs of 
> memory, it'll just eat up whatever gigs of swap you throw at it as well 
> and /still/ run out of memory.
> 
> Meanwhile, swap to spinning rust really is /slow/.  You're talking 16 GiB 
> of swap, and spinning rust speeds of 50 MiB/sec for swap isn't unusual.  
> That's ~20 seconds worth of swap-thrashing waiting per GiB, ~320 seconds 
> or over five minutes worth of swap thrashing to use the full 16 GiB.  OK, 
> so you take that priority= idea and raid0 over two devices, it'll still 
> be ~2:40 worth of waiting, to fully use that swap.  Is 16 GiB of swap 
> /really/ both needed and worth that sort of wait if you do actually use 
> it?
> 
> Tho again, if you're running a half dozen VMs and only actually use a 
> couple of them once or twice a day, having enough swap to let them swap 
> out the rest of the day, so the memory they took can be used for more 
> frequently accessed applications and cached files, can be useful.  But 
> that's a somewhat limited use-case.
> 
> 
> So swap, for its original use as slow memory at least, really isn't that 
> much used any longer, tho it can still be quite useful in specific use-
> cases.
> 
> But there's another more modern use-case that can be useful for many.  
> Linux's suspend-to-disk, aka hibernate (as opposed to suspend-to-RAM, aka 
> sleep or standby), functionality.  Suspend-to-disk uses swap space to 
> store the suspend image.  And that's commonly enough used that swap still 
> has a modern usage after all, just not the one it was originally designed 
> for.
> 
> The caveat with suspend-to-disk, however, is that normally, the entire 
> suspend image must be placed on a single swap device.[1]  If you intend 
> to use your swap to store a hibernate image, then, and if you have 16 GiB 
> or more of RAM and want to save as much of it as possible in that 
> hibernate image, then you'll want to keep that 16 GiB swap on a single 
> device in ordered to let you use the full size as a hibernate image.
> 
> Tho of course, if the corresponding space on the other hdd is going to be 
> wasted anyway, as it will if you're doing btrfs raid0 on the big 
> partition of each device and you don't have anything else to do with the 
> remaining ~16 GiB on the other device, then you might still consider 
> doing a 16 GiB swap on each and using the priority= trick to raid0 them 
> during normal operation.  You're unlikely to actually use the full 32 GiB 
> of swap, but since it'll be double-speed due to the raid0, if you do, 
> it'll still be basically the same as using a single 16 GiB swap device, 
> and at the more typical usage (if even above 0 at all) of a few MiB to a 
> GiB or so, you'll still get the benefit of the raid0 swap.
> 
>> Again, I'm sorry if it's an idiotic question, but I don't have it quite
>> clear and I would like to do it properly. So, any hint from more
>> knowable users would be MUCH appreciate it.
> 
> Perhaps this was more information than you expected, but hopefully it's 
> helpful, none-the-less.  And it's definitely better than finding out 
> critical information /after/ you did it wrong, so while the answer here 
> wasn't /that/ critical either way, I sure wish more people would ask 
> before they actually deploy, and avoid problems they run into when it 
> /was/ critical information they missed!  So you definitely have my 
> respect as a wise and cautious administrator, taking the time to get 
> things correct /before/ you make potential mistakes!  =:^)
> 
> 
> Meanwhile, you didn't mention whether you've discovered the btrfs wiki as 
> a resource and had read up there already or not.  So let me mention it, 
> and recommend that if you haven't, you set aside a few hours to read up 
> on btrfs and how it works, as well as problems you may encounter and 
> possible solutions.  You may still have important questions like the 
> above after reading thru the wiki, and indeed, may find reading it brings 
> even more questions to your mind, but it's a very useful resource to read 
> up a bit on, before starting in with btrfs.  I know it helped me quite a 
> bit, tho I had questions after I read it, too.  But at least I knew a bit 
> more about what questions I still needed to ask after that. =:^)
> 
> https://btrfs.wiki.kernel.org
> 
> Read up on most of the user documentation pages, anyway.  As a user not a 
> dev, you can skip the developer pages unless like me you're simply 
> curious and read some developer-targeted stuff anyway, even if you don't 
> claim to actually be one.
> 
> ---
> [1] Single-device suspend-image:  There are ways around this that involve 
> complex hoop-jumping in the initr* before the image is reloaded, but at 
> least here, I prefer to avoid that sort of complexity as it increases 
> maintenance complexity as well, and as an admin I prefer a simpler system 
> that I understand well enough to troubleshoot and recover from disaster, 
> to a complex one that I don't really understand and thus can't 
> effectively troubleshoot nor be confident I can effectively recover in a 
> disaster situation.
> 
