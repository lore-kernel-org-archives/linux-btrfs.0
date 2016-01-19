Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51315 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515AbcASJOs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 04:14:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aLSNB-0003v3-QX
	for linux-btrfs@vger.kernel.org; Tue, 19 Jan 2016 10:14:45 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 10:14:45 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jan 2016 10:14:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)?
 Explain like I'm five pls.
Date: Tue, 19 Jan 2016 09:14:23 +0000 (UTC)
Message-ID: <pan$85c04$d9fd4f4d$1304efda$85c18be@cox.net>
References: <loom.20160116T132316-196@post.gmane.org>
	<569C41B1.1090206@cn.fujitsu.com>
	<pan$9ea8b$cdf4a5be$a6b3ced0$e73fd4ce@cox.net>
	<569C58FB.70407@cn.fujitsu.com>
	<pan$9dd9b$58cdc4a$94401f0f$f97ce29e@cox.net> <569CDF0D.9030609@gmail.com>
	<pan$9821b$e84a8fc3$23a877ef$2b0858e0@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Tue, 19 Jan 2016 08:30:43 +0000 as excerpted:

> (As I write this system/app memory usage is ~2350 MiB, buffers 4 MiB,
> cache 7321 MiB, total usage ~9680 MiB, on a 16 GiB system.  That's with
> about three days uptime, after mounting the packages partition and
> remounting / rw and doing a bunch of builds, then umounting the pkgs
> partition, killing X and running a lib_users check to ensure no services
> are running on outdated deleted libs and need restarted, remounting
> / ro, and restarting X.  At some point I had the media partition
> mounted too, but now it's unmounted again, dropping that cache.  So in
> addition to cache memory which /could/ be dumped if I had to, I have
> 6+ GiB of entirely idle unused memory.  Nice as I don't have swap
> configured, so if I'm out of RAM, I'm out, but there's a lot of cache
> to dump first before it gets that bad.  Meanwhile, zero cache pressure,
> and 6+ GiB of spare RAM to use for apps/tmpfs/cache if I need it,
> before any cache dumps at all! =:^)

Oh, I also don't allow any crazy indexers, like kde's baloo or the older 
updatedb for (s)locate, to go crazy indexing everything, thereby wasting 
valuable cache memory on files I won't actually be using.  These things 
get shut down as soon as I discover new ones, and preferably get 
uninstalled, with dependencies on them turned off (on gentoo, via 
appropriate USE flag) as well.  On kde4 I was even carrying my own no-
semantic-desktop patches for awhile, when gentoo/kde decided they weren't 
going to support kde without semantic-desktop.  Fortunately they changed 
their minds.  I'm now finally updated to kde-frameworks5 with plasma5, 
and have baloo installed for that as I don't yet grok how to keep it off 
the system entirely in frameworks/plasma5, but it's definitely shut down 
as far as runtime goes.

There is a package indexer that runs, and of course syncing package 
updates loads all that in cache, but all that's on my packages partition, 
unmounted when I'm not actively doing package updates, etc, thereby 
freeing the package updates subsystem caches.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

