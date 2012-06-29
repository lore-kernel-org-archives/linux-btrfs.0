Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54766 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab2F2LRi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 07:17:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SkZCe-0005QA-Fd
	for linux-btrfs@vger.kernel.org; Fri, 29 Jun 2012 13:17:32 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 13:17:32 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 13:17:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Kernel panic from "btrfs subvolume delete"
Date: Fri, 29 Jun 2012 11:17:17 +0000 (UTC)
Message-ID: <pan.2012.06.29.11.17.17@cox.net>
References: <B53F1BEB-C285-4A01-A61A-4B324CB6FA7F@richardcooper.net>
	<CAG1y0seoS2c7d=jQgrZNF0aAJPrgTKbL1v6JzFigCk9ZMZ7H+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fajar A. Nugraha posted on Fri, 29 Jun 2012 17:42:26 +0700 as excerpted:

> On Fri, Jun 29, 2012 at 5:11 PM, Richard Cooper
> <richard@richardcooper.net> wrote:
>> Hi All,
>>
>> I have two machines where I've been testing various btrfs based backup
>> strategies. They are both Cent OS 6 with the standard kernel and
>> btrfs-progs RPMs from the CentOS repos.
>>
>> - kernel-2.6.32-220.17.1.el6.x86_64 - btrfs-progs-0.19-12.el6.x86_64
> 
> In btrfs terms, 2.6.32 is ... stone age :P

Indeed!  As both the kernel option and the btrfs wiki state, btrfs is an 
experimental filesystem under heavy development and fit for testing, not 
operational use.  Oracle and I believe SuSE have paid support now if you 
want it, but to some extent that's by locking down your options, and 
otherwise, it's simply offering to let you pay them for recovery efforts 
if something does go wrong.

Meanwhile, "under heavy development" in practice means that if you're 
using a kernel older than the last upstream release or two (so 3.3 at the 
very oldest!), you're testing extremely outdated code and the value of 
those tests both in reporting problems and in conclusions you yourself 
may draw from them is extremely limited.

Latest upstream release, now 3.4, is really the oldest you should be 
running for btrfs testing, and many people run the development kernel rcs, 
3.5-rc4 currently, or git-kernels, either Linus or btrfs-next (see the 
wiki).

So 2.6.32...  Do you still run kernel 2.2 on your non-btrfs machines, by 
any chance?  Because that's what's comparable, in terms of btrfs 
development vs kernel development.

>> What should I do now? Do I need to upgrade to a more recent btrfs?
> 
> Yep
> 
>> If so, how?
> 
> https://blogs.oracle.com/linux/entry/
oracle_unbreakable_enterprise_kernel_release
> http://elrepo.org/tiki/kernel-ml


Or read up on the wiki and go mainline kernel:

https://btrfs.wiki.kernel.org/

https://btrfs.wiki.kernel.org/index.php/Main_Page#Documentation

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

