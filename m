Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42541 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbaBZFnh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 00:43:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WIXHL-00063X-Sy
	for linux-btrfs@vger.kernel.org; Wed, 26 Feb 2014 06:43:36 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 06:43:35 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Feb 2014 06:43:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: VM nocow, should VM software set +C by default?
Date: Wed, 26 Feb 2014 05:43:11 +0000 (UTC)
Message-ID: <pan$4f13b$4e4a556c$b18c9a89$9c0c3ab3@cox.net>
References: <A2EE3F12-97D9-46CD-8360-ACCFF71F149B@colorremedies.com>
	<530C5F65.6020607@internetionals.nl>
	<4C05BCCD-ED77-4D8D-B9C7-47CB6D1B4ACC@colorremedies.com>
	<530CD898.6090401@jrs-s.net>
	<630BA589-DD50-4C7C-9E95-610662BD66B9@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 25 Feb 2014 11:33:34 -0700 as excerpted:

> I've had a qcow2 image with more than 30,000 extents and didn't notice a
> performance drop. So I don't know that number of extents is the problem.
> Maybe it's how they're arranged on disk and what's causing the problem
> is excessive seeking on HDD? Or does this problem sometimes also still
> happen on SSD?

SSDs are interesting beasts.

1) Seek-times aren't an issue, so that disappears, BUT...

2) SSDs still have IOPS ratings/limits.  Typically these are in the 
(high) tens of thousands per second range, so a single file at 30K 
extents isn't likely to be terribly significant.  However, 300K extents 
could be, and several VMs @ 30K each, and/or mixed in with other traffic, 
likely also fragmented due simply to the number of VM image fragments...

3) There's also the read vs. write vs. erase-block size thing to think 
about, and how that can affect not reads, but writes.  As long as there's 
sufficient overprovisioning it shouldn't be a real problem, but fill the 
SSD more than about 2/3 full (as a significant number of non-
professionally managed systems likely will) and all those extra fragments 
being written is going to trigger erase-block garbage collection cycles 
more frequently, and that could massively up the latency jitter on a 
reasonably frequent basis.

#2 and 3 are a big part of the reason I still enable the autodefrag mount 
option here, even tho I'm on SSD and my use-case doesn't have a lot of 
huge internal-write files to worry about, plus I'm only about 50 percent 
partitioned on the SSDs so they have LOTS of room to do their wear-
leveling, etc. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

