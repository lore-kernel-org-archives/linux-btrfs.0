Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54122 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab3LOX2u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 18:28:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VsL7B-0006vb-3J
	for linux-btrfs@vger.kernel.org; Mon, 16 Dec 2013 00:28:49 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 00:28:49 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 00:28:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs balance on single device
Date: Sun, 15 Dec 2013 23:28:21 +0000 (UTC)
Message-ID: <pan$138cb$448d68e$2d9dcb10$fc6a898a@cox.net>
References: <CAAeznTpG6A7ygKg1AUx_pAMs_SNwG4a4C5gHPeT+HcKRsD+TWA@mail.gmail.com>
	<20131215202456.GA11281@carfax.org.uk>
	<CAAeznTryb7kyuvEyBFniv-UtGCQwdNtZMhpxm=-2MtKZSOj9Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Leonidas Spyropoulos posted on Sun, 15 Dec 2013 20:28:05 +0000 as
excerpted:

> Oh, so the df report from btrfs doesn't show the total as 'free'! But it
> means how much space the filesystem allocated so far.

Yes.

Btrfs allocates in chunks, 256 MiB at a time for metadata (but on a 
single device, metadata chunks are DUP by default, so two are created at 
once, thus half a gig), 1 GiB at at a time for data (single device 
values, when there's plenty of unallocated space left in ordered to do 
so).  As these chunks are filled up new ones are allocated as necessary 
(assuming there's enough unallocated space left to do so).

But normal usage including deleting old files and rewriting parts of 
existing files (to new locations due to btrfs' copy-on-write/COW 
semantics) will often leave several partially filled chunks around, and a 
balance rewrites chunks, consolidating into fewer new chunks when 
possible as it does so.

That's what the btrfs fi df reports showed, many partially filled chunks 
before the balance, fewer but full chunks afterward, with the freed chunk 
space returned to the unallocated pool.

While btrfs fi df could report unallocated space as well, given the 
possibility of it being allocated differently (DUP vs SINGLE, and on 
multi-device filesystems, the various raid modes), it can't reliably 
predict how that unallocated space will be used and thus how much 
/effective/ free space you have.

But btrfs fi show gives the total filesystem size, as well as the total 
allocated.  So between df and show, plus a little math if necessary, you 
get a better picture.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

