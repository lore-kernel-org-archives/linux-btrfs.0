Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33235 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbbLYAsK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 19:48:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aCGY9-0001rF-Nm
	for linux-btrfs@vger.kernel.org; Fri, 25 Dec 2015 01:48:06 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 01:48:05 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 01:48:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid 5/6 Stability
Date: Fri, 25 Dec 2015 00:48:00 +0000 (UTC)
Message-ID: <pan$937ba$55672d2b$3ffa0250$de78eb00@cox.net>
References: <567BC911.4080707@nv-systems.net>
	<E1aC6NL-0003SE-1x@rmm6prod02.runbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

jwalmer posted on Thu, 24 Dec 2015 08:56:15 -0500 as excerpted:

> Thanks for the speedy replies! Earlier Duncan said, "there's still no
> user-side multi-device filesystem health monitoring application." I'm
> mostly worried about device errors/failures, not my filesystem health.

EUNFORESEEN_AMBIGUITY.  Unfortunately, I seem to run into this error in 
my posts more than I'd like. =:^(

The ambiguity here is that btrfs is more than a filesystem, it's a multi-
device raid (which would traditionally be at the block layer, not the 
filesystem layer) as well.

> Since my implimentation of btrfs will be on a storage array, I'm not
> going to be doing anything unusual that should lend itself to creating
> filesystem errors.
> 
> How serious of a concern should it be that the filesystem health is not
> easily monitored? i.e., Since this is not a RAID-level-specific-issue,
> should the lack of filesystem monitoring be enough to stop me from
> playing with btrfs deployments for now?

What I /meant/ was the previously discussed lack of raid-level device 
failure notification, which is arguably filesystem health notification 
when that filesystem incorporates multi-device raid as well, as btrfs 
does, but would in traditional filesystems be nothing they'd deal with at 
all as they don't do raid themselves, leaving that to other layers, which 
means it's not filesystem health in the traditional sense, but something 
beyond that, because btrfs is itself untraditional in that sense.

Since your concern continues to separate out the traditional filesystem 
health from the raid health, and I was talking about the latter while you 
are more concerned with the former, it wouldn't appear to be a concern in 
your case. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

