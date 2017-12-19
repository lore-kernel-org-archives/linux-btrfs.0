Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35193 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752621AbdLSUL2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 15:11:28 -0500
Received: by mail-io0-f195.google.com with SMTP id 14so8401520iou.2
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 12:11:28 -0800 (PST)
Subject: Re: Unexpected raid1 behaviour
To: Tomasz Pala <gotar@polanet.pl>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
 <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
 <20171219175633.GA19477@polanet.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4b132c07-62c7-e313-d454-b7414c737602@gmail.com>
Date: Tue, 19 Dec 2017 15:11:22 -0500
MIME-Version: 1.0
In-Reply-To: <20171219175633.GA19477@polanet.pl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-19 12:56, Tomasz Pala wrote:
> On Tue, Dec 19, 2017 at 11:35:02 -0500, Austin S. Hemmelgarn wrote:
> 
>>> 2. printed on screen when creating/converting "RAID1" profile (by btrfs tools),
>> I don't agree on this one.  It is in no way unreasonable to expect that
>> someone has read the documentation _before_ trying to use something.
> 
> Provided there are:
> - a decent documentation AND
> - appropriate[*] level of "common knowledge" AND
> - stable behaviour and mature code (kernel, tools etc.)
> 
> BTRFS lacks all of these - there are major functional changes in current
> kernels and it reaches far beyond LTS. All the knowledge YOU have here,
> on this maillist, should be 'engraved' into btrfs-progs, as there are
> people still using kernels with serious malfunctions. btrfs-progs could
> easily check kernel version and print appropriate warning - consider
> this a "software quirks".
Except the systems running on those ancient kernel versions are not 
necessarily using a recent version of btrfs-progs.

It might be possible to write up a script to check the kernel version 
and report known issues with it, but I don't think having it tightly 
integrated will be much help, at least not for quite some time.
> 
> [*] by 'appropriate' I mean knowledge so common, as the real word usage
> itself.
> 
> Moreover, the fact that I've read the documentation and did a
> comprehensive[**] reseach today, doesn't mean I should do this again
> after kernel change for example.
> 
> [**] apparently what I thought was comprehensive, wasn't at all. Most of
> the btrfs quirks I've found HERE. As a regular user, not fs developer, I
> shouldn't be even looking at this list.
That last bit is debatable.  BTRFS doesn't have separate developer and 
user lists, so this list serves both purposes (though IRC also serves 
some of the function of a user list).  I'll agree that searching the 
archives shouldn't be needed to get a baseline of knowledge.
> 
> BTW, doesn't SuSE use btrfs by default? Would you expect everyone using
> this distro to research every component used?
SuSE also provides very good support by themselves.
> 
>>> [*] yes, I know the recent kernels handle this, but the last LTS (4.14)
>>> is just too young.
>> 4.14 should have gotten that patch last I checked.
> 
> I meant too young to be widely adopted yet. This requires some
> countermeasures in the toolkit that is easier to upgrade, like userspace.
So in other words, spend the time to write up code for btrfs-progs that 
will then be run by a significant minority of users because people using 
old kernels usually use old userspace, and people using new kernels 
won't have to care, instead of working on other bugs that are still 
affecting people?
> 
>> Regarding handling of degraded mounts, BTRFS _is_ working just fine, we
>> just chose a different default behavior from MD and LVM (we make certain
>> the user knows about the issue without having to look through syslog).
> 
> I'm not arguing about the behaviour - apparently there were some
> technical reasons. But IF the reasons are not technical, but
> philosophical, I'd like to have either mount option (allow_degraded) or
> even kernel-level configuration knob for this to happen RAID-style.
> 
> Now, if the current kernels won't toggle degraded RAID1 as ro, can I
> safely add "degraded" to the mount options? My primary concern is the
> machine UPTIME. I care less about the data, as they are backed up to
> some remote location and loosing day or week of changes is acceptable,
> brain-split as well, while every hour of downtime costs me a real money.
In which case you shouldn't be relying on _ANY_ kind of RAID by itself, 
let alone BTRFS.  If you care that much about uptime, you should be 
investing in a HA setup and going from there.  If downtime costs you 
money, you need to be accounting for kernel updates and similar things, 
and therefore should have things set up such that you can reboot a 
system with no issues.
> 
> 
> Meanwhile I can't fix broken server using 'remote hands' - mounting degraded
> volume means using physical keyboard or KVM which might be not available
> at a site. Current btrfs behavious requires physical presence AND downtime
> (if a machine rebooted) for fixing things, that could be fixed remotely
> an on-line.
Assuming you have a sensibly designed system and are able to do remote 
management, physical presence should only be required for handling of an 
issue with the root filesystem, and downtime should only be needed long 
enough for other filesystem to get them into a sensible enough state 
that you can repair them the rest of the way online.  There's not really 
anything you can do about the root filesystem, but sensible organization 
of application data can mitigate the issues for other filesystems.
> 
> Anyway, users shouldn't look through syslog, device status should be
> reported by some monitoring tool.
This is a common complaint, and based on developer response, I think the 
consensus is that it's out of scope for the time being.  There have been 
some people starting work on such things, but nobody really got anywhere 
because most of the users who care enough about monitoring to be 
interested are already using some external monitoring tool that it's 
easy to hook into.

