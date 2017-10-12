Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:48797 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755110AbdJLVn3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 17:43:29 -0400
Received: by mail-pf0-f171.google.com with SMTP id b79so6784890pfk.5
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 14:43:29 -0700 (PDT)
Date: Thu, 12 Oct 2017 14:43:27 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Christos Gkekas <chris.gekas@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Clean up unused variables in free-space-tree.c
Message-ID: <20171012214327.GA16154@vader.DHCP.thefacebook.com>
References: <1507844442-26013-1-git-send-email-chris.gekas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1507844442-26013-1-git-send-email-chris.gekas@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 12, 2017 at 10:40:42PM +0100, Christos Gkekas wrote:
> Remove variables 'start' and 'end', which are set but never used.

Oops.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
> ---
>  fs/btrfs/free-space-tree.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index 684f122..fe5e032 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -1286,12 +1286,8 @@ static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
>  					struct btrfs_block_group_cache *block_group,
>  					struct btrfs_path *path)
>  {
> -	u64 start, end;
>  	int ret;
>  
> -	start = block_group->key.objectid;
> -	end = block_group->key.objectid + block_group->key.offset;
> -
>  	block_group->needs_free_space = 0;
>  
>  	ret = add_new_free_space_info(trans, fs_info, block_group, path);
> -- 
> 2.7.4
> 
