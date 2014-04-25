Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49595 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751765AbaDYRY0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 13:24:26 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: safe/necessary to balance system chunks?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <alpine.DEB.2.10.1404250842350.2320@cubia.leung>
Date: Fri, 25 Apr 2014 11:24:24 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung>
To: Steve Leung <sjleung@shaw.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 25, 2014, at 8:57 AM, Steve Leung <sjleung@shaw.ca> wrote:

> 
> Hi list,
> 
> I've got a 3-device RAID1 btrfs filesystem that started out life as single-device.
> 
> btrfs fi df:
> 
> Data, RAID1: total=1.31TiB, used=1.07TiB
> System, RAID1: total=32.00MiB, used=224.00KiB
> System, DUP: total=32.00MiB, used=32.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=66.00GiB, used=2.97GiB
> 
> This still lists some system chunks as DUP, and not as RAID1.  Does this mean that if one device were to fail, some system chunks would be unrecoverable?  How bad would that be?

Since it's "system" type, it might mean the whole volume is toast if the drive containing those 32KB dies. I'm not sure what kind of information is in system chunk type, but I'd expect it's important enough that if unavailable that mounting the file system may be difficult or impossible. Perhaps btrfs restore would still work?

Anyway, it's probably a high penalty for losing only 32KB of data.  I think this could use some testing to try and reproduce conversions where some amount of "system" or "metadata" type chunks are stuck in DUP. This has come up before on the list but I'm not sure how it's happening, as I've never encountered it.

> 
> Assuming this is something that needs to be fixed, would I be able to fix this by balancing the system chunks?  Since the "force" flag is required, does that mean that balancing system chunks is inherently risky or unpleasant?

I don't think force is needed. You'd use btrfs balance start -sconvert=raid1 <mountpoint>; or with -sconvert=raid1,soft although it's probably a minor distinction for such a small amount of data.

The metadata looks like it could use a balance, 66GB of metadata chunks allocated but only 3GB used. So you could include something like -musage=50 at the same time and that will balance any chunks with 50% or less usage.


Chris Murphy

