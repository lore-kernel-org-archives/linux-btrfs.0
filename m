From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] Btrfs: fix num_start_workers count if we fail to make an
 alloc
Date: Fri, 18 Nov 2011 20:20:56 +0000
Message-ID: <20111118202056.GA2203@ZenIV.linux.org.uk>
References: <1321645134-3944-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1321645134-3944-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 18, 2011 at 02:38:54PM -0500, Josef Bacik wrote:
> Al pointed out that if we fail to start a worker for whatever reason (ENOMEM
> basically), we could leak our count for num_start_workers, and so we'd think we
> had more workers than we actually do.  This could cause us to shrink workers
> when we shouldn't or not start workers when we should.  So check the return
> value and if we failed fix num_start_workers and fallback.  Thanks,

It's actually uglier than that; consider check_pending_workers_create()
where we
	* bump the num_start_workers
	* call start_new_worker(), which can fail, and then we have the same
leak; if it doesn't fail, it schedules a call of start_new_worker_func()
	* when start_new_worker_func() runs, it does btrfs_start_workers(),
which can run into the same leak again (this time on another pool - one
we have as ->async_helper).

Worse, __btrfs_start_workers() does btrfs_stop_workers() on failure.  That,
to put it mildly, is using excessive force.  As far as I can see, it's
_never_ the right thing to do - __btrfs_start_workers() is always getting
1 as the second argument, so even calls from mount path don't need that
kind of "kill ones we'd already created if we fail halfway through".  It
used to make sense when they had all been started at mount time, but now
it's useless in the best case (mount) and destructive elsewhere (when
pool had already been non-empty).

So I'd suggest killing that call of btrfs_stop_workers() completely, losing
the num_workers argument (along with a loop in __btrfs_start_workers())
and looking into check_pending_workers_create() path.

Probably I'd put decrement on ->num_workers_starting into failure exits of
__btrfs_start_workers() and start_new_worker(), but... can btrfs_queue_worker()
ever return non-zero?  AFAICS it can't and we could just merge
start_new_worker() into check_pending_workers() and pull allocation before
incrementing the ->num_workers_starting...
