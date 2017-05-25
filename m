Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36795 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755850AbdEYV1Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 17:27:25 -0400
Received: by mail-pf0-f173.google.com with SMTP id m17so178261450pfg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 May 2017 14:27:24 -0700 (PDT)
Date: Thu, 25 May 2017 14:27:21 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Vinnie Magro <vmagro@fb.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: Use kvzalloc instead of kzalloc/vmalloc in
 alloc_bitmap
Message-ID: <20170525212721.GA12994@vader>
References: <e507b0e6417e11e7a0df0002c95209d8-1f3c8f0@d8a20777635a6c1f43e7500017a6a474ea839660ad72b5b09d455997e9681205>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e507b0e6417e11e7a0df0002c95209d8-1f3c8f0@d8a20777635a6c1f43e7500017a6a474ea839660ad72b5b09d455997e9681205>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 12:18:02PM -0700, Vinnie Magro wrote:
> Replace alloc_bitmap with call to kvzalloc. kvzalloc preserves the
> same fallback heuristic.

Looks good, thanks.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Vinnie Magro <vmagro@fb.com>
> ---
>  fs/btrfs/free-space-tree.c | 23 ++---------------------
>  1 file changed, 2 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
> index fc0bd84..9e87129 100644
> --- a/fs/btrfs/free-space-tree.c
> +++ b/fs/btrfs/free-space-tree.c
> @@ -151,25 +151,6 @@ static inline u32 free_space_bitmap_size(u64 size, u32 sectorsize)
>  	return DIV_ROUND_UP((u32)div_u64(size, sectorsize), BITS_PER_BYTE);
>  }
>  
> -static u8 *alloc_bitmap(u32 bitmap_size)
> -{
> -	void *mem;
> -
> -	/*
> -	 * The allocation size varies, observed numbers were < 4K up to 16K.
> -	 * Using vmalloc unconditionally would be too heavy, we'll try
> -	 * contiguous allocations first.
> -	 */
> -	if  (bitmap_size <= PAGE_SIZE)
> -		return kzalloc(bitmap_size, GFP_NOFS);
> -
> -	mem = kzalloc(bitmap_size, GFP_NOFS | __GFP_NOWARN);
> -	if (mem)
> -		return mem;
> -
> -	return __vmalloc(bitmap_size, GFP_NOFS | __GFP_ZERO, PAGE_KERNEL);
> -}
> -
>  int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
>  				  struct btrfs_fs_info *fs_info,
>  				  struct btrfs_block_group_cache *block_group,
> @@ -189,7 +170,7 @@ int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
>  
>  	bitmap_size = free_space_bitmap_size(block_group->key.offset,
>  					     fs_info->sectorsize);
> -	bitmap = alloc_bitmap(bitmap_size);
> +	bitmap = kvzalloc(bitmap_size, GFP_NOFS);
>  	if (!bitmap) {
>  		ret = -ENOMEM;
>  		goto out;
> @@ -330,7 +311,7 @@ int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
>  
>  	bitmap_size = free_space_bitmap_size(block_group->key.offset,
>  					     fs_info->sectorsize);
> -	bitmap = alloc_bitmap(bitmap_size);
> +	bitmap = kvzalloc(bitmap_size, GFP_NOFS);
>  	if (!bitmap) {
>  		ret = -ENOMEM;
>  		goto out;
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
