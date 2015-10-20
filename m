Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:58734 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbJTNPy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 09:15:54 -0400
From: Russell Coker <russell@coker.com.au>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
Date: Wed, 21 Oct 2015 00:15:54 +1100
Cc: james harvey <jamespharvey20@gmail.com>, linux-btrfs@vger.kernel.org
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com> <201510201545.50705.russell@coker.com.au> <56263B0B.4050502@gmail.com>
In-Reply-To: <56263B0B.4050502@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201510210015.54337.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 21 Oct 2015 12:00:59 AM Austin S Hemmelgarn wrote:
> > https://www.gnu.org/software/ddrescue/
> > 
> > At this stage I would use ddrescue or something similar to copy data from
> > the failing disk to a fresh disk, then do a BTRFS scrub to regenerate
> > the missing data.
> > 
> > I wouldn't remove the disk entirely because then you lose badly if you
> > get another failure.  I wouldn't use a BTRFS replace because you already
> > have the system apart and I expect ddrescue could copy the data faster. 
> > Also as the drive has been causing system failures (I'm guessing a
> > problem with the power connector) you REALLY don't want BTRFS to corrupt
> > data on the other disks.  If you have a system with the failing disk and
> > a new disk attached then there's no risk of further contamination.
> 
> BIG DISCLAIMER: For the filesystem to be safely mountable it is
> ABSOLUTELY NECESSARY to remove the old disk after doing a block level

You are correct, my message wasn't clear.

What I meant to say is that doing a "btrfs device remove" or "btrfs replace" 
is generally a bad idea in such a situation.  "btrfs replace" is pretty good 
if you are replacing a disk with a larger one or replacing a disk that has 
only minor errors (a disk that just gets a few bad sectors is unlikely to get 
many more in a hurry).

> copy of it.  By all means, keep the disk around, but do not keep it
> visible to the kernel after doing a block level copy of it.  Also, you
> will probably have to run 'btrfs device scan' after copying the disk and
> removing it for the filesystem to work right.  This is an inherent
> result of how BTRFS's multi-device functionality works, and also applies
> to doing stuff like LVM snapshots of BTRFS filesystems.

Good advice.  I recommend just rebooting the system.  I think that if anyone 
who has the background knowledge to do such things without rebooting will 
probably just do it without needing to ask us for advice.

> >> Question 2 - Before having ran the scrub, booting off the raid with
> >> bad sectors, would btrfs "on the fly" recognize it was getting bad
> >> sector data with the checksum being off, and checking the other
> >> drives?  Or, is it expected that I could get a bad sector read in a
> >> critical piece of operating system and/or kernel, which could be
> >> causing my lockup issues?
> > 
> > Unless you have disabled CoW then BTRFS will not return bad data.
> 
> It is worth clarifying also that:
> a. While BTRFS will not return bad data in this case, it also won't
> automatically repair the corruption.

Really?  If so I think that's a bug in BTRFS.  When mounted rw I think that 
every time corruption is discovered it should be automatically fixed.

> b. In the unlikely event that both copies are bad, trying to read the
> data will return an IO error.
> c. It is theoretically possible (although statistically impossible) that
> the block could become corrupted, but the checksum could still be
> correct (CRC32c is good at detecting small errors, but it's not hard to
> generate a hash collision for any arbitrary value, so if a large portion
> of the block goes bad, then it can theoretically still have a valid
> checksum).

It would be interesting to see some research into how CRC32 fits with the more 
common disk errors.  For a disk to return bad data and claim it to be good the 
data must either be a misplaced write or read (which is almost certain to be 
caught by BTRFS as the metadata won't match), or a random sector that matches 
the disk's CRC.  Is generating a hash collision for a CRC32 inside a CRC 
protected block much more difficult?

> >> Question 3 - Probably doesn't matter, but how can I see which files
> >> (or metadata to files) the 40 current bad sectors are in?  (On extX,
> >> I'd use tune2fs and debugfs to be able to see this information.)
> > 
> > Read all the files in the system and syslog will report it.  But really
> > don't do that until after you have copied the disk.
> 
> It may also be possible to use some of the debug tools from BTRFS to do
> this without hitting the disks so hard, but it will likely take a lot
> more effort.

I don't think that you can do that without hitting the disks hard.

That said last time I checked (last time an executive of a hard drive 
manufacturer was willing to talk to me) drives were apparently designed to 
perform any sequence of operations for their warranty period.  So for a disk 
that is believed to be good this shouldn't be a problem.  For a disk that is 
known to be dying it would be a really bad idea to do anything other than copy 
the data off at maximum speed.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
