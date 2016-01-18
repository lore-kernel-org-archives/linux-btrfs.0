Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49023 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbcARDKT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 22:10:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aL0Cv-0005xm-Ai
	for linux-btrfs@vger.kernel.org; Mon, 18 Jan 2016 04:10:17 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 04:10:17 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 04:10:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)?
 Explain like I'm five pls.
Date: Mon, 18 Jan 2016 03:10:11 +0000 (UTC)
Message-ID: <pan$9ea8b$cdf4a5be$a6b3ced0$e73fd4ce@cox.net>
References: <loom.20160116T132316-196@post.gmane.org>
	<569C41B1.1090206@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 18 Jan 2016 09:36:49 +0800 as excerpted:

>> dedup'ing data immediately when written to high-write-count data is
>> counter productive because no sooner has it been deduped then it is
>> rendered obsolete by another COW write.
> 
> And it seems that you are not familiar how kernel is caching data for
> filesystem.
> There is already kernel page cache for such case.
> No matter how many times you write, as long as you're doing buffered
> write the the data is not written to disk but cached by kernel, until
> either you triggered a manual sync or memory pressure hits threshold.

Not contradicting in general, but checking my own understanding here...

Doesn't the kernel write cache get synced by timeout as well as memory 
pressure and manual sync, with the timeouts found in
/proc/sys/vm/dirty_*_centisecs, with defaults of 5 seconds background and 
30 seconds higher priority foreground expiry?

Regardless, I agree, the kernel page-cache seriously mitigates the stated 
concerns.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

