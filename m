Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40809 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909AbcESSLx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 14:11:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b3SP3-0004q3-Vf
	for linux-btrfs@vger.kernel.org; Thu, 19 May 2016 20:10:34 +0200
Received: from ip1f11faed.dynamic.kabel-deutschland.de ([31.17.250.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 20:10:33 +0200
Received: from hurikhan77 by ip1f11faed.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 20:10:33 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Hot data tracking / hybrid storage
Date: Thu, 19 May 2016 20:09:26 +0200
Message-ID: <20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
References: <nh9p2p$cns$1@ger.gmane.org>
	<pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
	<20160516010524.7e208f96@jupiter.sol.kaishome.de>
	<nhedk2$dpq$1@ger.gmane.org>
	<0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
	<20160517203335.5ff99a05@jupiter.sol.kaishome.de>
	<nhir96$8n4$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 18 May 2016 22:44:55 +0000 (UTC)
schrieb Ferry Toth <ftoth@exalondelft.nl>:

> Op Tue, 17 May 2016 20:33:35 +0200, schreef Kai Krakow:
> 
> > Am Tue, 17 May 2016 07:32:11 -0400 schrieb "Austin S. Hemmelgarn"
> > <ahferroin7@gmail.com>:
> >   
> >> On 2016-05-17 02:27, Ferry Toth wrote:  
>  [...]  
>  [...]  
> >>  [...]  
>  [...]  
>  [...]  
>  [...]  
> >> On the other hand, it's actually possible to do this all online
> >> with BTRFS because of the reshaping and device replacement tools.
> >> 
> >> In fact, I've done even more complex reprovisioning online before
> >> (for example, my home server system has 2 SSD's and 4 HDD's,
> >> running BTRFS on top of LVM, I've at least twice completely
> >> recreated the LVM layer online without any data loss and minimal
> >> performance degradation).  
>  [...]  
> >> I have absolutely no idea how bcache handles this, but I doubt
> >> it's any better than BTRFS.  
> > 
> > Bcache should in theory fall back to write-through as soon as an
> > error counter exceeds a threshold. This is adjustable with sysfs
> > io_error_halftime and io_error_limit. Tho I never tried what
> > actually happens when either the HDD (in bcache writeback-mode) or
> > the SSD fails. Actually, btrfs should be able to handle this (tho,
> > according to list reports, it doesn't handle errors very well at
> > this point).
> > 
> > BTW: Unnecessary copying from SSD to HDD doesn't take place in
> > bcache default mode: It only copies from HDD to SSD in writeback
> > mode (data is written to the cache first, then persisted to HDD in
> > the background). You can also use "write through" (data is written
> > to SSD and persisted to HDD at the same time, reporting persistence
> > to the application only when both copies were written) and "write
> > around" mode (data is written to HDD only, and only reads are
> > written to the SSD cache device).
> > 
> > If you want bcache behave as a huge IO scheduler for writes, use
> > writeback mode. If you have write-intensive applications, you may
> > want to choose write-around to not wear out the SSDs early. If you
> > want writes to be cached for later reads, you can choose
> > write-through mode. The latter two modes will ensure written data
> > is always persisted to HDD with the same guaranties you had without
> > bcache. The last mode is default and should not change behavior of
> > btrfs if the HDD fails, and if the SSD fails bcache would simply
> > turn off and fall back to HDD. 
> 
> Hello Kai,
> 
> Yeah, lots of modes. So that means, none works well for all cases?

Just three, and they all work well. It's just a decision wearing vs.
performance/safety. Depending on your workload you might benefit more or
less from write-behind caching - that's when you want to turn the knob.
Everything else works out of the box. In case of an SSD failure,
write-back is just less safe while the other two modes should keep your
FS intact in that case.

> Our server has lots of old files, on smb (various size), imap
> (10000's small, 1000's large), postgresql server, virtualbox images
> (large), 50 or so snapshots and running synaptics for system upgrades
> is painfully slow. 

I don't think that bcache even cares to cache imap accesses to mail
bodies - it won't help performance. Network is usually much slower than
SSD access. But it will cache fs meta data which will improve imap
performance a lot.

> We are expecting slowness to be caused by fsyncs which appear to be
> much worse on a raid10 with snapshots. Presumably the whole thing
> would be fast enough with ssd's but that would be not very cost
> efficient.
> 
> All the overhead of the cache layer could be avoided if btrfs would
> just prefer to write small, hot, files to the ssd in the first place
> and clean up while balancing. A combination of 2 ssd's and 4 hdd's
> would be very nice (the mobo has 6 x sata, which is pretty common)

Well, I don't want to advertise bcache. But there's nothing you
couldn't do with it in your particular case:

Just attach two HDDs to one SSD. Bcache doesn't use a 1:1 relation
here, you can use 1:n where n is the backing devices. There's no need
to clean up using balancing because bcache will track hot data by
default. You just have to decide which balance between wearing the SSD
vs. performance you prefer. If slow fsyncs are you primary concern, I'd
go with write-back caching. The small file contents are propably not
your performance problem anyways but the meta data management btrfs has
to do in the background. Bcache will help a lot here, especially in
write-back mode. I'd recommend against using balance too often and too
intensive (don't use too big usage% filters), it will invalidate your
block cache and probably also invalidate bcache if bcache is too small.
It will hurt performance more than you gain. You may want to increase
nr_requests in the IO scheduler for your situation.

> Moreover increasing the ssd's size in the future would then be just
> as simple as replacing a disk by a larger one.

It's as simple as detaching the HDDs from the caching SSD, replace it,
reattach it. It can be done online without reboot. SATA is usually
hotpluggable nowadays.

> I think many would sign up for such a low maintenance, efficient
> setup that doesn't require a PhD in IT to think out and configure.

Bcache is actually low maintenance, no knobs to turn. Converting to
bcache protective superblocks is a one-time procedure which can be done
online. The bcache devices act as normal HDD if not attached to a
caching SSD. It's really less pain than you may think. And it's a
solution available now. Converting back later is easy: Just detach the
HDDs from the SSDs and use them for some other purpose if you feel so
later. Having the bcache protective superblock still in place doesn't
hurt then. Bcache is a no-op without caching device attached.

> Even at home, I would just throw in a low cost ssd next to the hdd if
> it was as simple as device add. But I wouldn't want to store my
> photo/video collection on just ssd, too expensive.

Bcache won't store your photos if you copied them: Large copy
operations (like backups) and sequential access is detected and bypassed
by bcache. It won't invalidate your valuable "hot data" in the cache.
It works really well.

I'd even recommend to format filesystems with bcache protective
superblock (aka format backing device) even if you not gonna use
caching and not gonna insert an SSD now, just to have the option for
the future easily and without much hassle.

I don't think native hot data tracking will land in btrfs anytime soon
(read: in the next 5 years). Bcache is a general purpose solution for
all filesystems that works now (and properly works).

You maybe want to clone your current system and try to integrate bcache
to see the benefits. There's actually a really big impact on
performance from my testing (home machine, 3x 1TB HDD btrfs mraid1
draid0, 1x 500GB SSD as cache, hit rate >90%, cache utilization ~70%,
boot time improvement ~400%, application startup times almost instant,
workload: MariaDB development server, git usage, 3 nspawn containers,
VirtualBox Windows 7 + XP VMs, Steam gaming, daily rsync backups, btrfs
60% filled).

I'd recommend to not use a too small SSD because it wears out very fast
when used as cache (I think that generally applies and is not bcache
specific). My old 120GB SSD was specified for 85TB write performance,
and it was worn out after 12 months of bcache usage, which included 2
complete backup restores, multiple scrubs (which relocates and rewrites
every data block), and weekly balances with relatime enabled. I've
since used noatime+nossd, completely stopped using balance and never
used scrub yet, with the result of vastly reduced write accesses to the
caching SSD. This setup is able to write bursts of 800MB/s to the disk
and read up to 800MB/s from disk (if btrfs can properly distribute
reads to all disks). Bootchart shows up to 600 MB/s during cold booting
(with warmed SSD cache). My nspawn containers boot in 1-2 seconds and
do not add to the normal boot time at all (they are autostarted during
boot, 1x MySQL, 1x ElasticSearch, 1x idle/spare/testing container).
This is really impressive for a home machine, and c'mon: 3x 1TB HDD +
1x 500GB SSD is not that expensive nowadays. If you still prefer a
low-end SSD I'd recommend to use write-around only from my own
experience.

The cache usage of the 120GB of 100% with 70-80% hit rate, which means
it was constantly rewriting stuff. 500GB (which I use now) is a little
underutilized now but almost no writes happen after warming up, so it's
mostly a hot-data read cache (although I configured it as write-back).
Plus, bigger SSDs are usually faster - especially for write ops.

Conclusion: Btrfs + bcache make a very good pair. Btrfs is not really
optimized for good latency and that's where bcache comes in. Operating
noise from HDD reduces a lot as soon as bcache is warmed up.

BTW: If deployed, keep an eye on your SSD wearing (using smartctl). But
given you are using btrfs, you keep backups anyways. ;-)

-- 
Regards,
Kai

Replies to list-only preferred.

