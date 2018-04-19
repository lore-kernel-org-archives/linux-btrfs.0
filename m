Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbeDSLDE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 07:03:04 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DCE02AEA7
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 11:03:02 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: Add incompat flags check for
 btrfs_check_super_valid()
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180419093816.888-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7e7554c2-28d1-5912-7f02-e1f87556a3a8@suse.com>
Date: Thu, 19 Apr 2018 13:59:56 +0300
MIME-Version: 1.0
In-Reply-To: <20180419093816.888-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.04.2018 12:38, Qu Wenruo wrote:
> Although we have already checked incompat flags manually before really
> mounting it, we could still enhance btrfs_check_super_valid() to check
> incompat flags for later write time super block validation check.
> 
> This patch adds such incompat flags check for btrfs_check_super_valid(),
> currently it won't be triggered, but provides the basis for later write
> time check.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/disk-io.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 60caa68c3618..ec123158f051 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4104,6 +4104,19 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)

nit: Thinking out loud here - wouldn't it make more sense to name the
function btrfs_validate_super. check_super_valid sounds a bit cumbersome
to me. What do you think ?
>  		ret = -EINVAL;
>  	}
>  
> +	/*
> +	 * Before calling btrfs_check_super_valid() we have already checked
> +	 * incompat flags. So if we developr new incompat flags, it's must be
s/developr/detect ?
> +	 * some corruption.
> +	 */
> +	if (btrfs_super_incompat_flags(sb) & ~BTRFS_FEATURE_INCOMPAT_SUPP) {
> +		btrfs_err(fs_info,
> +		"corrupted incompat flags detected 0x%llx, supported 0x%llx",
> +			  btrfs_super_incompat_flags(sb),
> +			  BTRFS_FEATURE_INCOMPAT_SUPP);
> +		ret = -EINVAL;
> +	}
> +
>  	/*
>  	 * The generation is a global counter, we'll trust it more than the others
>  	 * but it's still possible that it's the one that's wrong.
> 
