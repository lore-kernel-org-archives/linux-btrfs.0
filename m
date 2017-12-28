Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46827 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751964AbdL1Alv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Dec 2017 19:41:51 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eUMEa-00087V-50
        for linux-btrfs@vger.kernel.org; Thu, 28 Dec 2017 01:39:44 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs balance problems
Date: Thu, 28 Dec 2017 00:39:37 +0000 (UTC)
Message-ID: <pan$ef2b8$3487070c$fddf5d1f$59a5a7a2@cox.net>
References: <CAAMvbhEL4gw29ttxN9xbey3YFwUpmeYht2_m4rPFn9F3fn1rqQ@mail.gmail.com>
        <VI1PR08MB03368FD615EFAF0C3BB6195B92030@VI1PR08MB0336.eurprd08.prod.outlook.com>
        <CAAMvbhHV=BvRLv14U0JRrYmhiXeREOTNiVLPkuq=MO6dH4jDiQ@mail.gmail.com>
        <CAAMvbhG62rbphgWXQ_UiHHtH89wpsZXaLU0mut+4E+uuK2nbFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

James Courtier-Dutton posted on Wed, 27 Dec 2017 21:39:30 +0000 as
excerpted:

> Thank you for your suggestion.

Please put your reply in standard list quote/reply-in-context order.  It 
makes further replies, /in/ /context/, far easier.  I've moved the rest 
of your reply to do that, but I shouldn't have to...

>> On 23 December 2017 at 11:56, Alberto Bursi <alberto.bursi@outlook.it>
>> wrote:
>>>
>>> On 12/23/2017 12:19 PM, James Courtier-Dutton wrote:
>>>>
>>>> During a btrfs balance, the process hogs all CPU.
>>>> Or, to be exact, any other program that wishes to use the SSD during
>>>> a btrfs balance is blocked for long periods. Long periods being more
>>>> than 5 seconds.

Blocking disk access isn't hogging the CPU, it's hogging the disk IO.

Tho FWIW we don't have many complaints about btrfs hogging /ssd/ 
access[1], tho we do have some complaining about problems on legacy 
spinning-rust.

>>>> Is there any way to multiplex SSD access while btrfs balance is
>>>> operating, so that other applications can still access the SSD with
>>>> relatively low latency?
>>>>
>>>> My guess is that btrfs is doing a transaction with a large number of
>>>> SSD blocks at a time, and thus blocking other applications.
>>>>
>>>> This makes for atrocious user interactivity as well as applications
>>>> failing because they cannot access the disk in a relatively low
>>>> latent manner.
>>>> For, example, this is causing a High Definition network CCTV
>>>> application to fail.

That sort of low-latency is outside my own use-case, but I do have some 
suggestions...

>>>> What I would really like, is for some way to limit SSD bandwidths to
>>>> applications.
>>>> For example the CCTV app always gets the bandwidth it needs, and all
>>>> other applications can still access the SSD, but are rate limited.
>>>> This would fix my particular problem.
>>>> We have rate limiting for network applications, why not disk access
>>>> also?
>>>>
>>> On most I/O intensive programs in Linux you can use "ionice" tool to
>>> change the disk access priority of a process. [1]

AFAIK, ionice only works for some IO schedulers, not all.  It does work 
with the default CFQ scheduler, but I don't /believe/ it works with 
deadline, certainly not with noop, and I'd /guess/ it doesn't work with 
block-multiqueue (and thus not with bfq or kyber) at all, tho it's 
possible it does in the latest kernels, since multi-queue is targeted to 
eventually replace, at least as default, the older single-queue options.

So which scheduler are you using and are you on multi-queue or not?

Meanwhile, where ionice /does/ work, using normal nice 19 should place 
the process in low-priority batch mode, which should automatically lower 
the ionice priority (increasing nice), as well.  That's what I normally 
use for such things here, on gentoo, where I schedule my package builds 
at nice 19, tho I also do the actual builds on tmpfs, so they don't 
actually touch anything but memory for the build itself, only fetching 
the sources, storing the built binpkg, and installing it to the main 
system.

