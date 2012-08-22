Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:42705 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab2HVP5a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 11:57:30 -0400
Date: Wed, 22 Aug 2012 17:57:23 +0200
From: David Sterba <dave@jikos.cz>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix a dio write regression
Message-ID: <20120822155723.GW17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1345630274-16242-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1345630274-16242-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a few minor style comments,

On Wed, Aug 22, 2012 at 06:11:14PM +0800, bo.li.liu@oracle.com wrote:
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5993,10 +5993,24 @@ unlock:
>  	 * in the case of read we need to unlock only the end area that we
>  	 * aren't using if there is any left over space.
>  	 */
> -	if (lockstart < lockend)
> -		clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
> -				 unlock_bits, 1, 0, &cached_state, GFP_NOFS);
> -	else
> +	if (lockstart < lockend) {
> +		if (create && len < lockend - lockstart) {
> +			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
> +					 lockstart + len - 1, unlock_bits, 1, 0,
> +					 &cached_state, GFP_NOFS);
> +			/*
> +			 * Beside unlock, we also need to cleanup reserved space
> +			 * for the left range by attaching EXTENT_DO_ACCOUNTING.
> +			 */
> +			clear_extent_bit(&BTRFS_I(inode)->io_tree,
> +					 lockstart + len, lockend, unlock_bits |
> +					 EXTENT_DO_ACCOUNTING, 1, 0, NULL,

I'd prefer to see unlock_bits and the new value on one line

> +					 GFP_NOFS);
> +		} else

add { ... } around this

> +			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
> +					 lockend, unlock_bits, 1, 0,
> +					 &cached_state, GFP_NOFS);
> +	} else

here too

>  		free_extent_state(cached_state);
>  
>  	free_extent_map(em);
