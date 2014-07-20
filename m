Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54163 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaGTIqD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 04:46:03 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X8mkr-0006yN-1q
	for linux-btrfs@vger.kernel.org; Sun, 20 Jul 2014 10:46:01 +0200
Received: from athedsl-372136.home.otenet.gr ([79.131.5.166])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 10:46:01 +0200
Received: from tmjuju by athedsl-372136.home.otenet.gr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 10:46:01 +0200
To: linux-btrfs@vger.kernel.org
From: TM <tmjuju@yahoo.com>
Subject: 1 week to rebuid 4x 3TB raid10 is a long time!
Date: Sun, 20 Jul 2014 08:45:51 +0000 (UTC)
Message-ID: <loom.20140720T102642-239@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a raid10 with 4x 3TB disks on a microserver
http://n40l.wikia.com/wiki/Base_Hardware_N54L , 8Gb RAM

Recently one disk started to fail (smart errors), so I replaced it
Mounted as degraded, added new disk, removed old
Started yesterday
I am monitoring /var/log/messages and it seems it will take a long time
Started at about 8010631739392
And 20 hours later I am at 6910631739392 
btrfs: relocating block group 6910631739392 flags 65

At this rate it will take a week to complete the raid rebuild!!!

Furthermore it seems that the operation is getting slower and slower
When the rebuild started I had a new message every half a minute, now it’s
getting to OneAndHalf minutes
Most files are small files like flac/jpeg

One week for a raid10 rebuild 4x3TB drives is a very long time.
Any thoughts?
Can you share any statistics from your RAID10 rebuilds?

If I shut down the system, before the rebuild, what is the proper procedure
to remount it? Again degraded? Or normally? Can the process of rebuilding
the raid continue after a reboot? Will it survive, and continue rebuilding?

Thanks in advance
TM


