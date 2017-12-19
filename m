Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:43699 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750918AbdLSR4f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 12:56:35 -0500
Date: Tue, 19 Dec 2017 18:56:33 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unexpected raid1 behaviour
Message-ID: <20171219175633.GA19477@polanet.pl>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 11:35:02 -0500, Austin S. Hemmelgarn wrote:

>> 2. printed on screen when creating/converting "RAID1" profile (by btrfs tools),
> I don't agree on this one.  It is in no way unreasonable to expect that 
> someone has read the documentation _before_ trying to use something.

Provided there are:
- a decent documentation AND
- appropriate[*] level of "common knowledge" AND
- stable behaviour and mature code (kernel, tools etc.)

BTRFS lacks all of these - there are major functional changes in current
kernels and it reaches far beyond LTS. All the knowledge YOU have here,
on this maillist, should be 'engraved' into btrfs-progs, as there are
people still using kernels with serious malfunctions. btrfs-progs could
easily check kernel version and print appropriate warning - consider
this a "software quirks".

[*] by 'appropriate' I mean knowledge so common, as the real word usage
itself.

Moreover, the fact that I've read the documentation and did a
comprehensive[**] reseach today, doesn't mean I should do this again
after kernel change for example.

[**] apparently what I thought was comprehensive, wasn't at all. Most of
the btrfs quirks I've found HERE. As a regular user, not fs developer, I
shouldn't be even looking at this list.

BTW, doesn't SuSE use btrfs by default? Would you expect everyone using
this distro to research every component used?

>> [*] yes, I know the recent kernels handle this, but the last LTS (4.14)
>> is just too young.
> 4.14 should have gotten that patch last I checked.

I meant too young to be widely adopted yet. This requires some
countermeasures in the toolkit that is easier to upgrade, like userspace.

> Regarding handling of degraded mounts, BTRFS _is_ working just fine, we 
> just chose a different default behavior from MD and LVM (we make certain 
> the user knows about the issue without having to look through syslog).

I'm not arguing about the behaviour - apparently there were some
technical reasons. But IF the reasons are not technical, but
philosophical, I'd like to have either mount option (allow_degraded) or
even kernel-level configuration knob for this to happen RAID-style.

Now, if the current kernels won't toggle degraded RAID1 as ro, can I
safely add "degraded" to the mount options? My primary concern is the
machine UPTIME. I care less about the data, as they are backed up to
some remote location and loosing day or week of changes is acceptable,
brain-split as well, while every hour of downtime costs me a real money.


Meanwhile I can't fix broken server using 'remote hands' - mounting degraded
volume means using physical keyboard or KVM which might be not available
at a site. Current btrfs behavious requires physical presence AND downtime
(if a machine rebooted) for fixing things, that could be fixed remotely
an on-line.

Anyway, users shouldn't look through syslog, device status should be
reported by some monitoring tool.

Deviation so big (respectively to common RAID1 scenarios) deserves being documented.
Or renamed...

> reliability, and all the discussion of reliability assumes that either:
> 1. Disks fail catastrophically.
> or:
> 2. Disks return read or write errors when there is a problem.
> 
> Following just those constraints, RAID is not designed to handle devices 
> that randomly drop off the bus and reappear

If it drops, there would be I/O errors eventually. Without the errors - agreed.

> implementations.  As people are quick to point out BTRFS _IS NOT_ RAID, 
> the devs just made a poor choice in the original naming of the 2-way 
> replication implementation, and it stuck.

Well, the question is: either it is not raid YET, or maybe it's time to consider renaming?

>> 3. if sysadmin doesn't request any kind of device autobinding, the
>> device that were already failed doesn't matter anymore - regardless of
>> it's current state or reappearences.
> You have to explicitly disable automatic binding of drivers to 
> hot-plugged devices though, so that's rather irrelevant.  Yes, you can 

Ha! I got this disabled on every bus (although for different reasons)
after boot completes. Lucky me:)

>> 1. "known" only to the people that already stepped into it, meaning too
>>     late - it should be "COMMONLY known", i.e. documented,
> And also known to people who have done proper research.

All the OpenSUSE userbase? ;)

>> 2. "older kernels" are not so old, the newest mature LTS (4.9) is still
>>     affected,
> I really don't see this as a valid excuse.  It's pretty well documented 
> that you absolutely should be running the most recent kernel if you're 
> using BTRFS.

Good point.

>> 4. As already said before, using r/w degraded RAID1 is FULLY ACCEPTABLE,
>>     as long as you accept "no more redundancy"...
> This is a matter of opinion.

Sure! And the particular opinion depends on system being affected. I'd
rather not have any brain-split scenario under my database servers, but
also won't mind data loss on BGP router as long as it keeps running and
is fully operational.

> I still contend that running half a two 
> device array for an extended period of time without reshaping it to be a 
> single device is a bad idea for cases other than BTRFS.  The fewer 
> layers of code you're going through, the safer you are.

I create single-device degraded MD RAID1 when I attach one disk for
deployment (usually test machines), which are going to be converted into
dual (production) in a future - attaching second disk to array is much
easier and faster than messing with device nodes (or labels or
anything). The same applies to LVM, it's better to have it even when not
used at a moment. In case of btrfs there is no need for such
preparations, as the devices are added without renaming.

However, sometimes the systems end up without second disk attached.
Either due to their low importance, sometimes power usage, others
need to be quiet.


One might ask, why don't I attach second disk before initial system
creation - the answer is simple: I usually use the same drive models in
RAID1, but it happens that drives bought from the same production lot
fail simultaneously, so this approach mitigates the problem and gives
more time to react.

> Patches would be gratefully accepted.  It's really not hard to update 
> the documentation, it's just that nobody has had the time to do it.

Writing accurate documentation requires deep undestanding of internals.
Me - for example, I know some of the results: "don't do this", "if X happens, Y
should be done", "Z doesn't work yet, but there were some patches", "V
was fixed in some recent kernel, but no idea which commit was it
exactly", "W was severly broken in kernel I.J.K" etc. Not the hard data
that could be posted without creating the impression, that it's all
about creating complain-list. Not to mention I'm absolutely not familiar
with current patches, WIP and many many other corner cases or usage
scenarios. In a fact, not only the internals, but motivation and design
principles must be well understood to write piece of documentation.

Otherwise some "fake news" propaganda is being created, just like
https://suckless.org/sucks/systemd or other systemd-haters that haven't
spent a day in their life for writing SysV init scripts or managing a
bunch of mission critical machines with handcrafted supervisors.

-- 
Tomasz Pala <gotar@pld-linux.org>
