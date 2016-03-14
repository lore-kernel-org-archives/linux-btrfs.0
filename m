Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39665 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964844AbcCNNwj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 09:52:39 -0400
Date: Mon, 14 Mar 2016 14:52:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Ashish Samant <ashish.samant@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH V3] btrfs: Print Warning only if ENOSPC_DEBUG is enabled
Message-ID: <20160314135215.GF18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457736845-27783-1-git-send-email-ashish.samant@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457736845-27783-1-git-send-email-ashish.samant@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 11, 2016 at 02:54:05PM -0800, Ashish Samant wrote:
> Dont print warning for ENOSPC error unless ENOSPC_DEBUG is enabled. Use 
> btrfs_debug if it is enabled.
> 
> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
> 
> V3:
>  - Use btrfs_debug() instead of WARN() per David Sterba's comment.
> V2:
>  - Add a commit message.
> ---
>  fs/btrfs/delayed-inode.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index b57daa8..b7e44cc 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -651,9 +651,12 @@ static int btrfs_delayed_inode_reserve_metadata(
>  			goto out;
>  
>  		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
> -		if (!WARN_ON(ret))
> +		if (!ret)
>  			goto out;
>  
> +		if (btrfs_test_opt(root, ENOSPC_DEBUG))
> +			btrfs_debug(root->fs_info,
> +				    "block rsv migrate returned %d\n", ret);

the message helpers do not need \n, I'll fix it here.

Reviewed-by: David Sterba <dsterba@suse.com>
