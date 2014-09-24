Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47882 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbaIXNaD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Sep 2014 09:30:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XWmdt-0007yp-Kq
	for linux-btrfs@vger.kernel.org; Wed, 24 Sep 2014 15:30:01 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Sep 2014 15:30:01 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Sep 2014 15:30:01 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send does not work from readonly device
Date: Wed, 24 Sep 2014 13:29:49 +0000 (UTC)
Message-ID: <pan$afb89$92478dcc$d289358e$905b34a@cox.net>
References: <16424080.RP99VxSJe8@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

GEO posted on Tue, 23 Sep 2014 14:58:06 +0200 as excerpted:

> Is that supposed to be that way? Why is readonly not enough to import
> data using btrfs send?

This is a known issue.  The subvolume itself needs to be set read-only, 
and of course that can't be done when the whole filesystem is set read-
only.

But a read-only filesystem should be sufficient, provided it can be 
forced to remain read-only thru the entire send.  I think that's the 
worry, that someone will switch their system from ro to rw in the middle 
of a send, thus screwing it up.

But they're aware of the problem and should eventually have a fix.  But 
I'm not sure how long as there's other work going on too, of course.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

