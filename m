Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35832 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750755AbaDZBYX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 21:24:23 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: safe/necessary to balance system chunks?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <535AACC0.2000600@shaw.ca>
Date: Fri, 25 Apr 2014 19:24:21 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <7336D5A2-5CDD-45A4-9D43-E94F1C451137@colorremedies.com>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung> <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com> <535AA581.1080301@gmail.com> <535AACC0.2000600@shaw.ca>
To: Steve Leung <sjleung@shaw.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 25, 2014, at 12:43 PM, Steve Leung <sjleung@shaw.ca> wrote:

> Once everything gets rebalanced though, I don't think I'd be missing out on any features, would I?

The default nodesize/leafsize is 16KB since btrfs-progs v3.12. This isn't changed with a balance. The difference between the previous default 4KB, and 16KB is performance and small file efficiency.

Also, I think newly default with v3.12 btrfs-progs is extref support is enabled, which permits significantly more hardlinks. But this can be turned on for an existing volume using btrfstune.

Any other efficiencies in writing things to disk aren't actually rewritten with newer methods using a balance. Balance just causes chunks to be rewritten.

Chris Murphy

