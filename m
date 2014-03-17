Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932954AbaCQOlc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 10:41:32 -0400
Date: Mon, 17 Mar 2014 15:41:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH] Btrfs: fix a crash of clone with inline extents's split
Message-ID: <20140317144131.GF29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1394448967-14128-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394448967-14128-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 10, 2014 at 06:56:07PM +0800, Liu Bo wrote:
> xfstests's btrfs/035 triggers a BUG_ON, which we use to detect the split
> of inline extents in __btrfs_drop_extents().
> 
> For inline extents, we cannot duplicate another EXTENT_DATA item, because
> it breaks the rule of inline extents, that is, 'start offset' needs to be 0.
> 
> We have set limitations for the source inode's compressed inline extents,
> because it needs to decompress and recompress.  Now the destination inode's
> inline extents also need similar limitations.

The limitation (by lack of implementation, not by design) of compressed
inline extents is there, but it's impossible to reach. The inline
extents are never longer than the 'inline limit' (the ~3916 size), so
the comment is more a note to the future.

You're adding another limitation to avoid a crash, but I don't agree
that EINVAL is right here, due to the fact that it's lack of
implementation, not a real error.

There are enough EINVAL's that verify correcntess of the input
parameters and it's not always clear which one fails. The EOPNOTSUPP
errocode is close to the true reason of the failure, but it could be
misinterpreted as if the whole clone operation is not supported, so it's
not all correct but IMO better than EINVAL.

The most common case of 'cp --reflink' is not affected by this.

> 
> With this, xfstests btrfs/035 doesn't run into panic.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/file.c  | 15 ++++++++++++---
>  fs/btrfs/ioctl.c | 10 ++++++----
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 0165b86..2c34a04 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3090,8 +3090,9 @@ process_slot:
>  							 new_key.offset + datal,
>  							 1);
>  				if (ret) {
> -					btrfs_abort_transaction(trans, root,
> -								ret);
> +					if (ret != -EINVAL)
> +						btrfs_abort_transaction(trans,
> +								root, ret);

The error comes from __btrfs_drop_extents and all callers would need to
be updated (or at least reviewed) with the 'ret != ...' check as well,
because it changes the semantics. And I'm not sure if to the right
direction.

>  					btrfs_end_transaction(trans, root);
>  					goto out;
>  				}
> @@ -3175,8 +3176,9 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  	 *   decompress into destination's address_space (the file offset
>  	 *   may change, so source mapping won't do), then recompress (or
>  	 *   otherwise reinsert) a subrange.

> -	 * - allow ranges within the same file to be cloned (provided
> -	 *   they don't overlap)?

True, but unrelated.

> +	 *
> +	 * - split destination inode's inline extents.  The inline extents can
> +	 *   be either compressed or non-compressed.
