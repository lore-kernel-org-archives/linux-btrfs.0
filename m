Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47094 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757266AbbA0MOw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Jan 2015 07:14:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YG52d-0004XN-Kh
	for linux-btrfs@vger.kernel.org; Tue, 27 Jan 2015 13:14:47 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2015 13:14:47 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jan 2015 13:14:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Am I missing partiy/redundancy - WARNING: RAID56 detected, not
 implemented
Date: Tue, 27 Jan 2015 12:14:39 +0000 (UTC)
Message-ID: <pan$be073$fe9f9943$23fa21e1$4f2014fe@cox.net>
References: <CABeopkFyVaSAxzgVjXZyqmWAWMG2+mnVXx34w9wEp9mWMjo9Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jeff Smith posted on Tue, 27 Jan 2015 02:21:24 -0700 as excerpted:

> I am just getting started with btrfs and wanted to test raid5.  I set it
> up and thought it was setup correctly but when I run " btrfs fi usage
> /mnt/btrdata"  I get the message "WARNING: RAID56 detected, not
> implemented".   Does this mean I have no redundancy?  I know it is
> experimental and I am not relying on it for production data (or data
> that cannot be replaced).  I don't think I do.  When I check the free
> space (3.7TB) it is the same as all the drive together (4x931MB).
> 
> 
> Any assistance in helping me understand would be appreciated greatly.
> 
> ------
> uname -a Linux alexandria.localdomain 3.17.8-300.fc21.x86_64 #1 SMP Thu
> Jan 8 23:32:49 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

On that kernel (or even a current 3.18 kernel), yes, in effect, no 
redundancy.

As the announcement stated, the raid56 mode code wasn't entirely complete 
at original commit, and as of current stable kernels, that hasn't 
changed, tho it's actually changing right now.

Basically, normal operation works -- the kernel calculates and writes the 
parity strips as expected.  However, the code to recover in case of 
device drop or filesystem damage isn't complete, so in effect, raid56 
mode is currently slow raid0 -- no redundancy -- in terms of recovery, 
except that when the code /is/ completed, you'll effectively get a "free" 
upgrade, as it has been writing the parity strips all along, it simply 
didn't have the code to recover properly if anything went wrong.

Meanwhile, the still in development 3.19 kernel (and corresponding 
userspace) /finally/ has very nearly complete raid56 code, altho at 
present there's still known bugs, and I'd not recommend actually 
upgrading from the "no redundancy" consideration until kernel/userspace 
3.20, tho 3.19 should give you significantly better chances at recovery 
on raid56 than previous versions did.

In addition to the announcement, status is documented on the wiki[1], and 
is well known on the list, so with a bit of research you'd have known 
that before trying it.  Well at least you tried it before relying on it. 
=:^)

---
[1] https://btrfs.wiki.kernel.org

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

