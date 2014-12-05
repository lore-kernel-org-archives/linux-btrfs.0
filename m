Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39916 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaLEH0U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 02:26:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XwnHO-0004fk-7j
	for linux-btrfs@vger.kernel.org; Fri, 05 Dec 2014 08:26:18 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Dec 2014 08:26:18 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Dec 2014 08:26:18 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH V2][BTRFS-PROGS] Don't use LVM snapshot device
Date: Fri, 5 Dec 2014 07:26:05 +0000 (UTC)
Message-ID: <pan$67e00$edffae8a$cb013d3$4a1bb73d@cox.net>
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Thu, 04 Dec 2014 19:39:37 +0100 as
excerpted:

> To check if a device is a LVM snapshot, it is checked the 'udev'
> device property 'DM_UDEV_LOW_PRIORITY_FLAG' . If it is set to 1,
> the device has to be skipped.
> 
> As consequence, btrfs now depends also by the libudev.

Not being a coder I gotta ask...

How does this patch deal with mdev (busybox) or static dev instead of 
udev?  Does it gracefully degrade to legacy LVM-agnostic behavior?

Meanwhile, just requiring libudev is certain to bring some pretty zealous 
opposition from the anti-systemd/anti-udev camp.  I like the goal, but 
that better be an optional dep unless we're deliberately stepping into 
that debate, because that's exactly what we'd be doing.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

