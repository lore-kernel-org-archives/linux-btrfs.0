Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54388 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab3LaDXy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 22:23:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vxpvr-0006Mj-C7
	for linux-btrfs@vger.kernel.org; Tue, 31 Dec 2013 04:23:51 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 04:23:51 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 04:23:51 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Migrate to bcache: A few questions
Date: Tue, 31 Dec 2013 04:13:01 +0100
Message-ID: <uap9pa-9un.ln1@hurikhan77.spdns.de>
References: <kof6pa-akd.ln1@hurikhan77.spdns.de> <pan$108e2$6f522d85$92bd821$4b98bdab@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

[ spoiler: tldr ;-) ]

>> * How stable is it? I've read about some csum errors lately...
> 
> FWIW, both bcache and btrfs are new and still developing technology.
> While I'm using btrfs here, I have tested usable (which for root means
> either means directly bootable or that you have tested booting to a
> recovery image and restoring from there, I do the former, here) backups,
> as STRONGLY recommended for btrfs in its current state, but haven't had
> to use them.
> 
> And I considered bcache previously and might otherwise be using it, but
> at least personally, I'm not willing to try BOTH of them at once, since
> neither one is mature yet and if there are problems as there very well
> might be, I'd have the additional issue of figuring out which one was the
> problem, and I'm personally not prepared to deal with that.

I mostly trust btrfs by now. Don't understand me wrong: I still have my 
nightly backup job syncing the complete system to an external drive - 
nothing defeats a good backup. But btrfs has survived reliably multiple 
power-losses, kernel panics/freezes, unreliable USB connections, ... It 
looks very stable from that view. Yes, it may have bugs that may introduce 
errors fatal to the filesystem structure. But generally, under usual 
workloads it has proven stable for me. At least for desktop workloads.
 
> Instead, at this point I'd recommend choosing /either/ bcache /or/ btrfs,
> and using bcache with a more mature filesystem like ext4 or (what I used
> for years previous and still use for spinning rust) reiserfs.

I've used reiserfs for several years a long time ago. But it does absolutely 
not scale well for parallel/threaded workloads which is a show stopper for 
server workloads. But it always survived even the worst failure scenarios 
(like SCSI bus going offline for some RAID members) and the tools 
distributed with it were able to recover all data even if the FS was damaged 
beyond any usual things you would normally try when it does no longer mount. 
I've been with Ext3 before, and it was not only one time that a simple 
power-loss during high server-workload destroyed the filesystem beyond 
repair with fsck only making it worse.

Since reiserfs did not scale well and ext* FS has annoyed me more than once, 
we've decided to go with XFS. While it tends to wipe some data after power-
loss and leaves you with zero-filled files, it has proven extremely reliable 
even under those situations mentioned above like dying SCSI bus. Not to the 
extent reiserfs did but still very satisfying. The big plus: it scales 
extremely well with parallel workloads and can be optimized for the stripe 
configuration of the underlying RAID layer. So I made it my default 
filesystem for desktop, too. With the above mentioned annoying "feature" of 
zero'ing out recently touched files when the system crashed. But well, we 
all got proven backups, right? Yep, I also learned that lesson... *sigh

But btrfs, when first announced and while I already was jealously looking at 
ZFS, seemed to be the FS of my choice giving me flexible RAID setups, 
snapshots... I'm quite happy with it although it feels slow sometimes. I 
simply threw more RAM at it - now it is okay.


> And as I said, keep your backups as current as you're willing to deal
> with losing what's not backed up, and tested usable and (for root) either
> bootable or restorable from alternate boot, because while at least btrfs
> is /reasonably/ stable for /ordinary/ daily use, there remain corner-
> cases and you never know when your case is going to BE a corner-case!

I've got a small rescue system I can boot which has btrfs-tools and a recent 
kernel to flexible repair, restore, or whatever I want to do with my backup. 
My backup itself is not bootable (although it probably could, if I change 
some configurations files).

