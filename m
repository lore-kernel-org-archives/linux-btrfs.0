Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33151 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3HEPLG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Aug 2013 11:11:06 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1224C9A0406
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Aug 2013 09:11:06 -0600 (MDT)
Date: Mon, 5 Aug 2013 11:09:06 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: stop all workers before cleaning up roots
Message-ID: <20130805150906.GG2372@localhost.localdomain>
References: <1369947496-27707-1-git-send-email-jbacik@fusionio.com>
 <CAOcd+r1mkZhaFNNBsu6G89zBKmtLTL5U72mBczFpukMNXckKXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r1mkZhaFNNBsu6G89zBKmtLTL5U72mBczFpukMNXckKXw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 01, 2013 at 05:05:35PM +0300, Alex Lyakas wrote:
> Hi Josef,
> 
> On Thu, May 30, 2013 at 11:58 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > Dave reported a panic because the extent_root->commit_root was NULL in the
> > caching kthread.  That is because we just unset it in free_root_pointers, which
> > is not the correct thing to do, we have to either wait for the caching kthread
> > to complete or hold the extent_commit_sem lock so we know the thread has exited.
> > This patch makes the kthreads all stop first and then we do our cleanup.  This
> > should fix the race.  Thanks,
> >
> > Reported-by: David Sterba <dsterba@suse.cz>
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  fs/btrfs/disk-io.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 2b53afd..77cb566 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3547,13 +3547,13 @@ int close_ctree(struct btrfs_root *root)
> >
> >         btrfs_free_block_groups(fs_info);
> 
> do you think it would be safer to stop all workers first and make sure
> they are stopped, then do btrfs_free_block_groups()? I see, for
> example, that btrfs_free_block_groups() checks:
> if (block_group->cached == BTRFS_CACHE_STARTED)
> which could be perhaps racy with other people spawning caching_threads.
> 
> So maybe better to stop all threads (including cleaner and committer)
> and then free everything?
> 

Well nobody should be writing anymore, so we shouldn't be starting any new
caching_kthreads, we should just be cleaning up threads that are already
running.  Btrfs_free_block_groups() will wait on any kthreads it spawned, so we
are good there.  Hth,

Josef
