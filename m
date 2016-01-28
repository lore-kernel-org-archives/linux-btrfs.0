Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:46943 "EHLO
	cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbcA1Ph7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 10:37:59 -0500
Received: from fox.rh.rit.edu (fox.rh.rit.edu [129.21.125.28])
	by cartman.routify.me (Postfix) with ESMTPSA id 21EDD81932
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 10:37:58 -0500 (EST)
Date: Thu, 28 Jan 2016 10:37:56 -0500
From: Sean Greenslade <sean@seangreenslade.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID1 disk upgrade method
Message-ID: <20160128153756.GA19617@fox.rh.rit.edu>
References: <20160122034538.GA25196@coach.student.rit.edu>
 <pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
 <20160123214127.GA601@fox.wireless.rit.edu>
 <CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
 <20160127224549.GA4891@fox.rh.rit.edu>
 <20160127235528.GA5498@fox.rh.rit.edu>
 <56AA0A0A.1060807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56AA0A0A.1060807@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 28, 2016 at 07:31:06AM -0500, Austin S. Hemmelgarn wrote:
> >Got the opportunity to reboot, and things appear to be OK. Still, I
> >would expect replace to work without requiring a reboot, so this may
> >still be a bug. I'm running a scrub to verify things, and once that
> >completes I'll do the second replace and see if I encounter the same
> >problem.
>
> That is unusual, it's supposed to work without needing a reboot or rescan,
> so I think you may have found a bug.

Did the second replace, and encountered a slightly different issue.
Btrfs fi show did list both new devices after the replace completed,
however the partition was no longer mounted. Trying to mount, the mount
command returned 0 but the partition was not actually mounted. I got
this in dmesg:

[Thu Jan 28 10:20:20 2016] BTRFS info (device sdd1): disk space caching
is enabled
[Thu Jan 28 10:20:20 2016] BTRFS: has skinny extents
[Thu Jan 28 10:20:20 2016] BTRFS: bdev /dev/sda1 errs: wr 0, rd 186,
flush 0, corrupt 0, gen 0

I ejected and re-inserted the HDDs, and everything was happy again. The
mount actually succeeded, with the same dmesg output. If I had to guess,
I'd say there's probably some stale state left over in the kernel after
the replace. I may try to create a test case to reproduce this later if
I have time.

Additionally, the filesystem did not expand to the larger drives after
the replace. So I ran btrfs fi resize max, and I got the following:


Label: none  uuid: 573863ec-d55e-4817-8c11-70bb8523b643
        Total devices 2 FS bytes used 1.64TiB
		devid    1 size 2.73TiB used 1.71TiB path /dev/sdb1
		devid    2 size 1.82TiB used 1.71TiB path /dev/sda1

[Thu Jan 28 10:32:36 2016] BTRFS: new size for /dev/sdb1 is 3000591912960

It only resized one of the two devices, and I'm suspicious because the
one that didn't resize is also the one that reports read errors in the
mount dmesg output.

Any ideas on what to try next? I'm kicking off a scrub for now.

--Sean

