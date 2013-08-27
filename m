Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:54714 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3H0NqH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 09:46:07 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 878457C069D
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 07:46:06 -0600 (MDT)
Date: Tue, 27 Aug 2013 09:46:04 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: handle errors when doing slow caching
Message-ID: <20130827134604.GI29654@localhost.localdomain>
References: <1375715995-3843-1-git-send-email-jbacik@fusionio.com>
 <CAOcd+r1zTBoEGG+JaCSdrNesUzbyDAufCQscGh8xuBoa4cQ=3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r1zTBoEGG+JaCSdrNesUzbyDAufCQscGh8xuBoa4cQ=3w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 27, 2013 at 01:26:36PM +0300, Alex Lyakas wrote:
> Hi Josef,
> thanks for addressing this.
> 
> On Mon, Aug 5, 2013 at 6:19 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > Alex Lyakas reported a bug where wait_block_group_cache_progress() would wait
> > forever if a drive failed.  This is because we just bail out if there is an
> > error while trying to cache a block group, we don't update anybody who may be
> > waiting.  So this introduces a new enum for the cache state in case of error and
> > makes everybody bail out if we have an error.  Alex tested and verified this
> > patch fixed his problem.  This fixes bz 59431.  Thanks,
> >
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  fs/btrfs/ctree.h       |    1 +
> >  fs/btrfs/extent-tree.c |   27 ++++++++++++++++++++-------
> >  2 files changed, 21 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index cbb1263..c17acbc 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -1188,6 +1188,7 @@ enum btrfs_caching_type {
> >         BTRFS_CACHE_STARTED     = 1,
> >         BTRFS_CACHE_FAST        = 2,
> >         BTRFS_CACHE_FINISHED    = 3,
> > +       BTRFS_CACHE_ERROR       = 4,
> >  };
> >
> >  enum btrfs_disk_cache_state {
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index e868c35..e6dfa7f 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -113,7 +113,8 @@ static noinline int
> >  block_group_cache_done(struct btrfs_block_group_cache *cache)
> >  {
> >         smp_mb();
> > -       return cache->cached == BTRFS_CACHE_FINISHED;
> > +       return cache->cached == BTRFS_CACHE_FINISHED ||
> > +               cache->cached == BTRFS_CACHE_ERROR;
> >  }
> >
> >  static int block_group_bits(struct btrfs_block_group_cache *cache, u64 bits)
> > @@ -389,7 +390,7 @@ static noinline void caching_thread(struct btrfs_work *work)
> >         u64 total_found = 0;
> >         u64 last = 0;
> >         u32 nritems;
> > -       int ret = 0;
> > +       int ret = -ENOMEM;
> >
> >         caching_ctl = container_of(work, struct btrfs_caching_control, work);
> >         block_group = caching_ctl->block_group;
> > @@ -517,6 +518,12 @@ err:
> >
> >         mutex_unlock(&caching_ctl->mutex);
> >  out:
> > +       if (ret) {
> > +               spin_lock(&block_group->lock);
> > +               block_group->caching_ctl = NULL;
> > +               block_group->cached = BTRFS_CACHE_ERROR;
> > +               spin_unlock(&block_group->lock);
> > +       }
> >         wake_up(&caching_ctl->wait);
> >
> >         put_caching_control(caching_ctl);
> > @@ -6035,8 +6042,11 @@ static u64 stripe_align(struct btrfs_root *root,
> >   * for our min num_bytes.  Another option is to have it go ahead
> >   * and look in the rbtree for a free extent of a given size, but this
> >   * is a good start.
> > + *
> > + * Callers of this must check if cache->cached == BTRFS_CACHE_ERROR before using
> > + * any of the information in this block group.
> >   */
> > -static noinline int
> > +static noinline void
> >  wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
> >                                 u64 num_bytes)
> >  {
> > @@ -6044,28 +6054,29 @@ wait_block_group_cache_progress(struct btrfs_block_group_cache *cache,
> >
> >         caching_ctl = get_caching_control(cache);
> >         if (!caching_ctl)
> > -               return 0;
> > +               return;
> >
> >         wait_event(caching_ctl->wait, block_group_cache_done(cache) ||
> >                    (cache->free_space_ctl->free_space >= num_bytes));
> >
> >         put_caching_control(caching_ctl);
> > -       return 0;
> >  }
> >
> >  static noinline int
> >  wait_block_group_cache_done(struct btrfs_block_group_cache *cache)
> >  {
> >         struct btrfs_caching_control *caching_ctl;
> > +       int ret = 0;
> >
> >         caching_ctl = get_caching_control(cache);
> >         if (!caching_ctl)
> >                 return 0;
> In case caching_thread completes with error for this block group,
> get_caching_control() will return NULL.
> So this function will return success, although the block group was not
> cached properly.
> Currently only btrfs_trim_fs() caller checks the return value of this
> function, although you didn't post the btrfs_trim_fs() change in this
> patch (but you posed it in the bugzilla). Still, should we check the
> cache->cached for ERROR even if there is no caching control?
>

Yeah I'll fix that up, sorry about that.  Thanks,

Josef 
