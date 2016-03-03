Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52623 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbcCCEbJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Mar 2016 23:31:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1abKup-0004zq-HA
	for linux-btrfs@vger.kernel.org; Thu, 03 Mar 2016 05:31:07 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 05:31:07 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 05:31:07 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Btrfs: fix loading of orphan roots leading to BUG_ON
Date: Thu, 3 Mar 2016 04:31:02 +0000 (UTC)
Message-ID: <pan$91701$3af360aa$c931211b$9c451328@cox.net>
References: <1456933778-7944-1-git-send-email-fdmanana@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fdmanana posted on Wed, 02 Mar 2016 15:49:38 +0000 as excerpted:

> When looking for orphan roots during mount we can end up hitting a
> BUG_ON() (at root-item.c:btrfs_find_orphan_roots()) if a log tree is
> replayed and qgroups are enabled.

This should hit 4.6, right?  Will it hit 4.5 before release?

Because I wasn't sure of current quota functionality status, but this bug 
obviously resets the counter on my ongoing "two kernel cycles with no 
known quota bugs before you try to use quotas" recommendation.

Meanwhile, what /is/ current quota feature status?  Other than this bug, 
is it now considered known bug free, or is more quota reworking and/or 
bug fixing known to be needed for 4.6 and beyond?

IOW, given that two release cycles no known bugs counter, are we 
realistically looking at that being 4.8, or are we now looking at 4.9 or 
beyond for reasonable quota stability?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

