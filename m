Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37383 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab3L2Mja (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Dec 2013 07:39:30 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VxFeS-0003IO-3T
	for linux-btrfs@vger.kernel.org; Sun, 29 Dec 2013 13:39:28 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2013 13:39:28 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2013 13:39:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is anyone using btrfs send/receive for backups instead of
 rsync?
Date: Sun, 29 Dec 2013 12:39:05 +0000 (UTC)
Message-ID: <pan$ac557$b59f1c0a$eeb339c8$e2df444@cox.net>
References: <20131228171943.GE19863@merlins.org>
	<20131228173730.GA7234@carfax.org.uk>
	<CAELSAVa=oVzrLnSSk+vnKQF46F7U5n6o8Nw9VGXkPQNCR2SVsA@mail.gmail.com>
	<CABR0jES_40xmVxi21+VUMzT_2ZuFWs9kUPfZAPZODq0rWrB0ug@mail.gmail.com>
	<CAELSAVY+J1GYuRDHwUZ882OVchqXk9ES9EJp89HQofC8m00uaQ@mail.gmail.com>
	<CABR0jERWpte3DAk+JCaybeGYRBtmUKEOoUzfAe=uC+k7KfdeQg@mail.gmail.com>
	<EF26DC97-2362-4C53-8B5F-4763A33375EC@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 28 Dec 2013 16:11:37 -0700 as excerpted:

> I am slightly bugged about a 16MB file having nearly 2000 extents,
> basically it's being turned into a bunch of 8KB fragments. I know
> nothing of the pros and cons of how systemd is writing journals, but
> they don't seem very big so I don't understand why they're preallocated,
> which on btrfs appears instantly defeated by COW upon the journal being
> modified. It seems to me either the journal doesn't need to be
> preallocated (at least on btrfs) or maybe systemd should set xattr +C on
> /var/log/journal?
> 
> That does disable checksumming though, along with data cow.

While I don't (yet?) use systemd here, from what I understand of its 
journal, it's essentially a binary database, and isn't necessarily even 
sequentially written as is traditional with log files.  That would 
explain the preallocation.  And given your mention of 8KB fragments, I 
wonder if that's its record-size?

Meanwhile, as with any pre-allocated-then-written-into file, including VM 
images and pre-allocated bittorrent files, the systemd journal is a known 
worst-case for COW filesystems including btrfs.

And setting NOCOW on the file (xattr +C) before those write-intos is the 
knob btrfs exposes to deal with the problem... for all the above cases.

Yes, it does turn off checksumming as well as COW, but given the write-
into scenario, that's actually best anyway, because otherwise btrfs has 
to keep updating the checksums as the internal writes are occurring, and 
that's both CPU intensive and potentially rate-limited, and an invitation 
to race conditions since the writing application and btrfs' checksumming 
are constantly lock-fighting, the one to update the file, the other to 
update the checksum based on the new data.

But in all these cases, it's also quite common for the application doing 
the writing to have its own checksumming/error-detection and possible 
correction -- it pretty much comes with the territory -- in which case 
btrfs attempting to do the same is simply superfluous even if it weren't 
a race-condition trigger.  Certainly torrents include checksumming -- 
that automatically guaranteed download integrity is part of what makes 
the protocol as popular as it is.  And databases too.  I don't actually 
know enough about VMs to know if it's the case there or not, but 
certainly, unexpected bit-flipping is likely to corrupt and crash the VM, 
just as it tends to do with on-the-metal operating systems.

If/when the file reaches effective stasis, as a torrented file once it's 
fully downloaded, /then/ it's reasonable to kill the NOCOW and do a final 
(sequential-write) copy/move so btrfs has it checksummed too.  And 
database and VM backups... if they're not being actively used, btrfs 
checksumming can guard against bitrot there too.  Similarly systemd's 
binary journal, once those are taken out of active logging, yeah, let 
btrfs do its normal thing.

But for all these cases, as long as the files are being actively written 
into, NOCOW, including its NOSUM implications, is exactly and precisely 
what they SHOULD be when the filesystem hosting them is btrfs.

And I'm predicting that since btrfs is the assumed successor to the ext* 
series as the Linux default filesystem, and systemd is targeting Linux 
default initsystem status as well, it's only logical that at some point 
systemd will detect what filesystem it's logging to, and will 
automatically set NOCOW on the journal file when that filesystem is 
btrfs.  Most Linux-targeted databases and file-preallocating torrent 
clients will no doubt do exactly the same thing.  Either that, or in 
their documentation, they'll suggest setting NOCOW on the target 
directory when setting up the app in the first place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

