Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:5270 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752848Ab3LMRYQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 12:24:16 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:56078 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VrWTH-003KlA-QW
	for linux-btrfs@vger.kernel.org; Fri, 13 Dec 2013 10:24:16 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs raid multiple devices IO utilisation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <l8ce99$31i$1@ger.gmane.org>
Date: Fri, 13 Dec 2013 10:24:16 -0700
Message-Id: <397752FF-604C-4FB5-9453-2CB42C8DC739@colorremedies.com>
References: <l8ce99$31i$1@ger.gmane.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 12, 2013, at 6:39 AM, Martin <m_btrfs@ml1.co.uk> wrote:

> Some time back, I noticed that with a two HDD btrfs raid1, some tasks
> suffered ALL the IO getting choked onto just one HDD!
> 
> 
> That turned out to be a feature of the btrfs code whereby a device is
> chosen depending on the process ID.

I wonder how much btrfs parallelism is affected by the default CFQ scheduler? On the XFS FAQ "the default i/o scheduler, CFQ, will defeat much of the parallelization in XFS." There's also quite a bit of parallelization in Btrfs so it too may be affected, in particular multiple device scenarios.

Chris Murphy

