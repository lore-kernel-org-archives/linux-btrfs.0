Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:36548 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380AbaLVAip (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 19:38:45 -0500
Message-ID: <54976811.2060507@pobox.com>
Date: Sun, 21 Dec 2014 16:38:41 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
References: <20141217024228.GA5544@pyropus.ca> <54955624.5040808@pobox.com> <20141221163207.GA18988@pyropus.ca> <54973C65.6070709@pobox.com> <20141221225315.GA19479@pyropus.ca>
In-Reply-To: <20141221225315.GA19479@pyropus.ca>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/21/2014 02:53 PM, Charles Cazabon wrote:
> Hi, Robert,
>
> My performance issues with btrfs are more-or-less resolved now -- the
> performance under btrfs still seems quite variable compared to other
> filesystems -- my rsync speed is now varying between 40MB and ~90MB/s, with
> occasional intervals where it drops further, down into the 10-20MB/s range.
> Still no disk errors or SMART warnings that would indicate that problem is at
> the hardware level.
>
>> Do make sure you are regularly running the long "offline" test.
>
> Ok, I'll do that.
>
>> Otherwise SMART is just going to tell you the disk just died when it dies.
>
> Ya, I'm aware of how limited/useful the SMART diagnostics are.  I'm also
> paranoid enough to be using RAID 6...
>
>> The thing with "movablecore=" will not lead to an "out of memory"
>> condition or not, its a question of cache and buffer evictions.
>
> I'm fairly certain memory isn't the issue here.  For what it's worth:
>
> %Cpu(s):  2.1 us, 19.4 sy,  0.0 ni, 78.0 id,  0.2 wa,  0.3 hi,  0.0 si,  0.0 st
> KiB Mem:  16469880 total, 16301252 used,   168628 free,      720 buffers
> KiB Swap:  7811068 total,        0 used,  7811068 free, 15146580 cached
>
> Swappiness I've left at the default of 60, but I'm not seeing swapping going
> on regardless.

Swappiness has nothing to do with swapping.

You have very little free memory.

Here is how a linux system runs a program. When exec() is called the 
current process memory is wiped (dropped, forgotten, whatever) [except 
for a few things like the open file discriptor table]. Then the 
executable is opened and mmap() is called to map the text portions of 
that executable into memory. This does not involve any particular 
reading of that file. The dynamic linker also selectively mmap()s the 
needed libraries. So you end up with something that looks like this:

[+.....................]

Most of the program is not actually in memory. (the "." parts), and some 
minimum part is in memory (the "+" part).

As you use the program more of it will work its way into memory.

[+++.....+.+....++....]

swappiness controls the likelihood that memory pressure will cause parts 
that have been read in to be "forgotten" based on the idea that it can 
be read again later if needed.

[+++.....+.+....++....]
[+.......+......+.....]

This is called "demand paging", and because linux uses ELF (extensible 
link format) and all programs run in a uniform memory map, program text 
_never_ needs to be written to swap space. Windows DLL/EXE has to 
"relocate" the code, e.g. re-write it to make it runable. So on windows 
code text has to be paged to swap.

So what is "swapping" and swap space for?

Well next to the code is the data.

[+++.....+.+....++....] {.............}

As it gets written to, it cannot just be forgotten because the program 
needs that data or it wouldn't have written it.

[+++.....+.+....++....] {..******.*...}

So if the system needs to reclaim the memory used by that kind of data 
it sends it to the swap space.

[+++.....+.+....++....] {..******.*...}
                       ^^^^ swapping vvvv
[+++.....+.+....++....] {..**...*.*...}


Swappiness is how you tel the system that you want to keep the code 
("+") in memory in favor of the data ("*").

But _long_ before you start having to actually write the data to disk in 
the swap space, the operating system will start casually forgetting the 
code. Most of both of these things, while "freshly forgotten" can be 
"reclaimed" from the disk/page cache.

So when you show me that free memory listing what I see is someone who 
is bumping against their "minimum desired free memory" limit (e.g. about 
1% free ram) and so has a system where it's _possible_ that a good bit 
of stuff is getting dumped out of the active page tables and into the 
disk/page cache where it could start bogging down the system in large 
numbers of short reclaim delays and potentially non-trivial amounts of 
demand paging.

So not "out of memory" but not ideal. Real measurements of page fault 
activity and wait for io time needs to be done to determine if more 
action needs to be taken.

Compare that to my laptop where I've deliberately made sure that memory 
is always available for fast transient use.

Gust ~ # free
               total        used        free      shared  buff/cache 
available
Mem:        7915804     2820368     2419300       47472     2676136 
4790892
Swap:       8778748      311688     8467060


In this configuration when I run bursty stuff I've set aside two gig 
that sits around "Free" into which the dynamic load can find ample 
space. (I am not recommending that for you necessarily, were I present 
I'd do some experimenting). But that dynamic space is where the rsync 
would be doing its work and so be less likely to stall. (Etc).


