Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45753 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbaKRMmM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 07:42:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xqi6h-0006KI-6H
	for linux-btrfs@vger.kernel.org; Tue, 18 Nov 2014 13:42:07 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 13:42:07 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 13:42:07 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs filesystem show _exact_ freaking size?
Date: Tue, 18 Nov 2014 12:41:55 +0000 (UTC)
Message-ID: <pan$9f136$52d63466$99e9041e$481f97b4@cox.net>
References: <546B21F4.8060203@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Tue, 18 Nov 2014 02:39:48 -0800 as excerpted:

> How does one get the exact size (in blocks preferably, but bytes okay)
> of the filesystem inside a partition? I know how to get the partition
> size, but that's not useful when shrinking a partition...

> There needs to be an option to btrfs filesystem show that will tell you
> XXXXXblocks, not Y.ZZ terabytes.

While having a btrfs fi show option for that would be nice, take a look 
at the output of btrfs-show-super.

The dev_item.total_bytes line appears to be the total filesystem bytes -- 
at least here on my exactly-8-GiB partitions, that's /exactly/ what it 
shows, 8589934592, which is 8*1024*1024*1024, and my /exactly/ 256 MiB 
partition shows 268435456, /exactly/ 256 MiB, as well.

The total_bytes line is the full /filesystem/ size, which should be the 
same as the dev_item.total_bytes number on a single-device-filesystem.  
Of course on my two-device btrfs filesystems here it's showing double the 
single-device size, which is as it should be.

But you're correct, having a btrfs fi show option for that would be more 
end-user friendly.  The btrfs-show-super output is rather low-level for 
that, but it does work.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