>> * I want to migrate my current storage to bcache without replaying a
>> backup.  Is it possible?
> 
> Since I've not actually used bcache, I won't try to answer some of these,
> but will answer based on what I've seen on the list where I can...  I
> don't know on this one.

I remember someone created some pyhton scripts to make it possible - wrt to 
btrfs especially. Can't remember the link. Maybe I'm able to dig it up. But 
at least I read it as: There's no improvement on that migration path 
directly from bcache. I hoped otherwise...

>> * Did others already use it? What is the perceived performance for
>> desktop workloads in comparision to not using bcache?
> 
> Others are indeed already using it.  I've seen some btrfs/bcache problems
> reported on this list, but as mentioned above, when both are in use that
> means figuring out which is the problem, and at least from the btrfs side
> I've not seen a lot of resolution in that regard.  From here it /looks/
> like that's simply being punted at this time, as there's still more
> easily traceable problems without the additional bcache variable to work
> on first.  But it's quite possible the bcache list is actively tackling
> btrfs/bache combination problems, as I'm not subscribed there.
> 
> So I can't answer the desktop performance comparison question directly,
> but given that I /am/ running btrfs on SSD, I /can/ say I'm quite happy
> with that. =:^)

Well, I'm most interested in bcache+btrfs so I put my questions here in this 
list - although I have to admit that most questions would've better been 
properly placed in the bcache list.

Small sidenote: I'm subscribed through the gmane NNTP proxy to all these 
lists, using a native NNTP reader. I can really recommend it. Subscribing to 
the list for post access is also very easy. You may want to look into it. 
;-)

> Keep in mind...
> 
> We're talking storage cache here.  Given the cost of memory and common
> system configurations these days, 4-16 gig of memory on a desktop isn't
> unusual or cost prohibitive, and a common desktop working set should well
> fit.

I'm having 16 gig of memory. I started with 8, but it was insanely cheap 
when I upgraded my mainboard, only €30 for 8 gig - so I threw in another 
pair of 4 gig modules. Did never regret...

> I suspect my desktop setup, 16 gigs memory backing a 6-core AMD fx6100
> (bulldozer-1) @ 3.6 GHz, is probably a bit toward the high side even for
> a gentooer, but not inordinately so.  Based on my usage...

Mine is 16 gigs, Core i5 Quad @ 3.3 (with this turbo boost thingy) - so, 
well, no. I think both, your and my setup, are decent but not extraordinary. 
;-)

> Typical app memory usage runs 1-2 GiB (that's with KDE 4.12.49.9999 from
> the gentoo/kde overlay, but USE=-semantic-desktop, etc).  Buffer memory
> runs a few MiB but isn't normally significant, so it can fold into that
> same 1-2 GiB too.

Similar observation here, though I'm using semantic-desktop: Memory usage 
rarely goes above 3-4 GB in KDE during usual workloads, so the rest is 
mostly dedicated to cache. Still, btrfs feels very sluggish from time to 
time. Thus my idea throwing a SSD with bcache into the equation. This 
sluggishness came quite suddenly with one of the kernel updates though I 
don't remember which, probably between 3.7 and 3.8... I've mitigated it 
mostly by ramping up the IO queue depth... A lot... From default 128 to 
8192. My amount of RAM allows it - so what... ;-)

> When I'm doing multi-job builds or working with big media files, I'll
> sometimes go above 8 gig usage, and that occasional cache-spill was why I
> upgraded to 16 gig.  But in practice, 10 gig would take care of that most
> of the time, and were it not for the "accident" of powers-of-two meaning
> 16 gig is the notch above 8 gig, 10 or 12 gig would be plenty.  Truth be
> told, I so seldom use that last 4 gig that it's almost embarrassing.

Same observation here: 8 gigs are usually enough for almost any workload. 
Just sometimes an extra amount of 2-3 gigs was needed. But well, it was 
cheap. Why spend 20 bucks for 4 gigs if I could get 8 for 30 bucks. :-) And 
while I never measured it and neither looked at how todays system organize 
memory, I still believe in memory interleaving and thus always buy in pairs.

