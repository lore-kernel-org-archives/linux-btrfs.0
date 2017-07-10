Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45418 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754601AbdGJXD7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Jul 2017 19:03:59 -0400
Date: Mon, 10 Jul 2017 16:00:10 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        markus@trippelsdorf.de, linux-kernel@vger.kernel.org, axboe@kernel.dk,
        dsterba@suse.com, marc.c.dionne@gmail.com,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH v2] btrfs: Correct assignment of pos
Message-ID: <20170710230010.GC20647@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170705033307.8213-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170705033307.8213-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 04, 2017 at 10:33:07PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Assigning pos for usage early messes up in append mode, where
> the pos is re-assigned in generic_write_checks(). Assign
> pos later to get the correct position to write from iocb->ki_pos.
> 
> Since check_can_nocow also uses the value of pos, we shift
> generic_write_checks() before check_can_nocow(). Checks with
> IOCB_DIRECT are present in generic_write_checks(), so checking
> for IOCB_NOWAIT is enough.
> 
> Also, put locking sequence in the fast path.
> 
> Changes since v1:
>  - Moved pos higher up to encompass check_can_nocow() call.
> 
> Fixes: edf064e7c6fe ("btrfs: nowait aio support")
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/file.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 59e2dccdf75b..ad53832838b5 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1875,16 +1875,25 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  	ssize_t num_written = 0;
>  	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
>  	ssize_t err;
> -	loff_t pos = iocb->ki_pos;
> +	loff_t pos;
>  	size_t count = iov_iter_count(from);
>  	loff_t oldsize;
>  	int clean_page = 0;
>  
> -	if ((iocb->ki_flags & IOCB_NOWAIT) &&
> -			(iocb->ki_flags & IOCB_DIRECT)) {
> -		/* Don't sleep on inode rwsem */
> -		if (!inode_trylock(inode))
> +	if (!inode_trylock(inode)) {
> +		if (iocb->ki_flags & IOCB_NOWAIT)
>  			return -EAGAIN;
> +		inode_lock(inode);
> +	}
> +
> +	err = generic_write_checks(iocb, from);
> +	if (err <= 0) {
> +		inode_unlock(inode);
> +		return err;
> +	}
> +
> +	pos = iocb->ki_pos;
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
>  		/*
>  		 * We will allocate space in case nodatacow is not set,
>  		 * so bail
> @@ -1895,13 +1904,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  			inode_unlock(inode);
>  			return -EAGAIN;
>  		}
> -	} else
> -		inode_lock(inode);
> -
> -	err = generic_write_checks(iocb, from);
> -	if (err <= 0) {
> -		inode_unlock(inode);
> -		return err;
>  	}
>  
>  	current->backing_dev_info = inode_to_bdi(inode);

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo
