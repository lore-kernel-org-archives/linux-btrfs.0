Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37270 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaEBIXf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 04:23:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wg8ko-0001NV-1B
	for linux-btrfs@vger.kernel.org; Fri, 02 May 2014 10:23:34 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 May 2014 10:23:34 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 May 2014 10:23:34 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Help with space
Date: Fri, 2 May 2014 08:23:24 +0000 (UTC)
Message-ID: <pan$b29aa$ed2c5b17$e83ea42c$5e85b880@cox.net>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
	<2809235.lZD2oazSeA@xev> <pan$e723c$9c5c686c$f2068dd4$dd71b519@cox.net>
	<201405021148.07577.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Fri, 02 May 2014 11:48:07 +1000 as excerpted:

> On Thu, 1 May 2014, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> Am I missing something or is it impossible to do a disk replace on BTRFS
> right now?
> 
> I can delete a device, I can add a device, but I'd like to replace a
> device.

You're missing something... but it's easy to do as I almost missed it too 
even tho I was sure it was there.

Something tells me btrfs replace (not device replace, simply replace) 
should be moved to btrfs device replace...

> http://www.eecs.berkeley.edu/Pubs/TechRpts/1987/CSD-87-391.pdf‎
> 
> Whether a true RAID-1 means just 2 copies or N copies is a matter of
> opinion. Papers such as the above seem to clearly imply that RAID-1 is
> strictly 2 copies of data.

Thanks for that link. =:^)

My position would be that reflects the original, but not the modern, 
definition.  The paper seems to describe as raid1 what would later come 
to be called raid1+0, which quickly morphed into raid10, leaving the 
raid1 description only covering pure mirror-raid.

And even then, the paper says mirrors in spots without specifically 
defining it as (only) two mirrors, but in others it seems to /assume/, 
without further explanation, just two mirrors.  So I'd argue that even 
then the definition of raid1 allowed more than two mirrors, but that it 
just so happened that the examples and formulae given dealt with only two 
mirrors.

Tho certainly I can see the room for differing opinions on the matter as 
well.

> I don't have a strong opinion on how many copies of data can be involved
> in a RAID-1, but I think that there's no good case to claim that only 2
> copies means that something isn't "true RAID-1".

Well, I'd say two copies if it's only two devices in the raid1... would 
be true raid1.  But if it's say four devices in the raid1, as is 
certainly possible with btrfs raid1, that if it's not mirrored 4-way 
across all devices, it's not true raid1, but rather some sort of hybrid 
raid,  raid10 (or raid01) if the devices are so arranged, raid1+linear if 
arranged that way, or some form that doesn't nicely fall into a well 
defined raid level categorization.

But still, opinions can differ.  Point well made... and taken. =:^)

>> Surprisingly, after shutting everything down, getting a new AC, and
>> letting the system cool for a few hours, it pretty much all came back
>> to life, including the CPU(s) (that was pre-multi-core, but I don't
>> remember whether it was my dual socket original Opteron, or
>> pre-dual-socket for me as well) which I had feared would be dead.
> 
> CPUs have had thermal shutdown for a long time.  When a CPU lacks such
> controls (as some buggy Opteron chips did a few years ago) it makes the
> IT news.

That was certainly some years ago, and I remember for awhile, AMD Athlons 
didn't have thermal shutdown yet, while Intel CPUs of the time did.  And 
that was an AMD CPU as I've run mostly AMD (with only specific 
exceptions) for literally decades, now.  But what IDR for sure is whether 
it was my original AMD Athlon (500 MHz), or the Athlon C @ 1.2 GHz, or 
the dual Opteron 242s I ran for several years.  If it was the original 
Athlon, it wouldn't have had thermal shutdown.  If it was the Opterons I 
think they did, but I think the Athlon Cs were in the period when Intel 
had introduced thermal shutdown but AMD hadn't, and Tom's Hardware among 
others had dramatic videos of just exactly what happened if one actually 
tried to run the things without cooling, compared to running an Intel of 
the period.

But I remember being rather surprised that the CPU(s) was/were unharmed, 
which means it very well could have been the Athlon C era, and I had seen 
the dramatic videos and knew my CPU wasn't protected.

> I'd like to be able to run a combination of "dup" and RAID-1 for
> metadata. ZFS has a "copies" option, it would be good if we could do
> that.

Well, if N-way-mirroring were possible, one could do more or less just 
that easily enough with suitable partitioning and setting the data vs 
metadata number of mirrors as appropriate... but of course with only two-
way-mirroring and dup as choices... the only way to do it would be 
layering btrfs atop something else, say md/raid.  And without real-time 
checksumming verification at the md/raid level...

> I use BTRFS for all my backups too.  I think that the chance of data
> patterns triggering filesystem bugs that break backups as well as
> primary storage is vanishingly small.  The chance of such bugs being
> latent for long enough that I can't easily recreate the data isn't worth
> worrying about.

The fact that my primary filesystems and their first backups are btrfs 
raid1 on dual SSDs, while secondary backups are on spinning rust, does 
factor into my calculations here.

