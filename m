Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47491 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaLVCNu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 21:13:50 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 7640D3EE0B6
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 11:13:48 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 7E6C4AC0421
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 11:13:47 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 31312E08005
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 11:13:47 +0900 (JST)
Message-ID: <54977E50.7000109@jp.fujitsu.com>
Date: Mon, 22 Dec 2014 11:13:36 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
References: <20141217024228.GA5544@pyropus.ca> <54955624.5040808@pobox.com> <20141221163207.GA18988@pyropus.ca> <54973C65.6070709@pobox.com>
In-Reply-To: <54973C65.6070709@pobox.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 2014/12/22 6:32, Robert White wrote:
> On 12/21/2014 08:32 AM, Charles Cazabon wrote:
>> Hi, Robert,
>>
>> Thanks for the response.  Many of the things you mentioned I have tried, but
>> for completeness:
>>
>>> Have you taken SMART (smartmotools etc) to these disks
>> There are no errors or warnings from SMART for the disks.
>
>
> Do make sure you are regularly running the long "offline" test. [offline is a bad name, what it really should be called is the long idle-interval test. sigh] about once a week. Otherwise SMART is just going to tell you the disk just died when it dies.
>
> I'm not saying this is relevant to the current circumstance. But since you didn't mention a testing schedule I figured it bared a mention
>
>>> Have you tried segregating some of your system memory for to make
>>> sure that you aren't actually having application performance issues?
>>
>> The system isn't running out of memory; as I say, about the only userspace
>> processes running are ssh, my shell, and rsync.
>
> The thing with "movablecore=" will not lead to an "out of memory" condition or not, its a question of cache and buffer evictions.
>
> I figured that you'd have said something about actual out of memory errors.
>
> But here's the thing.
>
> Once storage pressure gets "high enough" the system will start forgetting things intermittently to make room for other things. One of the things it will "forget" is pages of code from running programs. The other thing it can "forget" is dirent (directory entries) relevant to ongoing activity.
>
> The real killer can involve "swappiness" (e.g. /proc/sys/vm/swapiness :: the tendency of the system to drop pages of program code, do not adjust this till you understand it fully) and overall page fault rates on the system. You'll start geting evictions long before you start using _any_ swap file space.
>
> So if your effective throughput is low, the first thing to really look at is if your page fault rates are rising.  Variations of sar, ps, and top may be able to tell you about the current system and/or per-process page fault rates. You'll have to compare your distro's tool set to the procedures you can find online.
>
> It's a little pernicious because it's a silent performance drain. There are no system messages to tell you "uh, hey dude, I'm doing a lot of reclaims lately and even going back to disk for pages of this program you really like". You just have to know how to look in that area.
>
>>
>> However, your first suggestion caused me to slap myself:
>>
>>> Have you tried increasing the number of stripe buffers for the
>>> filesystem?
>>
>> This I had totally forgotten.  When I bump up the stripe cache size, it
>> *seems* (so far, at least) to eliminate the slowest performance I'm seeing -
>> specifically, the periods I've been seeing where no I/O at all seems to
>> happen, plus the long runs of 1-3MB/s.  The copy is now staying pretty much in
>> the 22-27MB/s range.
>>
>> That's not as fast as the hardware is capable of - as I say, with other
>> filesystems on the same hardware, I can easily see 100+MB/s - but it's much
>> better than it was.
>>
>> Is this remaining difference (25 vs 100+ MB/s) simply due to btrfs not being
>> tuned for performance yet, or is there something else I'm probably
>> overlooking?
>
>
> I find BTRFS can be a little slow on my laptop, but I blame memory pressure evicting important structures somewhat system wide. Which is part of why I did the moveablecore= parametric tuning. I don't think there is anything that will pack the locality of the various trees, so you can end up needing bits of things from all over your disk in order to sequentially resolve a large directory and compute the running checksums for rsync (etc.).
>
> Simple rule of thumb, if "wait for I/O time" has started to rise you've got some odd memory pressure that's sending you to idle land. It's not hard-and-fast as a rule, but since you've said that your CPU load (wich I'm taking to be the  user+system time) is staying low you are likely waiting for something.

Capturing "echo t >/proc/magic-sysrq" on waiting for I/O may help you.
It shows us where kernel actually be waiting for.

In addition, to confirm whether this problem is caused only by
Btrfs or not, the following way can be used.

  1. preparing the extra storage,
  2. copy Btrfs's data into int by dd if=<LVM volume> of=<extra storage>
  3. Use it and confirm whether this problem still happen or not

However, since the size of your Btrfs is quite large, I guess you
can't do it. If you have such extra storage, you've already
embed it to Btrfs.

Thanks,
Satoru

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

