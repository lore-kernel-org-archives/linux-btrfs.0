Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51173 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbcARDWJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jan 2016 22:22:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aL0ON-00059M-3Y
	for linux-btrfs@vger.kernel.org; Mon, 18 Jan 2016 04:22:07 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 04:22:02 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 04:22:02 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS: bdev /dev/mapper/dshelf1 errs: wr 2970, rd 848, flush 0,
 corrupt 189, gen 0
Date: Mon, 18 Jan 2016 03:21:53 +0000 (UTC)
Message-ID: <pan$6d745$1ec4d122$7401737e$1adc2b07@cox.net>
References: <20160118002748.GE12045@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sun, 17 Jan 2016 16:27:48 -0800 as excerpted:

> So, I had an FS with a few issues, I ran btrfs check --repair to
> completion
> 
> Then, after mounting, I still get this warning. [see subject]
> Shouldn't those error counters be reset after check --repair?

No.  Those are monotonically increasing counts that are never 
automatically reset over the life of the filesystem.  Use ...

btrfs dev stats

... to display them on the commandline (vs. the kernel log at filesystem 
mount), with the -z option to reset them after display, if desired.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

