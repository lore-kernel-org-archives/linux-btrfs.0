Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23325 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752079AbdESE7m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 00:59:42 -0400
Date: Thu, 18 May 2017 21:57:58 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs list corruption and soft lockups while testing writeback
 error handling
Message-ID: <20170519045758.GB30704@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1494501232.2625.3.camel@redhat.com>
 <1494532377.2771.3.camel@redhat.com>
 <30759db2-127f-a9e6-2c77-5734137ce52c@fb.com>
 <1494591145.2787.5.camel@redhat.com>
 <1494598967.2787.9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1494598967.2787.9.camel@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 12, 2017 at 10:22:47AM -0400, Jeff Layton wrote:
> On Fri, 2017-05-12 at 08:12 -0400, Jeff Layton wrote:
> > On Thu, 2017-05-11 at 15:56 -0400, Chris Mason wrote:
> > > On 05/11/2017 03:52 PM, Jeff Layton wrote:
> > > > On Thu, 2017-05-11 at 07:13 -0400, Jeff Layton wrote:
> > > > > I finally got my writeback error handling test to work on btrfs (thanks,
> > > > > Chris!), by making the filesystem stripe the data and mirror the
> > > > > metadata across two devices. The test passes now, but on one run, I got
> > > > > the following list corruption warning and then a soft lockup (which is
> > > > > probably fallout from the list corruption).
> > > > > 
> > > > > I ran the test several times before and since then without this failure,
> > > > > so I don't have a clear reproducer. The kernel in this instance is
> > > > > basically a v4.11 kernel with my pile of writeback error handling
> > > > > patches on top:
> > > > > 
> > > > >     https://urldefense.proofpoint.com/v2/url?u=https-3A__git.samba.org_-3Fp-3Djlayton_linux.git-3Ba-3Dshortlog-3Bh-3Drefs_heads_wberr&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=BXXwaUFQNFNaGGFYHEVlvNBwkrXiIoH7K5iOdR_PvxM&s=xE6pIXeQ1rlaxAV8aTYBSiI06pb3WZoiRJW8Vo1L3NQ&e=
> > > > > 
> > > > > It may be that they are a contributing factor, but this smells more like
> > > > > a bug down in btrfs. Let me know if you need other info:
> > > 
> > > [ btrfs inode logging ]
> > > 
> > > > (cc'ing Liu Bo since we were discussing this earlier this week)
> > > > 
> > > > I can't reproduce this on stock v4.11, so I think this is a bug in my
> > > > series.
> > > > 
> > > > I think this is due to the differences in how errors are being reported
> > > > from filemap_fdatawait_range now causing some transactions to end up
> > > > being freed while they're still on the log_ctxs list. I'm working on
> > > > hunting down the problem now.
> > > > 
> > > > Sorry for the noise!
> > > > 
> > > 
> > > There's a list in the inode logging code that we consistently seem to 
> > > find list debugging assertions with.  We've fixed up all the known 
> > > issues, but I wouldn't be surprised if we've got a goto fail in there.
> > > 
> > > I'll take a look ;)
> > > 
> > 
> > Thanks. I'm running test 999 here in a loop to reproduce it on a kernel
> > with my patch series applied:
> > 
> > https://git.samba.org/?p=jlayton/xfstests.git;a=shortlog;h=refs/heads/wberr
> > 
> > The patch below seems to prevent it from crashing, but I'm not at all
> > sure that this is a correct fix. Still, I think that the way errors are
> > tracked within btrfs might need some rework around errseq_t's. In
> > principle, it could make things even simpler now that we don't need to
> > worry about resetting errors that have been cleared, etc...
> > 
> 
> This patch instead rolls up all of the btrfs changes in the earlier
> patches so it may make a bit more sense. I also tried to clean up the
> changelog. I think this is probably along the lines of what we want, but
> I'd want someone with more btrfs chops to scrutinize it closely:
> 
> -----------------------8<----------------------
> 
> [PATCH] SQUASH: btrfs: convert over to errseq_t based writeback error tracking
> 
> Writeback in btrfs is somewhat complicated and it tries to use
> filemap_* functions to drive it, while tracking errors with flags,
> alternate error fields, etc.
> 
> With the change to errseq_t based error reporting in the kernel, we
> can simplify this somewhat and ensure that errors are caught properly
> even when there are parallel operations on the same inode.
> 
> The btrfs_log_ctx has an io_err field in it that gets an error stored in
> it when there is an I/O error. Instead, sample the mapping's errseq_t
> when the context is initialized and use that to tell whether there has
> been a writeback error since that point.
> 
> Note that btrfs_sync_log passes in NULL for the inode when initializing
> the context, but that codepath doesn't seem to use the io_err field
> anyway.
>

Have you figured out why we hit that list_add_tail assertion?

> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/btrfs/file.c     | 17 ++++++-----------
>  fs/btrfs/tree-log.c | 24 ------------------------
>  fs/btrfs/tree-log.h |  7 +++++--
>  3 files changed, 11 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 520cb7230b2d..28ad03154452 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1959,9 +1959,10 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_log_ctx ctx;
> -	int ret = 0;
> +	int ret = 0, wb_ret;
>  	bool full_sync = 0;
>  	u64 len;
> +	errseq_t wb_since = READ_ONCE(file->f_wb_err);
>  
>  	/*
>  	 * The range length can be represented by u64, we have to do the typecasts
> @@ -2079,14 +2080,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  		 */
>  		clear_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
>  			  &BTRFS_I(inode)->runtime_flags);
> -		/*
> -		 * An ordered extent might have started before and completed
> -		 * already with io errors, in which case the inode was not
> -		 * updated and we end up here. So check the inode's mapping
> -		 * flags for any errors that might have happened while doing
> -		 * writeback of file data.
> -		 */
> -		ret = filemap_check_errors(inode->i_mapping);
> +		ret = filemap_check_wb_error(inode->i_mapping, wb_since);
>  		inode_unlock(inode);
>  		goto out;
>  	}
> @@ -2149,9 +2143,10 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	 * therefore we need to check for errors in the ordered operations,
>  	 * which are indicated by ctx.io_err.
>  	 */
> -	if (ctx.io_err) {
> +	wb_ret = filemap_check_wb_error(inode->i_mapping, ctx.since);

Now that we don't pass error via ctx.io_err, we could use %wb_since instead of
ctx.since because all we want is to catch any error since this fsync.  Then we
can remove ctx.since as the (!inode) case doesn't need it, either.

Others Look good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
> +	if (wb_ret) {
> +		ret = wb_ret;
>  		btrfs_end_transaction(trans);
> -		ret = ctx.io_err;
>  		goto out;
>  	}
>  
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index a59674c3e69e..da414e488c4b 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3972,12 +3972,6 @@ static int wait_ordered_extents(struct btrfs_trans_handle *trans,
>  			    test_bit(BTRFS_ORDERED_IOERR, &ordered->flags)));
>  
>  		if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags)) {
> -			/*
> -			 * Clear the AS_EIO/AS_ENOSPC flags from the inode's
> -			 * i_mapping flags, so that the next fsync won't get
> -			 * an outdated io error too.
> -			 */
> -			filemap_check_errors(inode->i_mapping);
>  			*ordered_io_error = true;
>  			break;
>  		}
> @@ -4085,11 +4079,6 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
>  	if (ret)
>  		return ret;
>  
> -	if (ordered_io_err) {
> -		ctx->io_err = -EIO;
> -		return 0;
> -	}
> -
>  	btrfs_init_map_token(&token);
>  
>  	ret = __btrfs_drop_extents(trans, log, &inode->vfs_inode, path, em->start,
> @@ -4204,19 +4193,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
>  
>  	list_sort(NULL, &extents, extent_cmp);
>  	btrfs_get_logged_extents(inode, logged_list, start, end);
> -	/*
> -	 * Some ordered extents started by fsync might have completed
> -	 * before we could collect them into the list logged_list, which
> -	 * means they're gone, not in our logged_list nor in the inode's
> -	 * ordered tree. We want the application/user space to know an
> -	 * error happened while attempting to persist file data so that
> -	 * it can take proper action. If such error happened, we leave
> -	 * without writing to the log tree and the fsync must report the
> -	 * file data write error and not commit the current transaction.
> -	 */
> -	ret = filemap_check_errors(inode->vfs_inode.i_mapping);
> -	if (ret)
> -		ctx->io_err = ret;
>  process:
>  	while (!list_empty(&extents)) {
>  		em = list_entry(extents.next, struct extent_map, list);
> diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
> index 483027f9a7f4..9d52046d4201 100644
> --- a/fs/btrfs/tree-log.h
> +++ b/fs/btrfs/tree-log.h
> @@ -28,7 +28,7 @@
>  struct btrfs_log_ctx {
>  	int log_ret;
>  	int log_transid;
> -	int io_err;
> +	errseq_t since; /* Check for writeback errors from this sample */
>  	bool log_new_dentries;
>  	struct inode *inode;
>  	struct list_head list;
> @@ -39,9 +39,12 @@ static inline void btrfs_init_log_ctx(struct btrfs_log_ctx *ctx,
>  {
>  	ctx->log_ret = 0;
>  	ctx->log_transid = 0;
> -	ctx->io_err = 0;
>  	ctx->log_new_dentries = false;
>  	ctx->inode = inode;
> +	if (inode)
> +		ctx->since = filemap_sample_wb_error(inode->i_mapping);
> +	else
> +		ctx->since = 0;
>  	INIT_LIST_HEAD(&ctx->list);
>  }
>  
> -- 
> 2.9.3
> 
