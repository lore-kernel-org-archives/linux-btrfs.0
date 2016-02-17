Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50934 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965142AbcBQE2X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 23:28:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aVtiv-0008C7-W2
	for linux-btrfs@vger.kernel.org; Wed, 17 Feb 2016 05:28:22 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Feb 2016 05:28:21 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Feb 2016 05:28:21 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID 6 full, but there is still space left on some devices
Date: Wed, 17 Feb 2016 04:28:16 +0000 (UTC)
Message-ID: <pan$14375$e0cb4647$d3ccfaa2$90fd0ecc@cox.net>
References: <CABmr4wVBb0CCEoU_N2jxYvC=gVn9vUKWfb0902yZDuP2N3ck3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dan Blazejewski posted on Tue, 16 Feb 2016 15:20:12 -0500 as excerpted:

> A little background: I started using BTRFS over a year ago, in RAID 1
> with mixed size drives. A few months ago, I started replacing the disks
> with 4 TB drives, and eventually switched over to RAID 6. I am currently
> running a 6x4TB RAID6 drive configuration, which should give me ~14.5 TB
> usable, but I'm only getting around 11.
> 
> The weird thing is that It seems to completely fill 4/6 of the disks,
> while leaving lots of space free on 2 of the disks. I've tried full
> filesystem balances, yet the problem continues.
> 
> # btrfs fi show
> 
> Label: none  uuid: 78733087-d597-4301-8efa-8e1df800b108
>         Total devices 6 FS bytes used 11.59TiB
>         devid    1 size 3.64TiB used 3.64TiB path /dev/sdd
>         devid    2 size 3.64TiB used 3.64TiB path /dev/sdg
>         devid    3 size 3.64TiB used 3.64TiB path /dev/sdf
>         devid    5 size 3.64TiB used 2.92TiB path /dev/sda
>         devid    6 size 3.64TiB used 1.48TiB path /dev/sdb
>         devid    7 size 3.64TiB used 3.64TiB path /dev/sdc
> 
> btrfs-progs v4.2.3
> 
> 
> 
> # btrfs fi df /mnt/data
> 
> Data, RAID6: total=11.67TiB, used=11.58TiB
> System, RAID6: total=64.00MiB, used=1.70MiB
> Metadata, RAID6: total=15.58GiB, used=13.89GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> # btrfs fi usage /mnt/data
> 
> WARNING: RAID56 detected, not implemented

Your btrfs-progs is old and I don't see any indication of kernel version 
at all, but I'll guess it's old as well.  Particularly for raid56 mode, 
which still isn't to the maturity level of the rest of btrfs, using 
current kernel and btrfs-progs is *very* strongly recommended.

Among other things, current userspace 4.4 btrfs fi usage should support 
raid56 mode properly, now.  Also, with newer userspace and kernel, btrfs 
balance supports the stripes= filter, which appears to be what you're 
looking for, to rebalance to full-width stripes anything that's not yet 
full width, thereby evening out your usage.

A full balance /should/ do it as well, I believe, but with raid56 support 
still not yet at the maturity level of btrfs in general, it's likely your 
version is old and buggy in that regard.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

