Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58464 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbbJOH7m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 03:59:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZmdRl-0001Z1-Sk
	for linux-btrfs@vger.kernel.org; Thu, 15 Oct 2015 09:59:34 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 09:59:33 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 09:59:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: System completely unresponsive after `btrfs balance start
 -dconvert=raid0 /` and `btrfs fi show /`
Date: Thu, 15 Oct 2015 07:59:21 +0000 (UTC)
Message-ID: <pan$9a17e$32c179cf$a587598d$f4fafcb8@cox.net>
References: <C1BFF62A-9C2E-4A5D-86F9-7F01DDDF8BF6@paolino.me>
	<20151015043927.GC4400@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Thu, 15 Oct 2015 00:39:27 -0400 as excerpted:

> As others have pointed out, the raid0 allocator has a 2-disk-minimum
> constraint, so any difference in size between the largest and
> second-largest disk is unusable.  In your case that's 73% of the raw
> space.
> 
> If the two smaller disks were almost full (no space unallocated in
> 'btrfs fi usage') before you converted to raid0, then immediately after
> starting a conversion to raid0 you have no space left _at all_.  This is
> because the space you previously had under some other data profile is no
> longer considered "free" even if it isn't in use.  All future
> allocations must be raid0, starting immediately, but no space is
> available for raid0 data chunks.
> 
> This will cause some symptoms like huge write latency (it will not take
> seconds or minutes, but *hours* to write anything to the disk) and
> insanely high CPU usage.

Very nice analysis.  The implications hadn't occurred to me, but you 
spell them out in the stark terms the reality of the situation dictates, 
along with offering a sane way out.

Thanks.  I'll have to keep this in mind for the next time something like 
this comes up.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

