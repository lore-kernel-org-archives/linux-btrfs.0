Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:41552 "EHLO
	cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934499AbcA1Ulv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 15:41:51 -0500
Received: from coach.student.rit.edu (coach.student.rit.edu [129.21.178.64])
	by cartman.routify.me (Postfix) with ESMTPSA id 1616A81F93
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 15:41:51 -0500 (EST)
Date: Thu, 28 Jan 2016 15:41:49 -0500
From: Sean Greenslade <sean@seangreenslade.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID1 disk upgrade method
Message-ID: <20160128204149.GA11985@coach.student.rit.edu>
References: <20160127224549.GA4891@fox.rh.rit.edu>
 <20160127235528.GA5498@fox.rh.rit.edu>
 <56AA0A0A.1060807@gmail.com>
 <20160128153756.GA19617@fox.rh.rit.edu>
 <CAJCQCtRQZOM3cYiG_KyJYWRS-OR7Q+xMm6o1vBD6BTy=Eb2MUw@mail.gmail.com>
 <20160128184736.GB1167@fox.rh.rit.edu>
 <56AA6E17.3060104@gmail.com>
 <CAJCQCtTJ75C2vz0b6v_=qzV304FyhR3q5CdPDqCsRD8U2kspMw@mail.gmail.com>
 <56AA70DC.1000201@gmail.com>
 <CAJCQCtR=+H94a=6H4=RPSpFb8GWN1g26NMhrwat9bgLWHYuZiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtR=+H94a=6H4=RPSpFb8GWN1g26NMhrwat9bgLWHYuZiA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 28, 2016 at 01:24:07PM -0700, Chris Murphy wrote:
> >> How about something like:
> >>
> >> # hdparm -Y /dev/sdb
> >> # echo 1 /sys/block/sdb/device/delete
> >>
> >> Then physically disconnect the drive, assuming hot-plug is supported
> >> by all hardware?
> >>
> > That should safely disconnect the device, but you may still have to touch
> > some of the PM related stuff in the /sys/class/ directories for the disk
> > itself, and possibly do something to force it to flush the write cache
> > (toggling the write cache off then back on again usually does this).
> 
> Interesting, I figured a umount should include telling the drive to
> flush the write cache; but maybe not, if the drive or connection (i.e.
> USB enclosure) doesn't support FUA?
> 
> I wonder what the kernel sends to the device on restart/poweroff?

Yes, I did neglect to mention that. Wherever I said eject, I meant "send
1 to /sys delete, wait for drive to spin down, then remove." I also
unmount all partitions that are on that disk.

It's not an enclosure, it's hot-swap sata ports on the motherboard.

--Sean

