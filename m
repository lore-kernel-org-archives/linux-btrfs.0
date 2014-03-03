Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58506 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbaCCSaK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 13:30:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WKXcp-0002CH-PQ
	for linux-btrfs@vger.kernel.org; Mon, 03 Mar 2014 19:30:04 +0100
Received: from pool-96-232-101-151.nycmny.fios.verizon.net ([96.232.101.151])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 19:30:03 +0100
Received: from mike by pool-96-232-101-151.nycmny.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 19:30:03 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Russo <mike@papersolve.com>
Subject: Re: ENOSPC errors during raid1 rebalance
Date: Mon, 3 Mar 2014 18:24:41 +0000 (UTC)
Message-ID: <loom.20140303T191959-983@post.gmane.org>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com> <pan$b5b02$85505b$f53ee629$e32b9776@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:
> 
> That allows rollback if desired, but does tie up some some space with the 
> automatically created btrfs "snapshot" that contains the ext3/4 metadata 
> and untouched data.  

Nope, I definitely deleted the snapshots, running btrfs sub list 
gives me nothing back:

root@ossy:/usr/src/btrfs-progs# /usr/src/btrfs-progs/btrfs sub list /mymedia
root@ossy:/usr/src/btrfs-progs# 

Thanks for the detailed reply though. While doing this operation I 
wanted to not have any snapshots so that I needed the minimum 
amount of space to do the rebalance.  

But this all does seem strange right? Why the heck would it refuse
to move these 70GB and think there are 0 blocks of free space? 

