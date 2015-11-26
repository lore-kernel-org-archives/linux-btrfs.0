Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59359 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbbKZPpK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 10:45:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a1yjI-0002us-Pm
	for linux-btrfs@vger.kernel.org; Thu, 26 Nov 2015 16:45:04 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 16:45:04 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 16:45:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send reproducibly fails for a specific subvolume after
 sending 15 GiB, scrub reports no errors
Date: Thu, 26 Nov 2015 15:44:59 +0000 (UTC)
Message-ID: <pan$b4680$c7011382$e419cda7$b7453e07@cox.net>
References: <56530608.50906@gmail.com>
	<20151123211012.GA12286@ny.voidptr.de>
	<pan$7e9cd$79273243$6e85efe7$7ee378ef@cox.net>
	<56545C1B.1080507@gmail.com> <1448390914.21291.42.camel@scientia.net>
	<5654CC1B.4030209@gmail.com> <1448398257.21291.63.camel@scientia.net>
	<5654CF58.8080207@gmail.com> <1448399833.21291.84.camel@scientia.net>
	<20151124212746.GS24333@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Tue, 24 Nov 2015 21:27:46 +0000 as excerpted:

[In the context of btrfs send...]

>    -p only sends the file metadata for the changes from the reference
> snapshot to the sent snapshot. -c sends all the file metadata, but will
> preserve the reflinks between the sent snapshot and the (one or more)
> reference snapshots. You can only use one -p (because there's only one
> difference you can compute at any one time), but you can use as many -c
> as you like (because you can share extents with any number of subvols).
> 
>    In both cases, the reference snapshot(s) must exist on the
> receiving side.
> 
>    In implementation terms, on the receiver, -p takes a (writable)
> snapshot of the reference subvol, and modifies it according to the
> stream data. -c makes a new empty subvol, and populates it from scratch,
> using the reflink ioctl to use data which is known to exist in the
> reference subvols.

Thanks, Hugo.  I had a vague idea that the above was the difference in 
general, but as CAM says, the manpage (and wiki) isn't particularly 
detailed on the differences, so I didn't know whether my vague idea was 
correct or not.  Your explanation makes perfect sense and clears things 
up dramatically. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

