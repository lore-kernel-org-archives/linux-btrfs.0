Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57096 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759156Ab3KMPP0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 10:15:26 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VgcA9-0007Cq-Rp
	for linux-btrfs@vger.kernel.org; Wed, 13 Nov 2013 16:15:25 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 16:15:25 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 16:15:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: NMI from btrfs cron jobs in 3.11.6
Date: Wed, 13 Nov 2013 15:15:04 +0000 (UTC)
Message-ID: <pan$4655$5629e47b$7d83e5a0$59910e71@cox.net>
References: <201311140145.29255.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Thu, 14 Nov 2013 01:45:29 +1100 as excerpted:

> It appears that running two scripts that create snapshots at the same
> time as a script that removes maybe 97 snapshots causes an NMI.

This is a known bug in 3.11 (and presumably earlier).  Snapshot 
manipulation concurrency evidently wasn't originally well considered, and 
either a recent regression triggered the problem or possibly it always 
existed and only recently was reported (I don't know either way, tho the 
btrfs devs might).

Either way, there's a patch both to address the problem and adding a 
regression test to the xfstests filesystem testing suite to catch future 
regressions, but it's too recent to be in 3.11 yet, and indeed, as of my 
update yesterday (3.12.0-03510-g9b66bfb), there hadn't yet been a btrfs 
pull in the 3.12 commit window yet either, so while 3.12 will likely get 
it, it's not there yet as of the above git snapshot.

If interested in more, check recent list threads for the bug report and 
proposed patch.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

