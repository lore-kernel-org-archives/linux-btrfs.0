Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35063 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab2ITOFI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 10:05:08 -0400
Date: Thu, 20 Sep 2012 16:05:00 +0200
From: David Sterba <dave@jikos.cz>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>,
        ching <lsching17@gmail.com>
Subject: Re: enquiry about autodefrag option
Message-ID: <20120920140500.GO17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50570652.4060200@gmail.com>
 <5059AC5E.1030003@gmail.com>
 <5059D2D3.3050303@oracle.com>
 <201209191939.43182.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <201209191939.43182.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2012 at 07:39:42PM +0200, Martin Steigerwald wrote:
> > >>    (P.S. I am aware that autodefrag will introduce extra write I/O)
> > 
> > Yes, your understanding is right, random write workloads will benefit
> > from it.
> 
> What about the extra I/O? And the greatly reduced seek times on SSDs?
> 
> Upto now I kept away from defragmenting on SSD.
> 
> I wonder about a good way to decide whether autodefrag makes things better 
> or worse for a specific workload. What are the criteria on rotating media 
> and what are they on SSD?

Reducing data block fragmentation is accompanied by decreased metadata
usage that's needed to maintan the data blocks, and this means less
cpu processing and less memory usage.

Blocks in larger contiguous chunks are also more friendly to the SSD
garbage collection. A full filesystem defrag & fstrim once in a while
may improve performance and device lifetime.

> [??? informational part about a BTRFS on SSD that should have an age of at 
> least 8 months with almost daily upgrades  ???]
> 
> I only have / running on SSD, but this since quite some time. And it does 
> not seem to have gotten much worse ??? however this is only subjective 
> feeling of performance.
> 
> Except for fstrim times. fstrim take way more time than in the beginning¹. 
> So there seems to be free space fragmentation. Which makes sense for a 
> root filesystem on a Debian Sid machine with lots of upgrade activity and 
> way over 50% usage.

I'm roughly counting:

used: 11 + 2*0.688           = 12
touched blocks: 15 + 2* 1.75 = 18.5

of 19, ~90%, this may be problematic even on a SSD regarding the erase
block related specifics.

> merkaba:~> df -hT /          
> Dateisystem    Typ   Größe Benutzt Verf. Verw% Eingehängt auf
> /dev/dm-0      btrfs   19G     13G  3,6G   79% /
> 
> merkaba:~> btrfs fi sh       
> failed to read /dev/sr0
> Label: 'debian'  uuid: [???]
>         Total devices 1 FS bytes used 12.25GB
>         devid    1 size 18.62GB used 18.62GB path /dev/dm-0
> 
> merkaba:~> btrfs fi df /
> Data: total=15.10GB, used=11.58GB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.75GB, used=688.96MB
> Metadata: total=8.00MB, used=0.00
> 
> I think I get rid of that duplicate metadata once I redo the fs with 8 or 
> 16 KiB metadata blocks.
> 
> I thought about rebalancing it, but last time boot time doubled after a 
> complete rebalance. The effect of a rebalance of just the metadata tree to 
> one instead of two might be different tough.
> 
> Intel SSD 320 300GB on Kernel 3.6-rc5.
> 
> 
> [1] It has been a second or two in the beginning I think. Then it grew 
> over time.
> 
> merkaba:~> time fstrim -v /
> /: 5877809152 bytes were trimmed
> fstrim -v /  0,00s user 5,74s system 14% cpu 39,920 total
> merkaba:~> time fstrim -v /
> /: 5875712000 bytes were trimmed
> fstrim -v /  0,00s user 5,55s system 14% cpu 39,095 total
> merkaba:~> time fstrim -v /
> /: 5875712000 bytes were trimmed
> fstrim -v /  0,00s user 5,62s system 14% cpu 38,538 total

Looks like the issued TRIM commands actually did no work.

david
