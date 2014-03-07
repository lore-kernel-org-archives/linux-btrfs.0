Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58829 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaCGBOV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 20:14:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WLjMh-0002Id-8R
	for linux-btrfs@vger.kernel.org; Fri, 07 Mar 2014 02:14:19 +0100
Received: from pool-96-232-101-151.nycmny.fios.verizon.net ([96.232.101.151])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Mar 2014 02:14:19 +0100
Received: from mike by pool-96-232-101-151.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Mar 2014 02:14:19 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Russo <mike@papersolve.com>
Subject: Re: ENOSPC errors during raid1 rebalance
Date: Fri, 7 Mar 2014 01:13:53 +0000 (UTC)
Message-ID: <loom.20140307T021006-737@post.gmane.org>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com> <20140303183911.GL13899@carfax.org.uk> <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com> <73124688-5EDF-4DB5-AC9E-9F365397DD28@colorremedies.com> <loom.20140305T190503-404@post.gmane.org> <pan$23ceb$3bedfe62$bfb976de$e16d8fde@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

> But if you're not using compression, /that/ can't explain it...
> 

Ha! Well while that was an interesting discussion of fragmentation,
I am only using the default mount options here and so no compression. 
The only reason I'm really even looking at the fragmentation 
issue is because running the defragment (with varying sizes of
"-t" which I'm not sure why that's even necessary) seemed
to force btrfs to move segments around and let me rebalance
more block groups.  I don't even care if the files are defragged,
I just want them all in the RAID1 profile.  Hopefully if I move
each file out to some other FS like /dev/shm and then back
it will work, I just gotta hack a script together to do so.

