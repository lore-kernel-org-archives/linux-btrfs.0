Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49590 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbaLSRdP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 12:33:15 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y21QQ-0002ZV-4b
	for linux-btrfs@vger.kernel.org; Fri, 19 Dec 2014 18:33:14 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 18:33:14 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 18:33:14 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Oddly slow read performance with near-full largish FS
Date: Fri, 19 Dec 2014 17:33:02 +0000 (UTC)
Message-ID: <pan$97927$88ff6377$b9b2d72e$d33f9ad1@cox.net>
References: <20141217024228.GA5544@pyropus.ca>
	<5493E8B0.1080107@jp.fujitsu.com> <20141219165849.GA15104@pyropus.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Charles Cazabon posted on Fri, 19 Dec 2014 10:58:49 -0600 as excerpted:

> This configuration is one I've been using for many years.  It's only
> recently that I've noticed it being particularly slow with btrfs -- I
> don't know if that's because the filesystem has filled up past some
> critical point, or due to something else entirely.  That's why I'm
> trying to figure this out.

Not recommending at this point, just saying these are options...

Btrfs raid56 mode should, I believe, be pretty close to done with the 
latest patches.  That would be 3.19, however, which isn't out yet of 
course.

There's also raid10, if you have enough devices or little enough data to 
do it.  That's much more mature than raid56 mode and should be about as 
mature and stable as btrfs in single-device mode, which is what you are 
using now.  But it'll require more devices than a raid56 would...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

