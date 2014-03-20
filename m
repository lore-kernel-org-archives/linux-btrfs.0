Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49093 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaCTDOg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 23:14:36 -0400
Date: Thu, 20 Mar 2014 11:14:22 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove unnecessary inode generation lookup in send
Message-ID: <20140320031421.GC1792@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1395165366-24715-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1395165366-24715-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 18, 2014 at 05:56:06PM +0000, Filipe David Borba Manana wrote:
> No need to search in the send tree for the generation number of the inode,
> we already have it in the recorded_ref structure passed to us.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo

> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/send.c |    9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 5d757ee..db4b10c 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -3179,7 +3179,7 @@ static int wait_for_parent_move(struct send_ctx *sctx,
>  	int ret;
>  	u64 ino = parent_ref->dir;
>  	u64 parent_ino_before, parent_ino_after;
> -	u64 new_gen, old_gen;
> +	u64 old_gen;
>  	struct fs_path *path_before = NULL;
>  	struct fs_path *path_after = NULL;
>  	int len1, len2;
> @@ -3198,12 +3198,7 @@ static int wait_for_parent_move(struct send_ctx *sctx,
>  	else if (ret < 0)
>  		return ret;
>  
> -	ret = get_inode_info(sctx->send_root, ino, NULL, &new_gen,
> -			     NULL, NULL, NULL, NULL);
> -	if (ret < 0)
> -		return ret;
> -
> -	if (new_gen != old_gen)
> +	if (parent_ref->dir_gen != old_gen)
>  		return 0;
>  
>  	path_before = fs_path_alloc();
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
