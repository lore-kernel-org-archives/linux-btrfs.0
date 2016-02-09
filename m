Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52149 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbcBIH3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Feb 2016 02:29:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aT2k4-0002YT-3M
	for linux-btrfs@vger.kernel.org; Tue, 09 Feb 2016 08:29:44 +0100
Received: from ip5f5ae057.dynamic.kabel-deutschland.de ([95.90.224.87])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 08:29:44 +0100
Received: from hurikhan77 by ip5f5ae057.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 08:29:44 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Use fast device only for metadata?
Date: Tue, 9 Feb 2016 08:29:33 +0100
Message-ID: <20160209082933.52273993@jupiter.sol.kaishome.de>
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba>
	<87twliri6m.fsf@thinkpad.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 08 Feb 2016 13:44:17 -0800
schrieb Nikolaus Rath <Nikolaus@rath.org>:

> On Feb 07 2016, Martin Steigerwald <martin@lichtvoll.de> wrote:
> > Am Sonntag, 7. Februar 2016, 21:07:13 CET schrieb Kai Krakow:
> >> Am Sun, 07 Feb 2016 11:06:58 -0800
> >> 
> >> schrieb Nikolaus Rath <Nikolaus@rath.org>:
> >> > Hello,
> >> > 
> >> > I have a large home directory on a spinning disk that I regularly
> >> > synchronize between different computers using unison. That takes
> >> > ages, even though the amount of changed files is typically
> >> > small. I suspect most if the time is spend walking through the
> >> > file system and checking mtimes.
> >> > 
> >> > So I was wondering if I could possibly speed-up this operation by
> >> > storing all btrfs metadata on a fast, SSD drive. It seems that
> >> > mkfs.btrfs allows me to put the metadata in raid1 or dup mode,
> >> > and the file contents in single mode. However, I could not find
> >> > a way to tell btrfs to use a device *only* for metadata. Is
> >> > there a way to do that?
> >> > 
> >> > Also, what is the difference between using "dup" and "raid1" for
> >> > the metadata?
> >> 
> >> You may want to try bcache. It will speedup random access which is
> >> probably the main cause for your slow sync. Unfortunately it
> >> requires you to reformat your btrfs partitions to add a bcache
> >> superblock. But it's worth the efforts.
> >> 
> >> I use a nightly rsync to USB3 disk, and bcache reduced it from 5+
> >> hours to typically 1.5-3 depending on how much data changed.
> >
> > An alternative is using dm-cache, I think it doesn´t need to
> > recreate the filesystem.
> 
> Yes, I tried that already but it didn't improve things at all. I
> wrote a message to the lvm list though, so maybe someone will be able
> to help.
> 
> Otherwise I'll give bcache a shot. I've avoided it so far because of
> the need to reformat and because of rumours that it doesn't work well
> with LVM or BTRFS. But it sounds as if that's not the case..

I'm myself using bcache+btrfs and it ran bullet proof so far, even
after unintentional resets or power outage. It's important tho to NOT
put any storage layer between bcache and your devices or between btrfs
and your device as there are reports it becomes unstable with md or lvm
involved. In my setup I can even use discard/trim without problems. I'd
recommend a current kernel, tho.

Since it requires reformatting, it's a big pita but it's worth the
efforts. It appeared, from its design, much more effective and stable
than dmcache. You could even format a bcache superblock "just in case",
and add an SSD later. Without SSD, bcache will just work in passthru
mode. Actually, I started to format all my storage with bcache
superblock "just in case". It is similar to having another partition
table folded inside - so it doesn't hurt (except you need bcache-probe
in initrd to detect the contained filesystems).

-- 
Regards,
Kai

Replies to list-only preferred.


