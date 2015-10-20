Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:55935 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbbJTEpx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 00:45:53 -0400
From: Russell Coker <russell@coker.com.au>
To: james harvey <jamespharvey20@gmail.com>
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
Date: Tue, 20 Oct 2015 15:45:50 +1100
Cc: linux-btrfs@vger.kernel.org
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
In-Reply-To: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201510201545.50705.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 20 Oct 2015 03:16:15 PM james harvey wrote:
> sda appears to be going bad, with my low threshold of "going bad", and
> will be replaced ASAP.  It just developed 16 reallocated sectors, and
> has 40 current pending sectors.
> 
> I'm currently running a "btrfs scrub start -B -d -r /terra", which
> status on another term shows me has found 32 errors after running for
> an hour.

https://www.gnu.org/software/ddrescue/

At this stage I would use ddrescue or something similar to copy data from the 
failing disk to a fresh disk, then do a BTRFS scrub to regenerate the missing 
data.

I wouldn't remove the disk entirely because then you lose badly if you get 
another failure.  I wouldn't use a BTRFS replace because you already have the 
system apart and I expect ddrescue could copy the data faster.  Also as the 
drive has been causing system failures (I'm guessing a problem with the power 
connector) you REALLY don't want BTRFS to corrupt data on the other disks.  If 
you have a system with the failing disk and a new disk attached then there's 
no risk of further contamination.

> Question 2 - Before having ran the scrub, booting off the raid with
> bad sectors, would btrfs "on the fly" recognize it was getting bad
> sector data with the checksum being off, and checking the other
> drives?  Or, is it expected that I could get a bad sector read in a
> critical piece of operating system and/or kernel, which could be
> causing my lockup issues?

Unless you have disabled CoW then BTRFS will not return bad data.

> Question 3 - Probably doesn't matter, but how can I see which files
> (or metadata to files) the 40 current bad sectors are in?  (On extX,
> I'd use tune2fs and debugfs to be able to see this information.)

Read all the files in the system and syslog will report it.  But really don't 
do that until after you have copied the disk.

> I do have hourly snapshots, from when it was properly running, so once
> I'm that far in the process, I can also compare the most recent
> snapshots, and see if there's any changes that happened to files that
> shouldn't have.

Snapshots refer to the same data blocks, so if a data block is corrupted in a 
way that BTRFS doesn't notice (which should be almost impossible) then all 
snapshots will have it.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