I ran reiserfs for many years, since I first switched to Linux full time 
in the early kernel 2.4 era in fact, and while it had its problems early 
on, since the introduction of ordered data mode in IIRC 2.6.16 or some 
such, reiserfs has proven its reliability thru all sorts of hardware 
issues including faulty memory, bad power, and that overheated disk, 
here, and thru the infamous ext3 write-back-journal-by-default period as 
well.  Of course I attribute a good part of that reliability to the fact 
that kernel hackers that think they know enough about ext* to mess with 
it are afraid to touch reiserfs, leaving that to the experts, and of 
course that (and memories of its earlier writeback issues) are precisely 
why reiserfs didn't suffer the same writeback-by-default problems that 
ext3 had, when kernel hackers thought they knew ext3 well enough to try 
writeback with it.

And it's in no small part due to Chris Mason's history with reiserfs and 
the introduction of ordered journaling there, that I trust btrfs to the 
degree I trust it today.

But reiserfs, while it has proven its reliability here time and again, 
simply wasn't designed nor is it appropriate for SSDs.  So while I had 
tried btrfs on spinning rust somewhat earlier and decided it wasn't 
mature enough for my usage at that time, when I switched to SSD I needed 
to find a new filesystem as well, and in part because I do /not/ trust 
the kernel hackers to keep their hands off ext*, while at the same time 
I /do/ routinely run pre-release kernels including occasionally pre-rc1 
kernels, thereby heightening my exposure to ext* kernel hacking risks, I 
wasn't particularly enthusiastic about switching to ext4 and its ssd 
mode.  Moreover, having run reiserfs with tail-packing for years, I 
viewed the restrictions of whole-block allocations as a regression I 
didn't want to deal with.

As a result, when I switched to SSD and needed something more suited to 
ssd than reiserfs, it was little surprise that I decided on a new 
filesystem with a lead developer instrumental in making reiserfs as 
stable as it has been for me, even while keeping my spinning rust backups 
on the reiserfs that has time and again demonstrated for me surprisingly 
good stability in the face of hardware issues.

Meanwhile, I'm not so much afraid of data-pattern triggered btrfs bugs, 
at least not directly, as I am of the possibility of some new development-
version btrfs bug eating my working fs, and then when I boot to the 
backup to try to recover, eating it too, if it too is btrfs.  If that 
backup is instead my trusted reiserfs I've found so stable over the 
years, then that new btrfs bug shouldn't affect it, and while I'll 
discover my attempt to restore from reiserfs to btrfs doesn't work due to 
that btrfs bug again eating the btrfs as soon as I load it up, at least 
the reiserfs copy of the same data should still be safe, since the btrfs 
bug wouldn't affect it.

In that regard having reiserfs on the second level backups on spinning 
rust, while running btrfs on the working copy and primary level backups 
on ssd, serves as a firewall against bugs from the still under 
development btrfs eating first my working copy, then the primary backup, 
then the secondary backup and beyond, since the secondary and beyond 
backups are beyond the firewall on a totally different filesystem, which 
shouldn't be susceptible to the same bugs.

Another risk reduction I take some comfort in, is the fact that I keep my 
rootfs mounted read-only by default, only remounting it read-write for 
updates to packages or configuration.  Since the rootfs is thus likely to 
be read-only mounted at the time of a crash and will almost certainly be 
read-only mounted if I'm booting from backup in ordered to restore a 
damaged working filesystem, it's even more unlikely that a bug that might 
destroy the working copy could destroy the backup as I boot from it to 
try to restore the working copy. =:^)  Of course if the bug triggers on 
/home or the like, it could still destroy the backup /home as well, at 
least the primary btrfs backup, but in that case, chances remain quite 
good that the read-only rootfs with all the usual recovery tools, etc, 
will remain intact and usable to rescue the other filesystems.)

And yet another risk reduction is the fact that I run totally separate 
and independent partition filesystems, not subvolumes on the same 
partition with the same common base filesystem structures, which is what 
a lot of btrfs users are choosing to do.  If btrfs suffers a structure 
destroying bug, they'll lose and have to restore everything, while I'll 
lose and have to restore just one filesystem with its rather more limited 
dataset.

Meanwhile, those partitions are all dual-copy checksummed gpt based (now 
days I use gpt even on USB sticks), too, with an identical partitioning 
scheme on each of two different physical devices.  So if one partition 
table gets corrupted, the other one will kick in.  And if both partition 
tables at opposite ends of the same device get corrupted, presumably in 
some power failure accident while I was actually editing them or 
something, then there's still the other physical device I can boot from 
and use its partitioning table and gptfdisk to redo the corrupted 
partition table on the damaged device.

If all that fails and my final backup, an external spinning rust device 
not normally even attached to the computer, fails as well, say due to a 
fire or flood or something, I figure at that point I'll have rather more 
important things to worry about, like just surviving and finding a new 
home, than what happened to all those checksum-verified both logically 
and physically redundant layers of backup.  And when I do get around to 
worrying about computers again, well, the really valuable stuff's in my 
head anyway, and if *THAT* copy dies too, well, come visit me in the the 
mental ward or cemetery!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

