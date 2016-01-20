Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41588 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744AbcATOoW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 09:44:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aLtzb-0000f1-4x
	for linux-btrfs@vger.kernel.org; Wed, 20 Jan 2016 15:44:15 +0100
Received: from 87-127-115-15.static.enta.net ([87.127.115.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 15:44:15 +0100
Received: from 6401e46d by 87-127-115-15.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 15:44:15 +0100
To: linux-btrfs@vger.kernel.org
From: Al <6401e46d@opayq.com>
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain like I'm five pls.
Date: Wed, 20 Jan 2016 14:43:49 +0000 (UTC)
Message-ID: <loom.20160120T143906-108@post.gmane.org>
References: <loom.20160116T132316-196@post.gmane.org> <pan$6d016$7902b96d$a10088a$d023ef02@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

> 
> Al posted on Sat, 16 Jan 2016 12:27:16 +0000 as excerpted:
> 

That it does, Duncan, thank you!

I was suggesting, albeit implicitly, that unless you're really short of
block dev space (!), which is a pretty naff dedup strategy, dedup isn't time
critical AFAIC(See). My server memory is not huge and I'd happily let it
chug away dedup'ing than have the whole thing run like a dog for lack of memory.

I'm looking forward to using it; keep up the very good work.



