Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54814 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbcCGUID (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Mar 2016 15:08:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ad1Rb-0003tO-RS
	for linux-btrfs@vger.kernel.org; Mon, 07 Mar 2016 21:07:56 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 21:07:55 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 21:07:55 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Date: Mon, 7 Mar 2016 20:07:48 +0000 (UTC)
Message-ID: <pan$ccd37$8304e3b1$cca62ce4$b65208d5@cox.net>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160305200909.GJ1902@torres.zugschlus.de>
	<pan$1c315$d49e06ee$da97f10b$cb207808@cox.net>
	<20160307083043.GA6939@torres.zugschlus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Haber posted on Mon, 07 Mar 2016 09:30:43 +0100 as excerpted:

> I have dug aroud in my auth.logs, and thanks to my not working in a root
> shell but using sudo for every single command I can say that the
> filesystem was created on September 1, 2015, so it is not _this_ old,
> and snapshot.debian.net tells me that Debian unstable had btrfs-tools
> 4.1.2 uploaded on August 31, so i guess that the filesystem was either
> created by the 4.0 version we had since May 2015 or by the brand new
> 4.1.2.
> 
> And it was a mkfs.btrfs with no special options.

I doubted that either a convert-from-ext* or a mkfs with the bad 4.1.1 
would turn out to be the cause, but those are the only things /I/ am 
aware of that can trigger wild behavior like we're seeing with this 
metadata, here.

So it's certainly a bug, and not accounted for by anything know at least 
to me, which makes it a new and interesting bug.  But not being a dev, 
that's about as far as I can take it.  As CMurphy said, file a bug with 
all the various information, and hope the devs can replicate and trace it 
down.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