> * Tho if I ran multi-GiB VMs that'd use up that extra memory real fast!
> But while that /is/ becoming more common, I'm not exactly sure I'd
> classify 4 gigs plus of VM usage as "desktop" usage just yet.
> Workstation, yes, and definitely server, but not really desktop.

I want a snappy system without bothering how to distribute it over different 
storage techniques which both have their distinct limitations. So 
bcache+btrfs is a solution to have the best of _all_ worlds. Like having 
your own cake and eat it, too. And while having 16 gigs of RAM, using 
preload, btrfs distributed across 3 devices, gave me a pretty snappy system, 
it has suffered a lot due to the above mentioned "kernel incident." It never 
came back to its old snappiness. So I feel the urge to move forward.

[...]
> Given the stated 3 x 1TB drive btrfs in raid1 metadata, raid0 data, config
> you mention, I'm wondering if big media is a/the big use case for you, in
> which case bcache isn't going to be a good solution anyway, since that
> tends to be sequential access, which bcache deliberately ignores as it
> doesn't fit the model it's targeting.

Well, use cases are as follows:

  * The system is also connected to my TV by HDMI
  * used for HTPC functions (just playback) with XBMC
  * used for Steam (occasinally playing games on the big screen)
  * used for development (and I always keep loads of tabs open in the
    browser then)
  * this involves git, restarting dev servers, compiling
  * VMs for these Windows-only things (but this is rare)
  * the usual Gentoo compiling, you know it...

So, bcache could probably help those situations where I want snappiness. And 
in the long term I'm planning to add another HDD and go with btrfs RAID10 
instead.

> (I am a bit worried about that raid0 data, tho.  Unless you consider that
> data of trivial value that's not a good choice, since raid0 generally
> means you lose it all if you lose a physical device.  And you're running
> three devices, which means you just tripled the chance of a device
> failure over that of just putting it all on a single 3 TB drive!  And
> backups... a 3 TB restore on spinning rust will take some time any way
> you look at it, so backups may or may not be particularly viable here.

I have a working backup with backlog. I got the 1TB drives incredibly cheap, 
so it was the option of choice. And I feel big drives with high data density 
are not as reliable as not so big and technically proven drives 
(manufactured when technology had moved forward to bigger platters).

> The most common use case for that much data is probably a DVR scenario,
> which is video, and you may well consider it of low enough value that if
> you lose it, you lose it, and you're willing to take that risk, but for
> normally sequential access video/media, bcache isn't a good match anyway.)

I'm in the process of sorting out all my CD and DVDs with archived data on 
it. Such media is unreliable - more than my current setup. I've been with 
LVM and XFS before and it's always been headache to swap storage easily. 
With btrfs it is very easy, and RAID striping comes for free. With my 
previous LVM setup I used a JBOD setup and I wasn't entirely happy with it. 
And then, there's still the long-term goal of migrating to RAID-10.

> * With memory cost what it is, for repeat access where initial access
> time isn't /too/ critical, investing in more memory, to a point (for me,
> 8-12 gig as explained above), and simply letting the kernel manage cache
> and memory as it normally does, may make more sense than bcache to an ssd.

This is why I'm already having 16 gigs. But I feel bcache would improve cold 
start of applications and the system.

> * Of course, what bcache *DOES* effectively do, is extend the per-boot
> cache time of memory, making the cache persistent.  That effectively
> extends the time over which "occasional access" still justifies caching
> at all.

That is the plan. ;-)

> * That makes bcache well suited to boot-time and initial-access-speed-
> critical scenarios, where more memory for a larger in-memory cache won't
> do any good, since it's first-access-since-boot, because for in-memory
> cache that's a cold-cache scenario, while with bcache's persistent cache,
> it's a hot-cache scenario.

Dito.

> But what I'm actually wondering is if your use case better matches a
> split data model, where you put root and perhaps stuff like the portage
> tree and/or /home on fast SSD, while keeping all that big and generally
> sequential access media on slower but much cheaper big spinning rust.

