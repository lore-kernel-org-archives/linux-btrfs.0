Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53893 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaKZDWm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 22:22:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XtTBg-00047G-VN
	for linux-btrfs@vger.kernel.org; Wed, 26 Nov 2014 04:22:40 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 04:22:40 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 04:22:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Wed, 26 Nov 2014 03:22:29 +0000 (UTC)
Message-ID: <pan$8a1fe$cae59052$c5e19c35$9858d5fc@cox.net>
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>
	<5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org>
	<5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org>
	<5474FBD9.5070709@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Tue, 25 Nov 2014 22:59:53 +0100 as
excerpted:

> However I still doesn't understood why you want btrfs-w/multiple disk
> over LVM ?

While I'm not an LVM person here, and he already replied with essentially 
the same point, I think it's worth repeating...

Btrfs' checksummed error detection and automatic rewrite from a different 
copy isn't a small thing, and simply isn't available at all with most 
would-be alternatives (zfs being the only similar thing I know of for 
Linux, and of course it has its own issues both technical and social/
legal/license).  That alone is worth running multi-device btrfs to get.  
That makes btrfs a near-mandatory part of the picture, whatever it's on.

And for people wanting LVM's volume management (including partitioning 
without many of the limitations), the direct result is multi-device btrfs 
on lvm.

>From my perspective, however, btrfs is simply incompatible with lvm 
snapshots, because the basic assumptions are incompatible.  Btrfs assumes 
UUIDs will be exactly what they say on the label, /unique/, while lvm's 
snapshot feature directly breaks that uniqueness by copying the (former) 
UUID, thus making the former UUID no longer unique and thus no longer 
truly UUID.  Thus, part of the lvm /feature/ of snapshots is in direct 
contradiction to a basic assumption of btrfs, that UUIDs are exactly 
that, unique, making that feature directly incompatible with btrfs on a 
very basic level.

So people can have their btrfs on lvm, but if they do, they have to forego 
LVM snapshots because btrfs isn't compatible with their usage.  To me 
it's as simple as that, and people can choose either btrfs or lvm 
snapshots, but not both, it's one XOR the other.  So for me it's simply 
choose the one you will have the most difficulty doing without and forgo 
the other one.  Not a problem, just make your choice and move on.

OTOH, there's that common signature about the reasonable man folding to 
the circumstance while the unreasonable man insisting on folding the 
circumstance to his wishes instead, so progress depends on the 
unreasonable man...

But that's exactly what I see here, an unreasonable man insisting that 
entirely logical circumstance bend to his will.  Which, given someone to 
actually code it up, it might well do. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