>>> This allows me to run I/O intensive background scripts in servers
>>> without the users noticing slowdowns or lagging, of course this means
>>> the process doing heavy I/O will run more slowly or get outright
>>> paused if higher-priority processes need a lot of access to the disk.
>>>
>>> It works on btrfs balance too, see (commandline example) [2].

There's a problem with that example.  See below.

>>> If you don't start the process with ionice as in [2], you can always
>>> change the priority later if you get the get the process ID. I use
>>> iotop [3], which also supports commandline arguments to integrate its
>>> output in scripts.
>>>
>>> For btrfs scrub it seems to be possible to specify the ionice options
>>> directly, while btrfs balance does not seem to have them (would be
>>> nice to add them imho). [4]
>>>
>>> For the sake of completeness, there is also "nice" tool for CPU usage
>>> priority (also used in my scripts on servers to keep the scripts from
>>> hogging the CPU for what is just a background process, and seen in [2]
>>> commandline too). [5]
>>>
>>> 1. http://man7.org/linux/man-pages/man1/ionice.1.html
>>> 2. https://unix.stackexchange.com/questions/390480/nice-and-ionice-
which-one-should-come-first
>>> 3. http://man7.org/linux/man-pages/man8/iotop.8.html
>>> 4. https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-scrub
>>> 5. http://man7.org/linux/man-pages/man1/nice.1.html

> It does not help at all.
> btrfs balance's behaviour seems to be unchanged by ionice.
> It still takes 100% while working and starves all other processes of
> disk access.

100% CPU, or 100% IO?  How are you measuring?  If iotop, 99% of time 
waiting on IO for an IO-bound process isn't bad, and doesn't mean nothing 
else can do IO first (tho 99% for that CCTV process /could/ be a problem, 
if it's normally much lower and only 99% because btrfs is taking what it 
needs).

100% of a CPU on a multicore isn't as big a deal as it used to be on a 
single-core, either, not to mention that 100% of a cpu throttled down to 
under half-speed is 50% or under at full-speed.

And if it's CPU, what state?  Mostly in wait state indicates it's waiting 
for IO, rather different than 100% system, user, or niced (plus there's 
steal and guest in the virtual context, out of my own use-case so I don't 
know so much about it).  And near 100% niced shouldn't be a problem since 
other processes will come first.  

Meanwhile, the problem mentioned above is that it's not terribly 
surprising that it doesn't help a lot, since for commands such as btrfs 
balance, defrag and scrub, the btrfs userspace mostly just sets up the 
kernel to do the real job, so throttling the userspace only won't tend to 
do what you want.

Luckily, scrub has an option to use ionice builtin, so you don't have to 
worry about it there, but balance is a different story...

> I can I get btrfs balance to work in the background, without adversely
> affecting other applications?

I'd actually suggest a different strategy.  

What I did here way back when I was still on reiserfs on spinning rust, 
where it made more difference than on ssd, but I kept the settings when I 
switched to ssd and btrfs, and at least some others have mentioned that 
similar settings helped them on btrfs as well, is...

Problem: The kernel virtual-memory subsystem's writeback cache was 
originally configured for systems with well under a Gigabyte of RAM, and 
the defaults no longer work so well on multi-GiB-RAM systems, 
particularly above 8 GiB RAM, because they are based on a percentage of 
available RAM, and will typically let several GiB of dirty writeback 
cache accumulate before kicking off any attempt to actually write it to 
storage.  On spinning rust, when writeback /does/ finally kickoff, this 
can result in hogging the IO for well over half a minute at a time, where 
30 seconds also happens to be the default "flush it anyway" time.

On ssd, the problem isn't typically as bad, but it could still be well 
over 5 seconds worth, particularly if you're running 32 GiB+ RAM as large 
servers often do.

Solution:  Adjust the kernel's dirty writeback settings, located in
/proc/sys/kernel/vm/, as appropriate.

