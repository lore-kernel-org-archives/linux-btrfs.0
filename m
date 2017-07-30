Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56560 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdG3F1A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Jul 2017 01:27:00 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dbgkZ-0000dI-Gu
        for linux-btrfs@vger.kernel.org; Sun, 30 Jul 2017 07:26:47 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: write corruption due to bio cloning on raid5/6
Date: Sun, 30 Jul 2017 05:26:41 +0000 (UTC)
Message-ID: <pan$d09f2$d737b3f9$17473592$74a95e7@cox.net>
References: <CANznX5FxavW+0_YdA4hir9_A3KrobRLyV9+CNadigDT3uNUkXw@mail.gmail.com>
        <20170726160717.GA32451@localhost.localdomain>
        <CANznX5Hx57JbwS75usDHwWBHbmiLj7dVHrfgZ5Swn=8zX=2iHw@mail.gmail.com>
        <pan$ec007$3f43fe2a$2f099431$cc969edd@cox.net>
        <CANznX5GNuSXRNq7Zo7pghi4AM=jh_C9yGLd-zdi7P88xRE5Tqw@mail.gmail.com>
        <pan$6c020$e98b46d2$7e8ca956$7078db6d@cox.net>
        <CANznX5E9nONAbOA-RQWgdL2G7wgwkP73mUDL2d5v2AB9n3inqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Janos Toth F. posted on Sun, 30 Jul 2017 03:39:10 +0200 as excerpted:

[OT but related topic continues...]

> I still get shivers if I need to resize a filesystems due to the
> memories of those early tragic experiences when I never won the lottery
> on the "trial and error" runs but lost filesystems with both hands and
> learned what wild-spread silent corruption is and how you can refresh
> your backups with corrupted copies...). Let's not take me back to those
> early days, please. I don't want to live in a cave anymore. Thank you
> modern filesystems (and their authors). :)
> 
> And on that note... Assuming I had interference problems, it was caused
> by my human mistake/negligence. I can always make similar or bigger
> human mistakes, independent of disk-level segregation. (For example, no
> amount of partitions will save any data if I accidentally wipe the
> entire drive with DD, or if I have it security-locked by the controller
> and loose the passwords, etc...)

I was glad to say goodbye to MSDOS/MBR style partitions as well, but just 
as happy to enthusiastically endorse GPT/EFI style partitions, with their 
effectively unlimited partition numbers (128 allowed at the default table 
size), no primary/logical partition stuff to worry about, partition (as 
opposed to filesystem in the partition) labels/names, integrity 
checksums, and second copy at the other end of the device. =:^)

And while all admins have their fat-finger or fat-head, aka brown-bag, 
experiences, I've never erased the wrong partition, tho I can certainly 
remember being /very/ careful the first couple times I did partitioning, 
back in the 90s on MSDOS.  Thankfully, these days even ssds are 
"reasonably" priced, and spinning rust is the trivial cost of perhaps a 
couple meals out, so as long as there's backups on other physical 
devices, getting even the device name wrong simply means losing perhaps 
your working copy instead of redoing the layout of one of your backups.

And of course you can see the existing layout on the device before you 
repartition it, and if it's not what you expected or there are any other 
problems, you just back out without doing that final writeout of the new 
partition table.

FWIW my last brown-bag was writing and running a script as root, with a 
variable-name typo that made varname empty with an rm -rf $varname/.  I 
caught and stopped it after it had emptied /bin, while it was in /etc, I 
believe.  Luckily I could boot to the (primary) backup.

But meanwhile, two experiences that set in concrete the practicality of 
separate filesystems on their own partitions, for me:

1) Back on MS, IE4-beta era.  I was running the public beta when the MSIE 
devs decided that for performance reasons they needed to write directly 
to the IE cache index on disk, bypassing the usual filesystem methods.  
What they didn't think about, however, was IE's new integration into the 
Explorer shell, meaning it was running all the time.

So along come people running the beta, running their scheduled defrag, 
which decides the index is fragmented and moves it out from under the of 
course still running Explorer shell, so the next time it direct-writes to 
what WAS the cache index, it's overwriting whatever file defrag moved to 
that spot after it moved the cache file out.

The eventual fix was to set the system attribute on the cache index, so 
the defragger wouldn't touch it.

I know a number of people running that beta that lost important files to 
that, when those files got moved into the old on-disk location of the 
cache index file and overwritten by IE when it direct-wrote to what it 
/thought/ was still the on-disk location of its index file.

But I was fine, never in any danger, because IE's "Temporary Internet 
Files" cache was on a dedicated tempfiles filesystem.  So the only files 
it overwrote for me were temporary in any case.

2) Some years ago, during a Phoenix summer, my AC went out.  I was in a 
trailer at the time, so without the AC it got hot pretty quickly, and I 
was away, with the computer left on, at the time it went out.