I hate partitioning. I don't want to micro-optimize my partition setup when 
a solution like bcache could provide similar improvements without the 
downsides of such partitioning decisions. That's the point.

> That's effectively what I've done here, tho I'm looking at rather less
> than a TB of slow-access media, etc.  See below for the details.  The
> general idea is as I said to stick all the time-critical stuff on SSD
> directly (not using something like bcache), while keeping the slower
> spinning rust for the big less-time-critical and sequential-access stuff,
> and for non-btrfs backups of the stuff on the btrfs-formatted SSD, since
> btrfs /is/ after all still in development, and I /do/ intend to be
> prepared if /my/ particular case ends up being one of the corner-cases
> btrfs still worst-cases on.

I have no problem with the time a restore from backup takes. I'm not that 
dependent on the system. I case of time-critical stuff I would just bind-
mount the home backup to a rescue system or just sync the home directory 
from backup to a (slow) spare system I've got somewhere and that usually 
just collects dust. That's a tested setup. I worst case there's an Gentoo VM 
in my office with almost identical software setup which I could just attach 
my disk to and mount my home on, and then even work remote on it. At least 
both these spare system setups would work as an emergeny replacement for 
important work. All the rest is not that important. If I loose the 
entertainment part of my system: Sigh, annoying, but well: Not important. 
All those mostly static files are in the backup and I'm not dependent on 
them in a time-critical manner. The critical working set can be implanted 
into spare systems.

>> * How well does bcache handle power outages? Btrfs does handle them very
>>   well since many months.
> 
> Since I don't run bcache I can't really speak to this at all, /except/,
> the btrfs/bcache combo trouble reports that have come to the list have I
> think all been power outage or kernel-crash scenarios... as could be
> predicted of course since that's a filesystem's worst-case scenario, at
> least that it has to commonly deal with.
> 
> But I know I'd definitely not trust that case, ATM.  Like I said, I'd not
> trust the combination of the two, and this is exactly where/why.  Under
> normal operation, the two should work together well.  But in a power-loss
> situation with both technologies being still relatively new and under
> development... not *MY* data!

The question is: Will it eat my data twice a day or twice a year. I could 
live with the latter, I have no time for the former, though. But I'm 
interested in helping the community by testing this. The problem isn't 
actually with bcache+btrfs destroying my system beyond repair and having to 
restore from backup. My problem is with silent data corruption it may 
introduce. My backup strategry won't protect me from that altough I have 
several weeks of backlog. And putting just unimportant stuff I seldom work 
with would just not help the situation: First, I would not really test the 
setup, second, I would not really take advantage of the setup. It would be 
useless.

>> * How well does it play with dracut as initrd? Is it as simple as
>> telling it the new device nodes or is there something complicate to
>> configure?
> 
> I can't answer this at all for bcache, but I can say I've been relatively
> happy with the dracut initramfs solution for dual-device btrfs raid1
> root. =:^)  (At least back when I first set it up several kernels ago,
> the kernel's commandline parser apparently couldn't handle the multiple
> equals of something like rootflags=device=/dev/sda5,device=/dev/sdb5.  So
> the only way to get a multi-device btrfs rootfs to work was to use an
> initr* with userspace btrfs device scan before attempting to mount real-
> root, and dracut has worked well for that.)

Worked for me by adding rootdelay=2 to the cmdline. And I had to add a 
symlink into the dracut ramfs builder because the scripts expect the btrfs 
bins somewhere else than they install to. I now use root=UUID=xxxx and it 
works like a charme.

>> * How does bcache handle a failing SSD when it starts to wear out in a
>> few years?
> 
> Given the newness of the bcache technology, assuming your SSD doesn't
> fail early and it is indeed a few years, I'd suggest that question is
> premature.  Bcache will by that time be much older and more mature than
> it is now, and how it'd handle, or fail to handle, such an event /now/
> likely hasn't a whole lot to do with how much (presumably) better it'll
> handle it /then/.

