From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: allow changing 'thread_pool' size at remount time
Date: Tue, 24 Apr 2012 14:10:25 -0400
Message-ID: <20120424181025.GC6164@localhost.localdomain>
References: <1335288404-11565-1-git-send-email-slyich@gmail.com>
 <20120424173237.GA6164@localhost.localdomain>
 <20120424211115.319d1154@sf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Sergei Trofimovich <slyfox@gentoo.org>,
	Chris Mason <chris.mason@oracle.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120424211115.319d1154@sf.home>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 24, 2012 at 09:11:15PM +0300, Sergei Trofimovich wrote:
> On Tue, 24 Apr 2012 13:32:37 -0400
> Josef Bacik <josef@redhat.com> wrote:
> 
> > On Tue, Apr 24, 2012 at 08:26:44PM +0300, Sergei Trofimovich wrote:
> > > From: Sergei Trofimovich <slyfox@gentoo.org>
> > > 
> > > Changing 'mount -oremount,thread_pool=2 /' didn't make any effect:
> > > 
> > > maximum amount of worker threads is specified in 2 places:
> > > - in 'strict btrfs_fs_info::thread_pool_size'
> > > - in each worker struct: 'struct btrfs_workers::max_workers'
> > > 
> > > 'mount -oremount' updated only 'btrfs_fs_info::thread_pool_size'.
> > > 
> > > Fix it by pushing new maximum value to all created worker structures
> > > as well.
> > > 
> > > Cc: Josef Bacik <josef@redhat.com>
> > > Cc: Chris Mason <chris.mason@oracle.com>
> > > Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> > > ---
> > > WARNING: This patch makes sense only with
> > > WARNING:    "btrfs: fix early abort in 'remount'"
> > > WARNING: sitting in Josef's -next branch.
> > >  fs/btrfs/super.c |   38 +++++++++++++++++++++++++++++++++-----
> > >  1 files changed, 33 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > > index 2f28fc0..ed2dab9 100644
> > > --- a/fs/btrfs/super.c
> > > +++ b/fs/btrfs/super.c
> > > @@ -435,11 +435,8 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
> > >  		case Opt_thread_pool:
> > >  			intarg = 0;
> > >  			match_int(&args[0], &intarg);
> > > -			if (intarg) {
> > > +			if (intarg)
> > >  				info->thread_pool_size = intarg;
> > > -				printk(KERN_INFO "btrfs: thread pool %d\n",
> > > -				       info->thread_pool_size);
> > > -			}
> > >  			break;
> > >  		case Opt_max_inline:
> > >  			num = match_strdup(&args[0]);
> > > @@ -1119,6 +1116,35 @@ error_fs_info:
> > >  	return ERR_PTR(error);
> > >  }
> > >  
> > > +static void btrfs_set_max_workers(struct btrfs_workers *workers, int new_limit)
> > > +{
> > > +	workers->max_workers = new_limit;
> > > +}
> > 
> > This needs to be protected by it's spin lock, so do
> > 
> > spin_lock_irq(&workers->lock);
> > workers->max_workers = new_limit;
> > spin_unlock_irq(&workers->lock);
> > 
> > Also this doesn't do anything for thread pools that have already gone above the
> > new maximum.  In practice this shouldn't happen really since most of these
> > workers are related to writing anyway, but it may be prudent in the future to
> > make btrfs_set_max_workers to go through and stop threads until the workers are
> > below the new limit.  This doesn't have to be done in this patch, just good idea
> > for future work.
> 
> I've found a place where value is seemingly read w/o lock:
> /* fs/btrfs/disk-io.c */
> unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info)
> {
>         unsigned long limit = min_t(unsigned long,
>                                     info->workers.max_workers,
>                                     info->fs_devices->open_devices);
>         return 256 * limit;
> }
> 
> How hot that path is? Is it fine to guard with similar lock
> or it's better to consider something more SMP friendly?

It's pretty hot, we're ok reading from the value in this case without a lock
since we just want to try and throttle ourselves, it's not important to be super
accurate.  But in your case you are actually setting a new value which is going
to affect how we start new threads so you definitely want to lock it.  Thanks,

Josef
