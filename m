Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49206 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbaCEWNl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Mar 2014 17:13:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WLK4I-0000ai-MY
	for linux-btrfs@vger.kernel.org; Wed, 05 Mar 2014 23:13:39 +0100
Received: from pool-96-232-101-151.nycmny.fios.verizon.net ([96.232.101.151])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Mar 2014 23:13:38 +0100
Received: from mike by pool-96-232-101-151.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Mar 2014 23:13:38 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Russo <mike@papersolve.com>
Subject: Re: ENOSPC errors during raid1 rebalance
Date: Wed, 5 Mar 2014 22:13:10 +0000 (UTC)
Message-ID: <loom.20140305T190503-404@post.gmane.org>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>,<20140303183911.GL13899@carfax.org.uk> <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com> <73124688-5EDF-4DB5-AC9E-9F365397DD28@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists <at> colorremedies.com> writes:

> You could also try a full defragment by specifying -r on the mount point
> with a small -t value to effectively cause everything to be subject
> to defragmenting. If this still doesn't permit soft rebalance, then maybe
> filefrag can find files that have more than 1 extent and just copy 
> them (make duplicates, delete the original). Any copy will be
> allocated into chunks with the new profile.

I would think so too.  But it doesn't seem to be happening. 
Here is an example with one file:

root@ossy:/mymedia# filefrag output.wav
output.wav: 2 extents found
root@ossy:/mymedia# /usr/src/btrfs-progs/btrfs fi de -t 1 /mymedia/output.wav 
root@ossy:/mymedia# filefrag output.wav
output.wav: 2 extents found

btrfs does not defrag the file. And copying the file usually
doesn't defrag it either:

root@ossy:/mymedia# cp output.wav output.wav.bak
root@ossy:/mymedia# filefrag output.wav.bak
output.wav.bak: 2 extents found

I even tried copying a large file to another filesystem (/dev/shm),
 removing the original, and copying it back, and more often than not 
it still had more than 1 extent. 

If I copy each file out to another filesystem and then back, will btrfs 
not use any of the space on the "single" and just re-allocate space 
on the RAID1 like I want it to?


