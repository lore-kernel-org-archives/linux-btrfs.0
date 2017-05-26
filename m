Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36425 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753817AbdEZSVL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 14:21:11 -0400
Date: Fri, 26 May 2017 20:20:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] Btrfs: remove BUG() in add_data_reference
Message-ID: <20170526182011.GM30842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <20170526002631.8546-6-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526002631.8546-6-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 06:26:30PM -0600, Liu Bo wrote:
> Now that we have a helper to report invalid value of extent inline ref
> type, we need to quit gracefully instead of throwing out a kernel panic.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/relocation.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index b043e200..8b984bd 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -3774,7 +3774,10 @@ int add_data_references(struct reloc_control *rc,
>  			ret = find_data_references(rc, extent_key,
>  						   eb, dref, blocks);
>  		} else {
> -			BUG();
> +			ret = -EINVAL;
> +			WARN(1,
> +			     "extent %llu has an invalid inline ref type\n",
> +			     eb->start);

Would be good to extend the error message, also in the previous patch.
Print inode number, root id and the (invalid ref) type.

>  		}
>  		if (ret) {
>  			err = ret;
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
