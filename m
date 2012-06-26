Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:52926 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab2FZN1G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 09:27:06 -0400
Date: Tue, 26 Jun 2012 15:26:53 +0200
From: David Sterba <dave@jikos.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: [PATCH] Btrfs: check return value of btrfs_set_extent_delalloc()
Message-ID: <20120626132653.GS28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <201206260322.AA00002@FM-323941448.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201206260322.AA00002@FM-323941448.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 12:22:10PM +0900, Tsutomu Itoh wrote:
> btrfs_set_extent_delalloc() has the possibility of returning the error.
> So I add the code in which the return value of btrfs_set_extent_delalloc()
> is checked.

The caller is cluster_pages_for_defrag, the only error I see returned
via __set_extent_bit is -EEXIST, other errors BUG directly or via
extent_io_tree_panic() .

If the error happens, then the [page_start,page_end-1] is already set
for delalloc, that's probably a bug and should be caught.

There are two more unchecked calls to btrfs_set_extent_delalloc:

inode.c:btrfs_writepage_fixup_worker

1729         btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
1730         ClearPageChecked(page);
1731         set_page_dirty(page);

IIRC from the days full of fixup worker fun, the reason why this is safe
to ignore is because the call chain leading here is exactly due to missing
delalloc bits on the page.

relocation.c:relocate_file_extent_cluster

3034                 btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
3035                 set_page_dirty(page);

hmm relocation ... :)


Anyway, I'd like to let Josef take another look at your patch.

> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 0e92e57..95e27d6 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1016,13 +1016,16 @@ again:
>  	}
>  
>  
> -	btrfs_set_extent_delalloc(inode, page_start, page_end - 1,
> -				  &cached_state);
> +	ret = btrfs_set_extent_delalloc(inode, page_start, page_end - 1,
> +					&cached_state);
>  
>  	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
>  			     page_start, page_end - 1, &cached_state,
>  			     GFP_NOFS);
>  
> +	if (ret)
> +		goto out;
> +
>  	for (i = 0; i < i_done; i++) {
>  		clear_page_dirty_for_io(pages[i]);
>  		ClearPageChecked(pages[i]);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
