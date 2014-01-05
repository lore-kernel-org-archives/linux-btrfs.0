Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49209 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751836AbaAEUpE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 15:45:04 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs-transaction blocked for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$95dc3$6f31a244$d85ae144$1545dedf@cox.net>
Date: Sun, 5 Jan 2014 13:44:59 -0700
Message-Id: <188E11D6-411D-49F7-9B41-FB40B2AECB44@colorremedies.com>
References: <52C2AE7C.5020601@gmx.at> <pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net> <20140103172506.GA10021@merlins.org> <pan$6ce5a$53830c0$382c1e0e$7169217c@cox.net> <20140105063957.GF11749@merlins.org> <8EE40903-FE21-4516-B2D8-4EB8DCE79376@colorremedies.com> <52C99C64.2010209@jrs-s.net> <pan$95dc3$6f31a244$d85ae144$1545dedf@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 5, 2014, at 12:57 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> 
> But I do very little snapshotting here, and as a result hadn't considered 
> the knockon effect of 100K-plus extents in perhaps 1000 snapshots.

I wonder if this is an issue with snapshot aware defrag? Some problems were fixed recently but I'm not sure of the status.

The OP's case involves Btrfs on LVM on (I think) md raid5. The mdadm default stripe size is 512KB, which would be a 1MB full stripe. There are some optimizations for non-full stripe reads and writes for raid5 (not for raid6 so it takes a much bigger performance hit) but nevertheless it might be a factor.

>  I 
> guess that's what's killing the defrag, however it's initiated.  The only 
> way to get rid of the problem, then, would be to move the file away and 
> then back, but doing so does still leave all those snapshots with the 
> crazy fragmentation, and to kill that would require either killing all 
> those snapshots, or setting them writable and doing the same move out, 
> move back, on each one!  OUCH, but I guess that's why it just seems 
> impossible to deal with the fragmentation on these things, whether it's 
> autodefrag, or named file defrag, or doing the whole move out and back 
> thing, and then having to worry about all those snapshots.

It's why in the short term I'm using +C from the get go. And if I had more VM images and qcow2 snapshots, I would put them in a subvolume of their own so that they aren't snapshotted along with rootfs. Using Btrfs within the VM I still get the features I expect and the performance is quite good.


Chris Murphy

