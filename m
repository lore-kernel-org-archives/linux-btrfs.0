Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50181 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751888AbeEQPsv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 11:48:51 -0400
Subject: Re: [PATCH v2] btrfs: use kvzalloc for EXTENT_SAME temporary data
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: fdmanana@gmail.com, nefelim4ag@gmail.com
References: <20180517154110.29362-1-dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <8a301366-871b-4bc2-dadb-724d9037ad57@suse.com>
Date: Thu, 17 May 2018 18:48:49 +0300
MIME-Version: 1.0
In-Reply-To: <20180517154110.29362-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.05.2018 18:41, David Sterba wrote:
> The dedupe range is 16 MiB, with 4 KiB pages and 8 byte pointers, the
> arrays can be 32KiB large. To avoid allocation failures due to
> fragmented memory, use the allocation with fallback to vmalloc.
> 
> The arrays are allocated and freed only inside btrfs_extent_same and
> reused for all the ranges.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

LGTM:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Based on git://github.com/kdave/btrfs-devel.git ext/timofey/dedupe-16mb-limit
> 
> v2:
> - use kvmalloc_array
> - use __GFP_ZERO, as there's no kvzalloc_array
> - check that there are no other frees missed,
>   see https://patchwork.kernel.org/patch/10374941/ for reference
> 
>  fs/btrfs/ioctl.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b572e38b4b64..20751829104d 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3178,12 +3178,13 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>  	 * locking. We use an array for the page pointers. Size of the array is
>  	 * bounded by len, which is in turn bounded by BTRFS_MAX_DEDUPE_LEN.
>  	 */
> -	cmp.src_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> -	cmp.dst_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
> +	cmp.src_pages = kvmalloc_array(num_pages, sizeof(struct page *),
> +				       GFP_KERNEL | __GFP_ZERO);
> +	cmp.dst_pages = kvmalloc_array(num_pages, sizeof(struct page *),
> +				       GFP_KERNEL | __GFP_ZERO);
>  	if (!cmp.src_pages || !cmp.dst_pages) {
> -		kfree(cmp.src_pages);
> -		kfree(cmp.dst_pages);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto out_free;
>  	}
>  
>  	if (same_inode)
> @@ -3211,8 +3212,9 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>  	else
>  		btrfs_double_inode_unlock(src, dst);
>  
> -	kfree(cmp.src_pages);
> -	kfree(cmp.dst_pages);
> +out_free:
> +	kvfree(cmp.src_pages);
> +	kvfree(cmp.dst_pages);
>  
>  	return ret;
>  }
> 
