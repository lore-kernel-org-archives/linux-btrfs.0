Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:50524 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758125AbaDXPX3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 11:23:29 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49347 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WdLUn-004Bcq-4X
	for linux-btrfs@vger.kernel.org; Thu, 24 Apr 2014 09:23:29 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: btrfs send receive, clone
Message-Id: <35B44B63-D139-4E0E-AD6F-2320B79D19B1@colorremedies.com>
Date: Thu, 24 Apr 2014 09:23:28 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



I don't understand the btrfs send -c <clone-src> man page text, or really even the use case. In part this is what it says:

> You must not specify clone sources unless you
>  guarantee that these snapshots are exactly in the same state on both
>  sides, the sender and the receiver.

If the snapshots are the same on both sides, then why would I be using clone in the first place?

> -c <clone-src> Use this snapshot as a clone source for an 
> incremental send (multiple allowed)

Incremental send implies the sender and receiver are not in the same state now, but will be after the command is executed. Is one, or both, snapshots rw for -c?

Anyway, I'm lost on the specifics, but clearly I'm even lost when it comes to the basic difference between -p and -c.


Thanks,

Chris Murphy