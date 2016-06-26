Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54801 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbcFZPDg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 11:03:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bHBau-0003p4-QD
	for linux-btrfs@vger.kernel.org; Sun, 26 Jun 2016 17:03:34 +0200
Received: from 64.134.221.43 ([64.134.221.43])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 17:03:32 +0200
Received: from 1i5t5.duncan by 64.134.221.43 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 17:03:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Adventures in btrfs raid5 disk recovery
Date: Sun, 26 Jun 2016 15:03:25 +0000 (UTC)
Message-ID: <pan$78072$6fbc243b$9e6540c9$b3a61597@cox.net>
References: <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
	<CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
	<20160621015559.GM15597@hungrycats.org>
	<CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
	<20160622203504.GQ15597@hungrycats.org>
	<5790aea9-0976-1742-7d1b-79dbe44008c3@inwind.it>
	<CAJCQCtRXqSCFZTca+Vwraa0vS-MzLQKEkr=s41Vypc-O0ZDdxQ@mail.gmail.com>
	<20160624014752.GB14667@hungrycats.org> <576CB0DA.6030409@gmail.com>
	<20160624085014.GH3325@carfax.org.uk>
	<CAA91j0Uqg0FafFTG3NhQt=p8KkYRhTeMU5Bd+JuUxDntP6g8Ng@mail.gmail.com>
	<CAJCQCtQBQAng5_mNJZev+64Z15BSkBkG9f2qmz=ckPRqXRbbWA@mail.gmail.com>
	<576D6C0A.7070502@gmail.com>
	<CAJCQCtSskA4PC_a8tgQopHFNO83NQ=Gkx406haB7G0nBi5e=2A@mail.gmail.com>
	<c2a320a6-261b-723d-ab83-58f883e6315b@gmail.com>
	<CAJCQCtSqO4GNm8kBDuzUXEXYx+54zFgsD6=ARNsRgVUb53LQZw@mail.gmail.com>
	<CAJCQCtQhRbL_AWpspudPZzkkGkHT3O9T0QL94Of5LD8agmonwg@mail.gmail.com>
	<576F8A28.7060808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andrei Borzenkov posted on Sun, 26 Jun 2016 10:54:16 +0300 as excerpted:

> P.S. usage of "stripe" to mean "stripe element" actually adds to
> confusion when reading code :)

... and posts (including patches, which I guess are code as well, just 
not applied yet).  I've been noticing that in the "stripe length" 
patches, when the comment associated with the patch suggests it's "strip 
length" they're actually talking about, using the "N strips, one per 
device, make a stripe" definition.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

