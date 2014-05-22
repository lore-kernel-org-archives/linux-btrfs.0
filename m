Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57835 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750886AbaEVQ1f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 12:27:35 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:63624 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WnVq9-003IeK-DT
	for linux-btrfs@vger.kernel.org; Thu, 22 May 2014 10:27:34 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: mount hangs after disk crash (RAID-1)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$4965$e2755b8c$eb8c082f$e15db32d@cox.net>
Date: Thu, 22 May 2014 10:27:28 -0600
Message-Id: <CDA6B778-BD10-4D3E-A4C4-ED3E956FEFD2@colorremedies.com>
References: <20140522032258.234aaab7@s9> <pan$4965$e2755b8c$eb8c082f$e15db32d@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 22, 2014, at 3:43 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> Note that unlike md/raid1, btrfs raid1 won't mount writable with only a 
> single device.  You must have at least two devices to mount writable, tho 
> a formerly two-device raid1 with a device missing should mount read-only.

No, a single device from a two device Btrfs raid1 is normally mountable degraded,rw. I did this just a week ago when bug "kernel BUG at fs/btrfs/locking.c when mounting with previously missing device". At one point when reproducing it, I was running degraded,rw with a single device for several hours without problems.

Try -o recovery,degraded

I would drop the other options for now, since they aren't necessary to recover from a device failure.

Chris Murphy

