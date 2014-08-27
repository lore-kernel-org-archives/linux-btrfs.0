Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60677 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbaH0HKh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 03:10:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XMXNK-0004eX-HN
	for linux-btrfs@vger.kernel.org; Wed, 27 Aug 2014 09:10:34 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 09:10:34 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 09:10:34 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ext4 vs btrfs performance on SSD array
Date: Wed, 27 Aug 2014 07:10:19 +0000 (UTC)
Message-ID: <pan$646f5$964a0f2f$c0fb64a3$d18066b7@cox.net>
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nikolai Grigoriev posted on Tue, 26 Aug 2014 19:39:08 -0400 as excerpted:

> Kernel: 3.8.13-35.3.5.el6uek.x86_64 #2 SMP Fri Aug 8 21:58:11 PDT 2014
> x86_64 x86_64 x86_64 GNU/Linux

> Btrfs v0.20-rc1

I've no answer for your question, but you know how old both your kernel 
and btrfs-progs versions are, for a filesystem under as heavy development 
as btrfs is, right?

The normal recommendation is to run the latest stable series kernel, 
3.16.x at this time, unless you have specific reason not to (like the 
below, or because you're specifically comparing multiple btrfs kernel-
spaces).  Userspace isn't quite as critical, but 3.14.2 is current (with 
3.16 soon to be released), and 3.12 was the first one of the new 
versioning sequence and currently the minimum recommended.  Btrfs-progs 
v0.20-rc1 is as ancient as a 3.8 kernel.

Tho there's a current known btrfs kworker thread lockup bug that 
apparently only affects those using the compress mount option.  Btrfs 
converted from using its own private worker threads to generic kworker 
threads in 3.15, so previous to that wasn't affected, while all current 
releases in the 3.15 and 3.16 series (and 3.17 thru rc2, rc3 should have 
the patch) are affected.  The patch is marked for stable so should end up 
in 3.16 stable series too, tho probably not 3.15 as AFAIK as a non-long-
term-support release it's already EOL or close to it.  (3.14 is an LTS 
but as I said the bug didn't affect it so no backported patch necessary.)

So that'd be a good reason to stay with 3.14 (which as I said is LTS) for 
the time being, but back further than that is definitely older than would 
be recommended for anything btrfs related, and both kernel 3.8 and 
userspace 0.20-rc1 are positively ancient.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

