Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:59079 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751192AbdBALzf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Feb 2017 06:55:35 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.88)
        (envelope-from <kilobyte@angband.pl>)
        id 1cYtVa-0006Hf-Vk
        for linux-btrfs@vger.kernel.org; Wed, 01 Feb 2017 12:55:31 +0100
Date: Wed, 1 Feb 2017 12:55:30 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
Message-ID: <20170201115530.l2ce5afcqld2kzi4@angband.pl>
References: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
 <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
 <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
 <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
 <07bba687-64c3-6713-6f6a-c8da183cbd3d@gmail.com>
 <YAvBcoM9EImXYYAvCcegSf@videotron.ca>
 <a5262907-06f2-2c6f-d23a-2703b10429b7@deragon.biz>
 <pan$be2e$8a233bb0$f63eb0cb$d3413db@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$be2e$8a233bb0$f63eb0cb$d3413db@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 01, 2017 at 05:23:16AM +0000, Duncan wrote:
> Hans Deragon posted on Tue, 31 Jan 2017 21:51:22 -0500 as excerpted:
> > But the current scenario makes it difficult for me to put redundancy
> > back into service!  How much time did I waited until I find the mailing
> > list, subscribe to it, post my email and get an answer?  Wouldn't it be
> > better if the user could actually add the disk at anytime, mostly ASAP?
> > 
> > And to fix this, I have to learn how to patch and compile the kernel.  I
> > have not done this since the beginning of the century.  More delays,
> > more risk added to the system (what if I compile the kernel with the
> > wrong parameters?).
> 
> The patch fixing the problem and making return from degraded not the one-
> shot thing it tends to be now will eventually be merged

Not anything like the one I posted to this thread -- this one merely removes
a check that can't handle this particular (common) case of an otherwise
healthy RAID that lost one device then was mounted degraded twice.  We need
instead a better check, one that sees whether every block group is present.

This can be done quite easily, as as far as I know, the list of block group
is at that moment fully present in memory, but someone actually has to code
that, and I for one don't know btrfs internals (yet?).

> or if a patch is already available, rebuilding with that patch.

I've done smoke tests on this bandaid patch, and I _believe_ it is safe to
use it as long as you're certain the scenario of events is:
* you had a _redundant_ RAID, in good shape
* lost precisely one device
* mounted it degraded before (creating single blocks, but they're all on
  devices still present)
* no devices were added or removed since the original loss

> Otherwise, you simply mkfs and restore from the backup that was strongly 
> recommended if the data isn't of only trivial value in the first place.  
> If you didn't have that backup, and the data was stored on a still 
> stabilizing btrfs, well then, you defined it as of only trivial value

mkfs+restore is a lot of work, and it's likely to result in data loss,
bringing you back to the last backup.  Like, in the GitLab case yesterday
-- they lost "just" 6 hour of account database, but that was enough to give
them an article on every tech news site.

A degraded RAID with every bit of data present can still have that 6 hours
of data copied off it, but you need to organize temporary storage, lose
snapshot arrangements, etc.  It's so much better to just add a disk and
resync the RAID, like what you get in other RAID implementations.

In this case, you really want this this quick hack of a patch, even though
it comes from a doofus with little knowledge about btrfs, as it lets you
quickly recover in-place without that restore from backups.

> Otherwise, run a filesystem more appropriately stable and mature 
> according to your needs, as btrfs in its current state apparently doesn't 
> meet those needs.

No, I'm not touching a silentdatalossfs with a very long pole if I can help
it, "silentdatalossfs" currently defined as "any filesystem other than btrfs
and zfs", and zfs on Linux has more problems than btrfs.  Of last four $disk
failures I had recently (after a long stretch of luck), three had no
reported errors whatsoever, one had a single reported bad sector while scrub
found 3600 more.  Yeah, you're supposed to get warnings but somehow, on
three different computers from diverse manufacturers (one of these was a
RasPi with a SD card...), I got none.  Of these failures, those that were on
ext4 resulted in lots of woe and data loss, despite adequate backups going
months back -- _silent_ data loss means you keep backing up trash while good
backups expire; those on btrfs immediately told me that I should hit backups
and what exact files were lost.

And data checksums are just one of several upsides of btrfs.  So my decision
is to grit my teeth and deal with btrfs' downsides.


Meow!
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11
