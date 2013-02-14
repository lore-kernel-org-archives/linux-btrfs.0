Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60841 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758463Ab3BNSps convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 13:45:48 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Rebalancing RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <201302141544.05747.Martin@lichtvoll.de>
Date: Thu, 14 Feb 2013 11:45:47 -0700
Cc: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>,
        Fredrik Tolf <fredrik@dolda2000.com>, Hugo Mills <hugo@carfax.org.uk>
Message-Id: <7857EB12-1C91-4FCA-A819-B85EC51281B5@colorremedies.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> (sfid-20130213_093936_125418_3540CD10) <201302141544.05747.Martin@lichtvoll.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 14, 2013, at 7:44 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:

> For some reason BTRFS is still trying to write to /dev/sdd, which isn´t
> there anymore. That perfectly explains those lost page writes for me. If
> that is the case, this seems to me like a serious bug in BTRFS.

Following the ICRC ABRT error, /dev/sdd becomes /dev/sdi. Btrfs-progs recognizes this by only listing /dev/sdi and /dev/sde as devices in the volume. But the btrfs kernel space code continues to try to write to /dev/sdd, while /dev/sdi isn't getting any writes (at least, it's not filling up with data).

Btrfs kernel space code is apparently unaware that /dev/sdd is gone. That seems to be the primary problem.

A question is, if the kernel space code was aware of a member device vanishing and then reappearing, whether as the same or different block device designation, should it automatically re-add the device to the volume? Upon being re-added, it would be out of sync, leading to a follow-up question about whether it should be auto-scrubbed to fix this? And yet another follow-up question which is if the file system metadata contains information that can be used similar to the function of the md write-intent bitmap, reducing the time to catch the drive up, avoiding a full scrub?


Chris Murphy