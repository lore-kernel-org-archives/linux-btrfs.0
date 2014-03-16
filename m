Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38129 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755770AbaCPWzy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 18:55:54 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to handle a RAID5 arrawy with a failing drive? 
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140316222026.GU16946@merlins.org>
Date: Sun, 16 Mar 2014 16:55:50 -0600
Message-Id: <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com>
To: Btrfs <linux-btrfs@vger.kernel.org>, Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20140316222026.GU16946@merlins.org>


On Mar 16, 2014, at 4:20 PM, Marc MERLIN <marc@merlins.org> wrote:


> If I yank, sde1 and reboot, the array will not come back up from what I understand,
> or is that incorrect?
> Do rebuilds work at all with a missing drive to a spare drive?

The part that isn't working well enough is faulty status. The drive keeps hanging around producing a lot of errors, instead of getting booted. btrfs replace start ought to still work, but if the faulty drive is fussy it might slow down the rebuild, or even prevent it.

The more conservative approach is to pull the drive. If you've previously tested this hardware setup to tolerate hot swap, you can give that a shot. Otherwise, to avoid instability and additional problems, unmount the file system first. Do the hot swap. Then mount it -o degraded. Then use btrfs replace start.


Chris Murphy

