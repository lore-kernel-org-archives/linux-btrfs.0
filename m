Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:46131 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab2ILKhn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 06:37:43 -0400
Message-ID: <505065FB.4040200@giantdisaster.de>
Date: Wed, 12 Sep 2012 12:37:47 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: cleanup of error processing in btree_get_extent()
References: <201209120826.AA00007@FM-323941448.jp.fujitsu.com>
In-Reply-To: <201209120826.AA00007@FM-323941448.jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 12 Sep 2012 17:26:43 +0900, Tsutomu Itoh wrote:
> This patch simplifies a little complex error processing in
> btree_get_extent().
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>  fs/btrfs/disk-io.c |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 29c69e6..27d0ebe 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -222,21 +222,17 @@ static struct extent_map *btree_get_extent(struct inode *inode,
>  
>  		free_extent_map(em);
>  		em = lookup_extent_mapping(em_tree, start, len);
> -		if (em) {
> -			ret = 0;
> -		} else {
> -			em = lookup_extent_mapping(em_tree, failed_start,
> -						   failed_len);
> -			ret = -EIO;
> +		if (!em) {
> +			lookup_extent_mapping(em_tree, failed_start,
> +					      failed_len);
> +			em = ERR_PTR(-EIO);

The patch itself looks good and doesn't change the behavior while it
simplifies the code. But I think that it identifies an old error in the
code. It is eye-catching the the return value of lookup_extent_mapping()
is not used. Therefore the call can either be removed or it has
side-effects which are required. lookup_extent_mapping() has the
side-effect to increment the extent map's ref count that it returns. I
cannot believe that this incremented ref count is correct when the
extent map itself is not used. IMO, either the EIO and ignoring the
returned extent map is wrong, or the incremented ref count is wrong.

>  		}
>  	} else if (ret) {
>  		free_extent_map(em);
> -		em = NULL;
> +		em = ERR_PTR(ret);
>  	}
>  	write_unlock(&em_tree->lock);
>  
> -	if (ret)
> -		em = ERR_PTR(ret);
>  out:
>  	return em;
>  }

