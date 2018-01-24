Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932618AbeAXJkr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 04:40:47 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3A0C8AE60
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jan 2018 09:40:46 +0000 (UTC)
Subject: Re: [PATCH 1/2] btrfs-progs: mkfs: Fix minimal device size
 calculation for new temporary chunk layout
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180124023830.26184-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <61695dbe-d1f4-f2b2-0afc-df118c9547db@suse.com>
Date: Wed, 24 Jan 2018 11:40:45 +0200
MIME-Version: 1.0
In-Reply-To: <20180124023830.26184-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.01.2018 04:38, Qu Wenruo wrote:
> Commit 0b2161becf8e ("btrfs-progs: mkfs: Prevent temporary system chunk
> to use space in reserved 1M range") changed the hard-coded temporary
> chunk layout to avoid the first 1M.
> 
> However this also affects btrfs_min_dev_size() which still assume
> temporary chunks starts at device offset 0.
> 
> This patch will fix it.
> 
> Fixes: 0b2161becf8e ("btrfs-progs: mkfs: Prevent temporary system chunk
> to use space in reserved 1M range")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  mkfs/common.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/common.c b/mkfs/common.c
> index 5c5e9c3b9e01..8e85942ef4eb 100644
> --- a/mkfs/common.c
> +++ b/mkfs/common.c
> @@ -483,6 +483,8 @@ u64 btrfs_min_dev_size(u32 nodesize, int mixed, u64 meta_profile,
>  
>  	/*
>  	 * Minimal size calculation is complex due to several factors:
> +	 * 0) Reserved 1M range.
> +	 *
>  	 * 1) Temporary chunk reuse
>  	 *    If specified chunk profile is SINGLE, we can reuse
>  	 *    temporary chunks, no need to allocate new chunks.
> @@ -501,7 +503,8 @@ u64 btrfs_min_dev_size(u32 nodesize, int mixed, u64 meta_profile,
>  	 * The latter two are all 8M, accroding to @calc_size of
>  	 * btrfs_alloc_chunk().
>  	 */
> -	reserved += BTRFS_MKFS_SYSTEM_GROUP_SIZE + SZ_8M * 2;
> +	reserved += BTRFS_BLOCK_RESERVED_1M_FOR_SUPER +
> +		    BTRFS_MKFS_SYSTEM_GROUP_SIZE + SZ_8M * 2;
>  
>  	/*
>  	 * For real chunks, we need to select different sizes:
> 
