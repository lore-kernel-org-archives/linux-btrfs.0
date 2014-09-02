Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:50574 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755072AbaIBUm7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 16:42:59 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49406 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XOuum-000kxs-Lc
	for linux-btrfs@vger.kernel.org; Tue, 02 Sep 2014 14:42:57 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Kernel Bug while copying my data off btrfs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$4a69e$fb511089$4fe3f7c1$e2b7f2dc@cox.net>
Date: Tue, 2 Sep 2014 14:42:54 -0600
Message-Id: <3C2E23DA-2468-499B-9183-AC0EDEC88B19@colorremedies.com>
References: <54050BD4.2060804@nathanshearer.ca> <pan$4a69e$fb511089$4fe3f7c1$e2b7f2dc@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 2, 2014, at 12:02 AM, Duncan <1i5t5.duncan@cox.net> wrote:


>  The only benefit to raid5/raid6 mode at 
> this time is that assuming it survives without a device loss until the 
> raid5/6 mode code is complete, you'll get a "free" upgrade to raid5/6 at 
> that point, since it has actually been doing the writes for it all along, 
> it just doesn't have the recovery code done yet.

Normally mounted the fixing of corrupt blocks does happen, but the fixes aren't written back to disk. Same for scrub, the problems are noted along with the path to the affected file (if you don't see this, it probably means fs metadata has been corrupt), but the fixes aren't written back to disk.

Degraded mount, btrfs replace doesn't work, you need to use device add, device delete. This appears to do a rebuild in that it can now be mounted normally. Maybe a balance is also necessary after this, I haven't tested how well it tolerates additional device failures without having done a balance after device delete (missing).

> Tho at least scrub has some raid5/6 patches floating around, which I 
> /think/ might have made it into the I /think/ still soon to be released 
> btrfs-progs-3.16

Doesn't appear to be the case:
Sep 02 14:21:05 twenty1.localdomain kernel: BTRFS: checksum error at logical 2186412032 on dev /dev/sde, sector 2116736, root 5, inode 258, offset 0, length 4096, links 1 (path: images/IMG_3327.tif)
Sep 02 14:21:05 twenty1.localdomain kernel: BTRFS: bdev /dev/sde errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
Sep 02 14:21:05 twenty1.localdomain kernel: BTRFS: unable to fixup (regular) error at logical 2186412032 on dev /dev/sde


Chris Murphy

