Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56305 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbbKMTpr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 14:45:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZxKHo-000454-VJ
	for linux-btrfs@vger.kernel.org; Fri, 13 Nov 2015 20:45:29 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 20:45:28 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 20:45:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Where is the disk space?
Date: Fri, 13 Nov 2015 19:45:21 +0000 (UTC)
Message-ID: <pan$d16ba$8434e942$7cc09c55$439d7a74@cox.net>
References: <20151113174101.GC19249@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Fri, 13 Nov 2015 09:41:01 -0800 as excerpted:

> Any ideas?

Without addressing the main question, a couple targets of opportunity:

1) A quick balance with -mprofiles=single should kill those unused single 
metadata and system mkfs.btrfs legacies so you don't have to see them in 
fi df.

2) While fi df reports the data total vs. used spread being close enough 
that it's unsurprising a balance -dusage=80 didn't give you anything 
back, the spread on metadata is rather higher, dup, 6.0 gig total, less 
than 1 gig used, so a balance -musage=50 or 80 should return a few gigs, 
4-5 I'd guess, leaving you 1-2 gig metadata total.

Maybe that's part of the missing snapshot overhead?

(The -musage run should kill the unused single profile metadata/system as 
well, but for a different reason, so I made it a different point and used 
-mprofiles=single there to avoid conflating the two.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

