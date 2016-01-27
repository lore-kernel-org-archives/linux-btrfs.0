Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:47390 "EHLO
	cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934427AbcA0Wpw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 17:45:52 -0500
Received: from fox.rh.rit.edu (fox.rh.rit.edu [129.21.125.28])
	by cartman.routify.me (Postfix) with ESMTPSA id 3863181EE0
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 17:45:51 -0500 (EST)
Date: Wed, 27 Jan 2016 17:45:49 -0500
From: Sean Greenslade <sean@seangreenslade.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID1 disk upgrade method
Message-ID: <20160127224549.GA4891@fox.rh.rit.edu>
References: <20160122034538.GA25196@coach.student.rit.edu>
 <pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
 <20160123214127.GA601@fox.wireless.rit.edu>
 <CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 23, 2016 at 05:03:15PM -0700, Chris Murphy wrote:
> Just make sure you have backups before, during, and after all of this,
> which should be the case no matter Btrfs or not. Mixed extent types
> should work fine, but who knows you could get into an edge case at a
> later time for all anyone knows. Looks like skinny extent became
> default in btrfs-progs 3.18.

OK, disks have arrived, and I've completed the first replace.
Interestingly enough, the replace seems to have succeeded, however btrfs
fi show doesn't seem to think so.

Dmesg:
[Wed Jan 27 13:03:09 2016] BTRFS info (device sdb1): disk space caching
is enabled
[Wed Jan 27 13:03:09 2016] BTRFS: has skinny extents
[Wed Jan 27 13:03:09 2016] BTRFS: bdev /dev/sdb1 errs: wr 0, rd 186,
flush 0, corrupt 0, gen 0
[Wed Jan 27 13:05:23 2016]  sdc: sdc1
[Wed Jan 27 13:05:25 2016]  sdc: sdc1
[Wed Jan 27 13:08:37 2016] BTRFS: dev_replace from /dev/sdb1 (devid 2)
to /dev/sdc1 started
[Wed Jan 27 16:34:49 2016] BTRFS: dev_replace from /dev/sdb1 (devid 2)
to /dev/sdc1 finished

Btrfs fi show:
warning, device 3 is missing
warning, device 3 is missing
warning devid 3 not found already
Label: none  uuid: 490b8b7c-59c4-45dc-ac63-6a90f0966776
        Total devices 2 FS bytes used 1.45TiB
		devid    1 size 1.82TiB used 1.52TiB path /dev/sda1
		*** Some devices missing

I haven't rebooted or remounted yet, so I'm curious if this is a bug,
a normal thing that is fixed by a reboot, or what.

Still running the same versions from my original email, but here they
are again:

Linux rat 4.3.3-3-ARCH #1 SMP PREEMPT Wed Jan 20 08:12:23 CET 2016
x86_64 GNU/Linux

btrfs-progs v4.3.1


Thanks,

--Sean
