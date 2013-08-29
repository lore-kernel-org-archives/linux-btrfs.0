Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53488 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3H2TfD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 15:35:03 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9FFD37C0696
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Aug 2013 13:35:01 -0600 (MDT)
Date: Thu, 29 Aug 2013 15:34:59 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: allocate the free space by the existed max extent
 size when ENOSPC
Message-ID: <20130829193459.GD10591@localhost.localdomain>
References: <1377755258-2722-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1377755258-2722-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 29, 2013 at 01:47:38PM +0800, Miao Xie wrote:
> By the current code, if the requested size is very large, and all the extents
> in the free space cache are small, we will waste lots of the cpu time to cut
> the requested size in half and search the cache again and again until it gets
> down to the size the allocator can return. In fact, we can know the max extent
> size in the cache after the first search, so we needn't cut the size in half
> repeatedly, and just use the max extent size directly. This way can save
> lots of cpu time and make the performance grow up when there are only fragments
> in the free space cache.
> 
> According to my test, if there are only 4KB free space extents in the fs,
> and the total size of those extents are 256MB, we can reduce the execute
> time of the following test from 5.4s to 1.4s.
>   dd if=/dev/zero of=<testfile> bs=1MB count=1 oflag=sync
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

This breaks one of the free space cache unit tests, please enable the sanity
tests when you mess with free-space-cache.c so you can be sure you aren't
breaking anything.  Thanks,

Josef
