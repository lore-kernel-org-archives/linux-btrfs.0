Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:42483 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751916AbdLSQfH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 11:35:07 -0500
Received: by mail-it0-f53.google.com with SMTP id p139so3440031itb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 08:35:07 -0800 (PST)
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
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <639c6928-4f27-5c33-738a-385e5b4f299f@gmail.com>
Date: Tue, 19 Dec 2017 11:35:02 -0500
MIME-Version: 1.0
In-Reply-To: <20171219144644.GA9855@polanet.pl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-19 09:46, Tomasz Pala wrote:
> On Tue, Dec 19, 2017 at 07:25:49 -0500, Austin S. Hemmelgarn wrote:
> 
>>> Well, the RAID1+ is all about the failing hardware.
>> About catastrophically failing hardware, not intermittent failure.
> 
> It shouldn't matter - as long as disk failing once is kicked out of the
> array *if possible*. Or reattached in write-only mode as a best effort,
> meaning "will try to keep your *redundancy* copy, but won't trust it to
> be read from".
> As you see, the "failure level handled" is not by definition, but by implementation.
> 
> *if possible* == when there are other volume members having the same
> data /or/ there are spare members that could take over the failing ones.
Actually, it very much does matter, at least with hardware RAID.  The 
exact failure mode that causes issues for BTRFS (intermittent 
disconnects at the bus level) causes just as many issues with most 
hardware RAID controllers (though the exact issues are not quite the 
same), and is in and of itself an indicator that something else is wrong.
> 
>> I never said the hardware needed to not fail, just that it needed to
>> fail in a consistent manner.  BTRFS handles catastrophic failures of
>> storage devices just fine right now.  It has issues with intermittent
>> failures, but so does hardware RAID, and so do MD and LVM to a lesser
>> degree.
> 
> When planning hardware failovers/backups I can't predict the failing
> pattern. So first of all - every *known* shortcoming should be
> documented somehow. Secondly - permanent failures are not handled "just
> fine", as there is (1) no automatic mount as degraded, so the machine
> won't reboot properly and (2) the r/w degraded mount is[*] one-timer.
> Again, this should be:
> 1. documented in manpage, as a comment to profiles, not wiki page or
> linux-btrfs archives,
Agreed, our documentation needs consolidated in general (I would 
absolutely love to see it just be the man pages, and have those up on 
the wiki like some other software does).
> 2. printed on screen when creating/converting "RAID1" profile (by btrfs tools),
I don't agree on this one.  It is in no way unreasonable to expect that 
someone has read the documentation _before_ trying to use something.
> 3. blown into one's face when doing r/w degraded mount (by kernel).
Agreed here though.
> 
> [*] yes, I know the recent kernels handle this, but the last LTS (4.14)
> is just too young.
4.14 should have gotten that patch last I checked.
> 
> I'm now aware of issues with MD you're referring to - I got drives
> kicked off many times and they were *never* causing any problems despite
> being visible in the system. Moreover, since 4.10 there is FAILFAST
> which would do this even faster. There is also no problem with mounting
> degraded MD array automatically, so telling that btrfs is doing "just
> fine" is, well... not even theoretically close. And in my practice it
> never saved the day, but already ruined a few ones... It's not right for
> the protection to make more problems than it solves.
Regarding handling of degraded mounts, BTRFS _is_ working just fine, we 
just chose a different default behavior from MD and LVM (we make certain 
the user knows about the issue without having to look through syslog).
> 
>> No, classical RAID (other than RAID0) is supposed to handle catastrophic
>> failure of component devices.  That is the entirety of the original
>> design purpose, and that is the entirety of what you should be using it
>> for in production.
> 
> 1. no, it's not: https://www.cs.cmu.edu/~garth/RAIDpaper/Patterson88.pdf
OK, so I see here performance as a motivation, but listed secondarily to 
reliability, and all the discussion of reliability assumes that either:
1. Disks fail catastrophically.
or:
2. Disks return read or write errors when there is a problem.

