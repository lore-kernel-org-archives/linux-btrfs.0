Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:52319 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725954AbeHTJWO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 05:22:14 -0400
Date: Sun, 19 Aug 2018 23:07:38 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: kill btrfs_clear_path_blocking
Message-ID: <20180820060737.h5qwjpi3lzo72gbp@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1534453645-17714-1-git-send-email-bo.liu@linux.alibaba.com>
 <1534453645-17714-2-git-send-email-bo.liu@linux.alibaba.com>
 <f8f4cdcb-5b11-5654-b658-63d9ba1c1638@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f8f4cdcb-5b11-5654-b658-63d9ba1c1638@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 17, 2018 at 10:24:58AM +0300, Nikolay Borisov wrote:
> 
> 
> On 17.08.2018 00:07, Liu Bo wrote:
> > Btrfs's btree locking has two modes, spinning mode and blocking mode,
> > while searching btree, locking is always acquired in spinning mode and
> > then converted to blocking mode if necessary, and in some hot paths we may
> > switch the locking back to spinning mode by btrfs_clear_path_blocking().
> > 
> > When acquiring locks, both of reader and writer need to wait for blocking
> > readers and writers to complete before doing read_lock()/write_lock().
> > 
> > The problem is that btrfs_clear_path_blocking() needs to switch nodes
> > in the path to blocking mode at first (by btrfs_set_path_blocking) to
> > make lockdep happy before doing its actual clearing blocking job.
> > 
> > When switching to blocking mode from spinning mode, it consists of
> > 
> > step 1) bumping up blocking readers counter and
> > step 2) read_unlock()/write_unlock(),
> > 
> > this has caused serious ping-pong effect if there're a great amount of
> > concurrent readers/writers, as waiters will be woken up and go to
> > sleep immediately.
> 
> I think this ping-pong needs to be explained in a bit more detail.
> 
> Looking at the code it seems the issue happens when we have a path
> locked in spinning mode (via btrfs_tree_lock) - in this case we have
> blocking_readers/writes == 0 and write_lock acquired. Then we could
> potentially have multiple requests to lock the tree (in this case the
> root) and since the current holder is spinning then btrfs_tree_lock
> callers will block on the write_lock. Subsequently when the holder
> switches to blocking he calls
> btrfs_set_path_blocking->btrfs_set_lock_blocking_rw which of course
> increments the blocking reader/writes and calls the unlock at which
> point a "thundering herd" problem occurs on the lock. Am I correct?
>

That's correct, but the "thundering herd' problem is not really the
problem that this patch is trying to address, see more in below.

> Furthermore I think the problem occurs not in btrfs_clear_path_blocking
> but rather in the initial call to btrfs_set_path_blocking.
> 
> The way I see it the following sequence of operations occur:
> 
> 1. Call btrfs_set_path_blocking: increments
> blocking_writers/blocking_readers, calls unlock: ping-pong happens. Now
> the lock types for the nodes in the path are
> BTRFS_READ_LOCK_BLOCKING/BTRFS_WRITE_LOCK_BLOCKING
> 
> 2. Some time later we call btrfs_clear_path_blocking
> which also calls btrfs_set_path_blocking, however this time this
> function doesn't do anything because the lock types in path struct are
> already blocking and none of the 2 conditions inside
> btrfs_set_lock_blocking_rw will match hence this code won't be executed.
> 
> Did I miss something ?
> 

Thanks for sharing your thoughts.

We have to set path blocking as the subsequent code needs to sleep,
it's the cost we have to pay by design, I'm OK with it.

The problem is that btrfs_clear_path_blocking always tries to set path
to blocking before clearing path blocking as it needs to ensure
spin_locks on each level are acquired in right order.  And if all the
nodes in the path are already in spinning mode (say that
should_cow_block() decides to not COW), setting path blocking doesn't
really make sense and causes others waiting on the lock to do a
wake-up and a go-to-sleep.

My trace showed that there could be up to 50 switches for a single
lock waiter and the difference on the finished time also proved how
big the impact is.

