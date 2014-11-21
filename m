Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60593 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbaKUGXL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 01:23:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xrhcc-0000Xb-GT
	for linux-btrfs@vger.kernel.org; Fri, 21 Nov 2014 07:23:10 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 07:23:10 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 07:23:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Fri, 21 Nov 2014 06:22:57 +0000 (UTC)
Message-ID: <pan$29e1e$f368f5df$85fe86e7$dd12c3b5@cox.net>
References: <54699CC7.1050909@swiftspirit.co.za>
	<546A46A5.8030603@inwind.it>
	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
	<CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
	<27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Thu, 20 Nov 2014 23:28:14 -0500 as excerpted:

> On Wed, Nov 19, 2014 at 10:20:17AM -0500, Phillip Susi wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>> 
>> On 11/18/2014 9:54 PM, Chris Murphy wrote:
>> > Why is it silly? Btrfs on a thin volume has practical use case aside
>> > from just being thinly provisioned, its snapshots are block device
>> > based, not merely that of an fs tree.
>> 
>> Umm... because one of the big selling points of btrfs is that it is in
>> a much better position to make snapshots being aware of the fs tree
>> rather than doing it in the block layer.
> 
> One of the big selling points of LVM is that it is in a much better
> position to make snapshots so you can run btrfsck on the shattered
> remains of your broken btrfs filesystem.
> 
> The UUID-driven behavior of btrfs is _really extremely annoying_.
> No other filesystem forces me to jump through the hoops btrfs does to
> get routine admin tasks done.
> 
> e.g. if an ext4 filesystem explodes, I can:
> 
> 	1.  make a LVM snapshot of the broken filesystem
> 
> 	2.  run e2fsck on the snapshot
> 
> 	3.  mount and repair the snapshot, e.g. rsync any missing files 
from
> 	backups, salvage anything that survived
> 
> 	4.  LVM merge the snapshot to its origin volume
> 
> 	5.  umount the origin volume and mount the merged volume (or just
> 	reboot)
> 
> ...and I can do all of this on a running system, in-place, with only a
> few minutes of downtime in the must-reboot case.
> 
> None of the above works with btrfs at all.  Multi-device btrfs fails at
> 2,
> and mounting the filesystem fails at 3.  The closest I've gotten to this
> workflow is to set up a kvm instance that can see only the LVM
> snapshots, (only) and run the btrfsck or rsync there--and hope that the
> system doesn't crash and reboot during that time, or the filesystem will
> be more or less destroyed by the random combination of origin and
> snapshot LVs.
> 
> I've also learned the hard way to always make an LVM snapshot before
> running btrfsck, just in case you discover a new btrfsck bug with your
> filesystem.  That at least works for single-device btrfs filesystems.

When I have such a filesystem level problem, I simply dd from the backing 
device to some other location, generally to a file that's on a different 
filesystem (preferrably non-btrfs, I use reiserfs as I've found it very 
resilient, here), in which case btrfs device scan won't see the UUID on 
the copy as it scans block devices, not inside non-device files.

After all, an LVM block-level snapshot takes the same space as a file 
containing the same raw data, and if there's room for the data in an LVM 
snapshot, given a different layout, there's room for exactly the same 
amount of data as a file on a different filesystem, piped thru some 
compressor if necessary due to tight datasize constraints.

But while other filesystems might allow un-UUIDs (heh, UUUIDs or U3IDs 
=:^), because they're no longer unique, requiring them to be unique just 
as the label says cannot be considered a bug.  It's simply stricter 
enforcement of the rules, which are, after all, plainly stated in the 
descriptive name.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

