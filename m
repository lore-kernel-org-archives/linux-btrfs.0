Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-06v.sys.comcast.net ([96.114.154.165]:59757 "EHLO
	resqmta-po-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbaLUVc1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 16:32:27 -0500
Message-ID: <54973C65.6070709@pobox.com>
Date: Sun, 21 Dec 2014 13:32:21 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
References: <20141217024228.GA5544@pyropus.ca> <54955624.5040808@pobox.com> <20141221163207.GA18988@pyropus.ca>
In-Reply-To: <20141221163207.GA18988@pyropus.ca>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/21/2014 08:32 AM, Charles Cazabon wrote:
> Hi, Robert,
>
> Thanks for the response.  Many of the things you mentioned I have tried, but
> for completeness:
>
>> Have you taken SMART (smartmotools etc) to these disks
> There are no errors or warnings from SMART for the disks.


Do make sure you are regularly running the long "offline" test. [offline 
is a bad name, what it really should be called is the long idle-interval 
test. sigh] about once a week. Otherwise SMART is just going to tell you 
the disk just died when it dies.

I'm not saying this is relevant to the current circumstance. But since 
you didn't mention a testing schedule I figured it bared a mention

>> Have you tried segregating some of your system memory for to make
>> sure that you aren't actually having application performance issues?
>
> The system isn't running out of memory; as I say, about the only userspace
> processes running are ssh, my shell, and rsync.

The thing with "movablecore=" will not lead to an "out of memory" 
condition or not, its a question of cache and buffer evictions.

I figured that you'd have said something about actual out of memory errors.

But here's the thing.

Once storage pressure gets "high enough" the system will start 
forgetting things intermittently to make room for other things. One of 
the things it will "forget" is pages of code from running programs. The 
other thing it can "forget" is dirent (directory entries) relevant to 
ongoing activity.

The real killer can involve "swappiness" (e.g. /proc/sys/vm/swapiness :: 
the tendency of the system to drop pages of program code, do not adjust 
this till you understand it fully) and overall page fault rates on the 
system. You'll start geting evictions long before you start using _any_ 
swap file space.

So if your effective throughput is low, the first thing to really look 
at is if your page fault rates are rising.  Variations of sar, ps, and 
top may be able to tell you about the current system and/or per-process 
page fault rates. You'll have to compare your distro's tool set to the 
procedures you can find online.

It's a little pernicious because it's a silent performance drain. There 
are no system messages to tell you "uh, hey dude, I'm doing a lot of 
reclaims lately and even going back to disk for pages of this program 
you really like". You just have to know how to look in that area.

>
> However, your first suggestion caused me to slap myself:
>
>> Have you tried increasing the number of stripe buffers for the
>> filesystem?
>
> This I had totally forgotten.  When I bump up the stripe cache size, it
> *seems* (so far, at least) to eliminate the slowest performance I'm seeing -
> specifically, the periods I've been seeing where no I/O at all seems to
> happen, plus the long runs of 1-3MB/s.  The copy is now staying pretty much in
> the 22-27MB/s range.
>
> That's not as fast as the hardware is capable of - as I say, with other
> filesystems on the same hardware, I can easily see 100+MB/s - but it's much
> better than it was.
>
> Is this remaining difference (25 vs 100+ MB/s) simply due to btrfs not being
> tuned for performance yet, or is there something else I'm probably
> overlooking?


I find BTRFS can be a little slow on my laptop, but I blame memory 
pressure evicting important structures somewhat system wide. Which is 
part of why I did the moveablecore= parametric tuning. I don't think 
there is anything that will pack the locality of the various trees, so 
you can end up needing bits of things from all over your disk in order 
to sequentially resolve a large directory and compute the running 
checksums for rsync (etc.).

Simple rule of thumb, if "wait for I/O time" has started to rise you've 
got some odd memory pressure that's sending you to idle land. It's not 
hard-and-fast as a rule, but since you've said that your CPU load (wich 
I'm taking to be the  user+system time) is staying low you are likely 
waiting for something.


