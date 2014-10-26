Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32817 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaJZCCW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Oct 2014 22:02:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XiD9w-0006q5-AX
	for linux-btrfs@vger.kernel.org; Sun, 26 Oct 2014 03:02:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Oct 2014 03:02:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Oct 2014 03:02:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs balance segfault, kernel BUG at
 fs/btrfs/extent-tree.c:7727
Date: Sun, 26 Oct 2014 02:02:06 +0000 (UTC)
Message-ID: <pan$bb7bd$8793909$82b5d901$ab0e3a25@cox.net>
References: <20141009141944.GA11525@atrey.karlin.mff.cuni.cz>
	<CAGfcS_nR-MP8VLWanvvs9dMQBi02JoCCUTYd_JwA9tmtPRGmSg@mail.gmail.com>
	<CAGfcS_kFnqp5aeHMfTLJbTbVx=yobNf+Zp-ECYh1xNRFG7UjaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman posted on Sat, 25 Oct 2014 21:41:27 -0400 as excerpted:

> However, i'm still getting "bdev /dev/sdb2 errs: wr 0, rd 1361, flush 0,
> corrupt 0, gen 0" in my dmesg logs.  I have tried scrubbing the device
> with no errors found.

Note that error counts do /not/ reset at boot.  The counts are therefore 
since either the last mkfs, or the last time the error counts were reset 
manually, and if you know you've had errors (as you did here), all you 
need to do is take note of the count and ensure it's not increasing 
unexpectedly.

Meanwhile, btrfs device stats can be used to print the error counts on 
demand and its -z option resets them after that print, thus being the 
manual reset I mentioned above.

So chances are those read errors are the same ones you had previously.  
As long as the number isn't increasing, you're not registering any 
further errors.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

