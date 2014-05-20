Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:34569 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbaETCHO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 22:07:14 -0400
From: Russell Coker <russell@coker.com.au>
To: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: Re: ditto blocks on ZFS
Date: Tue, 20 May 2014 12:07:10 +1000
Message-ID: <4483661.BdmCOR8JR5@xev>
In-Reply-To: <537A7BF9.5060508@swiftspirit.co.za>
References: <2308735.51F3c4eZQ7@xev> <lldpvm$s7c$1@ger.gmane.org> <537A7BF9.5060508@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 19 May 2014 23:47:37 Brendan Hide wrote:
> This is extremely difficult to measure objectively. Subjectively ... see
> below.
> 
> > [snip]
> > 
> > *What other failure modes* should we guard against?
> 
> I know I'd sleep a /little/ better at night knowing that a double disk
> failure on a "raid5/1/10" configuration might ruin a ton of data along
> with an obscure set of metadata in some "long" tree paths - but not the
> entire filesystem.

My experience is that most disk failures that don't involve extreme physical 
damage (EG dropping a drive on concrete) don't involve totally losing the 
disk.  Much of the discussion about RAID failures concerns entirely failed 
disks, but I believe that is due to RAID implementations such as Linux 
software RAID that will entirely remove a disk when it gives errors.

I have a disk which had ~14,000 errors of which ~2000 errors were corrected by 
duplicate metadata.  If two disks with that problem were in a RAID-1 array 
then duplicate metadata would be a significant benefit.

> The other use-case/failure mode - where you are somehow unlucky enough
> to have sets of bad sectors/bitrot on multiple disks that simultaneously
> affect the only copies of the tree roots - is an extremely unlikely
> scenario. As unlikely as it may be, the scenario is a very painful
> consequence in spite of VERY little corruption. That is where the
> peace-of-mind/bragging rights come in.

http://research.cs.wisc.edu/adsl/Publications/corruption-fast08.html

The NetApp research on latent errors on drives is worth reading.  On page 12 
they report latent sector errors on 9.5% of SATA disks per year.  So if you 
lose one disk entirely the risk of having errors on a second disk is higher 
than you would want for RAID-5.  While losing the root of the tree is 
unlikely, losing a directory in the middle that has lots of subdirectories is 
a risk.

I can understand why people wouldn't want ditto blocks to be mandatory.  But 
why are people arguing against them as an option?


As an aside, I'd really like to be able to set RAID levels by subtree.  I'd 
like to use RAID-1 with ditto blocks for my important data and RAID-0 for 
unimportant data.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

