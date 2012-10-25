Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49160 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646Ab2JYLxA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 07:53:00 -0400
Message-ID: <50892821.5010808@oracle.com>
Date: Thu, 25 Oct 2012 19:53:05 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] flush delalloc by multi-task
References: <5089045D.8050801@cn.fujitsu.com>
In-Reply-To: <5089045D.8050801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/25/2012 05:20 PM, Miao Xie wrote:
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

I can see the potential improvements brought by flushing inodes this way.

But I don't think it makes much sense by making waiting process multi-task,
since even we spread wait order extents into different cpus, they just occpied
the cpu and went on waiting and scheduled then, I mean, the bottleneck is on
what we're waiting for.

Besides, considering that this patchset is about to getting us better performance,
I'm expecting any performance numbers (I'm a little worried about context switches
overhead).

btw, cool ideas indeed.

thanks,
liubo

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

