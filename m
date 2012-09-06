Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:41489 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab2IFKTg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:19:36 -0400
Date: Thu, 6 Sep 2012 12:19:30 +0200
From: David Sterba <dave@jikos.cz>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: remove unnecessary -ENOMEM BUG_ON check in
 extent-tree.c/btrfs_alloc_logged_file_extent
Message-ID: <20120906101930.GP17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5048457E.6050002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5048457E.6050002@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2012 at 02:41:02PM +0800, Wang Sheng-Hui wrote:
> The memory allocation failure is BUG_ON in add_excluded_extent
> (following the code path). No need to BUG_ON -ENOMEM inside
> btrfs_alloc_logged_file_extent.

This indirectly calls __set_extent_bit that does BUG_ON on memory
allocation failures. This type of error condition is hard to fix, as it
usually needs to do non-trivial cleanups in the function before
returning -ENOMEM, so the easiset way to "handle" it is to do BUG_ON and
then separately deal with it in another patch (so it does not mix with
the original patch).

Your patches remove (from my POV) useful marks that we have an error
condition to handle, not to hide it.

So, NAK from me for anything that looks like this. I'm of course glad to
look at patches that replace the BUG_ON with proper error handling :)


david

> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/btrfs/extent-tree.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 95492cc..9b9a6fa 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6207,8 +6207,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
>  		mutex_lock(&caching_ctl->mutex);
>  
>  		if (start >= caching_ctl->progress) {
> -			ret = add_excluded_extent(root, start, num_bytes);
> -			BUG_ON(ret); /* -ENOMEM */
> +			add_excluded_extent(root, start, num_bytes);

>  		} else if (start + num_bytes <= caching_ctl->progress) {
>  			ret = btrfs_remove_free_space(block_group,
>  						      start, num_bytes);
> @@ -6222,8 +6221,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
>  			start = caching_ctl->progress;
>  			num_bytes = ins->objectid + ins->offset -
>  				    caching_ctl->progress;
> -			ret = add_excluded_extent(root, start, num_bytes);
> -			BUG_ON(ret); /* -ENOMEM */
> +			add_excluded_extent(root, start, num_bytes);
>  		}
>  
>  		mutex_unlock(&caching_ctl->mutex);
