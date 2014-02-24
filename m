Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49749 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaBXGm5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 01:42:57 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WHpFe-0007pf-Qi
	for linux-btrfs@vger.kernel.org; Mon, 24 Feb 2014 07:42:54 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 07:42:54 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 07:42:54 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.13.5 kernel hangs some processes with btrfs
Date: Mon, 24 Feb 2014 06:42:30 +0000 (UTC)
Message-ID: <pan$5eb48$855696ce$5bb0f0dc$b9ce161e@cox.net>
References: <20140224061426.GB15937@merlins.org>
	<20140224061714.GC15937@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 23 Feb 2014 22:17:14 -0800 as excerpted:

> Mmmh, this bug might be part of the problem:
> gargamel:/mnt# btrfs scrub start btrfs_pool2
> ERROR: scrub is already running.

> gargamel:/mnt# btrfs scrub cancel btrfs_pool2
> ERROR: scrub cancel failed on btrfs_pool2: not running

> gargamel:/mnt# btrfs scrub status
[snip output]
> Note that it says running for 5 seconds, but it started 4H ago.

This is a known issue.

I believe there's a fix coming (a cancel that blows away the tracking 
file if it finds it and no actual running scrub is the most obvious fix), 
but meanwhile, see the /var/lib/btrfs/scrub.status.* files.  That's where 
scrub state is stored, and manually blowing away the appropriate file 
should clear btrfs' memory of the aborted scrub, so you can scrub start 
properly.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

