Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45606 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbaCCUue (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 15:50:34 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WKZol-0005TN-P1
	for linux-btrfs@vger.kernel.org; Mon, 03 Mar 2014 21:50:31 +0100
Received: from pool-96-232-101-151.nycmny.fios.verizon.net ([96.232.101.151])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 21:50:31 +0100
Received: from mike by pool-96-232-101-151.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 21:50:31 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Russo <mike@papersolve.com>
Subject: Re: ENOSPC errors during raid1 rebalance
Date: Mon, 3 Mar 2014 20:50:05 +0000 (UTC)
Message-ID: <loom.20140303T214420-188@post.gmane.org>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com> <pan$b5b02$85505b$f53ee629$e32b9776@cox.net> <loom.20140303T191959-983@post.gmane.org> <D35E6741-2350-4910-B785-5584F730EDA9@colorremedies.com> <loom.20140303T200845-874@post.gmane.org> <523E1747-8B25-48F8-8DAD-D40021F42DAC@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists <at> colorremedies.com> writes:

> 
> > Chris Murphy <lists <at> colorremedies.com> writes:
> Gotcha. I think Hugo has the best next step. Defragment.

I think this is going to work. I cancelled a partial defrag 
and did another move attempt, and this time 
5GB got moved! So I'm going to let the whole thing 
finish and try again and that will probably fix it. 
Interestingly I had to specify the -t option to get some
 big files to move, it wouldn't work without it 
(I'm doing "btrfs fi defrag -r -v /mymedia -t 500000000"). 

> 
> That's not good. It sounds to me like misdirected writes. 
> Or file system corruption. Anyone else?

Oh yeah, it was definitely a problem with either the drives 
or the external enclosure, which was converting USB to SATA 
and mirroring the drives internally (it was a WD MyBook 
Mirror Edition). There was a problem with one of the drives 
and I replaced it, but before I did it screwed up some 
data. I think one drive kept trying to do a retry on a read 
and somehow the logic decided to just give me a "nearby" 
sector to satisfy the read (I can't really figure out how else 
10 seconds of a random but "nearby" in alphabetical order 
MP3 could get stuck into the middle of another MP3).   
So I removed the entire enclosure and put them inside 
my case and decided I never wanted it to happen again so I 
converted to btrfs. :)  Very happy it exists!


