Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424AbcCKPt4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 10:49:56 -0500
Date: Fri, 11 Mar 2016 16:49:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Ashish Samant <ashish.samant@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2] btrfs: Print Warning only if ENOSPC_DEBUG is enabled
Message-ID: <20160311154934.GT18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1446501310-4408-1-git-send-email-ashish.samant@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446501310-4408-1-git-send-email-ashish.samant@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 02, 2015 at 01:55:10PM -0800, Ashish Samant wrote:
> Dont call WARN_ON for ENOSPC error unless ENOSPC_DEBUG is enabled.
> 
> Signed-off-by : Ashish Samant <ashish.samant@oracle.com>
> ---
>  fs/btrfs/delayed-inode.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index a2ae427..b86cfd9 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -652,9 +652,13 @@ static int btrfs_delayed_inode_reserve_metadata(
>  			goto out;
>  
>  		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
> -		if (!WARN_ON(ret))
> +		if (!ret)
>  			goto out;
>  
> +		if (btrfs_test_opt(root, ENOSPC_DEBUG))
> +			WARN(1, KERN_DEBUG
> +			     "btrfs: block rsv migrate returned %d\n", ret);

Please use btrfs_debug

> +
>  		/*
>  		 * Ok this is a problem, let's just steal from the global rsv
>  		 * since this really shouldn't happen that often.
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
