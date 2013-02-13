Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:10187 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752252Ab3BMBXH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 20:23:07 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Rebalancing RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com>
Date: Tue, 12 Feb 2013 17:58:00 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com>
To: Fredrik Tolf <fredrik@dolda2000.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 12, 2013, at 4:01 PM, Fredrik Tolf <fredrik@dolda2000.com> wrote:
> 
> mkfs.btrfs -d raid -m raid1 /dev/sd{d,e}1

Is that a typo? -d raid isn't valid.

What do you get for:
btrfs fi df /mnt

Please report the result for each drive:
smartctl -a /dev/sdX
smartctl -l scterc /dev/sdX

> 
> Also, why does it say that the errors are occuring /dev/sdd1? Is it just remembering the whole filesystem by that name since that's how I mounted it, or is it still trying to access the old removed instance of that disk and is that, then, why it's giving all these errors?

I suspect bad sectors at the moment. But it could be other things too. What kernel version?


Chris Murphy