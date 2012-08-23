Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:52457 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614Ab2HWLki (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 07:40:38 -0400
Date: Thu, 23 Aug 2012 07:40:33 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dave@jikos.cz" <dave@jikos.cz>
Subject: Re: [PATCH v2] Btrfs: fix a dio write regression
Message-ID: <20120823114033.GA2066@localhost.localdomain>
References: <1345687838-18002-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1345687838-18002-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 22, 2012 at 08:10:38PM -0600, bo.li.liu@oracle.com wrote:
> From: Liu Bo <bo.li.liu@oracle.com>
> 
> This bug is introduced by commit 3b8bde746f6f9bd36a9f05f5f3b6e334318176a9
> (Btrfs: lock extents as we map them in DIO).
> 
> In dio write, we should unlock the section which we didn't do IO on in case that
> we fall back to buffered write.  But we need to not only unlock the section
> but also cleanup reserved space for the section.
> 
> This bug was found while running xfstests 133, with this 133 no longer complains.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v1->v2: apply style comments from David Sterba.
> 
>  fs/btrfs/inode.c |   24 ++++++++++++++++++++----
>  1 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 7131fac..ea6a4ee 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5993,11 +5993,27 @@ unlock:
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
> +					 lockstart + len, lockend,
> +					 unlock_bits | EXTENT_DO_ACCOUNTING,
> +					 1, 0, NULL, GFP_NOFS);
> +		} else {
> +			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
> +					 lockend, unlock_bits, 1, 0,
> +					 &cached_state, GFP_NOFS);
> +		}
> +	} else {
>  		free_extent_state(cached_state);
> +	}
>  
>  	free_extent_map(em);
>  

Ahh yeah good catch, thanks Liu.

Josef
