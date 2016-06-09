Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36466 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbcFIT6M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 15:58:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bB65c-0006AF-Q0
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 21:58:04 +0200
Received: from ip-64-134-228-1.public.wayport.net ([64.134.228.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 21:58:04 +0200
Received: from 1i5t5.duncan by ip-64-134-228-1.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 21:58:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recommended why to use btrfs for production?
Date: Thu, 9 Jun 2016 19:57:58 +0000 (UTC)
Message-ID: <pan$3271$1d7da956$393e2ccc$d395c1dd@cox.net>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
	<aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
	<CAGQ70YeZzDgiT_v1Z0eGcWsn8prnji30hCkyjrBg8vNziLUkiQ@mail.gmail.com>
	<dd952b29-1bea-59e1-1857-418b86951b47@gmail.com>
	<pan$f0f75$1ba12fd1$de89e173$5dda67a@cox.net>
	<aa93e9e0-eade-085c-c955-2f7e433d92f8@gmail.com>
	<CAJCQCtR_s6qt_4PXRDu4e78KiaKM+SrTDB6WMw8MzZNuP+B5rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 09 Jun 2016 11:39:23 -0600 as excerpted:

> Yeah but somewhere there's a chunk that's likely affected by two losses,
> with a probability much higher than for conventional raid10 where such a
> loss is very binary: if the loss is a mirrored pair, the whole array and
> filesystem implodes; if the loss does not affect an entire mirrored
> pair, the whole array survives.
> 
> The thing with Btrfs raid 10 is you can't really tell in advance to what
> degree you have loss. It's not a binary condition, it has a gray area
> where a lot of data can still be retrieved, but the instant you hit
> missing data it's a loss, and if you hit missing metadata then the fs
> will either go read only or crash, it just can't continue. So that
> "walking on egg shells" behavior in a 2+ drive loss is really different
> from a conventional raid10 where it's either gonna completely work or
> completely fail.

Yes, thanks, CMurphy.  That's exactly what I was trying to explain. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

