Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33759 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbbF2IIb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 04:08:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z9U78-0000St-09
	for linux-btrfs@vger.kernel.org; Mon, 29 Jun 2015 10:08:26 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 10:08:25 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 10:08:25 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs replace seems to corrupt the file system
Date: Mon, 29 Jun 2015 08:08:20 +0000 (UTC)
Message-ID: <pan$36112$278c5ce$95ee5224$7ba3d78f@cox.net>
References: <CA+xOVSOD1YY-=Cm+vmzTUV9cHe9idtDkRr0RmpRP5a0Z6eC4YQ@mail.gmail.com>
	<CA+xOVSNu547eo6TY_mwLypTGWuE5AmyMqC6GwR06Sir1282vqA@mail.gmail.com>
	<CAJCQCtSv15DVDju7vhm=Luc5hqWvce__F7iovh87uxq37bNg0Q@mail.gmail.com>
	<CA+xOVSMjO0e5TPfksr=TmnT9zc5=hJemYPtn_tg+xxsWbFMV=A@mail.gmail.com>
	<CADfjVrhmUhWAs0+6_s-hDcoLyrXdvkY1fZgoKv2VRDt2F8MWhQ@mail.gmail.com>
	<CA+xOVSOxTnRpfxnw=FpizBNGJmdi5y_aEPRZqHos6W5u4=HgbQ@mail.gmail.com>
	<CAJCQCtTv+yAQAQsBrbWEFo4_i0_tUUtbxwU1R4xDDhPTzQNGAQ@mail.gmail.com>
	<CA+xOVSMgqwOGxdhAjEZQHOCNhaJs-g2ieDE7qss8skyF4=shkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mordechay Kaganer posted on Mon, 29 Jun 2015 08:02:01 +0300 as excerpted:

> On Sun, Jun 28, 2015 at 10:32 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
>> On Sun, Jun 28, 2015 at 1:20 PM, Mordechay Kaganer <mkaganer@gmail.com>
>> wrote:
>>
>> Use of dd can cause corruption of the original.
>>
> But doing a block-level copy and taking care that the original volume is
> hidden from the kernel while mounting the new one is safe, isn't it?

As long as neither one is mounted while doing the copy, and one or the 
other is hidden before an attempt to mount, it should be safe, yes.

The base problem is that btrfs can be multi-device, and that it tracks 
the devices belonging to the filesystem based on UUID, so as soon as it 
sees another device with the same UUID, it considers it part of the same 
filesystem.  Writes can go to any of the devices it considers a component 
device, and after a write creates a difference, reads can end up coming 
from the stale one.

Meanwhile, unlike many filesystems, btrfs uses the UUID as part of the 
metadata, so changing the UUID isn't as simple as rewriting a superblock; 
the metadata must be rewritten to the new UUID.  There's actually a tool 
now available to do just that, but it's new enough I'm not even sure it's 
available in release form yet; if so, it'll be latest releases.  
Otherwise, it'd be in integration branch.

And FWIW a different aspect of the same problem can occur in raid1 mode, 
when a device drops out and is later reintroduced, with both devices 
separately mounted rw,degraded and updated in the mean time.  Normally, 
btrfs will track the generation, a monotonically increasing integer, and 
will read from the higher/newer generation, but with separate updates to 
each, if they both happen to have the same generation at reunite...

So for raid1 mode, the recommendation is that if there's a split and one 
continues to be updated, be sure the other one isn't separately mounted 
writable and then the two combined again, or if both must be separately 
mounted writable and then recombined, wipe the one and add it as a new 
device, thus avoiding the possibility of confusion.

> Anyway, what is the "strait forward" and recommended way of replacing
> the underlying device on a single-device btrfs not using any raid
> features? I can see 3 options:
> 
> 1. btrfs replace - as far as i understand, it's primarily intended for
> replacing the member disks under btrfs's raid.

It seems this /can/ work.  You demonstrated that much.  But I'm not sure 
whether btrfs replace was actually designed to do the single-device 
replace.  If not, it almost certainly hasn't been tested for it.  Even if 
so, I'm sure I'm not the only one who hadn't thought of using it that 
way, so while it might have been development-tested for single-device-
replace, it's unlikely to have had the same degree of broader testing of 
actual usage, simply because few even thought of using it that way.

Regardless, you seem to have flushed out some bugs.  Now that they're 
visible and the weekend's over, the devs will likely get to work tracing 
them down and fixing them.

> 2, Add a new volume, then remove the old one. Maybe this way we'll need
> to do a full balance after that?

This is the alternative I'd have used in your scenario (but see below).  
Except a manual balance shouldn't be necessary.  The device add part 
should go pretty fast as it would simply make more space available.  The 
device remove will go much slower as in effect it'll trigger that 
balance, forcing everything over to the just added pretty much empty 
device.

You'd do a manual balance if you wanted to convert to raid or some such, 
but from single device to single device, just the add/remove should do it.

> 3. Block-level copy of the partition, then hide the original from the
> kernel to avoid confusion because of the same UUID. Of course, this way
> the volume is going to be off-line until the copy is finished.

This could work too, but in addition to being forced to keep the 
filesystem offline the entire time, the block-level copy will copy any 
problems, etc, too.


But what I'd /prefer/ to do would be to take the opportunity to create a 
new filesystem, possibly using different mkfs.btrfs options or at least 
starting new with a fresh filesystem and thus eliminating any as yet 
undetected or still developing problems with the old filesystem.  Since 
the replace or device remove will end up rewriting everything anyway, 
might as well make a clean break and start fresh, would be my thinking.

You could then use send/receive to copy all the snapshots, etc, over.  
Currently, that would need to be done one at a time, but there's 
discussion of adding a subvolume-recursive mode.

Tho while on the subject of snapshots, it should be noted that btrfs 
operations such as balance don't scale so well with tens of thousands of 
snapshots.  So the recommendation is to try to keep it to 250 snapshots 
or so per subvolume, under 2000 snapshots total, if possible, which of 
course at 250 per would be 8 separate subvolumes.  You can go above that 
to 3000 or so if absolutely necessary, but if it reaches near 10K, expect 
more problems in general, and dramatically increased memory and time 
requirements, for balance, check, device replace/remove, etc.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

