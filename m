Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37014 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaAQSYz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 13:24:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W4E69-00089k-OU
	for linux-btrfs@vger.kernel.org; Fri, 17 Jan 2014 19:24:53 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 19:24:53 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 19:24:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: usrquota
Date: Fri, 17 Jan 2014 18:24:26 +0000 (UTC)
Message-ID: <pan$195b9$80426a01$8783bbd1$4f640ee9@cox.net>
References: <20140117141841.GA2838@rz.uni-freiburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Walter posted on Fri, 17 Jan 2014 15:18:41 +0100 as excerpted:

> Our problem is a zfs with 20,000 quota-enabled homedirectories and 100
> snapshots.
> We would really like to do the same with btrfs, but we don't know how to
> replace the zfs quotas with btrfs subvolume quotas. It seems unfeasible
> to handle 2,000,000 subvolumes.
> e.g. we would have to create every hour 20,000 snapshots and delete the
> same amount.
> 
> Is there any chance to get real user quotas with btrfs?

At present I'd suggest staying away from quotas on btrfs in any case, as 
there have been some serious bugs (quotas going negative with snapshot 
deletion, etc) in the way they're tracked.  I don't use quotas here so 
haven't closely followed status and perhaps the bugs are fixed, but never-
the-less, it's something I'd recommend staying away from for the time 
being.  Certainly for usage at that scale.  I'd suggest reexamining that 
decision perhaps a year from now, but it's simply not ready for that, now.

So I'd say stick with zfs for quota usage at that scale, for now.

On a more general note, btrfs is just beginning to stabilize in 
general... the kernel config warnings were just toned down for 3.13, 
etc.  However, as mkfs.btrfs warns when you create a btrfs filesystem, 
it's still not entirely stable.  This year should bring a lot of 
stabilization as development focus gradually switches from features to 
stabilization, but again, for production deployment at that scale, I'd 
suggest waiting a year and reexamining the question.

Of course you can still do pilot deployments now, but even more than with 
fully stable filesystems, be sure you have current and tested backups, 
because it's still possible you'll need to use them.  Also, using the 
current latest stable kernel (so 3.12.x currently, soon to be 3.13) if 
not the development kernel is still recommended, as critical fixes still 
go into every new kernel, and while they're marking more of them for 
stable now, not all of them reach stable.  Again, the warning was only 
toned down with 3.13, so from there I'd hope they backport stable fixes, 
but I wouldn't count on it before that.  And btrfs-tools, while less 
critical, is kernel-version synced from 3.12 as well, so you want a btrfs-
tools release at least reasonably comparable to your current kernel (v3.12 
current and minimum).

(This as just a user and list regular, not a dev, myself.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

