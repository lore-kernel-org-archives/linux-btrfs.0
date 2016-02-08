Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51100 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbcBHBEa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Feb 2016 20:04:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aSaFe-0008OK-Ca
	for linux-btrfs@vger.kernel.org; Mon, 08 Feb 2016 02:04:26 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Feb 2016 02:04:26 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Feb 2016 02:04:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Use fast device only for metadata?
Date: Mon, 8 Feb 2016 01:04:21 +0000 (UTC)
Message-ID: <pan$47bb8$3ee33232$868a6132$8161e79b@cox.net>
References: <874mdktk4t.fsf@vostro.rath.org>
	<20160207210713.7e4661a8@jupiter.sol.kaishome.de>
	<1507413.RERLDqpHyU@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sun, 07 Feb 2016 21:59:48 +0100 as excerpted:

> Am Sonntag, 7. Februar 2016, 21:07:13 CET schrieb Kai Krakow:
>> Am Sun, 07 Feb 2016 11:06:58 -0800
>> 
>> schrieb Nikolaus Rath <Nikolaus@rath.org>:
>>> 
>>> I have a large home directory on a spinning disk that I regularly
>>> synchronize between different computers using unison. That takes
>>> ages, even though the amount of changed files is typically small.
>>> I suspect most if the time is spend walking through the file system
>>> and checking mtimes.
>>> 
>>> So I was wondering if I could possibly speed-up this operation by
>>> storing all btrfs metadata on a fast, SSD drive. It seems that
>>> mkfs.btrfs allows me to put the metadata in raid1 or dup mode, and
>>> the file contents in single mode. However, I could not find a way to
>>> tell btrfs to use a device *only* for metadata. Is there a way to do
>>> that?

As with the others, I'd recommend bcache or dmcache.  Which one is up to 
you, but AFAIK, bcache has more on-list users and is thus potentially 
better tested with btrfs and easier to find someone to compare btrfs-on-
XXcache notes with, if you find you need to.

>>> Also, what is the difference between using "dup" and "raid1" for the
>>> metadata?

Dup is 2X on a single device and is the single-device metadata default on 
spinning rust (single is the default for single-device on SSDs, primarily 
due to some SSD firmware doing dedup already, in which case dup wouldn't 
do anything but take more CPU time).

Raid1 is 2X on multiple devices, with the allocator ensuring the two 
copies don't end up on the same device.  It's the metadata default on 
multi-device.

>> You may want to try bcache. [...] I use a nightly rsync to USB3 disk,
>> and bcache reduced it from 5+ hours to typically 1.5-3 depending on
>> how much data changed.
> 
> An alternative is using dm-cache, I think it doesn´t need to recreate
> the filesystem.
> 
> I wonder what happened to the VFS hot data tracking stuff patchset
> floating around here quite some time ago.

AFAIK it's still around, and very possibly in-use by some major user.  I 
believe it's still on the btrfs roadmap and should eventually be 
mainlined, but with bcache and dmcache maturing now, there's not the 
pressing need for it to be btrfs-built-in that there was before.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

