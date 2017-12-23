Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:41710 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbdLWFZq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 00:25:46 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eScHd-0002ei-P8
        for linux-btrfs@vger.kernel.org; Sat, 23 Dec 2017 06:23:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unexpected raid1 behaviour
Date: Sat, 23 Dec 2017 05:23:35 +0000 (UTC)
Message-ID: <pan$67a6b$113eab75$92b6d511$8c16d2f6@cox.net>
References: <23094.37316.66397.431081@tree.ty.sabi.co.uk>
        <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
        <20171218194351.GA25245@polanet.pl>
        <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
        <20171219144644.GA9855@polanet.pl>
        <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
        <20171219175633.GA19477@polanet.pl>
        <CAJCQCtT+DjUDf3NBEQNxYm6SRhDL_FFXpz===fgub_k+AMmABg@mail.gmail.com>
        <20171219211757.GC14726@polanet.pl>
        <CAJCQCtSqw=-_6PBzaTiVhA=yoN4Fm=uwwjtqKgncK4B6R-zfJw@mail.gmail.com>
        <20171223040815.GA31330@polanet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Pala posted on Sat, 23 Dec 2017 05:08:16 +0100 as excerpted:

> On Tue, Dec 19, 2017 at 17:08:28 -0700, Chris Murphy wrote:
> 
>>>>> Now, if the current kernels won't toggle degraded RAID1 as ro, can I
>>>>> safely add "degraded" to the mount options? My primary concern is
>>>>> the
>>> [...]
>> 
>> Well it only does rw once, then the next degraded is ro - there are
>> patches dealing with this better but I don't know the state. And
>> there's no resync code that I'm aware of, absolutely it's not good
>> enough to just kick off a full scrub - that has huge performance
>> implications and I'd consider it a regression compared to functionality
>> in LVM and mdadm RAID by default with the write intent bitmap.  Without
>> some equivalent short cut, automatic degraded means a
> 
> I read about the 'scrub' all over the time here, so let me ask this
> directly, as this is also not documented clearly:
> 
> 1. is the full scrub required after ANY desync? (like: degraded mount
> followed by readding old device)?

It is very strongly recommended.

> 2. if the scrub is omitted - is it possible that btrfs return invalid
> data (from the desynced and readded drive)?

Were invalid data returned it would be a bug.  However, a reasonably 
common refrain here is that btrfs is "still stabilizing, not yet fully 
stable and mature", so occasional bugs can be expected, tho both the 
ideal and experience suggests that they're gradually reducing in 
frequency and severity as time goes on and we get closer to "fully stable 
and mature".

Which of course is why both having usable and tested backups, and keeping 
current with the kernel, are strongly recommended as well, the first in 
case one of those bugs does hit and it's severe enough to take out your 
working btrfs, the second because later kernels have fewer known bugs in 
the first place.

Functioning as designed as as intent-coded, in the case of a desync, 
btrfs will use the copy with the latest generation/transid serial, and 
thus should never return older data from the desynced device.  Further, 
btrfs is designed to be self-healing and will transparently rewrite the 
out-of-sync copy, syncing it in the process, as it comes across each 
stale block.

But the only way to be sure everything's consistent again is that scrub, 
and of course if something should happen to the only current copy while 
the desync still has the other copy stale, /then/ you lose data.

And as I said, that's functioning as designed and intent-coded, assuming 
no bugs, an explicitly unsafe assumption given btrfs' "still stabilizing" 
state.

So... "strongly recommended" indeed, tho in theory it shouldn't be 
absolutely required as long as unlucky fate doesn't strike before the 
data is transparently synced in normal usage.  YMMV, but I definitely do 
those scrubs here.

> 3. is the scrub required to be scheduled on regular basis? By 'required'
> I mean by design/implementation issues/quirks, _not_ related to possible
> hardware malfunctions.

Perhaps I'm tempting fate, but I don't do scheduled/regular scrubs here.  
Only if I have an ungraceful shutdown or see complaints in the log (which 
I tail to a system status dashboard so I'd be likely to notice a problem 
one way or the other pretty quickly).

But I do keep those backups, and while it has been quite some time (over 
a year, I'd say about 18 months to two years, and I was actually able to 
use btrfs restore and avoid having to use the backups themselves the last 
time it happened even 18 months or whatever ago) now since I had to use 
them, I /did/ actually spend some significant money upgrading my backups 
to all-SSD in ordered to make updating those backups easier and encourage 
me to keep them much more current than I had been (btrfs restore saved me 
more trouble than I'm comfortable admitting, given that I /did/ have 
backups, but they weren't the freshest at the time).

If as some people I had my backups offsite and would have to download 
them if I actually needed them, I'd potentially be rather stricter and 
schedule regular scrubs.

So by design and intention-coding, no, regularly scheduled scrubs aren't 
"required".  But I'd treat them the same as I would on non-btrfs raid, or 
a bit stricter given the above discussed btrfs stability status.  If 
you'd be uncomfortable not scheduling regular scrubs on your non-btrfs 
raid, you better be uncomfortable not scheduling them on btrfs as well!

And as always, btrfs or no btrfs, scrub or no scrub, have your backups or 
you are literally defining your data as not worth the time/trouble/
resources necessary to do them, and some day, maybe 10 minutes from now, 
maybe 10 years from now, fate's going to call you on that definition!

(Yes, I know /you/ know that or we'd not have this thread, which 
demonstrates that you /do/ care about your data.  But it's as much about 
the lurkers and googlers coming across the thread later as it is the 
direct participants...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

