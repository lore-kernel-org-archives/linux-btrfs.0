Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38591 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbcBMMfF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Feb 2016 07:35:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aUZPj-0003mT-Nw
	for linux-btrfs@vger.kernel.org; Sat, 13 Feb 2016 13:35:03 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Feb 2016 13:35:03 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Feb 2016 13:35:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: enospc while having a lot of free space with kernel 4.4
Date: Sat, 13 Feb 2016 12:32:44 +0000 (UTC)
Message-ID: <pan$2f1b6$75e523f6$567ed9fa$5e851f19@cox.net>
References: <56BED257.5080107@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Priebe posted on Sat, 13 Feb 2016 07:51:03 +0100 as excerpted:

> while running 4.4 i got the following enospc error today:

I don't see the usual btrfs fi sh <mntpnt> and btrfs fi df <mntpnt> 
output included, that would show exactly what btrfs thought the
free-space situation was.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