TBH, you essentially need external monitoring in most RAID situations 
anyway unless you've got some pre-built purpose specific system that 
already includes it (see FreeNAS for an example).
> 
> Deviation so big (respectively to common RAID1 scenarios) deserves being documented.
> Or renamed...
Really? Some examples of where MD and LVM provide direct monitoring 
without needing third party software please.  LVM technically has the 
ability to handle it though dmeventd, but it's decidedly non-trivial to 
monitor state with that directly, and as a result almost everyone uses 
third party software there..  MD I don't have as much background with (I 
prefer the flexibility LVM offers), but anything I've seen regarding 
that requires manual setup of some external software as well.
> 
>> reliability, and all the discussion of reliability assumes that either:
>> 1. Disks fail catastrophically.
>> or:
>> 2. Disks return read or write errors when there is a problem.
>>
>> Following just those constraints, RAID is not designed to handle devices
>> that randomly drop off the bus and reappear
> 
> If it drops, there would be I/O errors eventually. Without the errors - agreed.
Classical hardware RAID will kick the device when it drops, and then 
never re-add it, just like BTRFS functionally does.  The only difference 
is how they then treat the 'failed' disk.  Hardware RAID will stop using 
it, BTRFS will keep trying to use it.
> 
>> implementations.  As people are quick to point out BTRFS _IS NOT_ RAID,
>> the devs just made a poor choice in the original naming of the 2-way
>> replication implementation, and it stuck.
> 
> Well, the question is: either it is not raid YET, or maybe it's time to consider renaming?
Again, the naming is too ingrained.  At a minimum, you will have to keep 
the old naming, and at that point you're just wasting time and making 
things _more_ confusing because some documentation will use the old 
naming and some will use the new (keep in mind that third-party 
documentation rarely gets updated).
> 
>>> 3. if sysadmin doesn't request any kind of device autobinding, the
>>> device that were already failed doesn't matter anymore - regardless of
>>> it's current state or reappearences.
>> You have to explicitly disable automatic binding of drivers to
>> hot-plugged devices though, so that's rather irrelevant.  Yes, you can
> 
> Ha! I got this disabled on every bus (although for different reasons)
> after boot completes. Lucky me:)
Security I'm guessing (my laptop behaves like that for USB devices for 
that exact reason)?  It's a viable option on systems that are tightly 
controlled.  Once you look at consumer devices though, it's just 
impractical.  People expect hardware to just work when they plug it in 
these days.
> 
>>> 1. "known" only to the people that already stepped into it, meaning too
>>>      late - it should be "COMMONLY known", i.e. documented,
>> And also known to people who have done proper research.
> 
> All the OpenSUSE userbase? ;)
I don't think you quite understand what the SuSE business model is. 
SuSE does the research, and then provides support for customers so they 
don't have to.  Red Hat has a similar model.  Most normal distros 
however, do not, and those people using them need to be doing proper 
research.
> 
>>> 2. "older kernels" are not so old, the newest mature LTS (4.9) is still
>>>      affected,
>> I really don't see this as a valid excuse.  It's pretty well documented
>> that you absolutely should be running the most recent kernel if you're
>> using BTRFS.
> 
> Good point.
> 
>>> 4. As already said before, using r/w degraded RAID1 is FULLY ACCEPTABLE,
>>>      as long as you accept "no more redundancy"...
>> This is a matter of opinion.
> 
> Sure! And the particular opinion depends on system being affected. I'd
> rather not have any brain-split scenario under my database servers, but
> also won't mind data loss on BGP router as long as it keeps running and
> is fully operational.
> 
>> I still contend that running half a two
>> device array for an extended period of time without reshaping it to be a
>> single device is a bad idea for cases other than BTRFS.  The fewer
>> layers of code you're going through, the safer you are.
> 
> I create single-device degraded MD RAID1 when I attach one disk for
> deployment (usually test machines), which are going to be converted into
> dual (production) in a future - attaching second disk to array is much
> easier and faster than messing with device nodes (or labels or
> anything). The same applies to LVM, it's better to have it even when not
> used at a moment. In case of btrfs there is no need for such
> preparations, as the devices are added without renaming.
Unless you're pulling some complex black magic, you're not running 
degraded, you're running both in single device mode (which is not the 
same as a degraded two device RAID1 array) and converting to two device 
RAID1 later, which is a perfectly normal use case I have absolutely no 
issues with.
> 
> However, sometimes the systems end up without second disk attached.
> Either due to their low importance, sometimes power usage, others
> need to be quiet.
> 
> One might ask, why don't I attach second disk before initial system
> creation - the answer is simple: I usually use the same drive models in
> RAID1, but it happens that drives bought from the same production lot
> fail simultaneously, so this approach mitigates the problem and gives
> more time to react.
You appear to be misunderstanding me here.  I'm not saying I think 
running with a single disk is bad, I'm saying that I feel that running 
with a single disk and not telling the storage stack that the other one 
isn't coming back any time soon is bad.

