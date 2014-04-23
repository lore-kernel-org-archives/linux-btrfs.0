Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45988 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaDWDSw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 23:18:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wcnhy-0004OT-89
	for linux-btrfs@vger.kernel.org; Wed, 23 Apr 2014 05:18:50 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 05:18:50 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 05:18:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Slow Write Performance w/ No Cache Enabled and Different Size
 Drives
Date: Wed, 23 Apr 2014 03:18:34 +0000 (UTC)
Message-ID: <pan$d444b$cef389d2$82cdb021$b6eb95b4@cox.net>
References: <53540367.4050707@aeb.io>
	<D954AF21-BC14-4ADC-9C62-254753AF1998@colorremedies.com>
	<5354A4EA.3000209@aeb.io> <pan$ced8d$1ee3475f$a3c53cfd$a3dfb247@cox.net>
	<BDB8ED64-0A92-4C22-A07D-C06D790410ED@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 22 Apr 2014 11:42:09 -0600 as excerpted:


> On Apr 21, 2014, at 3:09 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> Adam Brenner posted on Sun, 20 Apr 2014 21:56:10 -0700 as excerpted:
>> 
>>> So ... BTRFS at this point in time, does not actually "stripe" the
>>> data across N number of devices/blocks for aggregated performance
>>> increase (both read and write)?
>> 
>> What Chris says is correct, but just in case it's unclear as written,
>> let me try a reworded version, perhaps addressing a few uncaught
>> details in the process.
> 
> Another likely problem is terminology. It's 2014 and still we don't have
> consistency in basic RAID terminology.

> It's not immediately obvious to the btrfs newcomer that the md raid
> chunk isn't the same thing as the btrfs chunk, for example.
> 
> And strip, chunk, stripe unit, and stripe size get used interchangeably
> to mean the same thing, while just as often stripe size means something
> different.

FWIW, I did hesitate at one point, then used "stripe" for what I guess 
should have been strip or stripe-unit, after considering and rejecting 
"chunk" as already in use.

But in any case, while btrfs single mode is distinct from btrfs raid0 
mode, and because the minimum single-mode unit is 1 GiB and thus too 
large to do practical raid0, on multiple devices btrfs single mode does 
in fact end up in a sort of raid0 layout, just with too big a "strip" to 
work as raid0 in practice.

IOW, btrfs single mode layout is one 1 GiB chunk on one device at a time, 
but btrfs will alternate devices with those 1 GiB chunks (choosing the 
one with the least usage from those available), *NOT* use one device 
until it's full, then another until its full, etc, like md/raid linear 
mode does.  In that way, the layout is raid0-like, even if the chunks are 
too big to be practical raid0.

Btrfs raid0 mode, however, *DOES* work as raid0 in practice.  It still 
allocates 1 GiB chunks per devices, but does so in parallel across all 
available devices, and then stripes at a unit far smaller than the 1 GiB 
chunk, using I believe a 64 or 128 KiB strip/stripe-unit/whatever, with 
the full stripe-size thus being that times the number of devices in 
parallel in the stripe.

<sigh>  It's all clear in my head, anyway! =:^(

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

