Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39897 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbcFPApw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 20:45:52 -0400
Date: Wed, 15 Jun 2016 17:47:20 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: track transid for delayed ref flushing
Message-ID: <20160616004720.GD8071@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1460410660-17430-1-git-send-email-jbacik@fb.com>
 <20160427135938.pczv7f4ulrvwehqp@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160427135938.pczv7f4ulrvwehqp@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 27, 2016 at 09:59:38AM -0400, Chris Mason wrote:
> On Mon, Apr 11, 2016 at 05:37:40PM -0400, Josef Bacik wrote:
> > Using the offwakecputime bpf script I noticed most of our time was spent waiting
> > on the delayed ref throttling.  This is what is supposed to happen, but
> > sometimes the transaction can commit and then we're waiting for throttling that
> > doesn't matter anymore.  So change this stuff to be a little smarter by tracking
> > the transid we were in when we initiated the throttling.  If the transaction we
> > get is different then we can just bail out.  This resulted in a 50% speedup in
> > my fs_mark test, and reduced the amount of time spent throttling by 60 seconds
> > over the entire run (which is about 30 minutes).  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/ctree.h       |  2 +-
> >  fs/btrfs/extent-tree.c | 15 ++++++++++++---
> >  fs/btrfs/inode.c       |  1 +
> >  fs/btrfs/transaction.c |  3 ++-
> >  4 files changed, 16 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 55a24c5..4222936 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -3505,7 +3505,7 @@ void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
> >  int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
> >  			   struct btrfs_root *root, unsigned long count);
> >  int btrfs_async_run_delayed_refs(struct btrfs_root *root,
> > -				 unsigned long count, int wait);
> > +				 unsigned long count, u64 transid, int wait);
> >  int btrfs_lookup_data_extent(struct btrfs_root *root, u64 start, u64 len);
> >  int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
> >  			     struct btrfs_root *root, u64 bytenr,
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 4b5a517..f23f426 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2839,6 +2839,7 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
> >  
> >  struct async_delayed_refs {
> >  	struct btrfs_root *root;
> > +	u64 transid;
> >  	int count;
> >  	int error;
> >  	int sync;
> > @@ -2854,9 +2855,16 @@ static void delayed_ref_async_start(struct btrfs_work *work)
> >  
> >  	async = container_of(work, struct async_delayed_refs, work);
> >  
> > -	trans = btrfs_join_transaction(async->root);
> > +	trans = btrfs_attach_transaction(async->root);
> >  	if (IS_ERR(trans)) {
> > -		async->error = PTR_ERR(trans);
> > +		if (PTR_ERR(trans) != -ENOENT)
> > +			async->error = PTR_ERR(trans);
> > +		goto done;
> > +	}
> 
> This ends up deadlocking because btrfs_attach_transaction waits in ways
> that join does not.  The differences between these two are really
> subtle, and we manage to make this mistake every year or so.
> 
> Subject: [PATCH] btrfs: fix deadlock in delayed_ref_async_start
> 
> "Btrfs: track transid for delayed ref flushing" was deadlocking on
> btrfs_attach_transaction because its not safe to call from the async
> delayed ref start code.  This commit brings back btrfs_join_transaction
> instead and checks for a blocked commit.

Are we going to take this patch?

Thanks,

-liubo

> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Chris Mason <clm@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6ce5b6c..44da4ac 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2845,16 +2845,13 @@ static void delayed_ref_async_start(struct btrfs_work *work)
>  
>  	async = container_of(work, struct async_delayed_refs, work);
>  
> -	trans = btrfs_attach_transaction(async->root);
> -	if (IS_ERR(trans)) {
> -		if (PTR_ERR(trans) != -ENOENT)
> -			async->error = PTR_ERR(trans);
> +	/* if the commit is already started, we don't need to wait here */
> +	if (btrfs_transaction_blocked(async->root->fs_info))
>  		goto done;
> -	}
>  
> -	/* Don't bother flushing if we got into a different transaction */
> -	if (trans->transid != async->transid) {
> -		btrfs_end_transaction(trans, async->root);
> +	trans = btrfs_join_transaction(async->root);
> +	if (IS_ERR(trans)) {
> +		async->error = PTR_ERR(trans);
>  		goto done;
>  	}
>  
> @@ -2863,10 +2860,15 @@ static void delayed_ref_async_start(struct btrfs_work *work)
>  	 * wait on delayed refs
>  	 */
>  	trans->sync = true;
> +
> +	/* Don't bother flushing if we got into a different transaction */
> +	if (trans->transid > async->transid)
> +		goto end;
> +
>  	ret = btrfs_run_delayed_refs(trans, async->root, async->count);
>  	if (ret)
>  		async->error = ret;
> -
> +end:
>  	ret = btrfs_end_transaction(trans, async->root);
>  	if (ret && !async->error)
>  		async->error = ret;
> -- 
> 2.8.0.rc2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