Well, good point. And I've read through some links (thanks to the other 
posters here) which show that bcache already has some countermeasures for 
this situation. So at least it is designed with such problems in mind. From 
that view it looks good to me. My biggest problem is probably I don't really 
trust SSDs by now, given my office background when SSDs fail in dumb ways 
just due to some workloads applied in Windows systems. Then, you update BIOS 
and firmware, and tada: Problems gone. BUT: This just implies that SSD is 
far from being mature. And then, I believe some manufactures just did not 
figure out how to do wear-leveling really correct. While HDDs usually fail 
in a soft way (some sectores no longer working, time for replacement), I 
usually read SSDs die from one minute to another unpredictably, so they fail 
the hard way in the way of from working flawlessly to everything lost. Or 
they start introducing silent data corruption which is much worse (like 
ack'ing writes but after reboot it looks like nothing was ever written).

>> * Is it worth waiting for hot-relocation support in btrfs to natively
>> use a SSD as cache?
> 
> I wouldn't wait for it.  It's on the wishlist, but according to the wiki
> (project ideas, see the dm_cache or bcache like cache, and the hybrid
> storage points), nobody has claimed that project yet, which makes it
> effectively status "bluesky", which in turn means "nice idea, we might
> get to it... someday."

One guy from this list was working on it - I remember it tho not his name. 
And he had patches. I liked the idea. It could probably work better than 
bcache due to not being filesystem agnostic.

> Given the btrfs project history of everything seeming to take rather
> longer than the original it turned out wildly optimistic projections, in
> the absense of a good filesystem dev personally getting that specific
> itch to scratch, that means it's likely a good two years out, and may be
> 5-10.  So no, I'd definitely *NOT* wait on it!

The well known mature filesystems (Ext, XFS, ...) are all probably 20 years 
old or more. Btrfs is maybe 5 years old now? It should start becoming 
feature complete now, and I think the devs are driven by similar emotions. 
Then give it another 5 years to work out all bugs and performance problems. 
At least from my dev background I know that time needed to code the feature-
complete codebase is about the same amount of time needed for testing and 
optimizing the system. I suppose it will then follow a similar evolution 
like the ext family of filesystems, adding new features while maintaining 
on-disk format as good as possible or at least enable easy forward-
migration, so users have a choice between proven stability or new features. 
At least this is what I hope and wish. ;-)

>> * Would you recommend going with a bigger/smaller SSD? I'm planning to
>> use only 75% of it for bcache so wear-leveling can work better, maybe
>> use another part of it for hibernation (suspend to disk).
> 
> FWIW, for my split data, some on SSD, some on spinning rust, setup, I had
> originally planned perhaps a 64 gig or so SSD, figuring I could put the
> boot-time-critical rootfs and a few other initial-access-time-critical
> things on it, with a reasonable amount of room to spare for wear-
> leveling.  Maybe 128 gig or so, with a bit more stuff on it.

The calculation behind this is that about 7% of the flash memory is already 
reserved for wear-leveling. The chips are powers of two (e.g., 128 gigs) 
while the drive announces more human-friendly sizes by cutting about 7% away 
(here: 120 gigs). But actually, reserving only 7% for wear-leveling is, 
according to multiple sources, not able to provide good performance in many 
workloads. The recommendation is to go with 30-50%. So, staying with the 
numbers, going with 90 gigs vs fully provisioned 120 gigs (that's 75% of the 
announced size), I effectively have a reserve of about 30% for wear-leveling 
(90 : 128 ~= 0.7).

> There were some smaller ones available, but
> they tended to be either MUCH slower or MUCH higher priced, I'd guess
> left over from a previous generation before prices came down, and they
> simply hadn't been re-priced to match current price/capacity price-points.

The performance drop is probably explainable by the fact that the drives to 
striping internally across the flash chips. You can see this performance 
drop even with modern drives if you look at comparision tests. That's not an 
effect of old technology only.

