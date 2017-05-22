Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50626 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1757863AbdEVJTv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 05:19:51 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dCjV8-0007gv-Ti
        for linux-btrfs@vger.kernel.org; Mon, 22 May 2017 11:19:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy
 memory stalls
Date: Mon, 22 May 2017 09:19:34 +0000 (UTC)
Message-ID: <pan$df61e$e305754a$711742a$a2be8e5d@cox.net>
References: <20170521214733.c62v7el4g66jf63x@merlins.org>
        <20170521234557.pu3vs3igdx7mqjzb@merlins.org>
        <20170522013553.hspdrwpmxe5kyoas@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 21 May 2017 18:35:53 -0700 as excerpted:

> On Sun, May 21, 2017 at 04:45:57PM -0700, Marc MERLIN wrote:
>> On Sun, May 21, 2017 at 02:47:33PM -0700, Marc MERLIN wrote:
>> > gargamel:~# btrfs check --repair /dev/mapper/dshelf1 enabling repair
>> > mode Checking filesystem on /dev/mapper/dshelf1 UUID:
>> > 36f5079e-ca6c-4855-8639-ccb82695c18d checking extents
>> > 
>> > This causes a bunch of these:
>> > btrfs-transacti: page allocation stalls for 23508ms, order:0,
>> > mode:0x1400840(GFP_NOFS|__GFP_NOFAIL), nodemask=(null)
>> > btrfs-transacti cpuset=/ mems_allowed=0
>> > 
>> > What's the recommended way out of this and which code is at fault? I
>> > can't tell if btrfs is doing memory allocations wrong, or if it's
>> > just being undermined by the block layer dying underneath.
>> 
>> I went back to 4.8.10, and similar problem.
>> It looks like btrfs check exercises the kernel and causes everything to
>> come down to a halt :(

btrfs check is userspace, not kernelspace.  The btrfs-transacti threads 
are indeed kernelspace, but the problem would appear to be either IO or 
memory starvation triggered by the userspace check hogging all available 
resources, not leaving enough for normal system, including kernel, 
processes.

Check is /known/ to be memory intensive, with multi-TB filesystems often 
requiring tens of GiB of memory, and qgroups and snapshots are both known 
to dramatically intensify the scaling issues.  (btrfs balance, by 
contrast, has the same scaling issues, but is kernelspace.)

That's one reason why (not all of these may apply to your case) ...

* Keeping the number of snapshots as low as possible is strongly 
recommended by pretty much everyone here, definitely under 300 per 
subvolume and if possible, to double-digits per subvolume.

* I personally recommend disabling qgroups, unless you're actively 
working with the devs on improving them.  In addition to the scaling 
issues, quotas simply aren't reliable enough on btrfs yet to rely on them 
if the use-case requires them (in which case using a mature filesystem 
where they're proven to work is recommended), and if it doesn't, there's 
simply too many remaining issues for the qgroups option to be worth it.

* I personally recommend keeping overall filesystem size to something one 
can reasonably manage.  Most people's use-cases aren't going to allow for 
an fsck taking days and tens of GiB, but /will/ allow for multi-TB 
filesystems to be split out into multiple independent filesystems of 
perhaps a TB or two each, tops, if that's the alternative to multiple-day 
fscks taking tens of GiB.  (Some use-cases are of course exceptions.)

* The low-memory-mode btrfs check is being developed, tho unfortunately 
it doesn't yet do repairs.  (Another reason is that it's an alternate 
implementation that provides a very useful second opinion and the ability 
to cross-check one implementation against the other in hard problem 
cases.)

(The two "I personally recommend" points above aren't recommendations 
shared by everyone on the list, but obviously I've found them very useful 
here. =:^)

>> Sadly, I tried a scrub on the same device, and it stalled after 6TB.
>> The scrub process went zombie and the scrub never succeeded, nor could
>> it be stopped.

Quite apart from the "... after 6TB" bit setting off my own "it's too big 
to reasonably manage" alarm, the filesystem obviously is bugged, and 
scrub as well, since it shouldn't just go zombie regardless of the 
problem -- it should fail much more gracefully.

Meanwhile, FWIW, unlike check, scrub /is/ kernelspace.

> So, putting the btrfs scrub that stalled issue, I didn't quite realize
> that btrs check memory issues actually caused the kernel to eat all the
> memory until everything crashed/deadlocked/stalled.
> Is that actually working as intended?
> Why doesn't it fail and stop instead of taking my entire server down?
> Clearly there must be a rule against a kernel subsystem taking all the
> memory from everything until everything crashes/deadlocks, right?

As explained, check is userspace, but as you found, it can still 
interfere with kernelspace, including unrelated btrfs-transaction 
threads.  When the system's out of memory, it's out of memory.

Tho there is ongoing work into better predicting memory allocation needs 
for btrfs kernel threads and reserving memory space accordingly, so this 
sort of thing doesn't happen any more.

Of course it could also be some sort of (not necessarily directly btrfs) 
lockdep issue, and there's ongoing kernel-wide and btrfs work there as 
well.

> So for now, I'm doing a lowmem check, but it's not going to be very
> helpful since it cannot repair anything if it finds a problem.
> 
> At least my machine isn't crashing anymore, I suppose that's still an
> improvement.
> gargamel:~# btrfs check --mode=lowmem /dev/mapper/dshelf1 We'll see how
> many days it takes.

Agreed.  Lowmem mode looks like about your only option, beyond simply 
blowing it away, at this point.  Too bad it doesn't do repair yet, but 
with a bit of luck it should at least give you and the devs some idea 
what's wrong, information that can in turn be used to fix both scrub and 
normal check mode, as well as low-mem repair mode, once it's available.

Of course your "days" comment is triggering my "it's too big to maintain" 
reflex again, but obviously it's something you've found to be tolerable 
or possibly required in your use-case, so who am I to second-guess... 
maybe you have /files/ of multi-TB size, which of course kills the split 
the filesystem down to under that, idea. <shrug>

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

