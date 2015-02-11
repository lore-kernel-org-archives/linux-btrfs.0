Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:49174
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbbBKJeP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 04:34:15 -0500
Date: Wed, 11 Feb 2015 10:34:07 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Bas Peters <baspeters93@gmail.com>
cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] fs: btrfs: free-space-cache.c: remove two unnecessary
 checks before calling kfree()
In-Reply-To: <1423646233-16637-1-git-send-email-baspeters93@gmail.com>
Message-ID: <alpine.DEB.2.10.1502111033450.2356@hadrien>
References: <1423646233-16637-1-git-send-email-baspeters93@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, 11 Feb 2015, Bas Peters wrote:

> kfree checks whether the pointer it is passed is NULL. The two foregoing
> checks are therefore unnecessary.
>
> This issue was detected using Coccinelle.
>
> Signed-off-by: Bas Peters <baspeters93@gmail.com>
> ---
>  fs/btrfs/free-space-cache.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index d6c03f7..7d2d817 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1976,8 +1976,7 @@ new_bitmap:
>
>  out:
>  	if (info) {
> -		if (info->bitmap)
> -			kfree(info->bitmap);
> +		kfree(info->bitmap);
>  		kmem_cache_free(btrfs_free_space_cachep, info);
>  	}
>
> @@ -3427,8 +3426,7 @@ again:
>
>  	if (info)
>  		kmem_cache_free(btrfs_free_space_cachep, info);
> -	if (map)
> -		kfree(map);
> +	kfree(map);

A certain lack of parallelism arises in the latter case.

julia

>  	return 0;
>  }
>
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
