Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38877 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbbHJENY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Aug 2015 00:13:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZOeSg-0000Wa-22
	for linux-btrfs@vger.kernel.org; Mon, 10 Aug 2015 06:13:22 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 06:13:22 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2015 06:13:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid1 on uneven-sized disks
Date: Mon, 10 Aug 2015 04:13:15 +0000 (UTC)
Message-ID: <pan$2bbc7$72b8aa61$ae5f57d7$55005ae7@cox.net>
References: <CAMoY8LpmhQtSvW-sWbGKDFKNN3xaKPwe+QxU5wCMg2Wcz3ObWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jim MacBaine posted on Sun, 09 Aug 2015 14:29:53 +0200 as excerpted:

> Traditionally I'm using rsync to create hardlinked backups on ext3/4 on
> md-raid1. This setup has been working reliably for many years now,
> including the survival of two disk failures. But it is quite cumbersome
> to reshape the structure of the raids when I get a new disk, an old one
> fails, or space requirements change. A single btrfs with snapshots would
> be much easier to handle. I'm not aiming for absolute reliability here
> -- all the really important stuff is backed up in a third place as well.
> But I would rather not like my file system to be the weakest link in the
> backup chain.

Others answered your raid1 question well, but left this, so let me tackle 
it.

My standard answer to btrfs stability questions is that btrfs is "not yet 
fully stable and mature", it's stabilizing, and definitely more stable 
that it has been, but it has only been a few kernel cycles since some 
really big bugs that hit a lot of people, and in fact, user-space side, 
there was a critical bug in mkfs.btrfs in btrfs-progs v4.1.1 (with v4.1.2 
being current), so they do still happen from time to time, tho that one 
only affected people happening to do a mkfs.btrfs with the affected 
version, which was only out a couple weeks or so.

IOW, the standard sysadmin rule that if it's not backed up, by 
definition, you don't care about it, still applies double to btrfs -- 
really, keep your backups, or your actions demonstrate your lack of care 
and you may see the results thereof.

That said, btrfs is working well in daily use for many people, and some 
distros are shipping it as the default for at least some partitions 
(often root, where the snapshot feature is used to manage update 
rollbacks where necessary), so it's stable /enough/, as long as you do 
have those backups and are prepared to use them, should it be necessary.

We do recommend that you stay relatively current on both kernel and 
userspace, however.  So a current 4.1 series kernel and btrfs-progs 4.1.2 
are excellent, but consider another filesystem if you're the type who was 
still on a 2.x kernel thru 3.12 or so. =:^)  

And... there's a couple btrfs features to avoid at this time.  As 
mentioned elsewhere, raid56 mode is still quite new and not yet mature, 
yet, so avoid it unless you intend to take on the risk of leading-edge 
testing, and the btrfs quota code continues to be a source of issues, so 
I recommend not using quotas on btrfs.  If you need quotas, you want 
another filesystem anyway, because quotas simply aren't reliable on btrfs 
yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

