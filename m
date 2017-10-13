Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52822 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758036AbdJMNZH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 09:25:07 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3149DAAC5
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 13:25:06 +0000 (UTC)
Date: Fri, 13 Oct 2017 15:23:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs: cleanup extent locking sequence
Message-ID: <20171013132321.GN3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171011022641.21202-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171011022641.21202-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 10, 2017 at 09:26:41PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Code cleanup for better understanding:
> needs_unlock to be called extent_locked to show state as opposed to
> action.
> Changed the variable to int, to reduce code in the critical path(code usually
> executed).
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/file.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f6c6754cf52d..a3d006d14683 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1590,7 +1590,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  	int ret = 0;
>  	bool only_release_metadata = false;
>  	bool force_page_uptodate = false;
> -	bool need_unlock;
> +	int extents_locked;

The variable can be moved to the while() { } block

>  
>  	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
>  			PAGE_SIZE / (sizeof(struct page *)));
> @@ -1670,7 +1670,6 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  		}
>  
>  		release_bytes = reserve_bytes;
> -		need_unlock = false;
>  again:
>  		/*
>  		 * This is going to setup the pages array with the number of
> @@ -1683,16 +1682,15 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
>  		if (ret)
>  			break;
>  
> -		ret = lock_and_cleanup_extent_if_need(BTRFS_I(inode), pages,
> +		extents_locked = lock_and_cleanup_extent_if_need(
> +				BTRFS_I(inode), pages,
>  				num_pages, pos, write_bytes, &lockstart,
>  				&lockend, &cached_state);
> -		if (ret < 0) {
> +		if (extents_locked < 0) {
>  			if (ret == -EAGAIN)

either

		if (extents_locked == -EAGAIN)

or

		move 'ret = extents_locked' above the if.

>  				goto again;
> +			ret = extents_locked;
>  			break;
> -		} else if (ret > 0) {
> -			need_unlock = true;
> -			ret = 0;
>  		}