IOW, if I lose a disk in a two device BTRFS volume set up for 
replication, I'll mount it degraded, and convert it from the raid1 
profile to the single profile and then remove the missing disk from the 
volume.  Similarly, for a 2 device LVM RAID1 LV, I would use lvconvert 
to a regular linear LV.  Going through the multi-device code in BTRFS or 
the DM-RAID code in LVM when you've only got one actual device is a 
waste of processing power, and ads another layer where things can go wrong.
> 
>> Patches would be gratefully accepted.  It's really not hard to update
>> the documentation, it's just that nobody has had the time to do it.
> 
> Writing accurate documentation requires deep undestanding of internals.
> Me - for example, I know some of the results: "don't do this", "if X happens, Y
> should be done", "Z doesn't work yet, but there were some patches", "V
> was fixed in some recent kernel, but no idea which commit was it
> exactly", "W was severly broken in kernel I.J.K" etc. Not the hard data
> that could be posted without creating the impression, that it's all
> about creating complain-list. Not to mention I'm absolutely not familiar
> with current patches, WIP and many many other corner cases or usage
> scenarios. In a fact, not only the internals, but motivation and design
> principles must be well understood to write piece of documentation.
Writing up something like that is near useless, it would only be valid 
for upstream kernels (And if you're using upstream kernels and following 
the advice of keeping up to date, what does it matter anyway?  The 
moment a new btrfs-progs gets released, you're already going to be on a 
kernel that fixes the issues it reports.), because distros do whatever 
the hell they want with version numbers (RHEL for example is notorious 
for using _ancient_ version numbers bug having bunches of stuff 
back-ported, and most other big distros that aren't Arch, Gentoo, or 
Slackware derived do so too to a lesser degree), and it would require 
constant curation to keep up to date.  Only for long-term known issues 
does it make sense, but those absolutely should be documented in the 
regular documentation, and doing that really isn't that hard if you just 
go for current issues.
> 
> Otherwise some "fake news" propaganda is being created, just like
> https://suckless.org/sucks/systemd or other systemd-haters that haven't
> spent a day in their life for writing SysV init scripts or managing a
> bunch of mission critical machines with handcrafted supervisors.
I hate to tell you that:
1. This type of thing happens regardless.  Systemd has just garnered a 
lot of hatred because it redesigned everything from the ground up and 
was then functionally forced on most of the Linux community.
2. There are quite a few of us who dislike systemd who have had to 
handle actual systems administration before (and quite a few such 
individuals are primarily complaining about other aspects of systemd, 
like the journal crap or how it handles manually mounted filesystems for 
which mount units exist (namely, if it thinks the underlying device 
isn't ready, it will unmount them immediately, even if the user just 
manually mounted them), not the service files replacing init scripts).
