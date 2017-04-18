Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46039 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752748AbdDRUV5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 16:21:57 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d0ZdE-0006lw-TO
        for linux-btrfs@vger.kernel.org; Tue, 18 Apr 2017 22:21:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs check --check-data-csum malfunctioning?
Date: Tue, 18 Apr 2017 20:21:43 +0000 (UTC)
Message-ID: <pan$bbd46$f7e1747b$a16558a6$33228918@cox.net>
References: <4b1b08de-9012-fb2a-eca1-a8adfdbf8e7b@o3-software.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Werner Braun posted on Tue, 18 Apr 2017 14:41:49 +0200 as excerpted:

> Hi,
> 
> i have a WD WD40EZRX with strange beaviour off btrfs check vs. btrfs
> scrub
> 
> running btrfs check --check-data-csum returns no errors on the disk
> 
> running btrfs scrub on the disk finds tons of errors

A dev could confirm this, but AFAIK from the comments on the patches I've 
seen going by, btrfs check --check-data-csum only checks that there's a 
valid copy available; that is, it stops as soon as it finds a valid copy, 
and if that's the first one, it won't check the second that's available 
in dup or raid1/10 mode.

A scrub of the full filesystem (as opposed to a single device, for those 
with more than one) will however check both copies and fix the second 
copy from the first, if necessary.

Of course this only applies to blocks that /have/ a second copy, that is, 
those in chunks that are raid1, raid10, or dup.   On a default single 
device btrfs, this will be metadata chunks in dup mode, not data chunks 
in single mode.

I think the low-memory-mode check may work differently than normal mode 
check in this regard, and as I said, this is based on the comments on 
patches going by, so it's possible the newest versions have changed this, 
but I'm not sure.

Meanwhile, it's worth noting that btrfs scrub calls in-kernel code to do 
the scrub, while check does everything in userspace, and the comments in 
the patches suggest the code has diverged, so it's not entirely 
surprising that the results differ.

Of course as Hugo mentions, scrub is done with the filesystem mounted, as 
well, and it's possible dio bypasses the normal buffered-write locking 
that prevents blocks from changing out from under scrub as it's doing its 
thing, allowing current direct-write access to screw things up in-
flight.  Check's userspace access is done with the filesystem unmounted, 
so that shouldn't be possible there, unless something's writing directly 
to the device itself, not thru the filesystem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

