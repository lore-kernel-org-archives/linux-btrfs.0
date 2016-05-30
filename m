Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43855 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161635AbcE3Tzi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 15:55:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b7THj-0000XI-Ot
	for linux-btrfs@vger.kernel.org; Mon, 30 May 2016 21:55:35 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 21:55:35 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 May 2016 21:55:35 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
Date: Mon, 30 May 2016 19:55:17 +0000 (UTC)
Message-ID: <pan$ec157$35290f6a$2662f654$78485165@cox.net>
References: <572D0C8B.8010404@mendix.com> <574C1EEE.2030507@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg posted on Mon, 30 May 2016 13:07:26 +0200 as
excerpted:

[Please don't post "upside down".  Reply in context under the quoted 
point, here the whole post, you're replying to.  It makes further replies 
in context far easier. =:^)  I've pasted your update at the bottom here.]

> On 05/06/2016 11:28 PM, Hans van Kranenburg wrote:
>>
>> I've got a mostly inactive btrfs filesystem inside a virtual machine
>> somewhere that shows interesting behaviour: while no interesting disk
>> activity is going on, btrfs keeps allocating new chunks, a GiB at a
>> time.
>>
>> A picture, telling more than 1000 words:
>> https://syrinx.knorrie.org/~knorrie/btrfs/keep/btrfs_usage_ichiban.png
>> (when the amount of allocated/unused goes down, I did a btrfs balance)

Agreed, that shows something strange going on.

>> Linux ichiban 4.5.0-0.bpo.1-amd64 #1 SMP Debian 4.5.1-1~bpo8+1
>> (2016-04-20) x86_64 GNU/Linux

So the kernel is/was current...

>> # btrfs fi show /
>> Label: none  uuid: 9881fc30-8f69-4069-a8c8-c057b842b0c4
>>      Total devices 1 FS bytes used 6.17GiB
>>      devid    1 size 20.00GiB used 16.54GiB path /dev/xvda
>>
>> # btrfs fi df /
>> Data, single: total=15.01GiB, used=5.16GiB
>> System, single: total=32.00MiB, used=16.00KiB
>> Metadata, single: total=1.50GiB, used=1.01GiB
>> GlobalReserve, single: total=144.00MiB, used=0.00B
>>
>> I'm a bit puzzled, since I haven't seen this happening on other
>> filesystems that use 4.4 or 4.5 kernels.

Nor have I, either reported (save for you) or personally.

>> If I dump the allocated chunks and their % usage, it's clear that the
>> last 6 new added ones have a usage of only a few percent.

Snip the dump, but curious as a user (not a dev) what command you used.  
Presumably one of the debug commands which I'm not particularly familiar 
with, but I wasn't aware it was even possible.

>> The only things this host does is
>>   1) being a webserver for a small internal debian packages repository
>>   2) running low-volume mailman with a few lists, no archive-gzipping
>> mega cronjobs or anything enabled.
>>   3) some little legacy php thingies
>>
>> Interesting fact is that most of the 1GiB increases happen at the same
>> time as cron.daily runs. However, there's only a few standard things in
>> there. An occasional package upgrade by unattended-upgrade, or some
>> logrotate. The total contents of /var/log/ together is only 66MB...
>> Graphs show only less than about 100 MB reads/writes in total around
>> this time.

The cron.daily timing is interesting.  I'll come back to that below.

>> As you can see in the graph the amount of used space is even
>> decreasing, because I cleaned up a bunch of old packages in the
>> repository, and still, btrfs keeps allocating new data chunks like a
>> hungry beast.
>>
>> Why would this happen?

> since it got any followup and since I'm bold enough to bump it one more
> time... :)
> 
> I really don't understand the behaviour I described. Does it ring a bell
> with anyone? This system is still allocating new 1GB data chunks every 1
> or 2 days without using them at all, and I have to use balance every
> week to get them away again.

Honestly I can only guess, and it's a new guess I didn't think of the 
first time around, thus my lack of response the first time around.  But 
lacking anyone else replying with better theories, given that I do have a 
guess, I might as well put it out there.

Is it possible something in that daily cron allocates/writes a large but 
likely spare file, perhaps a gig or more, probably fsyncing to lock the 
large size in place, then truncates it to actual size, which might be 
only a few kilobytes?

That's sort of behavior could at least in theory trigger the behavior you 
describe, tho not being a dev and not being a Linux filesystem behavior 
expert by any means, I'm admittedly fuzzy on exactly what details might 
translate that theory into the reality you're seeing.


In any event, my usual "brute force" approach to such mysteries is to 
bisect the problem space down until I know where the issue is.

First, try rescheduling your cron.daily run to a different time, and see 
if the behavior follows it, thus specifically tying it to something in 
that run.

Second, try either running all tasks it runs manually, checking which one 
triggers the problem, or if you have too many tasks for that to be 
convenient, split them into cron.daily1 and cron.daily2, scheduled at 
different times, bisecting the problem by seeing which one the behavior 
follows.

Repeat as needed until you've discovered the culprit, then examine 
exactly what it's doing to the filesystem.

And please report your results.  Besides satisfying my own personal 
curiosity, there's a fair chance someone else will have the same issue at 
some point and either post their own question, or discover this thread 
via google or whatever.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

