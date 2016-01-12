Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47980 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbcALBRE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 20:17:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aIna2-0007y7-E9
	for linux-btrfs@vger.kernel.org; Tue, 12 Jan 2016 02:17:02 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 02:17:02 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 02:17:02 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
Date: Tue, 12 Jan 2016 01:16:57 +0000 (UTC)
Message-ID: <pan$ce3b2$cb0106f5$ff557fab$febf0b4b@cox.net>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
	<CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
	<CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
	<CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
	<CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
	<CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
	<20160109202659.GC6060@carfax.org.uk>
	<CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
	<20160109210429.GD6060@carfax.org.uk>
	<CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
	<5693A8B3.2090508@gmail.com>
	<CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com>
	<5693B7C0.8010903@gmail.com>
	<CA+9GZUizsH3ToTMf_7mfN1Xgv=5obrCxCRHY+APS4SSGKoWHVA@mail.gmail.com>
	<CA+9GZUj92Y2qvgXjQbnavzrc4kM4n_0mBt+yu4CEFjzZJ2+kcQ@mail.gmail.com>
	<CAPmG0jYGRzvTWjSV09R7PswL6nqZVc7dhgXTQarej3JNeh0Q5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Henk Slager posted on Mon, 11 Jan 2016 21:29:37 +0100 as excerpted:

> The Data increments with 1G (or 10G?) chunks if there is no well-fitting
> space in existing chunks.

One of the devs (Qu?) explained this rather well in a followup to 
something or other, probably about a week or two ago.  I remember 
replying to the effect of how much more I knew of the exact numbers at 
the time.

Based on that, nominal data chunk size is 1 GiB, on btrfs upto 100 GiB in 
size (tho real small ones will have smaller data chunk sizes as well, not 
sure of the small end numbers, tho when mixed-mode was introduced until 
progs 4.3(.1 I think), mixed-mode was the default below 1 GiB size, and 
it uses metadata sized chunks).  Above 100 GiB, data chunk size increases 
to 10 GiB.  Similarly, metadata chunk sizes are 256 MiB below 100 GiB, I 
think 1 GiB above.

As we're talking multi-TB in this case, obviously well above 100 GiB, 
data chunk sizes are likely to be 10 GiB, tho I'm not 100% sure if that 
applies on single device, or only to striped chunks, with 1 GiB strips 
and stripes of up to 10 GiB if there's 10 devices in the stripe.

(As regulars here will know if they've kept track, I use multiple, much 
smaller btrfs here, the largest of which is 24 GiB per device, pair-
device raid1 for both data/metadata, so 48 GiB total fs size, 24 GiB each 
on two devices in raid1, 24 GiB capacity.  Obviously I see only 1 GiB 
data chunks, smaller of course on my 256 MiB /boot and its backup on the 
other device, both of which are single-device mixed-mode dup, so 128 MiB 
capacity.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

