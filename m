Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59427 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbdJOMFk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Oct 2017 08:05:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e3hfd-00073g-Pq
        for linux-btrfs@vger.kernel.org; Sun, 15 Oct 2017 14:05:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
Date: Sun, 15 Oct 2017 12:05:20 +0000 (UTC)
Message-ID: <pan$ab30f$50fa7dd5$4020df3f$7f597abb@cox.net>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
        <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zoltán Ivánfi posted on Sun, 15 Oct 2017 10:30:52 +0200 as excerpted:

> You assumed correctly that what I really wanted to ask about was btrfs
> on SATA+USB, thanks for answering that questions as well. Based on your
> replies I feel assured that btrfs should not be affected by this
> particular issue due to operating on the filesystem level and not on the
> block device level; but USB connectivity issues can still lead to
> problems.
> 
> Do these USB connectivity issues lead to data corruption? Naturally for
> raid0 they will, but for raid1 I suppose they shouldn't as one copy of
> the data remains intact.

FWIW, the problems I've /personally/ had with raid1 here, on both mdraid 
and btrfs raid, 100% SATA connections on both, with older SATA-1 spinning 
rust for the mdraid, and newer SSDs for btrfs raid, have to do with 
suspend to RAM, or hibernate (suspend to disk).  I finally gave up on 
it.  The problem is that in resume, one device is inevitably slower than 
the others to come back up, and will often get kicked from the array.

On original bootup there's a mechanism that waits for all devices, but 
apparently it's not activated on resume from suspend-to-RAM.  With mdraid 
(longer ago, with a machine that would hibernate but not suspend to ram) 
the device can be readded and will resync.  Btrfs (as of a couple years 
ago anyway, with a machine that would suspend to RAM but I've not 
actually tried hibernate as I've not configured a swap partition to 
suspend to) remains a bit behind in that area, however, and the slow 
device remains unsynced, eventually forcing a full reboot, where it comes 
up with the raid, but still must be manually synced via a btrfs scrub.  
Since I end up having to reboot and do a manual sync anyway, it's simply 
not worth doing suspend-to-ram in the first place, and I've started just 
shutting down or leaving the machine running.  That seems to work much 
better for both cases.

I've not personally tried raid1 (of either btrfs or mdraid) on USB, so I 
have no personal experience there, but as I said, we do get more reports 
of problems with USB-connected btrfs raid, than with SATA.  Most of the 
problems are fixable, and the reports have lessened as btrfs has matured, 
but I'd not recommend it or consider it worth the hassle.

What I'd recommend instead, if USB connectivity is all that's available 
(as with many appliance-type machines, my router, for instance, tho I'm 
not actually using the feature there), is larger capacity, then use btrfs 
in dup mode so it gets to use btrfs checksumming not just for error 
detection, but correction as well (a big advantage of both raid1 and dup 
mode), and do actual backups to other devices.  (Btrfs send/receive can 
be used for the backups, tho here I just alternate backups and use a 
simpler mkfs and midnight-commander copying with btrfs lzo compression.)

I tend to heavily partition and use smaller, independent btrfs anyway, 
over the huge multi-TB single btrfs that other people seem to favor, so a 
4 TB single device in dup mode for 2 TB capacity is larger by an order of 
magnitude than any of my filesystems (I'd certainly partition up anything 
that big, even for dup mode), tho I can imagine a 4 TB device in dup mode 
for 2 TB capacity would cramp the style of some users.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

