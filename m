Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47147 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751407AbaAFAPV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 19:15:21 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs-transaction blocked for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C9DE66.8080706@swiftspirit.co.za>
Date: Sun, 5 Jan 2014 17:15:18 -0700
Cc: Sulla <Sulla@gmx.at>, Brendan Hide <brendan@swiftspirit.co.za>
Message-Id: <82B00B7C-0767-44E2-95A5-309D80D789F1@colorremedies.com>
References: <52C2AE7C.5020601@gmx.at> <64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com> <52C9CBEF.2000309@gmx.at> <52C9DE66.8080706@swiftspirit.co.za>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 5, 2014, at 3:36 PM, Brendan Hide <brendan@swiftspirit.co.za> wrote:

> WD Greens (Reds too, for that matter) have poor non-sequential performance. An educated guess I'd say there's a 15% chance this is a major factor to the problem and, perhaps, a 60% chance it is merely a "small contributor" to the problem. Greens are aimed at consumers wanting high capacity and a low pricepoint. The result is poor performance. See footnote * re my experience.
> 
> My general recommendation (use cases vary of course) is to install a tiny SSD (60GB, for example) just for the OS. It is typically cheaper than the larger drives and will be *much* faster. WD Greens and Reds have good *sequential* throughput but comparatively abysmal random throughput even in comparison to regular non-SSD consumer drives.


Another thing with md raid and parallel flie systems that's been an issue is cqf. On the XFS list cqf is approximately in the realm of persona non grata. It might be worth Sulla also setting elevator=deadline and see if simply different scheduling is a work around, not that it's OK to get blocks with cqf. But it might be worth a shot as a more conservative approach to upgrading the kernel from 3.11.0.


> I had 8x 1.5TB WD1500EARS drives in an mdRAID5 array. With it I had a single 250GB IDE disk for the OS. When the very old IDE disk inevitably died, I decided to use a spare 1.5TB drive for the OS. Performance was bad enough that I simply bought my first SSD the same week.

Yeah for what it's worth, the current WD Green PDF says these drives are not to be used in RAID at all. Not 0, 1, 5 or 6.  Even Caviar Black is proscribed from use in RAID environments using multibay chassis, as in, no warranty. It's desktop raid0 and raid1 only, and arguably the lack of configurable SCT ERC makes it not ideal even for raid1.

Anyway, Sulla, how about putting up a smartctl -x for each drive? Curious if there are any bad sectors that have developed, and may be worth filtering all /var/log/messages for the word "reset" and see if you find any of these drives ever being reset by the kernel and if so, post the full output of that.


Chris Murphy