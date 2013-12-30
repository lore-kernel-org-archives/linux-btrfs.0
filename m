Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33529 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab3L3GZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 01:25:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VxWHk-0005FZ-91
	for linux-btrfs@vger.kernel.org; Mon, 30 Dec 2013 07:25:08 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 07:25:08 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 07:25:08 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Migrate to bcache: A few questions
Date: Mon, 30 Dec 2013 06:24:43 +0000 (UTC)
Message-ID: <pan$108e2$6f522d85$92bd821$4b98bdab@cox.net>
References: <kof6pa-akd.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sun, 29 Dec 2013 22:11:16 +0100 as excerpted:

> Hello list!
> 
> I'm planning to buy a small SSD (around 60GB) and use it for bcache in
> front of my 3x 1TB HDD btrfs setup (mraid1+draid0) using write-back
> caching. Btrfs is my root device, thus the system must be able to boot
> from bcache using init ramdisk. My /boot is a separate filesystem
> outside of btrfs and will be outside of bcache. I am using Gentoo as my
> system.

Gentooer here too. =:^)

> I have a few questions:
> 
> * How stable is it? I've read about some csum errors lately...

FWIW, both bcache and btrfs are new and still developing technology.  
While I'm using btrfs here, I have tested usable (which for root means 
either means directly bootable or that you have tested booting to a 
recovery image and restoring from there, I do the former, here) backups, 
as STRONGLY recommended for btrfs in its current state, but haven't had 
to use them.

And I considered bcache previously and might otherwise be using it, but 
at least personally, I'm not willing to try BOTH of them at once, since 
neither one is mature yet and if there are problems as there very well 
might be, I'd have the additional issue of figuring out which one was the 
problem, and I'm personally not prepared to deal with that.

Instead, at this point I'd recommend choosing /either/ bcache /or/ btrfs, 
and using bcache with a more mature filesystem like ext4 or (what I used 
for years previous and still use for spinning rust) reiserfs.

And as I said, keep your backups as current as you're willing to deal 
with losing what's not backed up, and tested usable and (for root) either 
bootable or restorable from alternate boot, because while at least btrfs 
is /reasonably/ stable for /ordinary/ daily use, there remain corner-
cases and you never know when your case is going to BE a corner-case!

> * I want to migrate my current storage to bcache without replaying a
> backup.  Is it possible?

Since I've not actually used bcache, I won't try to answer some of these, 
but will answer based on what I've seen on the list where I can...  I 
don't know on this one.

> * Did others already use it? What is the perceived performance for
> desktop workloads in comparision to not using bcache?

Others are indeed already using it.  I've seen some btrfs/bcache problems 
reported on this list, but as mentioned above, when both are in use that 
means figuring out which is the problem, and at least from the btrfs side 
I've not seen a lot of resolution in that regard.  From here it /looks/ 
like that's simply being punted at this time, as there's still more 
easily traceable problems without the additional bcache variable to work 
on first.  But it's quite possible the bcache list is actively tackling 
btrfs/bache combination problems, as I'm not subscribed there.

So I can't answer the desktop performance comparison question directly, 
but given that I /am/ running btrfs on SSD, I /can/ say I'm quite happy 
with that. =:^)

Keep in mind...

We're talking storage cache here.  Given the cost of memory and common 
system configurations these days, 4-16 gig of memory on a desktop isn't 
unusual or cost prohibitive, and a common desktop working set should well 
fit.

I suspect my desktop setup, 16 gigs memory backing a 6-core AMD fx6100 
(bulldozer-1) @ 3.6 GHz, is probably a bit toward the high side even for 
a gentooer, but not inordinately so.  Based on my usage...

Typical app memory usage runs 1-2 GiB (that's with KDE 4.12.49.9999 from 
the gentoo/kde overlay, but USE=-semantic-desktop, etc).  Buffer memory 
runs a few MiB but isn't normally significant, so it can fold into that 
same 1-2 GiB too.

That leaves a full 14 GiB for cache.  But at least with /my/ usage, 
normal non-update cache memory usage tends to be below ~6 GiB too, so 
total apps/buffer/cache memory usage tends to be below 8 GiB as well.

When I'm doing multi-job builds or working with big media files, I'll 
sometimes go above 8 gig usage, and that occasional cache-spill was why I 
upgraded to 16 gig.  But in practice, 10 gig would take care of that most 
of the time, and were it not for the "accident" of powers-of-two meaning 
16 gig is the notch above 8 gig, 10 or 12 gig would be plenty.  Truth be 
told, I so seldom use that last 4 gig that it's almost embarrassing.

