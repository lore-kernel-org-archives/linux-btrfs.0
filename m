Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33738 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752709AbaCPRJf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 13:09:35 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:59382 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WPEZ4-003JJo-Dg
	for linux-btrfs@vger.kernel.org; Sun, 16 Mar 2014 11:09:34 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: discard synchronous on most SSDs?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140316060634.GN16946@merlins.org>
Date: Sun, 16 Mar 2014 11:09:35 -0600
Message-Id: <7E07E049-AF1F-418C-9BE9-19811F450893@colorremedies.com>
References: <1756989.4ep0Vdupld@tethys> <yq1bnx8y2mi.fsf@sermon.lab.mkp.net> <4448214.x9oPWjPhdL@quad> <1566234.HjNzCBAKa5@quad> <pan$86f37$20eb1911$444fa726$8400b046@cox.net> <20140316060634.GN16946@merlins.org>
To: Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 16, 2014, at 12:06 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
> Mmmh, so now I'm confused.
> 
> See this:
> 
> === START OF INFORMATION SECTION ===
> Device Model:     INTEL SSDSC2BW180A3L
> Serial Number:    CVCV215200XU180EGN
> LU WWN Device Id: 5 001517 bb28c5317
> Firmware Version: LE1i
> User Capacity:    180,045,766,656 bytes [180 GB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    Solid State Device
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 3.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Sat Mar 15 15:49:06 2014 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> polgara:/usr/src# smartctl --identify /dev/sda | grep '^ 169'
> 169      -     0x0001   Data Set Management support
> 169      0          1   Trim bit in DATA SET MANAGEMENT command supported
> 
> This is a super old SSD from 3 years ago. Clearly it can't support
> synchronous dicard, right?

No. The first signs I saw they were appearing in the wild was 3rd quarter 2013. I'm pretty sure SAS SSDs always have had a queued trim command. So in the workloads that demanded it and with a budget, this wouldn't have ever been a problem.


> Yet, deleting a kernel tree also takes 1.5 seconds:
> polgara:/usr/src# time rm -rf linux-3.14-rc5/
> real    0m1.441s
> user    0m0.048s
> sys     0m1.352s

I don't know that this is a good test for two reasons. Does rm always call trim before the rm command completes? If trim is batched or delayed it could happen well after. Second, and more of a factor, the queue needs to have pending commands in them that an async trim command will have to wait for. The problem with non-queued trim is that it requires the queue to be empty. So you'd need a test or workload that causes that behavior to be a problem.

And yet another factor with trim is that some SSDs immediately, aggressively start garbage collection and become slow to respond to anything. While others are smarter about doing this when the drive isn't as busy.


Chris Murphy

