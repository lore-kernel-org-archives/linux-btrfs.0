Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49309 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbbJLGBQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 02:01:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZlWAa-0006Kz-Kc
	for linux-btrfs@vger.kernel.org; Mon, 12 Oct 2015 08:01:12 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 08:01:12 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 08:01:12 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Questions about FIEMAP
Date: Mon, 12 Oct 2015 06:01:01 +0000 (UTC)
Message-ID: <pan$9fdb4$9abccde1$23cdcfaa$1804db33@cox.net>
References: <CY1PR10MB04283CC6BA7D9AE8F3F0B984E4310@CY1PR10MB0428.namprd10.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang, Zhiye posted on Mon, 12 Oct 2015 04:37:55 +0000 as excerpted:

> I guess we cannot write to block device directly after get block list
> using FIEMAP. This is because:
> 
> 1. COW feature of btrfs (but this can be disabled using NOCOW)

I'm a user not a dev and many of the specifics of this discussion will 
with little doubt be above my head, but a warning on this assumption, 
just in case you overlooked it...

Btrfs' snapshot feature conflicts with nocow, because a snapshot locks in 
place existing extents, relying on cow for any rewrite, to write the new 
blocks elsewhere.

So what happens when a nocow file is snapshotted and then written into?

Simple enough, it's effectively cow1.  That is, the first write to a 
particular block of a nocow file after a snapshot will still cow it, but 
the file retains its nocow attribute, and further writes to the same 
block will rewrite the block in its now existing new location... until 
the next snapshot locks that too in place, of course.

Bottom line, in the presence of snapshotting, particularly scheduled 
snapshotting that the admin may have forgotten about and/or doesn't know 
the consequences of, you can't rely on nocow actually being absolute 
rewrite-in-place nocow.

So just in case you weren't aware, don't assume what can't be assumed. 
=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

