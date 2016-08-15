Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36447 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbcHOGdZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 02:33:25 -0400
Received: by mail-pa0-f43.google.com with SMTP id pp5so13976610pac.3
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Aug 2016 23:33:25 -0700 (PDT)
Date: Sun, 14 Aug 2016 23:33:23 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Harinath Nampally <harinath922@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] code cleanup
Message-ID: <20160815063323.GA19212@vader>
References: <1471205491-27411-1-git-send-email-harinath922@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1471205491-27411-1-git-send-email-harinath922@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 14, 2016 at 04:11:31PM -0400, Harinath Nampally wrote:
> This patch checks ret value and jumps to clean up in case of
>  btrs_add_systme_chunk call fails
> 
> Signed-off-by: Harinath Nampally <harinath922@gmail.com>
> ---
>  fs/btrfs/volumes.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 366b335..fedb301 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4880,12 +4880,15 @@ int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
>  
>  	ret = btrfs_insert_item(trans, chunk_root, &key, chunk, item_size);
>  	if (ret == 0 && map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
> -		/*
> -		 * TODO: Cleanup of inserted chunk root in case of
> -		 * failure.
> -		 */
>  		ret = btrfs_add_system_chunk(chunk_root, &key, chunk,
>  					     item_size);
> +		if (ret) {
> +			/*
> +			 * Cleanup of inserted chunk root in case of
> +			 * failure.
> +			 */
> +			goto out;
> +		}
>  	}
>  
>  out:

NAK. This patch doesn't do anything. That's just jumping to the exact
same location that we were previously returning to anyways.

-- 
Omar