* Tho if I ran multi-GiB VMs that'd use up that extra memory real fast!  
But while that /is/ becoming more common, I'm not exactly sure I'd 
classify 4 gigs plus of VM usage as "desktop" usage just yet.  
Workstation, yes, and definitely server, but not really desktop.

All that as background to this...

* Cache works only after first access.  If you only access something 
occasionally, it may not be worth caching at all.

* Similarly, if access isn't time critical, think of playing a huge video 
file where only a few meg in memory at once is plenty, and where storage 
access is several times faster than play-speed, cache isn't particularly 
useful.

* Bcache is designed not to cache sequential access (that large video 
file) in any case, since spinning rust tends to be more than fast enough 
for that sort of thing already.

Given the stated 3 x 1TB drive btrfs in raid1 metadata, raid0 data, config 
you mention, I'm wondering if big media is a/the big use case for you, in 
which case bcache isn't going to be a good solution anyway, since that 
tends to be sequential access, which bcache deliberately ignores as it 
doesn't fit the model it's targeting.

(I am a bit worried about that raid0 data, tho.  Unless you consider that 
data of trivial value that's not a good choice, since raid0 generally 
means you lose it all if you lose a physical device.  And you're running 
three devices, which means you just tripled the chance of a device 
failure over that of just putting it all on a single 3 TB drive!  And 
backups... a 3 TB restore on spinning rust will take some time any way 
you look at it, so backups may or may not be particularly viable here.  
The most common use case for that much data is probably a DVR scenario,  
which is video, and you may well consider it of low enough value that if 
you lose it, you lose it, and you're willing to take that risk, but for 
normally sequential access video/media, bcache isn't a good match anyway.)

* With memory cost what it is, for repeat access where initial access 
time isn't /too/ critical, investing in more memory, to a point (for me, 
8-12 gig as explained above), and simply letting the kernel manage cache 
and memory as it normally does, may make more sense than bcache to an ssd.

* Of course, what bcache *DOES* effectively do, is extend the per-boot 
cache time of memory, making the cache persistent.  That effectively 
extends the time over which "occasional access" still justifies caching 
at all.

* That makes bcache well suited to boot-time and initial-access-speed-
critical scenarios, where more memory for a larger in-memory cache won't 
do any good, since it's first-access-since-boot, because for in-memory 
cache that's a cold-cache scenario, while with bcache's persistent cache, 
it's a hot-cache scenario.


But what I'm actually wondering is if your use case better matches a 
split data model, where you put root and perhaps stuff like the portage 
tree and/or /home on fast SSD, while keeping all that big and generally 
sequential access media on slower but much cheaper big spinning rust.

That's effectively what I've done here, tho I'm looking at rather less 
than a TB of slow-access media, etc.  See below for the details.  The 
general idea is as I said to stick all the time-critical stuff on SSD 
directly (not using something like bcache), while keeping the slower 
spinning rust for the big less-time-critical and sequential-access stuff, 
and for non-btrfs backups of the stuff on the btrfs-formatted SSD, since 
btrfs /is/ after all still in development, and I /do/ intend to be 
prepared if /my/ particular case ends up being one of the corner-cases 
btrfs still worst-cases on.

> * How well does bcache handle power outages? Btrfs does handle them very
>   well since many months.

Since I don't run bcache I can't really speak to this at all, /except/, 
the btrfs/bcache combo trouble reports that have come to the list have I 
think all been power outage or kernel-crash scenarios... as could be 
predicted of course since that's a filesystem's worst-case scenario, at 
least that it has to commonly deal with.

But I know I'd definitely not trust that case, ATM.  Like I said, I'd not 
trust the combination of the two, and this is exactly where/why.  Under 
normal operation, the two should work together well.  But in a power-loss 
situation with both technologies being still relatively new and under 
development... not *MY* data!

> * How well does it play with dracut as initrd? Is it as simple as
> telling it the new device nodes or is there something complicate to
> configure?

I can't answer this at all for bcache, but I can say I've been relatively 
happy with the dracut initramfs solution for dual-device btrfs raid1 
root. =:^)  (At least back when I first set it up several kernels ago, 
the kernel's commandline parser apparently couldn't handle the multiple 
equals of something like rootflags=device=/dev/sda5,device=/dev/sdb5.  So 
the only way to get a multi-device btrfs rootfs to work was to use an 
initr* with userspace btrfs device scan before attempting to mount real-
root, and dracut has worked well for that.)

> * How does bcache handle a failing SSD when it starts to wear out in a
> few years?

Given the newness of the bcache technology, assuming your SSD doesn't 
fail early and it is indeed a few years, I'd suggest that question is 
premature.  Bcache will by that time be much older and more mature than 
it is now, and how it'd handle, or fail to handle, such an event /now/ 
likely hasn't a whole lot to do with how much (presumably) better it'll 
handle it /then/.

