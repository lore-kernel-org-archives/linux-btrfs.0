Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46905 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab3LLNjR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 08:39:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vr6Tx-0004Dx-Jy
	for linux-btrfs@vger.kernel.org; Thu, 12 Dec 2013 14:39:13 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Dec 2013 14:39:13 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Dec 2013 14:39:13 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfs raid multiple devices IO utilisation
Date: Thu, 12 Dec 2013 13:39:00 +0000
Message-ID: <l8ce99$31i$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some time back, I noticed that with a two HDD btrfs raid1, some tasks
suffered ALL the IO getting choked onto just one HDD!


That turned out to be a feature of the btrfs code whereby a device is
chosen depending on the process ID. For some cases such as in a bash
loop, the PID increments by two for each iteration and so only one HDD
ever gets hit...

So... Running with a 3-disk btrfs raid1 and... I still see the same
problem for such as compile tasks where only one of the three disks is
maxed out for periods with the other two disks left nearly idle.


Perhaps?...

Is there an easy fix in the code to allocate IO according to the
following search order:

Last used disk with an IO queue < 2 items;

Any disk with an IO queue < 2 items;

Whichever disk with least queued items.


The intention there is to repeat sequential IO to the current disk, but
allow a second disk to interleave data requests for a same one file if
data is requested faster than what the one disk can support.

Other aspects are that the IO queue length checks hopefully will
proportionately balance the requests across disks that offer different
speeds. Hence a faster disk will get used to advantage if paired with a
slower device.


There looks to be two points in the code where a device gets selected.
Not having delved into filesystems before... Is there easy/safe reading
available for the IO queues for a device?

Or rather: All easily done?

(Or is the btrfs code at too high a level to be able to see/access the
device IO queues?)


Regards,
Martin

