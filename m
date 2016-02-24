Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58975 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbcBXAkJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 19:40:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aYNUr-0006lB-6e
	for linux-btrfs@vger.kernel.org; Wed, 24 Feb 2016 01:40:05 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 01:40:05 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 01:40:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Documentation for BTRFS error (device dev): bdev /dev/xx errs:
 wr 22, rd 0, flush 0, corrupt 0, gen 0
Date: Wed, 24 Feb 2016 00:38:12 +0000 (UTC)
Message-ID: <pan$8667b$b7f76f6e$a3ce2838$cf0b785a@cox.net>
References: <pan$84c48$1f5c952c$5c23be23$5799c3a@cox.net>
	<20160224001944.GX22487@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Tue, 23 Feb 2016 16:19:44 -0800 as excerpted:

> Cabling is indeed a likely culprit, I'm just surprised that if it's the
> case, the sata layer is showing me nothing (I'm doing tail -f
> /var/log/kern.log and usually I'd see sata or PMP errors there)

That /is/ surprising.  No explanation, there, tho I don't know enough 
about such errors to know if they /always/ tend to show up in the logs, 
or not, only that mine generally have.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

