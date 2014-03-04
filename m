Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53588 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbaCDPzu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Mar 2014 10:55:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WKrh5-0005H9-0F
	for linux-btrfs@vger.kernel.org; Tue, 04 Mar 2014 16:55:47 +0100
Received: from pool-96-232-101-151.nycmny.fios.verizon.net ([96.232.101.151])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Mar 2014 16:55:46 +0100
Received: from mike by pool-96-232-101-151.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Mar 2014 16:55:46 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Russo <mike@papersolve.com>
Subject: Re: ENOSPC errors during raid1 rebalance
Date: Tue, 4 Mar 2014 15:55:20 +0000 (UTC)
Message-ID: <loom.20140304T164456-762@post.gmane.org>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com> <20140303183911.GL13899@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo <at> carfax.org.uk> writes:

>    This is just a guess, but you might have some large (>1GB) 
extents
> in there that span across multiple chunks. I'd suggest running a 
btrfs
> defrag on any particularly big files and see if that helps the 
situation.
> 

Doing this is definitely helping, but I have to run the defrag multiple 
times with different values for "-t". If I don't include -t the defrag 
runs really quickly but doesn't seem to do anything.  Now I've gotten 
it down to only 2 5GB segments that won't move.  I'm going to 
extract the very big log generated when I run 
"btrfs ba start -dconvert=raid1,soft /mymedia" 
with enospc_debug and send it as a file, hopefully it will help.  
The first couple lines are:

Mar  4 10:49:23 ossy kernel: [134922.806764] BTRFS info (device sdd1): 
relocating block group 894460493824 flags 1
Mar  4 10:49:32 ossy kernel: [134931.650504] BTRFS error (device sdd1): 
allocation failed flags 17, wanted 1368420352
Mar  4 10:49:32 ossy kernel: [134931.650507] BTRFS: space_info 1 has 
113996488704 free, is not full
Mar  4 10:49:32 ossy kernel: [134931.650509] BTRFS: space_info 
total=1320702443520, used=1201311391744, pinned=0, 
reserved=565596160, may_use=1368420352, readonly=4828966912