I think my system is mostly limited in performance by seeks not by 
throughput. So bcache came into my mind as the solution. Even a cheap drive 
would still be fast enough to deliver the throughput I usually measure in 
the system monitor with my HDDs - but with the bonus of more or less zero 
seek time. I don't think I have to optimize for throughput.

This is similar to throwing more RAM into the system usually gives a better 
performance boost than throwing more CPU at it: CPU would improve throughput 
- but the best throughput does not help if seeking is the limiting factor 
(i.e., having to re-read data from disk due to stressing the cache and RAM).

> But much below 128 GiB (there were some 120 GB at about the same per-gig,
> which "units" says is just under 112 GiB) and the price per gig tends to
> go up, while above 256 GB (not GiB) both the price per gig and full price
> tend to go up.

Yes, I figured currently you'd best go with the 128 gigs range, too. But in 
a range of difference around 60 gigs it is just not yet important for me. If 
it were 120 vs 240 gigs (or even more) it would become interesting. So in 
this difference range I'd probably prefer the lower price over the higher 
capacity. But I've not finally made up my mind about that.

> Of course that means if you do actually do bcache, 60-ish gigs should be
> good and I'd guess 128 gig would be overkill, as I guess 40-60 gigs
> probably about what my "hot" data is, the stuff bcache would likely catch.

That's the point. In higher capacity ranges it becomes interesting for more 
purpose than just bcache. But for the moment, and because of the fact I do 
not really trust this technology for storing all sorts of data with 
different access-patterns on it, I just want to try it out and see the 
effect of it.

> And 60 gig will likely be /some/ cheaper tho not as much as you might
> expect, but you'll lose flexibility too, and/or you might actually pay
> more for the 60 gig than the 120 gig, or it'll be slower speed-rated.
> That was what I found when I actually went out to buy, anyway.

It's like 50% of the capacity for 75% of the price. Not a very good deal. 
But throughput is not my prime target I guess (except you'd like to teach me 
otherwise wrt the above mentioned), and excess capacity is currently useless 
for me. So I'd probably go with the worse deal.

> I have a separate boot partition on each of the SSDs, with grub2
> installed to both SSD separately, pointing at its own /boot. with
> the SSD I boot selectable in BIOS.  That gives me a working /boot
> and a primary /boot backup.  I run git kernels and normally
> update the working /boot with a new kernel once or twice a week,
> while only updating the backup /boot with the release kernel, so
> every couple months.

Similar here: All hard disk use the same partitioning layout and I can use 
the spare space for /boot backups, EFI, or a small rescue system.

> 4	640 MiB /var/log (btrfs mixed-mode, raid1 data/metadata)
> 
> That gives me plenty of log space as long as logrotate doesn't
> break, while still keeping a reasonable cap on the log partition
> in case I get a runaway log.

I'm using journald as the only logger and it does its house keeping well.

> As any good sysadmin should know,
> some from experience (!!), keeping a separate log partition is a
> good idea, since that limits the damage if something /does/ go
> runaway logging.

Then take me as a good system admin: That's why the servers I admin are 
partitioned with these thoughts in mind. Since these servers run in VMs, I 
have no problem with partitioning here (in contrast to my "hate" above) 
because I can grow disk images and add new virtual drives without problems. 
My partitioning scheme in VMs is thus very simple: One partition per drive. 
So in the end: No problem for me with hating partitioning as there actually 
is no real partitioning. ;-)

In my opinion, partitioning is a remnant from ancient times which should go 
away. Volume pooling like it is supported by ZFS or btrfs is just the way to 
go. In VMs I can more or less emulate it by putting thin-provisioned virtual 
disk-images in the datastore.

> My rootfs includes (almost) all "installable" data, everything
> installed by packages except for /var/lib, which is a symlink to
> /home/var/lib.  The reason for that is that I keep rootfs mounted
> read-only by default, only mounting it read-write for updates or
> configuration changes, and /var/lib needs to be writable.  /home
> is mounted writable, thus the /var/lib symlink pointing into it.

