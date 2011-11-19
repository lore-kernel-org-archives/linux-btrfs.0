From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] Btrfs: fix num_start_workers count if we fail to make an
 alloc
Date: Sat, 19 Nov 2011 01:37:39 +0000
Message-ID: <20111119013739.GA30125@ZenIV.linux.org.uk>
References: <1321645134-3944-1-git-send-email-josef@redhat.com>
 <20111118202056.GA2203@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111118202056.GA2203@ZenIV.linux.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 18, 2011 at 08:20:56PM +0000, Al Viro wrote:
> On Fri, Nov 18, 2011 at 02:38:54PM -0500, Josef Bacik wrote:
> > Al pointed out that if we fail to start a worker for whatever reason (ENOMEM
> > basically), we could leak our count for num_start_workers, and so we'd think we
> > had more workers than we actually do.  This could cause us to shrink workers
> > when we shouldn't or not start workers when we should.  So check the return
> > value and if we failed fix num_start_workers and fallback.  Thanks,
> 
> It's actually uglier than that; consider check_pending_workers_create()
> where we
> 	* bump the num_start_workers
> 	* call start_new_worker(), which can fail, and then we have the same
> leak; if it doesn't fail, it schedules a call of start_new_worker_func()
> 	* when start_new_worker_func() runs, it does btrfs_start_workers(),
> which can run into the same leak again (this time on another pool - one
> we have as ->async_helper).

Nuts...  AFAICS, we _always_ leak ->num_start_workers here (i.e. when
check_pending_workers_create() finds ->atomic_start_pending set).  In
effect, we bump it once in check_pending_workers_create() itself, then
another time (on the same pool) when start_new_worker_func() calls
btrfs_start_workers().  That one will be dropped when we manage to 
start the thread, but the first one won't.

Shouldn't we use __btrfs_start_workers() instead here?
