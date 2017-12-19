Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from jax4mhfb02.myregisteredsite.com ([64.69.218.95]:32994 "EHLO
        jax4mhfb02.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750783AbdLSSkZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 13:40:25 -0500
Received: from jax4mhob17.registeredsite.com (jax4mhob17.registeredsite.com [64.69.218.105])
        by jax4mhfb02.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id vBJJ1LsC021183
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 14:01:21 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.113])
        by jax4mhob17.registeredsite.com (8.14.4/8.14.4) with ESMTP id vBJIVgir110924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 13:31:42 -0500
Reply-To: george@chinilu.com
Subject: Re: Unexpected raid1 behaviour
To: linux-btrfs@vger.kernel.org
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
 <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl>
 <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
From: George Mitchell <george@chinilu.com>
Message-ID: <f6785d3b-89fc-fd3b-38fe-815613b335fb@chinilu.com>
Date: Tue, 19 Dec 2017 10:31:40 -0800
MIME-Version: 1.0
In-Reply-To: <20171219144644.GA9855@polanet.pl>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/2017 06:46 AM, Tomasz Pala wrote:
> On Tue, Dec 19, 2017 at 07:25:49 -0500, Austin S. Hemmelgarn wrote:
>
>>> Well, the RAID1+ is all about the failing hardware.
>> About catastrophically failing hardware, not intermittent failure.
> It shouldn't matter - as long as disk failing once is kicked out of the
> array *if possible*. Or reattached in write-only mode as a best effort,
> meaning "will try to keep your *redundancy* copy, but won't trust it to
> be read from".
> As you see, the "failure level handled" is not by definition, but by implementation.
>
> *if possible* == when there are other volume members having the same
> data /or/ there are spare members that could take over the failing ones.
>
>> I never said the hardware needed to not fail, just that it needed to
>> fail in a consistent manner.  BTRFS handles catastrophic failures of
>> storage devices just fine right now.  It has issues with intermittent
>> failures, but so does hardware RAID, and so do MD and LVM to a lesser
>> degree.
> When planning hardware failovers/backups I can't predict the failing
> pattern. So first of all - every *known* shortcoming should be
> documented somehow. Secondly - permanent failures are not handled "just
> fine", as there is (1) no automatic mount as degraded, so the machine
> won't reboot properly and (2) the r/w degraded mount is[*] one-timer.
> Again, this should be:
> 1. documented in manpage, as a comment to profiles, not wiki page or
> linux-btrfs archives,
> 2. printed on screen when creating/converting "RAID1" profile (by btrfs tools),
> 3. blown into one's face when doing r/w degraded mount (by kernel).
>
> [*] yes, I know the recent kernels handle this, but the last LTS (4.14)
> is just too young.
>
> I'm now aware of issues with MD you're referring to - I got drives
> kicked off many times and they were *never* causing any problems despite
> being visible in the system. Moreover, since 4.10 there is FAILFAST
> which would do this even faster. There is also no problem with mounting
> degraded MD array automatically, so telling that btrfs is doing "just
> fine" is, well... not even theoretically close. And in my practice it
> never saved the day, but already ruined a few ones... It's not right for
> the protection to make more problems than it solves.
>
>> No, classical RAID (other than RAID0) is supposed to handle catastrophic
>> failure of component devices.  That is the entirety of the original
>> design purpose, and that is the entirety of what you should be using it
>> for in production.
> 1. no, it's not: https://www.cs.cmu.edu/~garth/RAIDpaper/Patterson88.pdf
>
> 2. even if there was, the single I/O failure (e.g. one bad block) might
>     be interpreted as "catastrophic" and the entire drive should be kicked off then.
>
> 3. if sysadmin doesn't request any kind of device autobinding, the
> device that were already failed doesn't matter anymore - regardless of
> it's current state or reappearences.
>
>> The point at which you are getting random corruption
>> on a disk and you're using anything but BTRFS for replication, you
>> _NEED_ to replace that disk, and if you don't you risk it causing
>> corruption on the other disk.
> Not only BTRFS, there are hardware solutions like T10 PI/DIF.
> Guess what should RAID controller do in such situation? Fail
> drive immediately after the first CRC mismatch?
>
> BTW do you consider "random corruption" as a catastrophic failure?
>
>> As of right now, BTRFS is no different in
>> that respect, but I agree that it _should_ be able to handle such a
>> situation eventually.
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
>
>
> - not having this == not having RAID1.
>
>> It shouldn't have been called RAID in the first place, that we can agree
>> on (even if for different reasons).
> The misnaming would be much less of a problem if it were documented
> properly (man page, btrfs-progs and finally kernel screaming).
>
>>> - I got one "RAID1" stuck in r/o after degraded mount, not nice... Not
>>> _expected_ to happen after single disk failure (without any reappearing).
>> And that's a known bug on older kernels (not to mention that you should
>> not be mounting writable and degraded for any purpose other than fixing
>> the volume).
> Yes, ...but:
>
> 1. "known" only to the people that already stepped into it, meaning too
>     late - it should be "COMMONLY known", i.e. documented,
> 2. "older kernels" are not so old, the newest mature LTS (4.9) is still
>     affected,
> 3. I was about to fix the volume, accidentally the machine has rebooted.
>     Which should do no harm if I had a RAID1.
> 4. As already said before, using r/w degraded RAID1 is FULLY ACCEPTABLE,
>     as long as you accept "no more redundancy"...
> 4a. ...or had an N-way mirror and there is still some redundancy if N>2.
>
>
> Since we agree, that btrfs RAID != common RAID, as there are/were
> different design principles and some features are in WIP state at best,
> the current behaviour should be better documented. That's it.
>
>
I have significant experience as a user of raid1. I spent years using 
software raid1 and then more years using hardware (3ware) raid1 and now 
around 3 years using btrfs raid1. I have not found btrfs raid1 to be 
less reliable than any of the previous implementations of raid.  I have 
found that any implementation of raid whether it be software, hardware, 
or filesystem, is not infallible.  I have also found that when you have 
a failure, you don't just plug things back in and expect it to be fixed 
without seriously investigating what has gone wrong and potential 
unexpected consequences.  I have found that even with hardware raid you 
can find ways to screw things up to the point that you lose your data.  
I have had situations where I reconnected a drive on hardware raid1 only 
to find that the array would not sync and from there on I ended up 
having to directly attach one of the drives and recover the partition 
table with test disk in order to regain access to my data.  So NO FORM 
of raid is a replacement for backups and NO FORM of raid is a 
replacement for due diligence in recovery from failure mode.  Raid gives 
you a second chance when things go wrong, it does not make failures 
transparent which is seemingly what we sometimes expect from raid.  And 
I doubt that we will ever achieve that goal no matter how much effort we 
put into making it happen. Even with hardware raid things can happen 
that were not foreseen by the designers.  So I think we have to be 
careful when we compare various raid (or "raid like") implementations.  
There is no such thing as "fool proof" raid and likely never will be. 
And with that I will end my rant.



