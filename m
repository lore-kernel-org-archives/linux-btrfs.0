Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42388 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbcDEEZb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Apr 2016 00:25:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anIYS-0003gc-Id
	for linux-btrfs@vger.kernel.org; Tue, 05 Apr 2016 06:25:28 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 06:25:28 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 06:25:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scrub priority, am I using it wrong?
Date: Tue, 5 Apr 2016 04:25:23 +0000 (UTC)
Message-ID: <pan$c43f6$971ba29e$d0efb8b3$80be0f78@cox.net>
References: <CA+WRLO-vu4B8X3Td12F0gueU70G6KwjRTD07MNwDrJfodAscNA@mail.gmail.com>
	<pan$603b6$4c4f876d$1daf06de$ec75378d@cox.net>
	<CA+WRLO_fmgogzErEdgNpnqJL2jozDRQGHrhUPt9aFtPb43iqyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye posted on Tue, 05 Apr 2016 13:45:11 +1000 as excerpted:

> On Tue, Apr 5, 2016 at 12:37 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> CPU bound, 0% IOWait even at idle IO priority, in addition to the
>> hundreds of M/s values per thread/device, here.  You OTOH are showing
>> under 20 M/s per thread/device on spinning rust, with an IOWait near
>> 90%,
>> thus making it IO bound.
> 
> 
> And yes I'd love to switch to SSD, but 12 2TB drives is a bit pricey
> still

No kidding.  That's why my media partition remains spinning rust.  (Tho 
FWIW, not btrfs, I use btrfs only on my ssds, and still use the old and 
stable reiserfs on my spinning rust.)

But my media partition is small enough, and ssd prices now low enough up 
to the 1 TB level, that when I upgrade I'll probably switch to ssd for 
the media partition as well, and leave spinning rust only as second or 
third level backups.

But that's because it all, including first level backups, fits in under a 
TB (and if pressed I could do it under a half TB).  Multi-TB, as you 
have, definitely still spinning rust, for me too.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

