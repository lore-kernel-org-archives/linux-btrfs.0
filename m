Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57245 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932387AbdLVIwO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 03:52:14 -0500
Subject: Re: [PATCH 08/10] Btrfs: add WARN_ONCE to detect unexpected error
 from merge_extent_mapping
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171221224256.18196-1-bo.li.liu@oracle.com>
 <20171221224256.18196-9-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <3fffd583-010a-8b84-3f93-e0a940eeb75e@suse.com>
Date: Fri, 22 Dec 2017 10:52:11 +0200
MIME-Version: 1.0
In-Reply-To: <20171221224256.18196-9-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.12.2017 00:42, Liu Bo wrote:
> This is a subtle case, so in order to understand the problem, it'd be good to
> know the content of existing and em when any error occurs.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/extent_map.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index d386cfb..a8b7e24 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -550,17 +550,23 @@ int btrfs_add_extent_mapping(struct extent_map_tree *em_tree,
>  			*em_in = existing;
>  			ret = 0;
>  		} else {
> +			u64 orig_start = em->start;
> +			u64 orig_len = em->len;
> +
>  			/*
>  			 * The existing extent map is the one nearest to
>  			 * the [start, start + len) range which overlaps
>  			 */
>  			ret = merge_extent_mapping(em_tree, existing,
>  						   em, start, len);
> -			free_extent_map(existing);
>  			if (ret) {
>  				free_extent_map(em);
>  				*em_in = NULL;
> +				WARN_ONCE(ret, KERN_INFO "Unexpected error %d: merge existing(start %llu len %llu) with em(start %llu len %llu)\n",

I think this KERN_INFO is spurious and should be removed?

> +					  ret, existing->start, existing->len,
> +					  orig_start, orig_len);
>  			}
> +			free_extent_map(existing);
>  		}
>  	}
>  
> 