The high in the shade that day was about 47C/117F, and the trailer was in 
the sun, so it easily hit 55-60C/131-140F inside.  The computer was 
obviously going to be hotter than that, and the spinning disk in the 
computer hotter still, so it easily hit 70C/158F or higher.

The CPU shut down of course, and was fine when I turned it back on after 
a cooldown.

The disk... not so fine.  I'm sure it physically head-crashed and if I 
had taken it apart I'd have found grooves on the platter.

But... disks were a lot more expensive back then, and I didn't have 
another disk with backups.

What I *DID* have were backup partitions on the same disk, and because 
they weren't mounted at the time, the head didn't try seeking to them, 
and they weren't damaged (at least not beyond what could be repaired). 
When I went to assess things after everything cooled down, the damage was 
(almost) all on the mounted partitions, damaged beyond repair, but I 
continued to run that disk from what had been the backup partitions, 
until some months later when I scraped together enough money to buy more 
disks, this time enough of them to do RAID and make proper other-physical-
device backups.  (Prices were by that time starting to come down enough 
so I could by multiple at a time and I bought four 300-gig disks, my 
first SATAs, as the mobo had four SATA ports.)

Had I not had it partitioned off, the seeks across the much bigger single 
active partition would have been very likely to do far greater damage, 
and I'd have probably lost everything.

Tho I /did/ decide I had it /too/ partitioned up at that time, because I 
ended up working off of a / backup from one date, a /var backup from 
another, and a /usr backup from a third, which really complicated package 
management trying to get things back to sanity, because the package 
manager database on /var didn't match the actual package versions running 
on / and /usr.  That's why these days, with a small exception for the 
operational-writable-mount-necessary /var/lib since / is operational read-
only mounted, everything the package manager touches, including both what 
it installs and its installation database, is on /, so regardless of what 
backup I end up on, the installation database now on / matches what's 
actually installed on that /.

Meanwhile, as mentioned, these days I keep /, including /bin /etc /usr 
and (most of) /var, mounted read-only, so it's unlikely to be damaged 
unless I'm actually updating at the time of a mishap.  /boot is its own 
partition, unmounted most of the time.  /var/log is its own sub-GiB 
partition (with journald set to volatile only, syslog-ng does the logging 
to permanent storage), so it's actually writable, but a runaway log won't 
fill up anything critical.  /home is its own partition, with a /home/var/
lib with a symlink from the read-only /var/lib for the rather small 
quantity of generic system stuff that needs to be writable.  I'm a 
gentooer so I build all my updates, and the gentoo and overlay trees, 
along with sources, the local binpkg cache, ccache and the kernel tree, 
are all on /pkgs, which is only mounted when I'm updating.  That's the 
core.  Then there's a media partitions and the text and binary news 
partitions, separate from each other and from /home both so usage is 
controlled (quota-by-filesystem-size) and so they can be unmounted if I'm 
not using them, reducing the amount of potential damage should a mishap 
occur.

Then of course there's two levels of backup of everything, with each 
backup partition and filesystem the same size as the working copy, with 
one backup on the same large working pair of ssds, and the other on a 
smaller backup pair.

Because only what's necessary for normal ops and for whatever I'm doing 
at that time are mounted, and root is mounted read-only unless I'm 
updating, both the likely potential damage and total filesystem-loss 
scenarios are much more limited and thus much easier to recover from than 
if the entire working system was on the same filesystem.

I actually learned /that/ lesson the hard way, tho, when I had everything 
on massive mdraid, and it took hours to rebuild from a simple ungraceful 
shutdown (this was before write-intent bitmaps).  After redoing the 
layout to multiple mdraids, each assembled from parallel partitions on 
the respective physical devices, then spinning rust, rebuild of a single 
mdraid was under 10 minutes, where after the first one I could go back to 
work with less disruption, and rebuild of all the typically active mdraids 
was under 30 minutes.  The difference was in all the data that wasn't in 
actual use at the time, but still assembled into the active raid under 
the first setup, while under the second, the other raids weren't even 
active.

Meanwhile, thru multiple generations of layout revisions and updates, I 
now have all filesystems at pretty close to their perfect sizes, so 
filesystem size, far from being an inconvenient barrier to workaround, 
actually works as convenient size-quota enforcement. If one of the 
filesystems starts getting too full, it's time to investigate why, take 
corrective action and do some cleanup. =:^)

And if I actually decide I need more room than is free on that filesystem 
for something, worst-case, I have a set of backups on a second pair of 
ssds, that I can make sure are current, then blkdiscard the entire 
physical device for the pair of working-copy ssds, and redo the layout.  
But I'm close enough to optimal now, that I usually only need to do that 
when I'm updating devices anyway.  Or at least, I've found the last two 
existing layouts more than workable until I updated physical devices and 
needed to do a new layout for them anyway. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

