Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60504 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbaFFAfZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 20:35:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wsi7v-0000xN-2d
	for linux-btrfs@vger.kernel.org; Fri, 06 Jun 2014 02:35:23 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 02:35:22 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 02:35:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Using BTRFS on SSD now ?
Date: Fri, 6 Jun 2014 00:35:08 +0000 (UTC)
Message-ID: <pan$d0f6f$958f1e6e$ae08a321$8fc7bdc5@cox.net>
References: <2215647.hErg5R77lo@zafu> <20140605145632.GD14713@merlins.org>
	<FFF0E455-5905-47D4-A768-96CA2FEDF3B3@colorremedies.com>
	<20140605190526.GS7210@merlins.org>
	<pan$4b696$bb5c3db8$50f45a4e$fdad0f36@cox.net>
	<yq14mzyzz6l.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin K. Petersen posted on Thu, 05 Jun 2014 19:58:26 -0400 as excerpted:

>>>>>> "Duncan" == Duncan  <1i5t5.duncan@cox.net> writes:
> 
> Duncan> OTOH, certain high-performance hardware goes beyond the current
> Duncan> standard and does a queued trim, without forcing a flush of the
> Duncan> queue in the process.  But this hardware tends to be rather rare
> Duncan> and expensive,
> 
> Queued trim has started to appear in consumer SSDs. However, since we're
> the only OS that supports it the feature has come off to a bumpy start.
> We tried to enable it on a drive model that passed testing here but we
> had to revert to unqueued when bug reports started rolling in this week.

[more elided]

Thanks. Fresher and better information than I had. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

