Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55432 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbbKSCQl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 21:16:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZzEm6-0001Ts-OI
	for linux-btrfs@vger.kernel.org; Thu, 19 Nov 2015 03:16:39 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 03:16:38 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 03:16:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
Date: Thu, 19 Nov 2015 02:16:20 +0000 (UTC)
Message-ID: <pan$61583$65d817c9$bfda2de6$465dca20@cox.net>
References: <564CC90F.3060703@gmail.com>
	<20151118190857.GY24333@carfax.org.uk> <564D1AE5.3000700@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Thu, 19 Nov 2015 08:42:13 +0800 as excerpted:

> Although the metadata output is showing that you still have about 512M
> available, but the 512M is Global Reserved space, or the unknown one.

Unknown here, as the userspace (btrfs-progs) is evidently too old to show 
it as global reserve, as it does in newer versions...

> The output is really a little confusing. I'd like the change the output
> by adding global reserved into metadata used space and make it a sub
> item for metadata.

Thanks for the clarification.  It's most helpful, here. =:^)

I've at times wondered if global reserve folded into one of the other 
settings.  Apparently it comes from the metadata allocation, but while 
metadata is normally dup (single-device btrfs) or raid1 (multi-device), 
global reserve is single.

It would have been nice if that sort of substructure was described a bit 
better when global reserve first made its appearance, at least in the 
patch descriptions and release announcement, if not then yet in btrfs fi 
df output, first implementations being what they are.  But regardless, 
now at least it should be clear for list regulars who read this thread 
anyway, since the above reasonably clarifies things.

As for btrfs fi df, making global reserve a metadata subentry there would 
be one way to deal with it, preserving the exposure of the additional 
data provided by that line (here, the fact that global reserve is 
actually being used, underlining the fact that the filesystem is severely 
short on space).

Another way of handling it would be to simply add the global reserve into 
the metadata used figure before printing it, eliminating the separate 
global reserve line, and changing the upthread posted metadata line from 
8.48 GiB of 9 GiB used, to 8.98 of 9 GiB used, which is effectively the 
case if the 512 MiB of global reserve indeed comes from the metadata 
allocation.  This would more clearly show how full metadata actually is 
without the added complexity of an additional global reserve line, but 
would lose the fact that global reserve is actually in use, that the 
broken out global reserve line exposes.

I'd actually argue in favor of the latter, directly folding global 
reserve allocation into metadata used, since it'd both be simpler, and 
more consistent if for instance btrfs fi usage didn't report separate 
global reserve in the overall stats, but fail to report it in the per-
device stats and in btrfs dev usage.

Either way would make much clearer that metadata is actually running out 
than the current report layout does, since "metadata used" would then 
either explicitly or implicitly include the global reserve.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

