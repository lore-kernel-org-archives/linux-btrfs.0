Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:35043 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab2ERQTK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 12:19:10 -0400
Message-ID: <4FB67679.3040205@pocock.com.au>
Date: Fri, 18 May 2012 16:19:05 +0000
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: Hubert Kario <hka@qbs.com.pl>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs RAID with RAID cards (thread renamed)
References: <4FAAE94D.4010103@pocock.com.au> <1494795.CqqnWfNEaS@bursa22>
In-Reply-To: <1494795.CqqnWfNEaS@bursa22>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> - if a non-RAID SAS card is used, does it matter which card is chosen?
>> Does btrfs work equally well with all of them?
> 
> If you're using btrfs RAID, you need a HBA, not a RAID card. If the RAID 
> card can work as a HBA (usually labelled as JBOD mode) then you're good to 
> go.
> 
> For example, HP CCISS controllers can't work in JBOD mode.

Would you know if they implement their own checksumming, similar to what
btrfs does?  Or if someone uses SmartArray (CCISS) RAID1, then they
simply don't get the full benefit of checksumming under any possible
configuration?

I've had a quick look at what is on the market, here are some observations:

- in many cases, IOPS (critical for SSDs) vary wildly: e.g.
  - SATA-3 SSDs advertise up to 85k IOPS, so RAID1 needs 170k IOPS
  - HP's standard HBAs don't support high IOPS
  - HP Gen8 SmartArray (e.g. P420) claims up to 200k IOPS
  - previous HP arrays (e.g. P212) support only 60k IOPS
  - many vendors don't advertise the IOPS prominently - I had to Google
the HP site to find those figures quoted in some PDFs, they don't quote
them in the quickspecs or product summary tables

- Adaptec now offers an SSD caching function in hardware, supposedly
drop it in the machine and all disks respond faster
  - how would this interact with btrfs checksumming?  E.g. I'm guessing
it would be necessary to ensure that data from both spindles is not
cached on the same SSD?
  - I started thinking about the possibility that data is degraded on
the mechanical disk but btrfs gets a good checksum read from the SSD and
remains blissfully unaware that the real disk is failing, then the other
disk goes completely offline one day, for whatever reason the data is
not in the SSD cache and the sector can't be read reliably from the
remaining physical disk - should such caching just be avoided or can it
be managed from btrfs itself in a manner that is foolproof?

How about the combination of btrfs/root/boot filesystems and grub?  Can
they all play nicely together?  This seems to be one compelling factor
with hardware RAID, the cards have a BIOS that can boot from any drive
even if the other is offline.




