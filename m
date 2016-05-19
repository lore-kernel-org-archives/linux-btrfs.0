Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59036 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbcESV6C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 17:58:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b3Vx8-0004wd-NJ
	for linux-btrfs@vger.kernel.org; Thu, 19 May 2016 23:57:58 +0200
Received: from ip1f11faed.dynamic.kabel-deutschland.de ([31.17.250.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 23:57:58 +0200
Received: from hurikhan77 by ip1f11faed.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 23:57:58 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Hot data tracking / hybrid storage
Date: Thu, 19 May 2016 23:01:40 +0200
Message-ID: <20160519230140.654daf03@jupiter.sol.kaishome.de>
References: <nh9p2p$cns$1@ger.gmane.org>
	<pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
	<20160516010524.7e208f96@jupiter.sol.kaishome.de>
	<nhedk2$dpq$1@ger.gmane.org>
	<0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
	<20160517203335.5ff99a05@jupiter.sol.kaishome.de>
	<nhir96$8n4$1@ger.gmane.org>
	<20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
	<e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 19 May 2016 14:51:01 -0400
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> For a point of reference, I've 
> got a pair of 250GB Crucial MX100's (they cost less than 0.50 USD per
> GB when I got them and provide essentially the same power-loss
> protections that the high end Intel SSD's do) which have seen more
> than 2.5TB of data writes over their lifetime, combined from at least
> three different filesystem formats (BTRFS, FAT32, and ext4), swap
> space, and LVM management, and the wear-leveling indicator on each
> still says they have 100% life remaining, and the similar 500GB one I
> just recently upgraded in my laptop had seen over 50TB of writes and
> was still saying 95% life remaining (and had been for months).

The smaller Crucials are much worse at that: The MX100 128GB version I
had was specified for 85TB writes which I hit after about 12 months (97%
lifetime used according to smartctl) due to excessive write patterns.
I'm not sure how long it would have lasted but I decided to swap it for
a Samsung 500GB drive, and reconfigure my system for much less write
patterns.

What should I say: I liked the Crucial more, first: It has an easy
lifetime counter in smartctl, Samsung doesn't. And it had powerloss
protection which Samsung doesn't explicitly mention (tho I think it has
it).

At least, according to endurance tests, my Samsung SSD should take
about 1 PB of writes. I've already written 7 TB if I can trust the
smartctl raw value.

But I think you cannot compare specification values to a real endurance
test... I think it says 150TBW for 500GB 850 EVO.

-- 
Regards,
Kai

Replies to list-only preferred.

