Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56416 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3IWPLB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 11:11:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VO7mu-0004xJ-1q
	for linux-btrfs@vger.kernel.org; Mon, 23 Sep 2013 17:11:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 17:11:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 17:11:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Failure to remove snapshot with 3.12* and FS switches to
 read-only
Date: Mon, 23 Sep 2013 15:10:41 +0000 (UTC)
Message-ID: <pan$a2948$dd94c9d5$255d00b$878969d0@cox.net>
References: <20130923125417.GA3413@wasting>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mathieu Chouquet-Stringer posted on Mon, 23 Sep 2013 14:54:17 +0200 as
excerpted:

> My system is configured to do FS snapshots when I upgrade packages.  I
> have a cron job which runs at night to delete these snapshots.  Its goal
> is to keep 10 snapshots maximum, one per day if possible.
> 
> This works perfectly with 3.11.1 but fails miserably with anything post
> 3.11.
> 
> With a pre 3.12 (3.11.0-10050-g3711d86), this is what happens:

There's a known regression.  Check Chris's for-Linus pull request posted 
within the last 48 hours, there's a patch in it that should fix it.  Or 
wait for -rc2 or 3 depending on when that pull gets processed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