> * Is it worth waiting for hot-relocation support in btrfs to natively
> use a SSD as cache?

I wouldn't wait for it.  It's on the wishlist, but according to the wiki 
(project ideas, see the dm_cache or bcache like cache, and the hybrid 
storage points), nobody has claimed that project yet, which makes it 
effectively status "bluesky", which in turn means "nice idea, we might 
get to it... someday."

Given the btrfs project history of everything seeming to take rather 
longer than the original it turned out wildly optimistic projections, in 
the absense of a good filesystem dev personally getting that specific 
itch to scratch, that means it's likely a good two years out, and may be 
5-10.  So no, I'd definitely *NOT* wait on it!

> * Would you recommend going with a bigger/smaller SSD? I'm planning to
> use only 75% of it for bcache so wear-leveling can work better, maybe
> use another part of it for hibernation (suspend to disk).

FWIW, for my split data, some on SSD, some on spinning rust, setup, I had 
originally planned perhaps a 64 gig or so SSD, figuring I could put the 
boot-time-critical rootfs and a few other initial-access-time-critical 
things on it, with a reasonable amount of room to spare for wear-
leveling.  Maybe 128 gig or so, with a bit more stuff on it.

But when I actually went looking for hardware (some months ago now, but 
rather less than a year), I found the availability and price-point knee 
at closer to 256 gig.  128 gig or so was at a similar price-point per-
gig, but tends to sell out pretty fast as it's about half the gigs and 
thus about half the price.  There were some smaller ones available, but 
they tended to be either MUCH slower or MUCH higher priced, I'd guess 
left over from a previous generation before prices came down, and they 
simply hadn't been re-priced to match current price/capacity price-points.

But much below 128 GiB (there were some 120 GB at about the same per-gig, 
which "units" says is just under 112 GiB) and the price per gig tends to 
go up, while above 256 GB (not GiB) both the price per gig and full price 
tend to go up.

In practice, 60 or 80 GB SSDs just didn't seem to be that much cheaper 
than 120-ish gig, and 120-ish gig were a good deal, but were popular 
enough that availability was a bit of an issue.

So I actually ended up with 256 GB, which works out to ~ 238 GiB.  Yeah I 
paid a bit more, but that both gave me a bit more flexibility in terms of 
what I put on them, AND meant after I set them up I STILL had about 40% 
unallocated, giving them *LOTS* of wear-leveling room.

Of course that means if you do actually do bcache, 60-ish gigs should be 
good and I'd guess 128 gig would be overkill, as I guess 40-60 gigs 
probably about what my "hot" data is, the stuff bcache would likely catch.

And 60 gig will likely be /some/ cheaper tho not as much as you might 
expect, but you'll lose flexibility too, and/or you might actually pay 
more for the 60 gig than the 120 gig, or it'll be slower speed-rated.  
That was what I found when I actually went out to buy, anyway.

As to layout (all GPT partitions, not legacy MBR):

On the SSD(s, I actually have two setup, mostly in btrfs dual-device data/
metadata raid1 partitions but with some single-device, mixed/dup):

-	(boot area)

x	1007 KiB free space (so partitions are 1 MiB aligned)

1	3 MiB BIOS reserved partition

	(grub2 puts its core image here, partitions are now 4 MiB aligned)

2	124 MiB EFI reserved partition (for EFI forward compatibility)

	(partitions are now 128 MiB aligned)

3	256 MiB /boot (btrfs mixed-block mode, DUP data/metadata)

	I have a separate boot partition on each of the SSDs, with grub2
	installed to both SSD separately, pointing at its own /boot. with
	the SSD I boot selectable in BIOS.  That gives me a working /boot
	and a primary /boot backup.  I run git kernels and normally
	update the working /boot with a new kernel once or twice a week,
	while only updating the backup /boot with the release kernel, so
	every couple months.

4	640 MiB /var/log (btrfs mixed-mode, raid1 data/metadata)

	That gives me plenty of log space as long as logrotate doesn't
	break, while still keeping a reasonable cap on the log partition
	in case I get a runaway log.  As any good sysadmin should know,
	some from experience (!!), keeping a separate log partition is a
	good idea, since that limits the damage if something /does/ go
	runaway logging.

	(partitions beyond this are now 1 GiB aligned)

