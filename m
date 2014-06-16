Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:51377 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaFPMBM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 08:01:12 -0400
From: Russell Coker <russell@coker.com.au>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>
Reply-To: russell@coker.com.au
Subject: Re: BTRFS, SSD and single metadata
Date: Mon, 16 Jun 2014 22:01:08 +1000
Message-ID: <6499435.9u7rVIGiXd@xev>
In-Reply-To: <539ED3A2.50309@gmail.com>
References: <1723493.aXdklhDgAK@vajra> <4823159.jCObc9Zrv0@vajra> <539ED3A2.50309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 16 Jun 2014 07:23:14 Austin S Hemmelgarn wrote:
> I'd personally stay with the DUP profile, but then that's just me being
> paranoid.  You will almost certainly get better performance using the
> SINGLE profile instead of DUP, but this is mostly due to it requiring
> fewer blocks to be encrypted by LUKS (Which is almost certainly your
> primary bottleneck unless you have some high-end crypto-accelerator card).

On my Q8400 workstation running BTRFS over LUKS on an Intel SSD the primary 
bottleneck has always been BTRFS.  The message I wrote earlier today about 
BTRFS fallocate() performance was on this system, I had BTRFS using kernel CPU 
time for periods of 10+ seconds without ANY disk IO - so LUKS wasn't a 
performance issue.

So far I've never seen LUKS be a performance bottleneck.  When running LUKS on 
spinning media the disk seek performance will almost always be the bottleneck.

The worst case for LUKS is transferring large amounts of data such as 
contiguous reads.  In a contiguous read test I'm seeing 120MB/s for LUKS on a 
SSD and 200MB/s for direct access to the same SSD.  That is a reasonable 
difference, but it's not something I've been able to hit with any real-world 
use while BTRFS metadata performance is often an issue.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

