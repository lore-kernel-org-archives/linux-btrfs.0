Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36742 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751780AbaANVFO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:05:14 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:55093 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W3BAf-000EVG-Dt
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 14:05:13 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140115013703.33bb2799@natsu>
Date: Tue, 14 Jan 2014 14:05:11 -0700
Message-Id: <1207CF09-B2A4-4DB6-9CA8-C3C78C1DA0F3@colorremedies.com>
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com> <52CF4D5D.2010709@chinilu.com> <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com> <20140115013703.33bb2799@natsu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 14, 2014, at 12:37 PM, Roman Mamedov <rm@romanrm.net> wrote:
> 
> I vaguely remember having some drives that were not able to remap a single
> block on write, but doing that successfully if I overwrote a sizable area
> around (and including) that block, or overwrite the whole drive. And after
> that they worked without issue not exhibiting further bad blocks.

Presumably the SMART self-assessment for this drive was FAIL? And if so what's the point of the work around when we only have a pass/fail level granularity for drive health?

> 
> Or for example consider the 4k sector drives. If even any portion of the
> physical 4k sector is corrupt, some of the eight 512 virtual blocks will be
> unreadable; but the thing is, writing to ANY of them individually will fail,
> because the drive's internal r-m-w will fail to obtain all the pieces of the
> 4k sector from disk to overwrite it.
> 
> So in my opinion one (and perhaps one of the easier) things to consider here,
> would be to try being "generous" in recovery-overwrite, say, rewrite a
> whole 1MB-sized region centered at the unreadable sector.

Not if the SMART status is a FAIL. And if it's not a fail then that sounds like a firmware bug. A better feature would be a way to send a command to the firmware to persistently increase the reserve sectors at the expensive of available space - in effect it reduces the LBA count by e.g. 10MB, thereby increasing the reserve pool by 10MB. Changing this setting in either directionwould obviously mean data loss; but at least it's managed by firmware which transports the accumulated knowledge. Otherwise these block files are going to be backed up, or subject to btrfs send. And then restored invariably in the wrong location on the same drive, or unnecessarily restored onto a new drive so then you need exception code if you don't want that behavior. I think it's trouble.


Chris Murphy

