Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxout014.mail.hostpoint.ch ([217.26.49.174]:59501 "EHLO
	mxout014.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbcFKNNr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jun 2016 09:13:47 -0400
Received: from [10.0.2.45] (helo=asmtp012.mail.hostpoint.ch)
	by mxout014.mail.hostpoint.ch with esmtp (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bBijQ-000IiR-NO
	for linux-btrfs@vger.kernel.org; Sat, 11 Jun 2016 15:13:44 +0200
Received: from 217-162-125-82.dynamic.hispeed.ch ([217.162.125.82] helo=imac.lan)
	by asmtp012.mail.hostpoint.ch with esmtpa (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bBijQ-0000PW-LT
	for linux-btrfs@vger.kernel.org; Sat, 11 Jun 2016 15:13:44 +0200
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
From: boli <btrfs@bueechi.net>
In-Reply-To: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
Date: Sat, 11 Jun 2016 15:13:44 +0200
Message-Id: <38F2FB04-0617-4DD3-9D48-ED3C4434003D@bueechi.net>
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Updates:

> So for this first replacement I mounted the volume degraded and ran "btrfs device delete missing /mnt", and that's where it's been stuck for the past ~23 hours. Only later did I figure out that this command will trigger a rebalance, and of course that will take a long time.

It has now been doing "btrfs device delete missing /mnt" for about 90 hours.

These 90 hours seem like a rather long time, given that a rebalance/convert from 4-disk-raid5 to 4-disk-raid1 took about 20 hours months ago, and a scrub takes about 7 hours (4-disk-raid1).

OTOH the filesystem will be rather full with only 3 of 4 disks available, so I do expect it to take somewhat "longer than usual".

Would anyone venture a guess as to how long it might take?

> I assume I could probably just Ctrl+C that "btrfs device delete missing /mnt", and the balance would continue as usual in the background, but I have not done that yet, as I'd rather consult you guys first (a bit late, I know).

I've tried finding more info about "btrfs device delete missing", but the man page doesn't even mention the "missing" option, nor does it tell about a rebalance automatically starting (or if that rebalance runs in the background and if Ctrl+C should work or not).

Given my assumption above I've just tried hitting Ctrl+C, but it didn't do anything. The (Java remote console) cursor is still happily blinking away, so I assume it's still doing its thing.

Since it's weekend I'd have more time to tinker, but I'm afraid to do anything drastic, such as force reboot the box, because in some other mails I read that one has just *one* chance to save a degraded array (though not sure if this applies to my case here).

If you know any DOs/DON'Ts please share. :)

Ofc I'll keep reporting any new developments. And should this replacement of the first of 4 drives turn end well, I'll replace the second drive with the "btrfs replace" option instead of delete/add and report.

Cheers, boli