I also started to hate such hacks, I used to use them, too - in the past. 
Volume pooling is the way to go. Waiting for btrfs to be able to mount 
subvolumes read-only...

> I learned the hard way to keep everything installed (but for
> /var/lib) on the same filesystem, along with the installed-
> package database (/var/db/pkg on gentoo), when I had to deal with
> a recovery situation with rootfs, /var, and /usr on separate
> partitions, recovering each one from a backup made at a different
> time!  Now I make **VERY** sure everything stays in sync, so
> the installed-package database matches what's actually installed.

Actually, I guess you might have some background to why I hate partitions. 
;-) But that's only one reasoning. The other is: You will always run out of 
space on one of them and have no way to redistribute space easily as needed. 
This is also why I pooled my HDDs together into one btrfs instead of putting 
different purpose partitions on them. And the draid-0 came for free. And 
since meta-data is much more critical, it is mraid-1. But I never had the 
problem yet that the btrfs driver had to repair from a good meta-data block. 
;-)

[most personal stuff snipped, feel free to PM]

> (My SSDs, Corsair Neutron series, run a LAMD (Link A
> Media Devices) controller.  These don't have the compression
> or dedup features of something like the sandforce controllers,
> but the Neutrons at least (as opposed to the Neutron GTX) are
> enterprise targeted, with the resulting predictable performance,
> capacity and reliability bullet-point features.  What you save to
> the SSD is saved as-you-sent-it, regardless of compressibility or
> whether it's a dup of something else already on the SSD.  Thus,
> at least with my SSDs, the redundant working and backup copies
> are actually two copies on the SSD as well, not one compressed/
> dedupped copy.  That's a very nice confidence point when the
> whole /point/ of sending two copies is to have a backup!  So
> for anyone reading this that decides to do something similar,
> be sure your SSD firmware isn't doing de-duping in the background,
> leaving you with only the one copy regardless of what you thought
> you might have saved!)

This is actually an important point when thinking of putting btrfs with raid 
features on such drives, or enabling btrfs compression.

> Still on spinning rust, meanwhile, all my filesystems remain the many-
> years-stable reiserfs.  I keep a working and backup media partition
> there, as well as second backup partitions for everything on btrfs on the
> ssds, just in case.

As initially mentioned, reiserfs has proven extremely reliable for me too, 
even in disastrous circumstances. No other FS has ever kept up with that. 
But scaling in multi-process IO situations which are mostly seen on busy 
servers is just, expressed mildly: bad. And XFS was the best candidate to 
fill that gap. I've lost my trust in ext family FS long before, so that was 
no option. Yes, I know: It's mature. It's proven. It's stable. But when it 
gets corrupted for whatever reason, my experience is that chances for 
recovery are virtually non-existent. Let's see how btrfs works for me during 
the next years. It's not there yet and performance is worse in almost any 
workload... But it has some compelling features. ;-)

> I figure if the external gets taken out too, say by fire if my house
> burnt down or by theft if someone broke in and stole it, I'd have much
> more important things to worry about for awhile, then what might have
> happened to my data!

Right. But still, my important work set (read: git repos, intellectual goods 
and activity, ...) are always mirrored outside. And btrfs snapshots help 
against accidential damage.

> And once I did get back on my feet and ready to
> think about computing again, much of the data would be sufficiently
> outdated as to be near worthless in any case.  At that point I might as
> well start from scratch but for the knowledge in my head, and whatever
> offsite or the like backups I might have had probably wouldn't be worth
> the trouble to recover anyway, so that's beyond cost/time/hassle
> effective and I don't bother.

I've once lost all my work set - that's when I started to hate FAT. This is 
probably 15 years ago but still bugs me, I only had very few and vastly 
outdated backups. But lessons learned. So maybe it is not as easy to say "I 
don't bother" as you think now. Just my two cents...


Sorry for the noise, list.

Enjoying discussion with you, I suggest getting in touch PM if this is 
getting away from btrfs any more...

Thanks,
Kai

