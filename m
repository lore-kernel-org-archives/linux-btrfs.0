Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41555 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750923AbaDZEFo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Apr 2014 00:05:44 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: safe/necessary to balance system chunks?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <alpine.DEB.2.10.1404252035150.4873@cubia.leung>
Date: Fri, 25 Apr 2014 22:05:41 -0600
Cc: Steve Leung <sjleung@shaw.ca>
Message-Id: <0EE2D80D-5AE3-4056-B41E-674050A4787F@colorremedies.com>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung> <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com> <535AA581.1080301@gmail.com> <535AACC0.2000600@shaw.ca> <7336D5A2-5CDD-45A4-9D43-E94F1C451137@colorremedies.com> <alpine.DEB.2.10.1404252035150.4873@cubia.leung>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 25, 2014, at 8:56 PM, Steve Leung <sjleung@shaw.ca> wrote:
> 
> Incidentally, is there a way for someone to tell what the node size currently is for a btrfs filesystem?  I never noticed that info printed anywhere from any of the btrfs utilities.

btrfs-show-super

> In case anyone's wondering, I did balance the system chunks on my filesystem and "btrfs fi df" now looks normal.  So thanks to all for the hints and advice.

Good news.

I kinda wonder if some of the degraded multiple device mount failures we've seen are the result of partially missing system chunks.


Chris Murphy

