Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:53433 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab3KQOny (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Nov 2013 09:43:54 -0500
Received: from bluebottle.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id A0D69219C2
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Nov 2013 01:43:52 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: Re: NMI from btrfs cron jobs in 3.11.6
Date: Mon, 18 Nov 2013 01:43:51 +1100
References: <201311140145.29255.russell@coker.com.au> <pan$4655$5629e47b$7d83e5a0$59910e71@cox.net>
In-Reply-To: <pan$4655$5629e47b$7d83e5a0$59910e71@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201311180143.51552.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 14 Nov 2013, Duncan <1i5t5.duncan@cox.net> wrote:
> > It appears that running two scripts that create snapshots at the same
> > time as a script that removes maybe 97 snapshots causes an NMI.
> 
> This is a known bug in 3.11 (and presumably earlier).  Snapshot 
> manipulation concurrency evidently wasn't originally well considered, and 
> either a recent regression triggered the problem or possibly it always 
> existed and only recently was reported (I don't know either way, tho the 
> btrfs devs might).
> 
> Either way, there's a patch both to address the problem and adding a 
> regression test to the xfstests filesystem testing suite to catch future 

Thanks for the information.

As an aside, I had it happen on a workstation that I was using to watch a 
movie over NFS.  Strangely the BTRFS hang caused video playback to pause.  I 
didn't expect a BTRFS issue like that to stop access to an NFS mount from 
another system.

Would it be locking up inside the VFS?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
