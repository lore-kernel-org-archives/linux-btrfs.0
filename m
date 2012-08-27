Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:34255 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab2H0RFb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 13:05:31 -0400
Date: Mon, 27 Aug 2012 13:05:29 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: [PATCH 1/2] Btrfs: cleanup extents after we finish logging inode
Message-ID: <20120827170529.GB4048@localhost.localdomain>
References: <1346086340-14776-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1346086340-14776-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 27, 2012 at 10:52:19AM -0600, Liu Bo wrote:
> This is based on Josef's "Btrfs: turbo charge fsync".
> 
> We should cleanup those extents after we've finished logging inode,
> otherwise we may do redundant work on them.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/tree-log.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 5190cd6..e7365d7 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3167,6 +3167,12 @@ next_slot:
>  			err = ret;
>  			goto out_unlock;
>  		}
> +	} else {
> +		struct extent_map_tree *tree = &BTRFS_I(inode)->extent_tree;
> +		struct extent_map *em, *n;
> +
> +		list_for_each_entry_safe(em, n, &tree->modified_extents, list)
> +			list_del_init(&em->list);
>  	}
>  
>  	if (inode_only == LOG_INODE_ALL && S_ISDIR(inode->i_mode)) {
> -- 

Ah thanks I had been meaning to do this but I kept forgetting.  I'll add it to
btrfs-next.  Thanks,

Josef
