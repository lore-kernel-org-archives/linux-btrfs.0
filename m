Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37597 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936007AbeE3ItL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 May 2018 04:49:11 -0400
Subject: Re: [PATCH] btrfs: return error value if create_io_em() failed in
 cow_file_range()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180530084856.17264-1-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <9ed9693b-797f-8340-abb0-9945a0111cee@suse.com>
Date: Wed, 30 May 2018 11:49:07 +0300
MIME-Version: 1.0
In-Reply-To: <20180530084856.17264-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.05.2018 11:48, Su Yue wrote:
> In cow_file_range(), create_io_em() may fail, but its return value is
> not recorded.
> Then return value may be 0 even it failed which is a wrong behavior.
> 
> Let cow_file_range() return PTR_ERR(em) if create_io_em() failed.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

This also needs:

Fixes: 6f9994dbabe5 ("Btrfs: create a helper to create em for IO")

And should be applied to stable starting from 4.11

> ---
>  fs/btrfs/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9228cb866115..14ffb4858d09 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1018,8 +1018,10 @@ static noinline int cow_file_range(struct inode *inode,
>  				  ram_size, /* ram_bytes */
>  				  BTRFS_COMPRESS_NONE, /* compress_type */
>  				  BTRFS_ORDERED_REGULAR /* type */);
> -		if (IS_ERR(em))
> +		if (IS_ERR(em)) {
> +			ret = PTR_ERR(em);
>  			goto out_reserve;
> +		}
>  		free_extent_map(em);
>  
>  		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
> 
