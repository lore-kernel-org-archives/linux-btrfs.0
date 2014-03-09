Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45754 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaCIKY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Mar 2014 06:24:29 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Massive BTRFS performance degradation
Date: Sun, 09 Mar 2014 11:23:29 +0100
Message-ID: <1756989.4ep0Vdupld@tethys>
In-Reply-To: <3438733.p6vCjojJlH@merkaba>
References: <531C1CC4.701@gmail.com> <1553599.dDs6U900Vh@tethys> <3438733.p6vCjojJlH@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le dimanche 9 mars 2014 11:01:17 vous avez écrit :
> This ThinkPad T520 has been with BTRFS since installation of the Debian
> sid system on it with Kernel 2.6.39 or even 2.6.38 (where Sandybridge
> graphics didn´t work so well as today yet).
>
> So that much to any FUD about BTRFS and SSDs.

Wow !

Thanks for this very interesting info. Would you tell me if you use any of the 
SSD optimisation mount options: discard, ssd or ssd_spread ?

Myself I've been moving back and forth between BTRFS / ZFS ans ext4 over the 
past 2-3 years, each time giving a chance to BTRFS, then typically 3-4 months 
later switching back to either ext4 or ZFS after having either lost all of my 
data, or seen the filesystem slow down to the point it becomes unusable, beyond 
defragmentation or removing snapshots or whatever...

So my yo-yo-game is kind of "Is BTRFS now ready for use ?... Let's give it a 
chance... OMFG... Lost everything, unusable system... Never want to hear about 
BTRFS anymore... Wel... Maybe will come back next year... etc"

I've been used to consider for 3 years that :

- Next kernel release will have a truly excellent and mature BTRFS support.

- Current kernel release has correct BTRFS support - but most mainline distros 
don't have it yet, maybe in 6 months ?

- Previous kernel release (the one that all current distros come with) have a 
completely broke BTRFS support...

#LOL

Well I hope it's quite not the case anymore for I just installed my neighbour, 
old lady's system with a Linux Mint 16 (kernel 3.11) on BTRFS with skinny 
extents...

But for myself running ArchLinux in kernel 3.13, I still find out that :

- "btrfs send" causes my kernel to BUG :-/ (the wiki says it's working 
stuff...)
- btrfs-defrag.sgh hangs because of some glitch with "filefrag".
- bedup crashes badly and looks completely unmaintained as far as I can tell 
and nobody seems to care.

Soooo weeelllll... Looks like readiness for prime time is still ahead of us...

(But still my 2 main systems are now BTRFS, including my main storage machine 
running BTRFS RAID-1, so I hope it can be reliable, at least...)

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

