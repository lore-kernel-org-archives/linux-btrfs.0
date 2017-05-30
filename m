Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:32988 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbdE3UvA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 May 2017 16:51:00 -0400
Received: by mail-pf0-f173.google.com with SMTP id e193so82702041pfh.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 May 2017 13:51:00 -0700 (PDT)
Date: Tue, 30 May 2017 13:50:57 -0700
From: Omar Sandoval <osandov@osandov.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix invalid extent maps due to hole punching
Message-ID: <20170530205057.GA11921@vader.DHCP.thefacebook.com>
References: <20170528163153.31962-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170528163153.31962-1-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 28, 2017 at 05:31:53PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>

[snip]

Hey, Filipe,

I saw this warning and tried to apply your patch, but it doesn't apply
cleanly (seems to conflict with 9986277e0e4c ("Btrfs: handle only
applicable errors returned by btrfs_get_extent")).

> Fixes: d77815461f04 ("btrfs: Avoid trucating page or punching hole in a already existed hole.")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/file.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index f7d022bc7998..2645d820422c 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2390,10 +2390,12 @@ static int fill_holes(struct btrfs_trans_handle *trans,
>   */
>  static int find_first_non_hole(struct inode *inode, u64 *start, u64 *len)
>  {
> +	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>  	struct extent_map *em;
>  	int ret = 0;
>  
> -	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, *start, *len, 0);
> +	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, *start,
> +			      round_up(*len, fs_info->sectorsize), 0);
>  	if (IS_ERR_OR_NULL(em)) {
>  		if (!em)
>  			ret = -ENOMEM;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
