Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54965 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbcDDGJx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 02:09:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amxhs-0007dR-Nk
	for linux-btrfs@vger.kernel.org; Mon, 04 Apr 2016 08:09:48 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 08:09:48 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 08:09:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 00/13 v3] Introduce device state 'failed', Hot spare and
 Auto replace
Date: Mon, 4 Apr 2016 06:09:41 +0000 (UTC)
Message-ID: <pan$64d8b$718e385e$1ef143f5$1db0a45a@cox.net>
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
	<20160404020043.47ad35bf@jupiter.sol.kaishome.de>
	<pan$5fc01$c48cb58$b5aadf3d$c2af2f78@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Mon, 04 Apr 2016 04:45:16 +0000 as excerpted:

> Kai Krakow posted on Mon, 04 Apr 2016 02:00:43 +0200 as excerpted:
> 
>> Does this also implement "copy-back" - thus, it returns the hot-spare
>> device to global hot-spares when the failed device has been replaced?
> 
> I don't believe it does that in this initial implementation, anyway.
> 
> There's a number of issues with the initial implementation, including
> the fact that the hot-spare is global only and can't be specifically
> assigned to a filesystem or set of filesystems, which means, if you have
> multiple filesystems using different sized devices, the hot-spares must
> be sized to match the largest device they could replace,

Obviously the sizes issue is problematic for the hot-spare-return 
situation as well, since it would then be possible for an appropriately 
large replacement device to replace a much smaller device on some 
filesystem, which would then put the much smaller device into rotation as 
a hot-spare where it could end up picked to replace a far larger device.  
As there's currently no intelligence as to device sizes, etc, it just 
picks the next device in the hot-spares list and tries to use it, oops!

So hot-spare-return really will need to wait until per-filesystem hot-
spares and/or some sizing intelligence is added.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

