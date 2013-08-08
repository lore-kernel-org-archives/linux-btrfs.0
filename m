Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55485 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965843Ab3HHR37 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 13:29:59 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 716DC7C064D
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Aug 2013 11:29:59 -0600 (MDT)
Date: Thu, 8 Aug 2013 13:29:57 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: John Williams <jwilliams4200@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Why does btrfs benchmark so badly in this case?
Message-ID: <20130808172957.GG16712@localhost.localdomain>
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

Excellent question, I'll get back to you on that.  Thanks,

Josef
