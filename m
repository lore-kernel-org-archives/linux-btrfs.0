Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56444 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaEVVGv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 17:06:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WnaCL-000553-CC
	for linux-btrfs@vger.kernel.org; Thu, 22 May 2014 23:06:45 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 23:06:45 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 23:06:45 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount hangs after disk crash (RAID-1)
Date: Thu, 22 May 2014 21:06:26 +0000 (UTC)
Message-ID: <pan$9e1ee$dd62e9f3$9263e2c8$c034feaf@cox.net>
References: <20140522032258.234aaab7@s9> <20140522095101.107b62e8@s9>
	<20140522161634.054ec95f@s9> <20140522185025.4c72aab9@s9>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Thu, 22 May 2014 18:50:25 +0100 as excerpted:

> It *does* mount as ro,degraded, but then, it's not possible to add a
> disk and recover to a functioning RAID-1.
> Also, when I try to remount rw, the mount command hangs as well.
> 
> Is there anything else I can try?

It's a long shot, but in addition to Chris's excellent suggestions, try 
the skip_balance mount option.  In the outside case that it's just a 
resumed balance that's triggering the hang, that should allow the rw 
mount to succeed as it kills the balance that would otherwise be 
immediately resumed as soon as the filesystem goes writable, possibly 
before the mount returns.

Otherwise, I'd go with Chris's suggestion, mount read-only and ensure 
your backups are current, then go experimental on it, since there's 
nothing further to lose at that point anyway.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

