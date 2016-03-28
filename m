Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35341 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbcC1Mgb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 08:36:31 -0400
Received: by mail-qg0-f50.google.com with SMTP id y89so107109546qge.2
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 05:36:30 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id r65sm900246qki.17.2016.03.28.05.36.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 28 Mar 2016 05:36:29 -0700 (PDT)
Subject: Re: Raid 0 setup doubt.
To: linux-btrfs@vger.kernel.org
References: <56F7B77F.9050306@gmail.com>
 <pan$8fc2c$862a26c8$c5af9279$b4bfa8ec@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56F9252F.90704@gmail.com>
Date: Mon, 28 Mar 2016 08:35:59 -0400
MIME-Version: 1.0
In-Reply-To: <pan$8fc2c$862a26c8$c5af9279$b4bfa8ec@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-27 20:56, Duncan wrote:
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
I'm not 100% certain that it will double swap bandwidth unless you're 
constantly swapping, and even then it would only on average double the 
write bandwidth.  The kernel swaps pages in groups (8 pages by default, 
which is 32k, I usually up this to 16 pages on my systems because when 
I'm hitting swap, it usually means I'm hitting it hard), and I'm pretty 
certain that each group of pages only goes to one swap device.  This 
means that by default, with two devices, you would get 32k written at a 
time to alternating devices.  However, there is no guarantee that when 
you swap things in they will be from alternating devices, so you could 
be reading multiple MB of data from one device without even touching the 
other one.  Thus, for writes, this works like a raid0 setup with a large 
stripe size, but for reads it ends up somewhere between raid0 and single 
disk performance, depending on how lucky you are and what type of 
workload you are dealing with.
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
I would tend to disagree here.  Using the default settings under Linux, 
it isn't used much, but there are many people (myself included), who 
turn off memory over-commit, and thus need reasonable amounts of swap 
space.  Many programs will allocate huge chunks of memory that they 
never need or even touch, either 'just in case', or because they want to 
manage their own memory usage.  To account for this, Linux has a knob 
for the virtual memory subsystem that controls how it handles 
allocations beyond the system's effective memory limit (userspace 
accessible RAM + swap space).  For specifics, you can check 
Documentation/sysctl/vm.txt and Documentation/vm/overcommit-accounting 
in the kernel source tree.  The general idea is that by default, the 
kernel tries to estimate how much can be allocated safely.  This usually 
works well until you start to get close to an OOM condition, but it 
slows down memory allocations significantly.  There are two other 
options for this though, just pretend there's enough memory until there 
isn't (this is the fastest, and probably should be the default if you 
don't have swap space), and never over-commit.  Telling the kernel to 
never over-commit is faster than the default, and provides more 
deterministic behavior (you can prove exactly how much needs to be 
allocated to hit OOM), but requires swap space (because it calculates 
the limit as swap space + some percentage of user-space accessible 
memory).  I know a lot of people who run server systems who configure 
the system to never over-commit memory, then just run with lots of swap 
space.  As an example, my home server system has 16G of RAM with 64G of 
swap space configured (16G on SSD's at a higher priority, 48G on 
traditional HDD's).  This lets me set it to never over-commit memory, 
while still allowing me to work with big (astronomical scale, so >10k 
pixels on a side) images, do complex audio/video editing, and work with 
big VCS repositories without any issues.
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
The other caveat that nobody seems to mention outside of specific cases 
is that using suspend to disks exposes you to direct attack by anyone 
with the ability to either physically access the system, or boot an 
alternative OS on it.  This is however not a Linux specific issue 
(although Windows and OS X do a much better job of validating the 
hibernation image than Linux does before resuming from it, so it's not 
as easy to trick them into loading arbitrary data).

