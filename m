Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42425 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723Ab3LETjy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Dec 2013 14:39:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Voem8-0005pL-SB
	for linux-btrfs@vger.kernel.org; Thu, 05 Dec 2013 20:39:52 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Dec 2013 20:39:52 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Dec 2013 20:39:52 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Extremely slow metadata performance
Date: Thu, 5 Dec 2013 19:39:30 +0000 (UTC)
Message-ID: <pan$950f8$ef940490$829198f6$4f5f85c7@cox.net>
References: <52A0BD44.9030509@complete.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Goerzen posted on Thu, 05 Dec 2013 11:52:04 -0600 as excerpted:

> Hello,
> 
> I have observed extremely slow metadata performance with btrfs. This may
> be a bit of a nightmare scenario; it involves untarring a backup of
> 1.6TB of backuppc data, which contains millions of hardlinks and much
> data, onto USB 2.0 disks.

> Is this behavior known and expected?

Yes.  Btrfs doesn't do well with lots of hardlinks and indeed until 
relatively recently had a hard-limit on the number of hardlinks possible 
within a directory, that hardlink-heavy use-cases would regularly hit.  
That was worked around, but there's an additional level of indirection 
once the first level link-pool is filled, and you're not the first to 
have observed that btrfs performance isn't the best in that sort of 
scenario.  That's known.

Other filesystems will probably do quite a bit better for hardlink style 
backups and other hardlink-heavy use-cases.  Either that, or consider 
using btrfs, but with some other form of backup, possibly btrfs 
snapshots, or COW reflinks.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

