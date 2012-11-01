Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:41208 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab2KAHna (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 03:43:30 -0400
Message-ID: <50922837.3080101@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 15:43:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] flush delalloc by multi-task
References: <5089045D.8050801@cn.fujitsu.com>
In-Reply-To: <5089045D.8050801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Josef

Please drop this patchset from your btrfs-next tree because it may cause the
performance regression in some cases. I'll improve it later.

Thanks
Miao

On thu, 25 Oct 2012 17:20:29 +0800, Miao Xie wrote:
> This patchset introduce multi-task delalloc flush, it can make the delalloc
> flush more faster. And besides that, it also can fix the problem that we join
> the same transaction handler more than 2 times.
> 
> Implementation:
> - Create a new worker pool.
> - Queue the inode with pending delalloc into the work queue of the worker pool
>   when we want to force them into the disk, and then we will wait till all the
>   works we submit are done. 
> - The ordered extents also can be queued into this work queue. The process is
>   similar to the second one.
> 
> Miao Xie (3):
>       Btrfs: make delalloc inodes be flushed by multi-task
>       Btrfs: make ordered operations be handled by multi-task
>       Btrfs: make ordered extent be flushed by multi-task
> 
>  fs/btrfs/ctree.h        |   14 +++++++
>  fs/btrfs/disk-io.c      |    7 ++++
>  fs/btrfs/inode.c        |   78 ++++++++++++++++++++++++++++++++++++++---
>  fs/btrfs/ordered-data.c |   87 ++++++++++++++++++++++++++++++++++-------------
>  fs/btrfs/ordered-data.h |    7 +++-
>  fs/btrfs/relocation.c   |    6 +++-
>  fs/btrfs/transaction.c  |   24 ++++++++++---
>  7 files changed, 185 insertions(+), 38 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