Following just those constraints, RAID is not designed to handle devices 
that randomly drop off the bus and reappear or exhibit silent data 
corruption, so my original statement largely was accurate, the primary 
design intent was handling of catastrophic failures.
> 
> 2. even if there was, the single I/O failure (e.g. one bad block) might
>     be interpreted as "catastrophic" and the entire drive should be kicked off then.
This I will agree with, given that it's common behavior in many RAID 
implementations.  As people are quick to point out BTRFS _IS NOT_ RAID, 
the devs just made a poor choice in the original naming of the 2-way 
replication implementation, and it stuck.
> 
> 3. if sysadmin doesn't request any kind of device autobinding, the
> device that were already failed doesn't matter anymore - regardless of
> it's current state or reappearences.
You have to explicitly disable automatic binding of drivers to 
hot-plugged devices though, so that's rather irrelevant.  Yes, you can 
do so yourself if you want, and it will mitigate one of the issues with 
BTRFS to a limited degree (we still don't 'kick-out' old devices, even 
if we should).
> 
>> The point at which you are getting random corruption
>> on a disk and you're using anything but BTRFS for replication, you
>> _NEED_ to replace that disk, and if you don't you risk it causing
>> corruption on the other disk.
> 
> Not only BTRFS, there are hardware solutions like T10 PI/DIF.
> Guess what should RAID controller do in such situation? Fail
> drive immediately after the first CRC mismatch?
If it's more than single errors, yes, it should fail the drive.  If 
you're getting any kind of recurring corruption, it's time to replace 
the drive, whether the error gets corrected or not.
> 
> BTW do you consider "random corruption" as a catastrophic failure?
No, catastrophic failure in reference to hard drives is (usually) 
mechanical failure rendering the drive unusable (such as a head crash 
for example), or a complete controller failure (for example, the drive 
won't enumerate at all).

To use a (possibly strained) analogy:  Catastrophic failure is like a 
handgun blowing up when you try to fire it, you won't be able to use it 
ever again.  Random corruption is equivalent to not consistently feeding 
new rounds from the magazine properly, it still technically works, and 
can (theoretically) be fixed, but it's usually just simpler (and 
significantly safer) to replace the gun than it is to try and jury rig 
things so that it works reliably.
> 
>> As of right now, BTRFS is no different in
>> that respect, but I agree that it _should_ be able to handle such a
>> situation eventually.
> 
> The first step should be to realize, that there are some tunables
> required if you want to handle many different situation.
> 
> Having said that, let's back to reallity:
> 
> 
> The classical RAID is about keeping the system functional - trashing a
> single drive from RAID1 should be fully-ignorable by sysadmin. The
> system must reboot properly, work properly and there MUST NOT by ANY
> functional differences compared to non-degraded mode except for slower
> read rate (and having no more redundancy obviously).
'No functional differences' isn't even a standard that MD or LVM 
achieve, and it's definitely not one that most hardware RAID controllers 
have.
> 
> - not having this == not having RAID1.
Again, BTRFS _IS NOT_ RAID.
> 
>> It shouldn't have been called RAID in the first place, that we can agree
>> on (even if for different reasons).
> 
> The misnaming would be much less of a problem if it were documented
> properly (man page, btrfs-progs and finally kernel screaming).
Yes, our documentation could be significantly better.
> 
>>> - I got one "RAID1" stuck in r/o after degraded mount, not nice... Not
>>> _expected_ to happen after single disk failure (without any reappearing).
>> And that's a known bug on older kernels (not to mention that you should
>> not be mounting writable and degraded for any purpose other than fixing
>> the volume).
> 
> Yes, ...but:
> 
> 1. "known" only to the people that already stepped into it, meaning too
>     late - it should be "COMMONLY known", i.e. documented,
And also known to people who have done proper research.

> 2. "older kernels" are not so old, the newest mature LTS (4.9) is still
>     affected,
I really don't see this as a valid excuse.  It's pretty well documented 
that you absolutely should be running the most recent kernel if you're 
using BTRFS.

> 3. I was about to fix the volume, accidentally the machine has rebooted.
>     Which should do no harm if I had a RAID1.
Agreed.

> 4. As already said before, using r/w degraded RAID1 is FULLY ACCEPTABLE,
>     as long as you accept "no more redundancy"...
This is a matter of opinion.  I still contend that running half a two 
device array for an extended period of time without reshaping it to be a 
single device is a bad idea for cases other than BTRFS.  The fewer 
layers of code you're going through, the safer you are.

> 4a. ...or had an N-way mirror and there is still some redundancy if N>2.
N-way mirroring is still on the list of things to implement, believe me, 
many people want it.
> 
> 
> Since we agree, that btrfs RAID != common RAID, as there are/were
> different design principles and some features are in WIP state at best,
> the current behaviour should be better documented. That's it.
Patches would be gratefully accepted.  It's really not hard to update 
the documentation, it's just that nobody has had the time to do it.
