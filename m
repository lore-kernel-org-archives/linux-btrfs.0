Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60290 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752901AbdGLOvO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 10:51:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2123BAD42
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jul 2017 14:51:13 +0000 (UTC)
Date: Wed, 12 Jul 2017 16:50:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove never reached code
Message-ID: <20170712145000.GD2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1499840038-16089-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1499840038-16089-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The subject is too generic, and the changelog could say something about
the btrfs_panic semantics. Otherwise the change is ok, previously there
was just BUG_ON, then if -> btrfs_panic and after moving the kfree after
the print, the return has been added, but this is just redundant.

On Wed, Jul 12, 2017 at 09:13:58AM +0300, Nikolay Borisov wrote:
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/relocation.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 65661d1aae4e..1a532bb72eab 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1308,8 +1308,6 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
>  		btrfs_panic(fs_info, -EEXIST,
>  			    "Duplicate root found for start=%llu while inserting into relocation tree",
>  			    node->bytenr);
> -		kfree(node);
> -		return -EEXIST;
>  	}
>  
>  	list_add_tail(&root->root_list, &rc->reloc_roots);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