5	8 GiB rootfs (btrfs raid1 data/metadata)

	My rootfs includes (almost) all "installable" data, everything
	installed by packages except for /var/lib, which is a symlink to
	/home/var/lib.  The reason for that is that I keep rootfs mounted
	read-only by default, only mounting it read-write for updates or
	configuration changes, and /var/lib needs to be writable.  /home
	is mounted writable, thus the /var/lib symlink pointing into it.

	I learned the hard way to keep everything installed (but for
	/var/lib) on the same filesystem, along with the installed-
	package database (/var/db/pkg on gentoo), when I had to deal with
	a recovery situation with rootfs, /var, and /usr on separate
	partitions, recovering each one from a backup made at a different
	time!  Now I make **VERY** sure everything stays in sync, so
	the installed-package database matches what's actually installed.

	(Obviously /var/lib is a limited exception in ordered to keep
	rootfs read-only by default.  If I have to recover from an out of
	sync /home and thus /home/var/lib, I can query for what packages
	own /var/lib and reinstall them.)

6	20 GiB /home (btrfs raid1 data/metadata)

	20 GiB is plenty big enough for /home, since I keep my big media
	files on a dedicated media partition on spinning rust.

7	24 GiB build and packages tree (btrfs raid1 data/metadata)

	I mount this at /usr/src, since that seemed logical, but it
	contains the traditional /usr/src/linux (a git kernel, here),
	plus the gentoo tree and layman-based overlays, plus my binpkg
	cache, plus the ccache.  Additionally it contains the 32-bit
	chroot binpkg cache and ccache, see below.

8	8 GiB 32-bit chroot build-image (btrfs raid1 data/metadata)

	I have a 32-bit netbook that runs gentoo also.  This is its
	build image, more or less a copy of its rootfs, but on my main
	machine where I build the packages for it.  I keep this
	rsynced to the netbook for its updates.  That way the slower
	netbook with its smaller hard drive doesn't have to build
	packages or keep a copy of the gentoo tree or the 32-bit
	binpkg cache at all.

9-12	Primary backups of partitions 5-8, rootfs, /home, packages, and
	netbook build image.  These partitions are the same size and
	configuration as their working copies above, recreated
	periodically to protect against fat-finger mishaps as well as
	still-under-development btrfs corner-cases and ~arch plus
	live-branch-kde, etc update mishaps.

	(My SSDs, Corsair Neutron series, run a LAMD (Link A
	Media Devices) controller.  These don't have the compression
	or dedup features of something like the sandforce controllers,
	but the Neutrons at least (as opposed to the Neutron GTX) are
	enterprise targeted, with the resulting predictable performance,
	capacity and reliability bullet-point features.  What you save to
	the SSD is saved as-you-sent-it, regardless of compressibility or
	whether it's a dup of something else already on the SSD.  Thus,
	at least with my SSDs, the redundant working and backup copies
	are actually two copies on the SSD as well, not one compressed/
	dedupped copy.  That's a very nice confidence point when the
	whole /point/ of sending two copies is to have a backup!  So
	for anyone reading this that decides to do something similar,
	be sure your SSD firmware isn't doing de-duping in the background,
	leaving you with only the one copy regardless of what you thought
	you might have saved!)
	

That STILL leaves me 117.5 GiB of the 238.5 GiB entirely free and 
unallocated for wear-leveling and/or future flexibility, and I've a 
second copy (primary backup copy) of most of the data as well, which 
could be omitted from SSD (kept on spinning rust) if necessary.

Before I actually got the drives and was still figuring on 128-ish gigs, 
I was figuring 1 gig x-log, maybe 6 gig rootfs, 16 gig home, 20 gig pkg, 
and another 6 gig netbookroot, so about 49 gig of data if I went with 
60-80 gig SSDs, with the backups as well 97 gig, if I went with 120-ish 
gig SSDs.

But as I said, once I actually was out there shopping for 'em I ended up 
getting the 256 GB (238.5 GiB) SSDs as a near-best bargain in terms of 
rated performance and reliability vs. size vs. price.


Still on spinning rust, meanwhile, all my filesystems remain the many-
years-stable reiserfs.  I keep a working and backup media partition 
there, as well as second backup partitions for everything on btrfs on the 
ssds, just in case.

Additionally, I have an external USB-connected drive that's both 
disconnected and off most of the time, to recover from in case something 
takes out both the SSDs and internal spinning rust.

I figure if the external gets taken out too, say by fire if my house 
burnt down or by theft if someone broke in and stole it, I'd have much 
more important things to worry about for awhile, then what might have 
happened to my data!  And once I did get back on my feet and ready to 
think about computing again, much of the data would be sufficiently 
outdated as to be near worthless in any case.  At that point I might as 
well start from scratch but for the knowledge in my head, and whatever 
offsite or the like backups I might have had probably wouldn't be worth 
the trouble to recover anyway, so that's beyond cost/time/hassle 
effective and I don't bother.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

