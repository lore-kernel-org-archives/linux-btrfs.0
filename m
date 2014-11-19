Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36089 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbaKSDG6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 22:06:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xqvbd-0008NB-4k
	for linux-btrfs@vger.kernel.org; Wed, 19 Nov 2014 04:06:57 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 04:06:57 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 04:06:57 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs on a failing drive
Date: Wed, 19 Nov 2014 03:06:45 +0000 (UTC)
Message-ID: <pan$4d12d$ac36086c$dc5d83e5$8040fa67@cox.net>
References: <CAD1x5BB5uevNP4wUsp+2tgVhofGr53QTURunsiM-4ico95R9vQ@mail.gmail.com>
	<546A9E0F.4070108@ubuntu.com>
	<CAD1x5BDJhZ6a=91G8+UzLTY+Oik7MVpr-XGKOQrOnXpkRLjwug@mail.gmail.com>
	<546B676E.6040305@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Phillip Susi posted on Tue, 18 Nov 2014 10:36:14 -0500 as excerpted:

> As I said before though, the errors you posted from dmesg don't indicate
> that the drive failed to read sectors, but rather that it returned
> incorrect data, and this is *NEVER* supposed to happen.
> 
> I'd suggest running a few passes of badblocks over the drive, testing
> writing different patterns and verifying that they read back correctly.

+1 for badblocks! =:^)

Tho a hint if you decide to test multiple drives as I did some years 
ago.  Doing a multiple passes (I'd suggest at least two) on a full drive 
can take QUITE some time (days), due to the shear volume of data to be 
written to the drive, then read back to verify, then written as a new 
pattern and read back again.

But unlike IDE, the bottleneck on at least spinning rust SATA (well, 
unless you go heavy port-multiplier) tends to be the platters themselves, 
not the buses as they're point-to-point now days, or the controllers.  
Generally you can process four or more drives in parallel without slowing 
down the individual results significantly at all.  Thus, while it takes 
days to test a single drive, it normally takes the same time to process 
four drives in parallel!  So if you have 4+ devices to badblocks-test, 
definitely setup four (perhaps more, depending on hardware layout) 
instances of badblocks running at once, one to each of the devices.  Cut 
your time for all four done serially to say 8 days, to only two days when 
done in parallel! =:^)

Of course good SSDs tend to be both many times faster and several times 
smaller in capacity, so a badblocks run on them should be MUCH faster, 
perhaps a couple hours vs a couple days, and much less parallelizable 
without slowing all of them down, since they tend to saturate the bus or 
close to it (the reason fast SATA-based SSDs all tend to rate similarly 
speed-wise, the SATA bus is the bottleneck and the PCI-E bus isn't /that/ 
far behind!, tho the PCIE bus can be /enough/ faster to give direct PCIE-
interface SSDs a definite speed boost over top-of-the-line SATA interface 
devices... for those that can afford their accordingly higher prices).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

