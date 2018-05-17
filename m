Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752303AbeEQHtC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 May 2018 03:49:02 -0400
Subject: Re: [PATCH 1/4] btrfs: compression: Add linux/sizes.h for
 compression.h
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: jamespharvey20@gmail.com
References: <20180517062753.25973-1-wqu@suse.com>
 <20180517062753.25973-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a32450c0-9aa7-a568-e39a-250fdf8a1316@suse.com>
Date: Thu, 17 May 2018 10:49:00 +0300
MIME-Version: 1.0
In-Reply-To: <20180517062753.25973-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.05.2018 09:27, Qu Wenruo wrote:
> Since compression.h is using SZ_* macros, and if some user only includes
> compression.h without linux/sizes.h, it will cause compile error.
> 
> One example is lzo.c, if it uses BTRFS_MAX_COMPRESSED, it would cause
> compile error.
> 
> Fix it by adding linux/sizes.h in compression.h
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/compression.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index cc605f7b23fb..317703d9b073 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -6,6 +6,7 @@
>  #ifndef BTRFS_COMPRESSION_H
>  #define BTRFS_COMPRESSION_H
>  
> +#include <linux/sizes.h>
>  /*
>   * We want to make sure that amount of RAM required to uncompress an extent is
>   * reasonable, so we limit the total size in ram of a compressed extent to
> 
