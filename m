Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55513 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758855AbcDHTx5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Apr 2016 15:53:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aocTa-0007gU-1Q
	for linux-btrfs@vger.kernel.org; Fri, 08 Apr 2016 21:53:54 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 21:53:54 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 21:53:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.4.0 - no space left with >1.7 TB free space left
Date: Fri, 8 Apr 2016 19:53:48 +0000 (UTC)
Message-ID: <pan$caab3$faaff583$6f85afa6$6f034ed9@cox.net>
References: <0c19f800da3013f22f2ab0d77d5a9efb@admin.virtall.com>
	<20160208162410.58cb2b4a@natsu>
	<eaeffce90cd04fa5b91284ca580b5969@admin.virtall.com>
	<20160408165332.450659c4@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Fri, 08 Apr 2016 16:53:32 +0500 as excerpted:

> It's not in 4.4.6 either. I don't know why it doesn't get included, or
> what we need to do. Last time I asked, it was queued:
> http://www.spinics.net/lists/linux-btrfs/msg52478.html But maybe that
> meant 4.5 or 4.6 only? While the bug is affecting people on 4.4.x today.

Patches must make it to the current development kernel before they're 
eligible for stable.  Additionally, they need to be cced to stable as 
well, in ordered to be queued there.

So check 4.5 and 4.6-rc.  If it's in neither of those, it's not going to 
be in stable yet.  Once it's in the development kernel, see if it was cced 
to stable and if needed, ask the author and btrfs devs to cc it to stable.

Tho sometimes stable can get a backlog as well.  I know earlier this year 
they were dealing with one, but I follow release or development, not 
stable, and don't know what stable's current status is.

If it gets to stable, and it wasn't for a bug introduced /after/ 4.4, it 
should eventually get into 4.4, as that's an LTS kernel.  But it might 
take awhile, as the above discussion hints.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

