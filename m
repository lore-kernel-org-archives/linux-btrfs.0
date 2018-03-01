Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:44982 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033543AbeCARrb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Mar 2018 12:47:31 -0500
Received: by mail-wr0-f194.google.com with SMTP id v65so7448576wrc.11
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Mar 2018 09:47:31 -0800 (PST)
Subject: Re: [PATCH 1/4] btrfs-progs: Limit inline extent below page size
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, peteryuchuang@gmail.com
References: <20180301024747.26192-1-wqu@suse.com>
 <20180301024747.26192-2-wqu@suse.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <0e1c383c-6d5b-d592-796a-ec78eef3713c@gmail.com>
Date: Thu, 1 Mar 2018 19:47:27 +0200
MIME-Version: 1.0
In-Reply-To: <20180301024747.26192-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  1.03.2018 04:47, Qu Wenruo wrote:
> Kernel doesn't support to drop extent inside an inlined extent.
> And kernel tends to limit inline extent just below sectorsize, so also
> limit it in btrfs-progs.
> 
> This fixes unexpected -EOPNOTSUPP error from __btrfs_drop_extents() on
> converted btrfs.
> 
> Fixes: 806528b8755f ("Add Yan Zheng's ext3->btrfs conversion program")
> Reported-by: Peter Y. Chuang <peteryuchuang@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  ctree.h | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/ctree.h b/ctree.h
> index 17cdac76c58c..0282deef339b 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -20,6 +20,7 @@
>  #define __BTRFS_CTREE_H__
>  
>  #include <stdbool.h>
> +#include "internal.h"
>  
>  #if BTRFS_FLAT_INCLUDES
>  #include "list.h"
> @@ -1195,8 +1196,14 @@ static inline u32 BTRFS_NODEPTRS_PER_BLOCK(const struct btrfs_fs_info *info)
>  	(offsetof(struct btrfs_file_extent_item, disk_bytenr))
>  static inline u32 BTRFS_MAX_INLINE_DATA_SIZE(const struct btrfs_fs_info *info)
>  {
> -	return BTRFS_MAX_ITEM_SIZE(info) -
> -		BTRFS_FILE_EXTENT_INLINE_DATA_START;
> +	/*
> +	 * Inline extent larger than pagesize could lead to kernel unexpected
> +	 * error when dropping extents, so we need to limit the inline extent
> +	 * size to less than sectorsize.
> +	 */
> +	return min_t(u32, info->sectorsize - 1,
> +		     BTRFS_MAX_ITEM_SIZE(info) -
> +		     BTRFS_FILE_EXTENT_INLINE_DATA_START);
>  }

Isn't the same change required in the kernel as well ?

>  
>  static inline u32 BTRFS_MAX_XATTR_SIZE(const struct btrfs_fs_info *info)
> 
