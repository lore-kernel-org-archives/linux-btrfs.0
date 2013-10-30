Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57861 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab3J3H61 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Oct 2013 03:58:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VbQfZ-0005RH-MG
	for linux-btrfs@vger.kernel.org; Wed, 30 Oct 2013 08:58:25 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 08:58:25 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Oct 2013 08:58:25 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: memory leak in <=3.11.6
Date: Wed, 30 Oct 2013 07:58:04 +0000 (UTC)
Message-ID: <pan$daeed$63ab09ce$f7cf614c$9dc4736d@cox.net>
References: <20131029132246.21258b95@virtall.com>
	<o1t5ka-p7g.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Wed, 30 Oct 2013 00:30:26 +0100 as excerpted:

> For me it started late 3.9 if I remember right. But I'm pretty sure it
> startet with 3.10 which I mostly upgraded to for using skinny extents.
> While skinny extents has helped subjective performance a little bit I
> since experience the problem with ever increasing RAM usage - up to the
> point of 15 GB swap, full RAM, and almost none of it is used for
> caching.

That's an interesting point.  I've been cautious about enabling skinny 
extents as well, and haven't enabled them here.  (Nothing major, just a 
couple early reports that I expect have long been worked out by now, but 
I decided giving them a few more kernel releases to mature was probably a 
good idea.)

So it'd be interesting to see if there's a correlation between skinny 
extents and the memory issues as well, as there seems to be between 
qgroups and the memory issues.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

