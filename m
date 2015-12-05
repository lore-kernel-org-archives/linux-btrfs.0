Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57882 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbbLENTY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Dec 2015 08:19:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a5CkE-0003Na-If
	for linux-btrfs@vger.kernel.org; Sat, 05 Dec 2015 14:19:22 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Dec 2015 14:19:22 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Dec 2015 14:19:22 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Subvolume UUID, data corruption?
Date: Sat, 5 Dec 2015 13:19:16 +0000 (UTC)
Message-ID: <pan$7e229$ce87d3b$b8d75c44$337e15c7@cox.net>
References: <20151204120529.37E47D5A28@emkei.cz>
	<20151204130758.GR8775@carfax.org.uk>
	<1449286104.18841.14.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sat, 05 Dec 2015 04:28:24 +0100 as
excerpted:

> On Fri, 2015-12-04 at 13:07 +0000, Hugo Mills wrote:
>> I don't think it'll cause problems.
> Is there any guaranteed behaviour when btrfs encounters two filesystems
> (i.e. not talking about the subvols now) with the same UUID?
> 
> Given that it's long standing behaviour that people could clone
> filesystems (dd, etc.) and this just worked™, btrfs should at least
> handle such case gracefully.
> For example, when already more than one block device with a btrfs of the
> same UUID are known, then it should refuse to mount any of them.
> 
> And if one is already known and another device pops up it should refuse
> to mount that and continue to normally use the already mounted one.

The problem with btrfs is that because (unlike traditional filesystems) 
it's multi-device, it needs some way to identify what devices belong to a 
particular filesystem.

And UUID is, by definition and expansion, Universally Unique ID.  Btrfs 
simply depends on it being what it says on the the tin, universally 
unique, to ID the components of the filesystem and assemble them 
correctly.

Besides dd, etc, LVM snapshots are another case where this goes screwy.  
If the UUID isn't UUID, do a btrfs device scan (which udev normally does 
by default these days) so the duplicate UUID is detected, and btrfs 
*WILL* eventually start trying to write to all the "newly added" devices 
that scan found, identified by their Universally Unique IDs, aka UUIDs.  
It's not a matter of if, but when.


And the UUID is embedded so deeply within the filesystem and its 
operations, as an inextricable part of the metadata (thus avoiding the 
problem reiserfs had where a reiserfs stored in a loopback file on a 
reiserfs, would screw up reiserfsck, on btrfs, the loopback file would 
have a different UUID and thus couldn't be mixed up), that changing the 
UUID is not the simple operation of changing a few bytes in the superblock 
that it is on other filesystems, which is why there's now a tool to go 
thru all those metadata entries and change it.


So an aware btrfs admin simply takes pains to avoid triggering a btrfs 
device scan at the wrong time, and to immediately hide their LVM 
snapshots, immediately unplug their directly dd-ed devices, etc, and thus 
doesn't have to deal with the filesystem corruption that'd be a when not 
if, if they didn't take such precautions with their dupped UUIDs that 
actually aren't as UUID as the name suggests...

And as your followup suggests in a security context, they consider 
masking out their UUIDs before posting them, as well, tho most kernel 
hackers generally consider unsupervised physical access to be game-over, 
security-wise.  (After all, in that case there's often little or nothing 
preventing a reboot to that USB stick, if desired, or simply yanking the 
devices and duping them or plugging them in elsewhere, if the BIOS is 
password protected, with the only thing standing in the way at that point 
being possible device encryption.)


The UUID *as* a UUID, _unique_ at least on that system (if not actually 
universally) as it says on the tin, is so deeply embedded in btrfs that 
at this point it's not going to be removed.  The only real alternative if 
you don't like it is using a different filesystem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

