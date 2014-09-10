Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cust-198-154-114-217.corexchange.com ([198.154.114.217]:55833
	"EHLO vkenny.zootboy.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753361AbaIJTi2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 15:38:28 -0400
Date: Wed, 10 Sep 2014 15:32:12 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Bob Williams <linux@barrowhillfarm.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Is it necessary to balance a btrfs raid1 array?
Message-ID: <20140910193212.GA2549@wheatley.student.rit.edu>
References: <541043B8.7010601@barrowhillfarm.org.uk>
 <54109BCD.5000106@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54109BCD.5000106@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 10, 2014 at 08:43:25PM +0200, Goffredo Baroncelli wrote:
> May be that I am missing something obvious, however I have to ask which 
> would be the purpose to balance a two disks RAID1 system.
> The balance command should move the data between the disks in order to
> avoid some disk full and other empty; but this assume that there is a
> not symmetrical uses of the disks. Which is not the case for a RAID1/two
> disks system.

Balancing is not necessarily about data distribution between two disks.
You can balance a single disk BTRFS partition. It's more about balancing
how the data / metadata chunks are allocated and used. It also (during a
re-write of a chunk) honors the RAID rules of that chunk type.

> *scrub
> Regarding scrub, pay attention that some (consumer) disks are 
> guarantee for a (not recoverable) error rate less than 1/10^14 [1] 
> bit reads. 10^14 bit are something like 10TB. This means that if you 
> read your system 5 times, you may got an error bit. I suppose 
> that these are very conservative number, so the likelihood of an 
> undetected error is (I hope)lower. But also I am inclined to think 
> these number are evaluated in an ideal case (in term of temperature, 
> voltage, vibration); this means that the true might be worse.
> 
> So if you compare these numbers with your average throughput, 
> you can estimate which is the likelihood of an error. Pay attention
> that a scrub job means read all your data: If you have 1T of data,
> and you performs a scrub each week, in three months you reach the 10^14
> bit reads.....
> 
> This explains the interest in higher redundancy level (raid 6 or more).
>  
> G.Baroncelli

I think there is a bit of misunderstanding here. Those disk error rates
are latent media errors. They're a function of production quality of the
platters and the amount of time the data rests on the drive. Reads do
not affect this, and in fact, can actually help reduce the error rate. 

When a hard drive does a read, it also reads the CRC values for the
sector that it just read. If it matches, the drive passes it on as good
data. If not, it attempts error correction on it. If it can correct the
error, it will return the corrected data and (hopefully) re-write the
data on the disk to fix the error "permanently." I use quotes because
this could mean that that zone of media is damaged, and it will probably
error again. The disk will eventually re-allocate a sector that
repeatedly returns bad data. This is what you want to happen.

So doing reads, especially across the entire media surface, is a great
way to make the disk perform these sector checks. But sometimes the disk
cannot correct the error. Then the controller (if it is well-behaved)
will return a read error, or sometimes just bunk data. If the BTRFS
scrub sees bad data, it will detect it with its checksums, and if in a
RAID configuration, be able to locate a good copy of the data to
restore. 

Long story short, reads don't cause media errors, and scrubs help detect
errors early.

--Sean
