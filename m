Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53054 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab3L2VKh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Dec 2013 16:10:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VxNd5-0004tM-PD
	for linux-btrfs@vger.kernel.org; Sun, 29 Dec 2013 22:10:35 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2013 22:10:35 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Dec 2013 22:10:35 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Migrate to bcache: A few questions
Date: Sun, 29 Dec 2013 22:11:16 +0100
Message-ID: <kof6pa-akd.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list!

I'm planning to buy a small SSD (around 60GB) and use it for bcache in front 
of my 3x 1TB HDD btrfs setup (mraid1+draid0) using write-back caching. Btrfs 
is my root device, thus the system must be able to boot from bcache using 
init ramdisk. My /boot is a separate filesystem outside of btrfs and will be 
outside of bcache. I am using Gentoo as my system.

I have a few questions:

* How stable is it? I've read about some csum errors lately...

* I want to migrate my current storage to bcache without replaying a backup.
  Is it possible?

* Did others already use it? What is the perceived performance for desktop
  workloads in comparision to not using bcache?

* How well does bcache handle power outages? Btrfs does handle them very
  well since many months.

* How well does it play with dracut as initrd? Is it as simple as telling it
  the new device nodes or is there something complicate to configure?

* How does bcache handle a failing SSD when it starts to wear out in a few
  years?

* Is it worth waiting for hot-relocation support in btrfs to natively use
  a SSD as cache?

* Would you recommend going with a bigger/smaller SSD? I'm planning to use
  only 75% of it for bcache so wear-leveling can work better, maybe use
  another part of it for hibernation (suspend to disk).

Regards,
Kai

