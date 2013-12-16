Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50535 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab3LPKet (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 05:34:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VsVVe-000893-PG
	for linux-btrfs@vger.kernel.org; Mon, 16 Dec 2013 11:34:46 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 11:34:46 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 11:34:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send in 3.12 : can't find snapshot?
Date: Mon, 16 Dec 2013 10:34:25 +0000 (UTC)
Message-ID: <pan$85bb8$3e67585f$45c93b97$25e14599@cox.net>
References: <87y53lqx88.fsf@maru2.md5i.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Welsh Duggan posted on Sun, 15 Dec 2013 22:40:55 -0500 as
excerpted:

> I built the new btrfs-progs 3.12 recently.  I note that the version
> information doesn't seem to match this:
> 
>     # ./btrfs --version Btrfs v0.20-rc1-358-g194aa4a

I see Wang Shilong dealt with the snapshot issue; I'll tackle the version 
thing.

There was a bit of a hiccup in the versioning with the 3.12 tarball, 
since the version policy had just changed with it, and (I gather) the 
tarball prep script hadn't been updated appropriately.  I believe a patch 
has already been applied to fix the problem (the patch was certainly 
posted on this list, but I haven't tracked whether it was actually 
applied yet) so the same problem won't happen the next time.

Meanwhile, btrfs properly reports v3.12 here, but I pull and build from 
live-git, and the v3.12 tagged commit simply happened to still be current 
HEAD last I updated.  That does explain why the problem with the tarball 
version wasn't discovered earlier, however, since people (including the 
devs) building from live-git saw the expected v3.12; it was apparently 
only the process of preparing and releasing the tarball that was affected 
by the version bug.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

