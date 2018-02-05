Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51426 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752972AbeBEQUs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Feb 2018 11:20:48 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E7BFAAC57
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Feb 2018 16:20:46 +0000 (UTC)
Subject: Re: [PATCH] btrfs: Add enospc_debug printing in
 metadata_reserve_bytes
To: linux-btrfs@vger.kernel.org
References: <1513332337-7068-1-git-send-email-nborisov@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <fd31d262-3b22-dbc0-6315-3ce734334625@suse.com>
Date: Mon, 5 Feb 2018 18:20:42 +0200
MIME-Version: 1.0
In-Reply-To: <1513332337-7068-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.12.2017 12:05, Nikolay Borisov wrote:
> Currently when enoscp_debug mount option is turned on we do not print
> any debug info in case metadata reservation failures happen. Fix this
> by adding the necessary hook in reserve_metadata_bytes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 4497f937e8fb..7a281fc97bc5 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5382,10 +5382,15 @@ static int reserve_metadata_bytes(struct btrfs_root *root,
>  		    !block_rsv_use_bytes(global_rsv, orig_bytes))
>  			ret = 0;
>  	}
> -	if (ret == -ENOSPC)
> +	if (ret == -ENOSPC) {
>  		trace_btrfs_space_reservation(fs_info, "space_info:enospc",
>  					      block_rsv->space_info->flags,
>  					      orig_bytes, 1);
> +
> +		if (btrfs_test_opt(fs_info, ENOSPC_DEBUG))
> +			dump_space_info(fs_info, block_rsv->space_info,
> +					orig_bytes, 0);
> +	}
>  	return ret;
>  }
>  
> 

Ping
