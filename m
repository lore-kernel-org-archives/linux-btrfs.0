Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:44482 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaEVPQj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 11:16:39 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 9434F36A43C
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 17:16:37 +0200 (CEST)
Received: from s9 (7.Red-88-15-60.dynamicIP.rima-tde.net [88.15.60.7])
	by mail.virtall.com (Postfix) with ESMTPSA id 3432436A433
	for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 17:16:37 +0200 (CEST)
Date: Thu, 22 May 2014 16:16:34 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: mount hangs after disk crash (RAID-1)
Message-ID: <20140522161634.054ec95f@s9>
In-Reply-To: <20140522095101.107b62e8@s9>
References: <20140522032258.234aaab7@s9>
	<20140522095101.107b62e8@s9>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > One disk in RAID-1 crashed, so powered off, changed disk, powered
> > on, trying to mount degraded.
> > 
> > Unfortunately it hangs (running 3.14.4).
> > 
> > # mount -o degraded,compress=lzo,noatime /dev/sdb4 /home (...never
> > returns...)
> 
> 1) Just to be sure, btrfs raid1, not btrfs on md/raid1 or the like, 
> correct?

Correct, it's btrfs raid1.


> 2) Btrfs raid1 for both data and metadata, correct?

raid1 for both data and metadata.


> 3) How many devices in the btrfs raid1?

There were 2 devices.

 
> 4) Did you try mounting read-only?

Tried also mounting with nospace_cache, recover, ro, but all hang in a
similar way.

 
> Note that unlike md/raid1, btrfs raid1 won't mount writable with only
> a single device.  You must have at least two devices to mount
> writable, tho a formerly two-device raid1 with a device missing
> should mount read-only.

That's not entirely correct - it will mount with -o degraded option.

However it hangs here...


-- 
Tomasz Chmielewski
http://wpkg.org
