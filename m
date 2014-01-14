Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34358 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751760AbaANTNN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 14:13:13 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:50226 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W39QE-003kvW-Ja
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 12:13:10 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52CF4D5D.2010709@chinilu.com>
Date: Tue, 14 Jan 2014 12:13:09 -0700
Message-Id: <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com>
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com> <52CF4D5D.2010709@chinilu.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 9, 2014, at 6:31 PM, George Mitchell <george@chinilu.com> wrote:
>> 
> Jim, my point was that IF the drive does not successfully resolve the bad block issue and btrfs takes a write failure every time it attempts to overwrite the bad data, it is not going to remap that data, but rather it is going to fail the drive.

If the drive doesn't resolve a bad block on write, then the drive is toast. That's how md handles it. That's even how manufacturers handle it. The point at which write failures occur mean there are no reserve sectors left, or the head itself is having problems writing data to even good sectors. Either way, the drive isn't reliable for rw purposes and coming up with a bunch of code to fix bad drives isn't worth development time in my opinion. Such a drive is vaguely interesting for test purposes however, because even though the drive is toast, we'd like the system to remain stable with it connected first and foremost. And maybe we'd want it as a source during rebuild/replacement.

>  In other words, if the drive has a bad sector which it has not done anything about at the drive level, btrfs will not remap the sector.  It will, rather, fail the drive. Is that not correct?

I've skimmed for this in the code, but haven't found it, so I'm not sure what the handling is. It's probably easier to take a drive I don't care about, and use hdparm to cause a sector to be flagged as bad, and see how Btrfs handles it. (The hdparm command should be clearable, but I'd rather not screw up a drive I like.)

Chris Murphy

