Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48343 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbbLXD41 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 22:56:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBx0q-000658-2V
	for linux-btrfs@vger.kernel.org; Thu, 24 Dec 2015 04:56:24 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 04:56:24 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 04:56:24 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid 5/6 Stability
Date: Thu, 24 Dec 2015 03:56:14 +0000 (UTC)
Message-ID: <pan$2d5fe$ffbfbbce$27af325f$ba6c76e8@cox.net>
References: <E1aBsGQ-0007zz-4V@rmm6prod02.runbox.com>
	<pan$3b05a$667561e3$4f808486$449baaf4@cox.net>
	<CAJCQCtR=ydFe0w4MUAS6CGZeOe3wMMmijOW=qptF20uDZaSMyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 23 Dec 2015 19:38:23 -0700 as excerpted:

> There's a worthwhile distinction between stability of raid56 vs all
> other profiles, and btrfs multiple device failure behavior. Right now
> there's no monitoring or notification of failures to user space. In
> fact Btrfs itself doesn't really understand device failures, a device
> can spit out many read or write errors and Btrfs keeps trying to read
> and write. So there's no equivalent to faultiness like with md/mdadm.
> Therefore you'll have to figure out a way to monitor kernel messages,
> maybe via a script that parses for btrfs messages and emails any such
> messages ever 10m or whatever.

Absolutely.  Raid56 mode may be stabilizing, but there's still no user-
side multi-device filesystem health monitoring application, either for 
raid56 or in general, for the raid1/10 modes which are in fact reasonably 
stable and mature on btrfs and have been considered at the level of btrfs 
itself for quite awhile (several years), now.

Thanks for that addendum, Chris.  It could be quite helpful to someone 
just setting up a new installation, particularly on a server where the 
user and/or admin is unlikely to be directly observing things and thus 
know when things go wrong due to the observed change in behavior, 
regardless of formal monitoring or the lack thereof, as would likely be 
the case on a desktop/workstation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

