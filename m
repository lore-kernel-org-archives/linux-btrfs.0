Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab3IKRjU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 13:39:20 -0400
Date: Wed, 11 Sep 2013 10:39:15 -0700
From: Zach Brown <zab@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 8/9] btrfs: Cleanup the old btrfs workqueue
Message-ID: <20130911173915.GI26818@lenny.home.zabbo.net>
References: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1378889558-21514-9-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1378889558-21514-9-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 11, 2013 at 04:52:37PM +0800, Qu Wenruo wrote:
> Since the patches before implemented the new kernel workqueue based
> btrfs_worqueue_struct, the old btrfs workqueue(btrfs_worker) can be
> removed without any problem.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/Makefile       |   2 +-
>  fs/btrfs/async-thread.c | 714 ------------------------------------------------
>  fs/btrfs/async-thread.h | 119 --------
>  fs/btrfs/ctree.h        |   3 -
>  fs/btrfs/dev-replace.c  |   1 -
>  fs/btrfs/disk-io.c      |  24 +-
>  fs/btrfs/raid56.c       |   1 -
>  fs/btrfs/relocation.c   |   1 -
>  fs/btrfs/super.c        |   8 -
>  fs/btrfs/volumes.c      |   1 -
>  fs/btrfs/volumes.h      |   1 -
>  11 files changed, 10 insertions(+), 865 deletions(-)
>  delete mode 100644 fs/btrfs/async-thread.c
>  delete mode 100644 fs/btrfs/async-thread.h

This is exciting.  I'm excited.

> -	worker->task = kthread_run(worker_loop, worker,
> -				   "btrfs-%s-%d", workers->name,
> -				   workers->num_workers + 1);

I bet this simply removes the possibility of the silly problem Eric once
saw where you can have threads with the same name.  (naming things based
on the number of things gives duplicate names if the things are
destroyed and recreated out of order.)

- z
