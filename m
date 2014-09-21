Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:51611 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaIUHek (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 03:34:40 -0400
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Duncan <1i5t5.duncan@cox.net>
Subject: Re: deleting a dead device
Date: Sun, 21 Sep 2014 17:34:36 +1000
Cc: linux-btrfs@vger.kernel.org
References: <201409211139.17295.russell@coker.com.au> <pan$e422f$7bb05c96$557446c8$a9f98e73@cox.net>
In-Reply-To: <pan$e422f$7bb05c96$557446c8$a9f98e73@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201409211734.36865.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 21 Sep 2014, Duncan <1i5t5.duncan@cox.net> wrote:
> Russell Coker posted on Sun, 21 Sep 2014 11:39:17 +1000 as excerpted:
> > On a system running the Debian 3.14.15-2 kernel I added a new drive to a
> > RAID-1 array.  My aim was to add a device and remove one of the old
> > devices.
> 
> That's an old kernel and presumably an old btrfs-progs.  Quite a number
> of device management fixes have gone in recently, and you'd likely not be
> in quite that predicament were you running a current kernel (make sure
> it's 3.16.2+ or 3.17-rc2+ to get the fix for the workqueues bug that
> affected 3.15 and thru 3.16.1 and 3.17-rc1).

3.16.2 is in Debian, I'm in the process of upgrading to it.

> And the recommended way to handle a device replace now would be btrfs
> replace, doing the add and delete in a single (albeit possibly long) step
> instead of separately.

I'm changing from a 500G single filesystem to a 200G RAID-1 (there's only 150G 
of data).  The change from 500G to 200G can't be done with a replace as a 
replace requires an equal or greater size.

I did a 2 step process, add/delete to go to a 200G USB attached device for 
half the array and then replace to go from 200G on USB to 200G internal.

> > The drive is attached by USB so I turned off the USB device and then got
> > the above result.  So it still seems impossible to remove the device
> > even though it's physically not present.  I've connected a new USB disk
> > which is now /dev/sdd, so it seems that BTRFS is keeping the name
> > /dev/sdc locked.
> > 
> > Should there be a way to fix this without rebooting or anything?
> 
> Did you try btrfs device delete missing?  It's documented on the wiki but
> apparently not yet on the manpage.

I did that after rebooting.  It didn't occur to me to try a "missing" 
operation when the drive really wasn't missing.

> According to the wiki that deletes
> the first device that was in the metadata but not found when booting, so
> you may have to reboot to do it, but it should work.

That would be a bug.  There's no reason a reboot should be required if we can 
remove a drive and add a new one with the kernel recognising it.  Hot-swap 
disks aren't any sort of new feature.

> Tho with the recent
> stale-devices fixes, were that a current kernel you may not actually have
> to reboot to have delete missing work.  But you probably will on 3.14,
> and of course to upgrade kernels you'd have to reboot anyway, so...

Yes a reboot was needed anyway.  But I'd have liked to delay that.

> > Also as an aside, while the stats about write errors are useful, in this
> > case it would be really good if there was a count of successful writes,
> > it would be useful to know if the successful write count was close to 0.
> > 
> >  My understanding of the BTRFS design is that there would be no
> > 
> > performance penalty for adding counts of the number of successful reads
> > and writes to the superblock.  Could this be done?
> 
> Not necessarily for reads, consider the case when the filesystem is read-
> only as my btrfs root filesystem is by default -- lots of reads but
> likely no writes and no super-block updates for the entire uptime.  But I
> believe you're correct for writes, since they'd ultimately update the
> superblocks anyway.

For the case of a read-only filesystem it's OK to skip read stats.  It would 
also be a bad idea to update read stats without writing data.  But there's no 
reason why read stats couldn't be accumulated in-memory and written out the 
next time something was written to disk.  That would give a slight inaccuracy 
in the case where there was a power failure after some period of reading 
without writing, but that's an unusual corner case.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