thanks,
-liubo
> > 
> > 1) Killing this kind of ping-pong results in a big improvement in my 1600k
> > files creation script,
> > 
> > MNT=/mnt/btrfs
> > mkfs.btrfs -f /dev/sdf
> > mount /dev/def $MNT
> > time fsmark  -D  10000  -S0  -n  100000  -s  0  -L  1 -l /tmp/fs_log.txt \
> >         -d  $MNT/0  -d  $MNT/1 \
> >         -d  $MNT/2  -d  $MNT/3 \
> >         -d  $MNT/4  -d  $MNT/5 \
> >         -d  $MNT/6  -d  $MNT/7 \
> >         -d  $MNT/8  -d  $MNT/9 \
> >         -d  $MNT/10  -d  $MNT/11 \
> >         -d  $MNT/12  -d  $MNT/13 \
> >         -d  $MNT/14  -d  $MNT/15
> > 
> > w/o patch:
> > real    2m27.307s
> > user    0m12.839s
> > sys     13m42.831s
> > 
> > w/ patch:
> > real    1m2.273s
> > user    0m15.802s
> > sys     8m16.495s
> > 
> > 2) dbench also proves the improvement,
> > dbench -t 120 -D /mnt/btrfs 16
> > 
> > w/o patch:
> > Throughput 158.363 MB/sec
> > 
> > w/ patch:
> > Throughput 449.52 MB/sec
> > 
> > 3) xfstests didn't show any additional failures.
> > 
> > One thing to note is that callers may set leave_spinning to have all
> > nodes in the path stay in spinning mode, which means callers are ready
> > to not sleep before releasing the path, but it won't cause problems if
> > they don't want to sleep in blocking mode, IOW, we can just get rid of
> > leave_spinning.
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > ---
> >  fs/btrfs/ctree.c         | 57 ++++--------------------------------------------
> >  fs/btrfs/ctree.h         |  2 --
> >  fs/btrfs/delayed-inode.c |  3 ---
> >  3 files changed, 4 insertions(+), 58 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index d436fb4c002e..8b31caa60b0a 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -52,42 +52,6 @@ noinline void btrfs_set_path_blocking(struct btrfs_path *p)
> >  	}
> >  }
> >  
> > -/*
> > - * reset all the locked nodes in the patch to spinning locks.
> > - *
> > - * held is used to keep lockdep happy, when lockdep is enabled
> > - * we set held to a blocking lock before we go around and
> > - * retake all the spinlocks in the path.  You can safely use NULL
> > - * for held
> > - */
> > -noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
> > -					struct extent_buffer *held, int held_rw)
> > -{
> > -	int i;
> > -
> > -	if (held) {
> > -		btrfs_set_lock_blocking_rw(held, held_rw);
> > -		if (held_rw == BTRFS_WRITE_LOCK)
> > -			held_rw = BTRFS_WRITE_LOCK_BLOCKING;
> > -		else if (held_rw == BTRFS_READ_LOCK)
> > -			held_rw = BTRFS_READ_LOCK_BLOCKING;
> > -	}
> > -	btrfs_set_path_blocking(p);
> > -
> > -	for (i = BTRFS_MAX_LEVEL - 1; i >= 0; i--) {
> > -		if (p->nodes[i] && p->locks[i]) {
> > -			btrfs_clear_lock_blocking_rw(p->nodes[i], p->locks[i]);
> > -			if (p->locks[i] == BTRFS_WRITE_LOCK_BLOCKING)
> > -				p->locks[i] = BTRFS_WRITE_LOCK;
> > -			else if (p->locks[i] == BTRFS_READ_LOCK_BLOCKING)
> > -				p->locks[i] = BTRFS_READ_LOCK;
> > -		}
> > -	}
> > -
> > -	if (held)
> > -		btrfs_clear_lock_blocking_rw(held, held_rw);
> > -}
> > -
> >  /* this also releases the path */
> >  void btrfs_free_path(struct btrfs_path *p)
> >  {
> > @@ -1306,7 +1270,6 @@ static struct tree_mod_elem *__tree_mod_log_oldest_root(
> >  		}
> >  	}
> >  
> > -	btrfs_clear_path_blocking(path, NULL, BTRFS_READ_LOCK);
> >  	btrfs_tree_read_unlock_blocking(eb);
> >  	free_extent_buffer(eb);
> >  
> > @@ -2483,7 +2446,6 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
> >  		btrfs_set_path_blocking(p);
> >  		reada_for_balance(fs_info, p, level);
> >  		sret = split_node(trans, root, p, level);
> > -		btrfs_clear_path_blocking(p, NULL, 0);
> >  
> >  		BUG_ON(sret > 0);
> >  		if (sret) {
> > @@ -2504,7 +2466,6 @@ noinline void btrfs_unlock_up_safe(struct btrfs_path *path, int level)
> >  		btrfs_set_path_blocking(p);
> >  		reada_for_balance(fs_info, p, level);
> >  		sret = balance_level(trans, root, p, level);
> > -		btrfs_clear_path_blocking(p, NULL, 0);
> >  
> >  		if (sret) {
> >  			ret = sret;
> > @@ -2789,7 +2750,10 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> >  		}
> >  cow_done:
> >  		p->nodes[level] = b;
> > -		btrfs_clear_path_blocking(p, NULL, 0);
> > +		/*
> > +		 * Leave path with blocking locks to avoid massive
> > +		 * lock context switch, this is made on purpose.
> > +		 */
> >  
> >  		/*
> >  		 * we have a lock on b and as long as we aren't changing
> > @@ -2871,8 +2835,6 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> >  					if (!err) {
> >  						btrfs_set_path_blocking(p);
> >  						btrfs_tree_lock(b);
> > -						btrfs_clear_path_blocking(p, b,
> > -								  BTRFS_WRITE_LOCK);
> >  					}
> >  					p->locks[level] = BTRFS_WRITE_LOCK;
> >  				} else {
> > @@ -2880,8 +2842,6 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> >  					if (!err) {
> >  						btrfs_set_path_blocking(p);
> >  						btrfs_tree_read_lock(b);
> > -						btrfs_clear_path_blocking(p, b,
> > -								  BTRFS_READ_LOCK);
> >  					}
> >  					p->locks[level] = BTRFS_READ_LOCK;
> >  				}
> > @@ -2900,7 +2860,6 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> >  				btrfs_set_path_blocking(p);
> >  				err = split_leaf(trans, root, key,
> >  						 p, ins_len, ret == 0);
> > -				btrfs_clear_path_blocking(p, NULL, 0);
> >  
> >  				BUG_ON(err > 0);
> >  				if (err) {
> > @@ -2967,7 +2926,6 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
> >  	while (b) {
> >  		level = btrfs_header_level(b);
> >  		p->nodes[level] = b;
> > -		btrfs_clear_path_blocking(p, NULL, 0);
> >  
> >  		/*
> >  		 * we have a lock on b and as long as we aren't changing
> > @@ -3013,8 +2971,6 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
> >  			if (!err) {
> >  				btrfs_set_path_blocking(p);
> >  				btrfs_tree_read_lock(b);
> > -				btrfs_clear_path_blocking(p, b,
> > -							  BTRFS_READ_LOCK);
> >  			}
> >  			b = tree_mod_log_rewind(fs_info, p, b, time_seq);
> >  			if (!b) {
> > @@ -5198,7 +5154,6 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
> >  		path->locks[level - 1] = BTRFS_READ_LOCK;
> >  		path->nodes[level - 1] = cur;
> >  		unlock_up(path, level, 1, 0, NULL);
> > -		btrfs_clear_path_blocking(path, NULL, 0);
> >  	}
> >  out:
> >  	path->keep_locks = keep_locks;
> > @@ -5783,8 +5738,6 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
> >  			if (!ret) {
> >  				btrfs_set_path_blocking(path);
> >  				btrfs_tree_read_lock(next);
> > -				btrfs_clear_path_blocking(path, next,
> > -							  BTRFS_READ_LOCK);
> >  			}
> >  			next_rw_lock = BTRFS_READ_LOCK;
> >  		}
> > @@ -5820,8 +5773,6 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
> >  			if (!ret) {
> >  				btrfs_set_path_blocking(path);
> >  				btrfs_tree_read_lock(next);
> > -				btrfs_clear_path_blocking(path, next,
> > -							  BTRFS_READ_LOCK);
> >  			}
> >  			next_rw_lock = BTRFS_READ_LOCK;
> >  		}
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 318be7864072..1aeed3c0e949 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -2876,8 +2876,6 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
> >  struct btrfs_path *btrfs_alloc_path(void);
> >  void btrfs_free_path(struct btrfs_path *p);
> >  void btrfs_set_path_blocking(struct btrfs_path *p);
> > -void btrfs_clear_path_blocking(struct btrfs_path *p,
> > -			       struct extent_buffer *held, int held_rw);
> >  void btrfs_unlock_up_safe(struct btrfs_path *p, int level);
> >  
> >  int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
> > diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> > index f51b509f2d9b..db9f45082c61 100644
> > --- a/fs/btrfs/delayed-inode.c
> > +++ b/fs/btrfs/delayed-inode.c
> > @@ -762,9 +762,6 @@ static int btrfs_batch_insert_items(struct btrfs_root *root,
> >  		i++;
> >  	}
> >  
> > -	/* reset all the locked nodes in the patch to spinning locks. */
> > -	btrfs_clear_path_blocking(path, NULL, 0);
> > -
> >  	/* insert the keys of the items */
> >  	setup_items_for_insert(root, path, keys, data_size,
> >  			       total_data_size, total_size, nitems);
> > 