Start with reading the kernel documentation's...

$KERNELDIR/Documentation/sysctl/vm.txt

Focus on the dirty_* files.

If you wish, google some of the files for other articles on the subject.

Then experiment a bit, first by writing the settings directly into the 
proc files.  When you get settings that work well for you, use your 
distro's sysctl configuration, typically writing the settings to 
/etc/sysctl.conf or to files in /etc/sysctl.d/, to make the settings 
permanent, so they're applied automatically at every boot.

FWIW, here's what I use in my /etc/sysctl.conf, 16 GiB desktop/
workstation system.  As I said, I originally set this up for spinning 
rust, but it doesn't hurt for ssd either.

# write-cache, foreground/background flushing
# vm.dirty_ratio = 10 (% of RAM)
# make it 3% of 16G ~ half a gig
vm.dirty_ratio = 3
# vm.dirty_bytes = 0

# vm.dirty_background_ratio = 5 (% of RAM)
# make it 1% of 16G ~ 160 M
vm.dirty_background_ratio = 1
# vm.dirty_background_bytes = 0

# vm.dirty_expire_centisecs = 2999 (30 sec)
# vm.dirty_writeback_centisecs = 499 (5 sec)
# make it 10 sec
vm.dirty_writeback_centisecs = 1000


As you can see I'm already at 1% for vm.dirty_background_ratio.  That 
works reasonably for a 16 GiB RAM system, where it's ~160 MiB.  Were I to 
have more memory, say 32+ GiB, or want to set it less to say 128 MiB or 
less, I'd need to switch to using the _bytes parameter instead of ratio, 
to go under 1% and be more precise.

Adjusting those down from their 10% foreground, 5% background defaults, 
over a gig and a half foreground at 16 GiB and over 6 gigs at 64 GiB, 
will likely help quite a bit right there... if it's IO, anyway.

(The default 30 seconds centiseconds time isn't so bad, but while I was 
there I decided a 10 seconds time was better for me, and I've not had 
problems with it, so...)


Tho there is a newer solution that in theory could potentially eliminate 
the need for the above, block-multiqueue IO and the kyber (for fast SSD) 
and bfq (for slower spinning rust and thumbdrives, etc) io-schedulers.  
They're eventually supposed to supplant the older single/serial-queue 
alternatives.  But there's a reason they're not the defaults yet, as 
they're still new, still somewhat experimental and potentially buggy, as 
well as not yet being as fully featured as the serial/single-queue 
defaults.  Of course you may wish to try them too.  Actually, I'm trying 
kyber here, and haven't seen anything major, tho when I do my mkfs.btrfs 
and fresh full backup routine, it /may/ be slightly slower, but not 
enough for me to bother actually benchmarking both ways to see for sure, 
and if it's slower because it's allowing other things in to do their 
thing too, that might actually be better.


Meanwhile, switching to btrfs specific, now...  These may or may not 
apply to your use-case.  If they do...

Be aware that certain btrfs features can be convenient, but the come at a 
cost.  In particular, both quotas and snapshotting (and dedup) seriously 
increase btrfs' scaling issues when running commands such as balance and 
check.

The running recommendation is to turn off btrfs quotas if you don't 
actually need them, as for people who don't, they're simply more trouble 
than they're worth.  (And until relatively recent kernels, btrfs quotas 
were buggy and not particularly reliable as well, tho they're better in 
that regard since 4.10 or so... unfortunately I'm not sure if the fixes 
hit 4.9-LTS or not.)

If you need quotas, then at least be aware that turning them off 
temporarily while doing balance can make a *BIG* difference in processing 
time -- for some people the difference is big enough that it turns a 
"just forget about balance, it won't complete in a practical amount of 
time anyway" job into "balance is actually practical now."  This is 
because quotas repeatedly recalculate as balance shifts the block groups 
around, and turning them off even temporarily allows balance to do its 
thing without those repeated recalculations getting in the way.

