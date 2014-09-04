Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35262 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbaIDW0z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Sep 2014 18:26:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XPfUS-0003AP-6t
	for linux-btrfs@vger.kernel.org; Fri, 05 Sep 2014 00:26:52 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Sep 2014 00:26:52 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Sep 2014 00:26:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS critical (device dm-0): invalid dir item name len: 45389
Date: Thu, 4 Sep 2014 22:26:40 +0000 (UTC)
Message-ID: <pan$680f3$c4143e4$b1f456fa$d9f8eac0@cox.net>
References: <CANg_oxxmR+qkSfZeVYK5dF1HnbSJapEF1tZ+3-9ij5hq7d2E=w@mail.gmail.com>
	<CANg_oxzsAAV3S-Qc=mz0GTVXnPFrQ43riNXVbtT4Wjqtwsbo2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

john terragon posted on Thu, 04 Sep 2014 15:03:04 +0200 as excerpted:

> Some more details about this problem:
> 
> -the directory involved is
> /lib/modules/3.17.0-rc3-cu3/kernel/drivers/iio/gyro -in that dir there
> should be kernel object named hid-sensor-gyro-3d.ko but there's
>  no trace of it
> -that dir cannot be removed or overwritten. rm -rf fails saying that the
> dir cannot be
>  removed because it's not empty (?, even with -rf ?) and trying to
> reinstall the .deb
>  package for that kernel image (thus overwriting that dir) ends up in a
>  segfault
> 
> The only workaround is to mv that dir (well, I simply mv the whole
> 3.17.0-rc3-cu3 dir but it should work also for the gyro subdir) and
> reinstall the deb package.
> 
> So, it's pretty serious because there's actual loss of data (even though
> I was lucky I just lost a ko I don't use).

I'd do a btrfs check (read-only without --repair or other switch) to see 
what it came up with, then if it looked reasonable, ensure my backups 
were fresh and do a btrfs check --repair.

If it fails or makes the problem worse, you can then mkfs and restore 
from the backups.

Meanwhile, nobody sane would keep valuable data on a raid0 (any raid0, 
btrfs or not) without backups anyway, as it's simply too risky, so by 
definition the problem /cannot/ be "pretty serious.  By definition, 
what's stored on a raid0 is more or less throw-away data that can either 
be recomputed or refetched from backup (which might be the net), or is 
simply tmp/cache in the first place.  So losing it can never be defined 
as "pretty serious", unless of course you're using raid0 for valuable 
data it was never intended, and don't keep current backups, which as I 
said for any responsible sysadmin (and with that I include every home 
user responsible for their own system, it's a responsibility taken too 
lightly by many) working with raid0 is insanity.

So if you're characterizing any potential loss of data on any sort of  
raid0 (btrfs or otherwise) as "pretty serious", I *STRONGLY* recommend 
that you reconsider using raid0 in the first place, because loss of 
ANYTHING, upto and including EVERYTHING on a raid0, by definition cannot 
be "pretty serious" or you're simply using it wrong.  And if you're doing 
a mkfs and restore from backup, that's the perfect opportunity to 
reconsider and choose something more appropriate. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

