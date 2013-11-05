Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50596 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab3KEOAd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Nov 2013 09:00:33 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VdhBE-0003hT-1H
	for linux-btrfs@vger.kernel.org; Tue, 05 Nov 2013 15:00:28 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 15:00:28 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 15:00:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Partition broken, btrfsck segfaults or asserts
Date: Tue, 5 Nov 2013 14:00:08 +0000 (UTC)
Message-ID: <pan$dd2c1$bf1263f8$d3d5db6a$5d59e872@cox.net>
References: <20131105130459.133d538e@samson>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dennis Schridde posted on Tue, 05 Nov 2013 13:04:59 +0100 as excerpted:

> I have a serious problem with inaccessible data and segfaulting btrfsck
> for the /var partition on my computer.

> I can mount it[.] When I access certain directories, however, I get a
> message like this one:
> ls: cannot access /var/log: Stale NFS file handle

> When I run btrfsck --repair it asserts, and when I just run btrfsck
> without extra options it segfaults.

Ouch!

> https://bugzilla.kernel.org/show_bug.cgi?id=64411
> 
> # btrfs --version Btrfs v0.20-rc1-358-g194aa4a
> 
> # uname -r 3.11.6-gentoo

Fellow gentooer, and quite upto date both kernel- and tools-wise, as 
befits a still experimental filesystem under heavy development.

=:^)

> I would be thankful if you could help me to get as much as possible of
> my data back. And please CC me, as I am not subscribed to the list.

Posted directly to you and to list as requested.

Unfortunately I don't have an easy guaranteed recovery solution.

But since you're running an experimental filesystem that both the btrfs 
wiki (mentioned in the gentoo btrfs-tools package post-inst message) and 
the kernel config option warn to keep tested backups and use only with 
non-critical data, either restore from that tested backup or by 
definition you considered the data not critical enough to be worth 
worrying about recovering if it was lost in the first place.  Thus no 
worries either way.  Either you had tested backups and can restore from 
them, or by your actions you already declared the data not worth worrying 
about if the still experimental filesystem ate it for lunch!

Meanwhile, I see you've tried a few recovery methods, but it might be 
worth mentioning this post, with a list of methods to try and in what 
order:

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999

And in case you missed the gentoo btrfs-tools package homepage link, 
which is to the wiki, here it is again.  If you haven't already, it's 
worth reading up. =:^)

https://btrfs.wiki.kernel.org

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