** Important missing info:  Because my own use-case doesn't need quotas 
I've never used them myself, and don't know if you need to quota rescan 
when turning them back on or not.  Perhaps someone who uses them can fill 
in that info, and I'll have it the next time.

The problem with both snapshotting and dedup is reflinks.  Reflinks 
increase the amount of work btrfs must do to maintain them when moving 
blockgroups around, thus increasing scaling issues.

While generally speaking a handful of snapshots per subvolume won't hurt, 
once it gets into the hundreds, balance takes *MUCH* longer.  Thus, try 
to keep snapshots per subvolume under 500 at all costs... if you plan on 
running balance or check, anyway[2]... and under triple-digits if 
possible.  A scheduled snapshot thinning program to match the scheduled 
snapshotting program many people (and distros) use goes a long way, 
here.  If you can do it, 50 snapshots per subvolume should be fine, with 
minimal scaling issues.

Dedup has the same reflinking issues, but is harder to quantify, because 
people using it often have many more reflinks but to far fewer files (or 
more literally, extents) than is typical of snapshots.  I'm not aware of 
any specific recommendations there, other than simply to take the issue 
into consideration when setting up your dedup.


Between my use-case not using quotas/snapshotting/subvolumes as I prefer 
multiple independent btrfs and full backups, and the above dirty-
writeback sysctl settings, plus being on relatively fast (tho still SATA, 
not the fancy direct-PCIE stuff), as I said, no complaints about btrfs 
hogging system CPU /or/ IO, here.

Tho as I also mentioned, the one thing I do regularly that /might/ tie 
things up, building package updates on gentoo, I have optimized as well, 
nice 19ed for idle/batch priority (which automatically ionices it as 
well), and doing the actual build in tmpfs, so it doesn't hit main 
storage except for caching the sources/ebuild-tree and built packages, 
and actually installing the built package.


OK, hopefully at least /some/ of that helps. The ionice suggestion wasn't 
wrong, but if you were facing some of these other issues, it's not 
entirely surprising that it didn't help, especially because by the posted 
suggestion, you were trying to ionice the userspace balance command, when 
the real trouble was the kernel threads doing the actual work.  
Unfortunately, those aren't as easy to ionice, tho in theory it could be 
done.[3]

---
[1]Few complaints about IO on SSD:  I'm on ssd too and no complaints 
about IO here, tho for my use-case I may not notice 5 second stalls.  30 
second I'd notice, but I've not seen that since I switched off spinning 
rust, or actually before, since I tuned my IO, as above.  Tho my btrfs 
use-case is rather simple, multiple smallish (mostly under 100 GiB per-
device) independent btrfs pair-device raid1, on partitioned ssds, no 
subvolumes, snapshots or quotas.  At that small size on SSDs, full 
balances/scrubs/etc normally take under a minute, so I use the no-
backgrounding option where necessary and normally wait for it to 
complete, tho I sometimes switch to doing something else for a minute or 
so in the mean time.  Tho of course if something goes really wrong, like 
an ssd failing, I'll have multiple btrfs to deal with, as I have it 
partitioned up, with multiple pair-device btrfs using a partition on it 
for one device of their pair.

[2] Balance and check reflink costs:  Some people just bite the bullet 
and don't worry about balance and check times because with their use-
cases, falling back to backup and redoing the filesystem from scratch is 
simpler/faster and more reliable than trying to balance to a different 
btrfs layout or check their way out of trouble.

[3] Ionicing btrfs balance kernel worker threads:  Simplest would be to 
have balance take parameters for it to hand the kernel btrfs to use when 
it kicks off the threads, like scrub apparently does.  Lacking that, I 
can envision some daemon watching for such threads and ionicing them as 
it finds them.  But that's way more complicated than just feeding the 
options to a btrfs balance commandline as can be done with scrub, and 
with a bit of luck, especially because you /are/ after all already 
running ssd, /may/ be unnecessary once the above suggestions are taken 
into account.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

