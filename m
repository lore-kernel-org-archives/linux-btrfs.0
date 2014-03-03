Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40620 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbaCCTYu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 14:24:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WKYTp-00068r-CM
	for linux-btrfs@vger.kernel.org; Mon, 03 Mar 2014 20:24:49 +0100
Received: from pool-96-232-101-151.nycmny.fios.verizon.net ([96.232.101.151])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 20:24:49 +0100
Received: from mike by pool-96-232-101-151.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 20:24:49 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Russo <mike@papersolve.com>
Subject: Re: ENOSPC errors during raid1 rebalance
Date: Mon, 3 Mar 2014 19:24:22 +0000 (UTC)
Message-ID: <loom.20140303T200845-874@post.gmane.org>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com> <pan$b5b02$85505b$f53ee629$e32b9776@cox.net> <loom.20140303T191959-983@post.gmane.org> <D35E6741-2350-4910-B785-5584F730EDA9@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists <at> colorremedies.com> writes:

> It might be worth adding enospc_debug as a mount option 

These messages only appear when I mount with enospc_debug. I 
included them as examples but I can post the full output later if 
needed. As for whether btrfs-convert should be recommended, I 
mean probably not, but when you've got a big media drive filled 
with music, pictures, and movies, with no other place to store it, 
and you've experienced corruption where 5% of your MP3 files
have 10 seconds of another MP3 stuck in the middle of them
somehow,  and suddenly realize you NEED a checksumming 
next-generation file system like btrfs, you're going to convert!




