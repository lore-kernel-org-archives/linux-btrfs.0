Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50320 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbbJCIcY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Oct 2015 04:32:24 -0400
From: Russell Coker <russell@coker.com.au>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: BTRFS as image store for KVM?
Date: Sat, 3 Oct 2015 18:32:17 +1000
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <55F88ECC.1040604@menke.ac> <201510021421.09558.russell@coker.com.au> <560E737C.7050206@gmail.com>
In-Reply-To: <560E737C.7050206@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201510031832.17802.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2 Oct 2015 10:07:24 PM Austin S Hemmelgarn wrote:
> > ARC presumably worked better than the other Solaris caching options.  It
> > was ported to Linux with zfsonlinux because that was the easy way of
> > doing it.
> 
> Actually, I think part of that was also the fact that ZFS is a COW 
> filesystem, and classical LRU caching (like the regular Linux pagecache) 
> often does horribly with COW workloads (and I'm relatively convinced 
> that this is a significant part of why BTRFS has such horrible 
> performance compared to ZFS).

Last time I checked a BTRFS RAID-1 filesystem would assign each process to read 
from one disk based on it's PID.  Every RAID-1 implementation that has any 
sort of performance optimisation will allow a single process that's reading to 
use both disks to some extent.

When the BTRFS developers spend some serious effort optimising for performance 
it will be useful to compare BTRFS and ZFS.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
