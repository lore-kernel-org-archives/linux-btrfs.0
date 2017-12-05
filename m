Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56161 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752833AbdLESEq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 13:04:46 -0500
Date: Tue, 5 Dec 2017 19:02:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: Handle btrfs_set_extent_delalloc failure
Message-ID: <20171205180246.GN3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512458959-20473-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512458959-20473-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 05, 2017 at 09:29:19AM +0200, Nikolay Borisov wrote:
> This function was introduced by 247e743cbe6e ("Btrfs: Use async helpers to deal
> with pages that have been improperly dirtied") and it didn't do any error
> handling then. This function might very well fail in ENOMEM situation, yet
> it's not handled, this could lead to inconsistent state. So let's handle the
> failure by setting the mapping error bit.

In current code the ENOMEM cannot happen (returned by __set_extent_bit),
but EEXIST could, so there's a possibility of an unhandled error.

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/btrfs/inode.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 993061f83067..7a5a46fefdb4 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2098,8 +2098,15 @@ static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
>  		goto out;
>  	 }
>  
> -	btrfs_set_extent_delalloc(inode, page_start, page_end, 0, &cached_state,
> -				  0);
> +	ret = btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
> +					&cached_state, 0);
> +	if (ret) {
> +		mapping_set_error(page->mapping, ret);
> +		end_extent_writepage(page, ret, page_start, page_end);
> +		ClearPageChecked(page);

So this repeats the cleanup code after the preceding call to
btrfs_delalloc_reserve_space fails, I don't see a better way how to get
out of that so it's probably ok.
