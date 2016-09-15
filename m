Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35785 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759340AbcIOIFe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 04:05:34 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke?
Date: Thu, 15 Sep 2016 10:05:29 +0200
Message-ID: <2471654.cnhj6IAGL9@merkaba>
In-Reply-To: <20160915075536.67ae74b9@jupiter.sol.kaishome.de>
References: <57D51BF9.2010907@online.no> <be04c51d-c35d-39fe-c5f7-a7ab13d72cc5@gmail.com> <20160915075536.67ae74b9@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 15. September 2016, 07:55:36 CEST schrieb Kai Krakow:
> Am Mon, 12 Sep 2016 08:20:20 -0400
> 
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
> > On 2016-09-11 09:02, Hugo Mills wrote:
> > > On Sun, Sep 11, 2016 at 02:39:14PM +0200, Waxhead wrote:
> > >> Martin Steigerwald wrote:
> >  [...]
> >  [...]
> >  [...]
> >  [...]
> >  
> > >> That is exactly the same reason I don't edit the wiki myself. I
> > >> could of course get it started and hopefully someone will correct
> > >> what I write, but I feel that if I start this off I don't have deep
> > >> enough knowledge to do a proper start. Perhaps I will change my
> > >> mind about this.
> > >> 
> > >    Given that nobody else has done it yet, what are the odds that
> > > 
> > > someone else will step up to do it now? I would say that you should
> > > at least try. Yes, you don't have as much knowledge as some others,
> > > but if you keep working at it, you'll gain that knowledge. Yes,
> > > you'll probably get it wrong to start with, but you probably won't
> > > get it *very* wrong. You'll probably get it horribly wrong at some
> > > point, but even the more knowledgable people you're deferring to
> > > didn't identify the problems with parity RAID until Zygo and Austin
> > > and Chris (and others) put in the work to pin down the exact
> > > issues.
> > 
> > FWIW, here's a list of what I personally consider stable (as in, I'm
> > willing to bet against reduced uptime to use this stuff on production
> > systems at work and personal systems at home):
> > 1. Single device mode, including DUP data profiles on single device
> > without mixed-bg.
> > 2. Multi-device raid0, raid1, and raid10 profiles with symmetrical
> > devices (all devices are the same size).
> > 3. Multi-device single profiles with asymmetrical devices.
> > 4. Small numbers (max double digit) of snapshots, taken at infrequent
> > intervals (no more than once an hour).  I use single snapshots
> > regularly to get stable images of the filesystem for backups, and I
> > keep hourly ones of my home directory for about 48 hours.
> > 5. Subvolumes used to isolate parts of a filesystem from snapshots.
> > I use this regularly to isolate areas of my filesystems from backups.
> > 6. Non-incremental send/receive (no clone source, no parent's, no
> > deduplication).  I use this regularly for cloning virtual machines.
> > 7. Checksumming and scrubs using any of the profiles I've listed
> > above. 8. Defragmentation, including autodefrag.
> > 9. All of the compat_features, including no-holes and skinny-metadata.
> > 
> > Things I consider stable enough that I'm willing to use them on my
> > personal systems but not systems at work:
> > 1. In-line data compression with compress=lzo.  I use this on my
> > laptop and home server system.  I've never had any issues with it
> > myself, but I know that other people have, and it does seem to make
> > other things more likely to have issues.
> > 2. Batch deduplication.  I only use this on the back-end filesystems
> > for my personal storage cluster, and only because I have multiple
> > copies as a result of GlusterFS on top of BTRFS.  I've not had any
> > significant issues with it, and I don't remember any reports of data
> > loss resulting from it, but it's something that people should not be
> > using if they don't understand all the implications.
> 
> I could at least add one "don't do it":
> 
> Don't use BFQ patches (it's an IO scheduler) if you're using btrfs.
> Some people like to use it especially for running VMs and desktops
> because it provides very good interactivity while maintaining very good
> throughput. But it completely destroyed my btrfs beyond repair at least
> twice, either while actually using a VM (in VirtualBox) or during high
> IO loads. I now stick to the deadline scheduler instead which provides
> very good interactivity for me, too, and the corruptions didn't occur
> again so far.
> 
> The story with BFQ has always been the same: System suddenly freezes
> during moderate to high IO until all processes stop working (no process
> shows D state, tho). Only hard reboot possible. After rebooting, access
> to some (unrelated) files may fail with "errno=-17 Object already
> exists" which cannot be repaired. If it affects files needed during
> boot, you are screwed because file system goes RO.

This could be a further row in the table. And well…

as for CFQ Jens Axboe currently works on bandwidth throttling patches 
*exactly* for the reason to provide more interactivity and fairness to I/O 
operations in between.

Right now, Completely Fair in CFQ is a *huge* exaggeration, at least while you 
have a dd bs=1M thing running.

Thanks,
-- 
Martin
