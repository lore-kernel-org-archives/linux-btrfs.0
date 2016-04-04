Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52860 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbcDDEpg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 00:45:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amwOL-0004Rn-P7
	for linux-btrfs@vger.kernel.org; Mon, 04 Apr 2016 06:45:33 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 06:45:33 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 06:45:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 00/13 v3] Introduce device state 'failed', Hot spare and
 Auto replace
Date: Mon, 4 Apr 2016 04:45:16 +0000 (UTC)
Message-ID: <pan$5fc01$c48cb58$b5aadf3d$c2af2f78@cox.net>
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
	<20160404020043.47ad35bf@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Mon, 04 Apr 2016 02:00:43 +0200 as excerpted:

> Does this also implement "copy-back" - thus, it returns the hot-spare
> device to global hot-spares when the failed device has been replaced?

I don't believe it does that in this initial implementation, anyway.

There's a number of issues with the initial implementation, including the 
fact that the hot-spare is global only and can't be specifically assigned 
to a filesystem or set of filesystems, which means, if you have multiple 
filesystems using different sized devices, the hot-spares must be sized 
to match the largest device they could replace, and thus would be mostly 
wasted if they ended up replacing a far smaller device.  If the spares 
could be associated with specific filesystems, then specifically sized 
spares could be associated appropriately, avoiding that waste.  
Additionally, it would then be possible to queue up say 20 spares on an 
important filesystem, with no spares on another that you'd rather just go 
down if a device fails.

So obviously the initial implementation isn't seriously enterprise-ready 
and is sub-optimal in many ways, but it's better than what is currently 
available (no automated spare handling at all), and an implementation 
must start somewhere, so as long as it's designed to be improved and 
extended with the missing features over time, as has been indicated, it's 
a reasonable first-implementation.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

