Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58070 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121AbbLNLTd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 06:19:33 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a8RA4-0007Iw-Il
	for linux-btrfs@vger.kernel.org; Mon, 14 Dec 2015 12:19:29 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 12:19:19 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 12:19:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
Date: Mon, 14 Dec 2015 11:19:06 +0000 (UTC)
Message-ID: <pan$844bc$626c7c35$7c4d2e49$5485aa77@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
	<20151126003342.GA24333@carfax.org.uk>
	<1449639781.7835.3.camel@scientia.net>
	<pan$ab79a$6d00d5c9$95504338$ca8d2761@cox.net>
	<1450061161.2388.66.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Mon, 14 Dec 2015 03:46:01 +0100 as
excerpted:

>> Same here.  In fact, my most anticipated feature is N-way-mirroring,
> Hmm ... not totally sure about that...
> AFAIU, N-way-mirroring is what currently the currently wrongly called
> RAID1 is in btrfs, i.e. having N replicas of everything on M devices,
> right?
> In other words, not being a N-parity-RAID and not guaranteeing that
> *any* N disks could fail, right?

No.  N-way-mirroring, at least in simplest form (as in md/raid1) is N 
replicas on N devices, so loss of N-1 devices is permitted without loss 
of data.

Normally the best thing about this is that unlike parity, once the 
general support is in, you can increase redundancy at will, with 
guaranteed device-loss protection of as many devices as you care to 
insure against.

At one point with somewhat old devices that I didn't particularly trust 
any more and because I had them from a previous raid6 setup, I was 
running 4-way-md/raid1.

Of course with md/raid1, the problem is lack of any sort of data 
integrity assurance, even scrubbing just arbitrarily chooses one and in 
the case of difference, simply copies that to the others, not even 
plurality-vote most authoritative version.

With btrfs checksumming, the value of N-way-mirroring is increased 
dramatically, since it allows individual block verification and fallback, 
as opposed to whole-device-loss.

While my own sweet-spot balance will tend to be three-way, avoiding the 
"if one copy is bad (perhaps because of a device that's known failing/
failed), you better /hope/ your only remaining copy is good" problem of 
the present two-way-only solution, I could easily see people finding 
value in 4/5/6-way mirroring as well.

And of course if that is extended to raid10, three-way-mirroring, two-way-
striping, on six total devices, would be my preferred, over the three-way-
striped, two-way-mirrored, that's the only current choice for six-device 
btrfs raid10.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

