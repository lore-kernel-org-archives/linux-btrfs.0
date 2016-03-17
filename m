Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39963 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbcCQIJa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 04:09:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1agSzi-0002ss-TL
	for linux-btrfs@vger.kernel.org; Thu, 17 Mar 2016 09:09:22 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 09:09:22 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 09:09:22 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Why we always balance system chunk alone with metadata?
Date: Thu, 17 Mar 2016 08:09:17 +0000 (UTC)
Message-ID: <pan$87d80$ac7678a4$4439cb5$60c45f2a@cox.net>
References: <56E8C990.1010508@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Wed, 16 Mar 2016 10:48:48 +0800 as excerpted:

> Hi,
> 
> During debugging a bug related to balancing metadata chunk, we found
> that if we specify -m option for "btrfs balance", it will always balance
> system chunk too.
> 
> cmds-balance.c:
> ---
>          /*
>           * allow -s only under --force, otherwise do with system chunks
>           * the same thing we were ordered to do with meta chunks */
>          if (args.flags & BTRFS_BALANCE_SYSTEM) {
>                  if (!force) {
>                          error(
>                              "Refusing to explicitly operate on system
> chunks.\n"
>                              "Pass --force if you really want to do
>                              that.");
>                          return 1;
>                  }
>          } else if (args.flags & BTRFS_BALANCE_METADATA) {
>                  args.flags |= BTRFS_BALANCE_SYSTEM; <<< Here
>                  memcpy(&args.sys, &args.meta,
>                          sizeof(struct btrfs_balance_args));
>          }
> ---
> 
> I'm curious why we always bind system chunk to metadata balance?
> 
> Is there any special reason?
> The patch introducing such behavior is dated back to 2012, and this
> makes us unable to do metadata *only* balance.

I always understood it as a convenient simplification for the sake of the 
user, for whom tracking data and metadata separately is already a major 
complication over what they're dealing with on most filesystems.

But I also wondered why there was no parallel to the -s system option for 
metadata ONLY, perhaps requiring --force just as the -s option does.

The --force requirement for -s /does/ encourage people not to touch it at 
all, separately, and there could be very good reasons to normally treat 
system as metadata and process them as a combined unit, but even then, it 
seems very odd to me to expose -s on its own, even if --force is 
required, and not a parallel, say -M, for metadata-only, again, possibly 
only if --force is used as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

