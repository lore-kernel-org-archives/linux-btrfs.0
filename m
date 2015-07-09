Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53708 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbbGIAAo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jul 2015 20:00:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZCzGc-0000P8-PQ
	for linux-btrfs@vger.kernel.org; Thu, 09 Jul 2015 02:00:42 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 02:00:42 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 02:00:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [BUG] BTRFS: error in btrfs_run_delayed_refs:2821: errno=-5 IO
 failure
Date: Thu, 9 Jul 2015 00:00:37 +0000 (UTC)
Message-ID: <pan$6018e$695880fb$38368ff9$1523835b@cox.net>
References: <CAJCQCtSyf+ADvupbAoVi3BPN-TxdYr0n=-6gykWVe-U33rUNAQ@mail.gmail.com>
	<CADfjVrhammqPo68TTckaGA8p+=G=zdno_LLiSZQj=9xLq14WVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Noah Massey posted on Wed, 08 Jul 2015 16:02:04 -0400 as excerpted:

> Standard disclaimer: Not a developer, just a user.

Same here. =:^)

> The 1.5 GB ISO on a fresh ext4 system made me think of
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/36955 (ext4
> extents over 1 GB causing ENOSPC).
> 
> Did the "btrfs filesystem balance" specify a "-t 900G" or similar?
> 
> Or has that issue been fixed?

Don't know about bug fixed, but that balance command syntax is definitely 
very deprecated, and there's no -t option documented for btrfs balance 
start, the current version.

Did you mean btrfs filesystem defrag?  It has a -t option that looks like 
it might have been what you were after.  However, until very recently (I 
think it's in integration but don't know if it's in an actual release 
yet), there was an integer overflow bug with the -t option, such that if 
given a value above 3G, (I believe the cutoff is actually 4G, so 
something like 3999M would work), it would behave as if -t0 had been 
given. =:^(  

But the effective high value is typically 1G anyway, so the workaround is 
simple enough, just use -t 1G or -t 2G.  That's what the patch 
effectively does anyway, reduce anything higher to 1G or 2G, IDR which.

So if you meant btrfs filesystem defrag -t, a 2G value would be 
preferable to a 900G value, with the latter very likely not working as 
intended.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

