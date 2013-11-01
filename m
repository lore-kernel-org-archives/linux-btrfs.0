Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:12749 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab3KAHan (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Nov 2013 03:30:43 -0400
Message-ID: <527358A4.9060003@giantdisaster.de>
Date: Fri, 01 Nov 2013 08:30:44 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: check file extent type before anything else
References: <1383252643-6429-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1383252643-6429-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 31 Oct 2013 16:50:43 -0400, Josef Bacik wrote:
> I hit this problem with my no holes patch and it made me realize what the
> problem was for bz 60834.  If the first item in the leaf is an inline extent and
> we try to read anything starting from disk_bytenr onward we will read off the
> end of the leaf.  So we need to check to see what it's type is, and if it's not
> REG we can just break out.  This should fix this problem.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/backref.c |  1 +
>  fs/btrfs/send.c    | 10 +++++-----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 3775947..b763f10 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1051,6 +1051,7 @@ static int btrfs_find_all_leafs(struct btrfs_trans_handle *trans,
>  
>  	if (ret < 0 && ret != -ENOENT) {
>  		free_leaf_list(*leafs);
> +		ulist_free(*leafs);

An en passant fix for which problem?


>  		return ret;
>  	}
>  
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 8af536f..629cb9e 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3943,16 +3943,16 @@ static int is_extent_unchanged(struct send_ctx *sctx,
>  	while (key.offset < ekey->offset + left_len) {
>  		ei = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
>  		right_type = btrfs_file_extent_type(eb, ei);
> -		right_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
> -		right_len = btrfs_file_extent_num_bytes(eb, ei);
> -		right_offset = btrfs_file_extent_offset(eb, ei);
> -		right_gen = btrfs_file_extent_generation(eb, ei);
> -
>  		if (right_type != BTRFS_FILE_EXTENT_REG) {
>  			ret = 0;
>  			goto out;
>  		}
>  
> +		right_disknr = btrfs_file_extent_disk_bytenr(eb, ei);
> +		right_len = btrfs_file_extent_num_bytes(eb, ei);
> +		right_offset = btrfs_file_extent_offset(eb, ei);
> +		right_gen = btrfs_file_extent_generation(eb, ei);
> +
>  		/*
>  		 * Are we at extent 8? If yes, we know the extent is changed.
>  		 * This may only happen on the first iteration.
> 


