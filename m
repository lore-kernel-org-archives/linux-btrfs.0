Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:59338 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422916AbcE3VS0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 17:18:26 -0400
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <572D0C8B.8010404@mendix.com> <574C1EEE.2030507@mendix.com>
 <pan$ec157$35290f6a$2662f654$78485165@cox.net>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <574CAE1C.6060604@mendix.com>
Date: Mon, 30 May 2016 23:18:20 +0200
MIME-Version: 1.0
In-Reply-To: <pan$ec157$35290f6a$2662f654$78485165@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/30/2016 09:55 PM, Duncan wrote:
> Hans van Kranenburg posted on Mon, 30 May 2016 13:07:26 +0200 as
> excerpted:
>
> [Please don't post "upside down".  Reply in context under the quoted
> point, here the whole post, you're replying to.  It makes further replies
> in context far easier. =:^)  I've pasted your update at the bottom here.]

Sure, thanks.

>> On 05/06/2016 11:28 PM, Hans van Kranenburg wrote:
>>>
>>> I've got a mostly inactive btrfs filesystem inside a virtual machine
>>> somewhere that shows interesting behaviour: while no interesting disk
>>> activity is going on, btrfs keeps allocating new chunks, a GiB at a
>>> time.
>>>
>>> A picture, telling more than 1000 words:
>>> https://syrinx.knorrie.org/~knorrie/btrfs/keep/btrfs_usage_ichiban.png
>>> (when the amount of allocated/unused goes down, I did a btrfs balance)
>
> Agreed, that shows something strange going on.
>
>>> Linux ichiban 4.5.0-0.bpo.1-amd64 #1 SMP Debian 4.5.1-1~bpo8+1
>>> (2016-04-20) x86_64 GNU/Linux
>
> So the kernel is/was current...

Running a slightly newer one now:

Linux ichiban 4.5.0-0.bpo.2-amd64 #1 SMP Debian 4.5.4-1~bpo8+1 
(2016-05-13) x86_64

>>> # btrfs fi show /
>>> Label: none  uuid: 9881fc30-8f69-4069-a8c8-c057b842b0c4
>>>       Total devices 1 FS bytes used 6.17GiB
>>>       devid    1 size 20.00GiB used 16.54GiB path /dev/xvda
>>>
>>> # btrfs fi df /
>>> Data, single: total=15.01GiB, used=5.16GiB
>>> System, single: total=32.00MiB, used=16.00KiB
>>> Metadata, single: total=1.50GiB, used=1.01GiB
>>> GlobalReserve, single: total=144.00MiB, used=0.00B
>>>
>>> I'm a bit puzzled, since I haven't seen this happening on other
>>> filesystems that use 4.4 or 4.5 kernels.
>
> Nor have I, either reported (save for you) or personally.
>
>>> If I dump the allocated chunks and their % usage, it's clear that the
>>> last 6 new added ones have a usage of only a few percent.
>
> Snip the dump, but curious as a user (not a dev) what command you used.
> Presumably one of the debug commands which I'm not particularly familiar
> with, but I wasn't aware it was even possible.

It's the output of a little programming exercise calling the search 
ioctl from python. https://github.com/knorrie/btrfs-heatmap

While using balance I got interested in knowing where balance got the 
information from to find how much % a chunk is used. I want to see that 
list in advance, so I can see what -dusage the most effective would be. 
My munin graphs show the stacked total value, which does not give you an 
idea about how badly the unused space is fragmented over already 
allocated chunks.

So, with some help of Hugo on IRC to get started, I ended up with this 
PoC, which can create nice movies of your data moving around over the 
physical space of the filesystem over time, like this one:

https://syrinx.knorrie.org/~knorrie/btrfs/heatmap.gif

Seeing the chunk allocator work its way around the two devices, choosing 
the one with the most free space, and reusing the gaps left by balance 
is super interesting. :-]

>>> The only things this host does is
>>>    1) being a webserver for a small internal debian packages repository
>>>    2) running low-volume mailman with a few lists, no archive-gzipping
>>> mega cronjobs or anything enabled.
>>>    3) some little legacy php thingies
>>>
>>> Interesting fact is that most of the 1GiB increases happen at the same
>>> time as cron.daily runs. However, there's only a few standard things in
>>> there. An occasional package upgrade by unattended-upgrade, or some
>>> logrotate. The total contents of /var/log/ together is only 66MB...
>>> Graphs show only less than about 100 MB reads/writes in total around
>>> this time.
>
> The cron.daily timing is interesting.  I'll come back to that below.

Well, it obviously has a very large sign saying "LOOK HERE" directly 
next to it yes.

>>> As you can see in the graph the amount of used space is even
>>> decreasing, because I cleaned up a bunch of old packages in the
>>> repository, and still, btrfs keeps allocating new data chunks like a
>>> hungry beast.
>>>
>>> Why would this happen?
>
>> since it got any followup and since I'm bold enough to bump it one more
>> time... :)
>>
>> I really don't understand the behaviour I described. Does it ring a bell
>> with anyone? This system is still allocating new 1GB data chunks every 1
>> or 2 days without using them at all, and I have to use balance every
>> week to get them away again.
>
> Honestly I can only guess, and it's a new guess I didn't think of the
> first time around, thus my lack of response the first time around.  But
> lacking anyone else replying with better theories, given that I do have a
> guess, I might as well put it out there.
>
> Is it possible something in that daily cron allocates/writes a large but
> likely spare file, perhaps a gig or more, probably fsyncing to lock the
> large size in place, then truncates it to actual size, which might be
> only a few kilobytes?
>
> That's sort of behavior could at least in theory trigger the behavior you
> describe, tho not being a dev and not being a Linux filesystem behavior
> expert by any means, I'm admittedly fuzzy on exactly what details might
> translate that theory into the reality you're seeing.

Interesting thought.

> In any event, my usual "brute force" approach to such mysteries is to
> bisect the problem space down until I know where the issue is.
>
> First, try rescheduling your cron.daily run to a different time, and see
> if the behavior follows it, thus specifically tying it to something in
> that run.

Yes.

> Second, try either running all tasks it runs manually, checking which one
> triggers the problem, or if you have too many tasks for that to be
> convenient, split them into cron.daily1 and cron.daily2, scheduled at
> different times, bisecting the problem by seeing which one the behavior
> follows.

The list is super super standard:

/etc/cron.daily 0-$ ll
total 52
-rwxr-xr-x 1 root root   744 Jan 25 19:24 000-delay
-rwxr-xr-x 1 root root   625 Nov 28  2015 apache2
-rwxr-xr-x 1 root root 15000 Jun 10  2015 apt
-rwxr-xr-x 1 root root   355 Oct 17  2014 bsdmainutils
-rwxr-xr-x 1 root root  1597 Apr 10  2015 dpkg
-rwxr-xr-x 1 root root   589 Oct 14  2015 etckeeper
-rwxr-xr-x 1 root root    89 Nov  8  2014 logrotate
-rwxr-xr-x 1 root root  1293 Dec 31  2014 man-db
-rwxr-xr-x 1 root root  1110 Oct 28  2015 ntp
-rwxr-xr-x 1 root root   249 Nov 20  2014 passwd

> Repeat as needed until you've discovered the culprit, then examine
> exactly what it's doing to the filesystem.

I'll try a few things.

> And please report your results.  Besides satisfying my own personal
> curiosity, there's a fair chance someone else will have the same issue at
> some point and either post their own question, or discover this thread
> via google or whatever.

We'll see. To be continued. Thanks for the feedback already!

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
