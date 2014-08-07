Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49664 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbaHGQFe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Aug 2014 12:05:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XFQBz-0003ro-Tm
	for linux-btrfs@vger.kernel.org; Thu, 07 Aug 2014 18:05:27 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Aug 2014 18:05:27 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Aug 2014 18:05:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Blocked tasks on 3.15.1
Date: Thu, 7 Aug 2014 16:05:13 +0000 (UTC)
Message-ID: <pan$761fe$70080dc7$7b88b5e9$aef75aea@cox.net>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
	<53C7CD0F.7070603@fb.com>
	<CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
	<1745216.hDa4tC2HJJ@merkaba> <53CE7ACF.7070109@fb.com>
	<CAPoQQ-3ceufwBNUOGsObwX8AMC5LZBDy6imZD3BaX+8B2_=W-w@mail.gmail.com>
	<CAGwxe4iMg5fL=Ao5_7o86JTuXs0ttF3YsyBj+D-t_5+sBy8KAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tobias Holst posted on Thu, 07 Aug 2014 17:12:17 +0200 as excerpted:

> Is there anything new on this topic? I am using Ubuntu 14.04.1 and
> experiencing the same problem.
> - 6 HDDs - LUKS on every HDD - btrfs RAID6 over this 6 crypt-devices No
> LVM, no nodatacow files.
> Mount-options: defaults,compress-force=lzo,space_cache With the original
> 3.13-kernel (3.13.0-32-generic) it is working fine.

I see you're using compress-force.  See the recent replies to the
"Btrfs: fix compressed write corruption on enospc" thread.

I'm not /sure/ your case is directly related (tho the kworker code is 
pretty new and 3.13 may be working for you due to being before the 
migration to kworkers, supporting the case of it being either the same 
problem or another related to it), but that's certainly one problem 
they've recently traced down... to a bug in the kworker threads code, 
that starts a new worker that can race with the first instead of obeying 
a flag that says keep it on the first worker.

Looks like they're doing patch that takes a slower but safer path to work 
around the kworker bug for now, as that bug was just traced (there was 
another bug, with a patch available originally hiding the ultimate 
problem, but obviously that's only half the fix as it simply revealed 
another bug underneath) and fixing it properly is likely to take some 
time.  Now that it's basically traced the workaround patch should be 
published on-list shortly and should make it into 3.17 and back into the 
stables, altho I'm not sure it'll make it into 3.16.1, etc.

But there's certainly progress. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

