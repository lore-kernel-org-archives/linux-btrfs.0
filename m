Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60038 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752259AbdLFQEF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Dec 2017 11:04:05 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D6F21AEB0
        for <linux-btrfs@vger.kernel.org>; Wed,  6 Dec 2017 16:04:03 +0000 (UTC)
Date: Wed, 6 Dec 2017 17:02:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] btrfs: Remove redundant NULL check
Message-ID: <20171206160205.GC3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
 <1512119984-12708-5-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1512119984-12708-5-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 01, 2017 at 11:19:43AM +0200, Nikolay Borisov wrote:
> Before returning hole_em in btrfs_get_fiemap_extent we check if it's different
> than null. However, by the time this null check is triggered we already know
> hole_em is not null because it means it points to the em we found and it
> has already been dereferenced.

Well, ok The whole function could use some cleanups and reordering,
it's hard to track all the variable changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/inode.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 92d140b06271..9e0473c883ce 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7300,9 +7300,8 @@ struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
>  			em->block_start = EXTENT_MAP_DELALLOC;
>  			em->block_len = found;
>  		}
> -	} else if (hole_em) {
> +	} else
>  		return hole_em;

The { } should stay. I'll fix it.

> -	}
>  out:
>  
>  	free_extent_map(hole_em);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
