Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60946 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752719AbdGLO4t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 10:56:49 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5790FABD9
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jul 2017 14:56:48 +0000 (UTC)
Date: Wed, 12 Jul 2017 16:55:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: Remove redundant code
Message-ID: <20170712145535.GE2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1499841135-18251-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1499841135-18251-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 09:32:15AM +0300, Nikolay Borisov wrote:
> insert_into_bitmap has only one caller which always allocates the info struct
> passed. As such remove the any NULL checks for info and also remove code
> to allocate info in case it was NULL.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/free-space-cache.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index c5e6180cdb8c..fd24fb99d6dc 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -2101,7 +2101,7 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
>  		goto again;
>  
>  new_bitmap:
> -	if (info && info->bitmap) {
> +	if (info->bitmap) {
>  		add_new_bitmap(ctl, info, offset);
>  		added = 1;
>  		info = NULL;

What if we reach this point, go back to label "again:", come back to
this check again, then info would be NULL and dereferencing info->bitmap
would crash. Then the below code is still required.

> @@ -2109,17 +2109,6 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
>  	} else {
>  		spin_unlock(&ctl->tree_lock);
>  
> -		/* no pre-allocated info, allocate a new one */
> -		if (!info) {
> -			info = kmem_cache_zalloc(btrfs_free_space_cachep,
> -						 GFP_NOFS);
> -			if (!info) {
> -				spin_lock(&ctl->tree_lock);
> -				ret = -ENOMEM;
> -				goto out;
> -			}
> -		}
> -
>  		/* allocate the bitmap */
>  		info->bitmap = kzalloc(PAGE_SIZE, GFP_NOFS);
>  		spin_lock(&ctl->tree_lock);
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
