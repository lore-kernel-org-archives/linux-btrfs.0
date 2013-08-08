Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56821 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965817Ab3HHTkS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 15:40:18 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 26D5B7C06A2
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Aug 2013 13:40:18 -0600 (MDT)
Date: Thu, 8 Aug 2013 15:40:15 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: John Williams <jwilliams4200@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Why does btrfs benchmark so badly in this case?
Message-ID: <20130808194015.GH16712@localhost.localdomain>
References: <CAJBj3vcfSrWC3sxxxin93GYYPZY_z_MJnAHoMxB45MFqEXYXkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAJBj3vcfSrWC3sxxxin93GYYPZY_z_MJnAHoMxB45MFqEXYXkA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 09:13:04AM -0700, John Williams wrote:
> Phoronix periodically runs benchmarks on filesystems, and one thing I
> have noticed is that btrfs always does terribly on their fio "Intel
> IOMeter fileserver access pattern" benchmark:
> 
> http://www.phoronix.com/scan.php?page=article&item=linux_310_10fs&num=2
> 
> Here, btrfs is more than 6 times slower than ext4, and about 3 times
> slower than XFS.
> 
> Lest we attribute it to an unavoidable downside of COW filesystems and
> move on...no, we cannot do that, because ZFS does well here -- btrfs
> is about 6 times slower than ZFS!
> 
> Note that btrfs does quite well in the other Phoronix benchmarks. It
> is just the fio fileserver benchmark that btrfs has problems with.
> 
> What is going on here? Why is btrfs doing so poorly?

So the reason this workload sucks for btrfs is because we fall back on buffered
IO because fio does not do block size aligned writes for this workload.  If you
add

ba=4k

to the iometer fio file then we go the same speed as xfs and ext4.  Not a whole
lot we can do about this since unaligned writes means we have to read in pages
to cow the block properly, which is why we fall back to buffered.  Once we do
that we end up having a lot of page locking stuff that gets in the way and makes
us twice as slow.  Thanks,

Josef
