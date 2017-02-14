Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50967 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752968AbdBNJYq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 04:24:46 -0500
Subject: Re: [PATCH 7/7] nonblocking aio: btrfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org
References: <20170214024603.9563-1-rgoldwyn@suse.de>
 <20170214024603.9563-8-rgoldwyn@suse.de>
Cc: jack@suse.cz, linux-btrfs@vger.kernel.org
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c88c6498-40ad-fd8b-abd8-bc5599fc72d9@suse.com>
Date: Tue, 14 Feb 2017 11:24:42 +0200
MIME-Version: 1.0
In-Reply-To: <20170214024603.9563-8-rgoldwyn@suse.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.02.2017 04:46, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Return EAGAIN if any of the following checks fail
>  + i_rwsem is lockable
>  + NODATACOW or PREALLOC is set

perhaps you wanted to say "NODATACOW or PREALLOC is _not_ set"? See below



>  + Can nocow at the desired location
>  + Writing beyond end of file
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/file.c  | 25 ++++++++++++++++++++-----
>  fs/btrfs/inode.c |  3 +++
>  2 files changed, 23 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 3a14c87..f4dcc7a 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1804,12 +1804,29 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  	ssize_t num_written = 0;
>  	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
>  	ssize_t err;
> -	loff_t pos;
> -	size_t count;
> +	loff_t pos = iocb->ki_pos;
> +	size_t count = iov_iter_count(from);
>  	loff_t oldsize;
>  	int clean_page = 0;
>  
> -	inode_lock(inode);
> +	if ((iocb->ki_flags & IOCB_NONBLOCKING) &&
> +			(iocb->ki_flags & IOCB_DIRECT)) {
> +		/* Don't sleep on inode rwsem */
> +		if (!inode_trylock(inode))
> +			return -EAGAIN;
> +		/*
> +		 * We will allocate space in case nodatacow is not set,
> +		 * so bail
> +		 */
> +		if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> +					      BTRFS_INODE_PREALLOC)) ||

The first part of the condition will evaluate to true only when both
btrfs_inode_nodatacow and btrfs_inodeprealloc are not set. The code
contradicts your statement in the change log.

> +		    check_can_nocow(inode, pos, &count) <= 0) {
> +			inode_unlock(inode);
> +			return -EAGAIN;
> +		}
> +	} else
> +		inode_lock(inode);
> +
>  	err = generic_write_checks(iocb, from);
>  	if (err <= 0) {
>  		inode_unlock(inode);
> @@ -1843,8 +1860,6 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  	 */
>  	update_time_for_write(inode);
>  
> -	pos = iocb->ki_pos;
> -	count = iov_iter_count(from);
>  	start_pos = round_down(pos, root->sectorsize);
>  	oldsize = i_size_read(inode);
>  	if (start_pos > oldsize) {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index be4da91..9911ebd 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8690,6 +8690,9 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
>  		if (offset + count <= inode->i_size) {
>  			inode_unlock(inode);
>  			relock = true;
> +		} else if (iocb->ki_flags & IOCB_NONBLOCKING) {
> +			ret = -EAGAIN;
> +			goto out;
>  		}
>  		ret = btrfs_delalloc_reserve_space(inode, offset, count);
>  		if (ret)
> 
