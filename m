Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42017 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751209AbeFVLsc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 07:48:32 -0400
Subject: Re: [PATCH] btrfs: Add more details while checking tree block
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180622015215.31812-1-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7b34f539-ef57-ecb3-37c8-7b3759874249@suse.com>
Date: Fri, 22 Jun 2018 14:48:30 +0300
MIME-Version: 1.0
In-Reply-To: <20180622015215.31812-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.06.2018 04:52, Su Yue wrote:
> For easier debug, print eb->start if level is invalid.
> Also make print clear if bytenr found is not expected.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/disk-io.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c3504b4d281b..a90dab84f41b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -615,8 +615,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  
>  	found_start = btrfs_header_bytenr(eb);
>  	if (found_start != eb->start) {
> -		btrfs_err_rl(fs_info, "bad tree block start %llu %llu",
> -			     found_start, eb->start);
> +		btrfs_err_rl(fs_info, "bad tree block start want %llu have %llu",

nit: I'd rather have the want/have in brackets (want %llu have% llu)

> +			     eb->start, found_start);
>  		ret = -EIO;
>  		goto err;
>  	}
> @@ -628,8 +628,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  	}
>  	found_level = btrfs_header_level(eb);
>  	if (found_level >= BTRFS_MAX_LEVEL) {
> -		btrfs_err(fs_info, "bad tree block level %d",
> -			  (int)btrfs_header_level(eb));
> +		btrfs_err(fs_info, "bad tree block level %d on %llu",
> +			  (int)btrfs_header_level(eb), eb->start);
>  		ret = -EIO;
>  		goto err;
>  	}
> 
