Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43759 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbaCDSyf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Mar 2014 13:54:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WKuTy-0005H0-RV
	for linux-btrfs@vger.kernel.org; Tue, 04 Mar 2014 19:54:27 +0100
Received: from pool-96-232-101-151.nycmny.fios.verizon.net ([96.232.101.151])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Mar 2014 19:54:26 +0100
Received: from mike by pool-96-232-101-151.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Mar 2014 19:54:26 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Russo <mike@papersolve.com>
Subject: Re: ENOSPC errors during raid1 rebalance
Date: Tue, 4 Mar 2014 18:54:01 +0000 (UTC)
Message-ID: <loom.20140304T194101-763@post.gmane.org>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com> <20140303183911.GL13899@carfax.org.uk> <loom.20140304T164456-762@post.gmane.org> <1B8ADD42-4E49-4A9A-9AF9-F403BF69D92F@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists <at> colorremedies.com> writes:
> Based on my reading of the man page, I think it's expected. 
>You either need -s -l or -t.

Ok, although the man page uses [ ] instead of < > and something
does happen if I don't add them. But if I use "-t 1" wouldn't that
get everything?

> 
> >  Now I've gotten 
> > it down to only 2 5GB segments that won't move.
> 
> Another way would be to just copy it (not reflink) and delete the original.
> 

How can I find out what file is on the block group that 
it's having a problem with?



