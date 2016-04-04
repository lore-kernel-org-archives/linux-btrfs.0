Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42368 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbcDDUPa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 16:15:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1anAuC-0004m9-Ed
	for linux-btrfs@vger.kernel.org; Mon, 04 Apr 2016 22:15:24 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 22:15:24 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 22:15:24 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: [PATCH 00/13 v3] Introduce device state 'failed', Hot spare and
 Auto replace
Date: Mon, 4 Apr 2016 22:15:13 +0200
Message-ID: <20160404221513.7fd31f8f@jupiter.sol.kaishome.de>
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
	<20160404020043.47ad35bf@jupiter.sol.kaishome.de>
	<pan$5fc01$c48cb58$b5aadf3d$c2af2f78@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 4 Apr 2016 04:45:16 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Kai Krakow posted on Mon, 04 Apr 2016 02:00:43 +0200 as excerpted:
> 
> > Does this also implement "copy-back" - thus, it returns the
> > hot-spare device to global hot-spares when the failed device has
> > been replaced?  
> 
> I don't believe it does that in this initial implementation, anyway.
> 
> There's a number of issues with the initial implementation, including
> the fact that the hot-spare is global only and can't be specifically
> assigned to a filesystem or set of filesystems, which means, if you
> have multiple filesystems using different sized devices, the
> hot-spares must be sized to match the largest device they could
> replace, and thus would be mostly wasted if they ended up replacing a
> far smaller device.  If the spares could be associated with specific
> filesystems, then specifically sized spares could be associated
> appropriately, avoiding that waste. Additionally, it would then be
> possible to queue up say 20 spares on an important filesystem, with
> no spares on another that you'd rather just go down if a device fails.
> 
> So obviously the initial implementation isn't seriously
> enterprise-ready and is sub-optimal in many ways, but it's better
> than what is currently available (no automated spare handling at
> all), and an implementation must start somewhere, so as long as it's
> designed to be improved and extended with the missing features over
> time, as has been indicated, it's a reasonable first-implementation.

Your argument would be less important if it did copy-back, tho... ;-)

It's a very welcome and good start, I didn't mean to talk it useless.
By no way.

But to handle it right, that point should be clear. Currently, if the
global spare jumps in, you can always simulate "hot spare" by manually
putting back a correctly sized drive, then remove the spare again to
simulate copy-back, then make it global spare again.

Since such an incident needs manual investigation anyways, it's totally
reasonable to start with this implementation.

This sort of handling could be made into a guide within the docs.

-- 
Regards,
Kai

Replies to list-only preferred.

