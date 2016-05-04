Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbcEDO7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 10:59:51 -0400
Date: Wed, 4 May 2016 16:59:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, master.b.at.raven@chefmail.de
Subject: Re: [PATCH] Btrfs: fix unexpected balance crash due to BUG_ON
Message-ID: <20160504145933.GX29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462230062-8053-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1462230062-8053-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 02, 2016 at 04:01:02PM -0700, Liu Bo wrote:
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3418,13 +3418,25 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>  		ret = btrfs_shrink_device(device, old_size - size_to_free);
>  		if (ret == -ENOSPC)
>  			break;
> -		BUG_ON(ret);
> +		if (ret) {
> +			/* btrfs_shrink_device never returns ret > 0 */
> +			WARN_ON_ONCE(ret > 0);
> +			goto error;
> +		}
>  
>  		trans = btrfs_start_transaction(dev_root, 0);
> -		BUG_ON(IS_ERR(trans));
> +		if (IS_ERR(trans)) {
> +			ret = PTR_ERR(trans);
> +			goto error;
> +		}
>  
>  		ret = btrfs_grow_device(trans, device, old_size);
> -		BUG_ON(ret);
> +		if (ret) {
> +			btrfs_end_transaction(trans, dev_root);
> +			/* btrfs_grow_device never returns ret > 0 */
> +			WARN_ON_ONCE(ret > 0);
> +			goto error;
> +		}

The "shrink then grow" trick seems to be necessary to make the workspace
for balance. I'm thinking what could be the intermediate result when it
succeeds only partially that we should worry about. (This also means
partial success on several devices only.)

If just shrink succeeds, then there is a smaller device that the user
did not ask for. This is effectively no change from the current
behaviour, now we fail more gracefully.

My idea is to print the at least original size of the device if
transaction start or grow phase fails.

Otherwise patch looks ok.
