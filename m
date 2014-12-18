Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44839 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbaLRICY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 03:02:24 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y1W2O-0006PP-HX
	for linux-btrfs@vger.kernel.org; Thu, 18 Dec 2014 09:02:20 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 09:02:20 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 09:02:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Standards Problems [Was: [PATCH v2 1/3] Btrfs: get more
 accurate output in df command.]
Date: Thu, 18 Dec 2014 08:02:09 +0000 (UTC)
Message-ID: <pan$f1f89$5f6c1478$209cc54c$73adc535@cox.net>
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>
	<548B4117.1040007@inwind.it>
	<CA+qeAOokzptsxMKJaQwtVSFe5UxYuZnx5E22iMjRqM4AsuN8bA@mail.gmail.com>
	<CABmMA7tw9BDsBXGHLO4vjcO4gaYmZPb_BQV8w22griqFvCJpPA@mail.gmail.com>
	<CABmMA7vtHzUYAhnEfpnx3Fx93SJyx=Qqoaz-PyQcivo=51jKsA@mail.gmail.com>
	<548E377D.6030804@cn.fujitsu.com> <548E7A7A.90505@pobox.com>
	<548E929B.2090203@pobox.com> <548E9B38.9080202@cn.fujitsu.com>
	<548EABBB.4060204@pobox.com> <548FA762.2070504@pobox.com>
	<549017E8.7060107@cn.fujitsu.com> <54908D8A.8040101@pobox.com>
	<54916B39.5080409@cn.fujitsu.com> <549252FF.10400@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Wed, 17 Dec 2014 20:07:27 -0800 as excerpted:

>  We have room for 1 more metadata extent on each
> drive, but if we allocate two more metadat extents on each drive we will
> burn up 1.25 GiB by reducing it to 0.75GiB.

FWIW, at least the last chunk assignment can be smaller than normal.  I 
believe I've seen it happen both here and on posted reports.  The 0.75 
GiB could thus be allocated as data if needed.

I'm not actually sure how the allocator works with the last few GiB.  
Some developer comments have hinted that it starts carving smaller chunks 
before it actually has to, and I could imagine it dropping data chunks to 
a half gig, then a quarter gig, than 128 MiB, then 64 MiB... as space 
gets tight, and metadata chunks similarly but of course from a quarter 
gig down.  That I'm not sure about.  But I'm quite sure it will actually 
use the last little bit (provided it can properly fill its raid policy 
when doing so), as I'm quite sure I've seen it do it.

I know for sure it does that in mixed-mode, as I have a 256 MiB mixed-
mode dup /boot (and a backup /boot of the same size on the other device, 
so I can select the one that's booted from the BIOS), and they tend to be 
fully chunk-allocated.   Note that even with mixed-mode, which defaults 
to metadata-sized-chunks, thus 256 MiB, on a 256 MiB device, by the time 
overhead, system, and reserve chunks are allocated, there's definitely 
NOT 256 MiB left for a data/metadata-mixed chunk, so if it couldn't 
allocate smaller bits it couldn't allocate even ONE chunk, let alone a 
pair (dup mode).

And I think I've seen it happen on my larger (not mixed) filesystems of 
several GiB as well, tho I don't actually tend to fill them up quite so 
routinely, so it's more difficult to say for sure.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

