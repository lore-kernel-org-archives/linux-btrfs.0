Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:12885 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab3GCIxI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 04:53:08 -0400
Message-ID: <51D3E66C.8060501@jan-o-sch.net>
Date: Wed, 03 Jul 2013 10:53:00 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix extent buffer leak after backref walking
References: <1372833644-30061-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1372833644-30061-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, July 03, 2013 at 08:40 (+0200), Liu Bo wrote:
> commit 47fb091fb787420cd195e66f162737401cce023f(Btrfs: fix unlock after free on rewinded tree blocks)
> takes an extra increment on the reference of allocated dummy extent buffer, so now we
> cannot free this dummy one, and end up with extent buffer leak.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>

> ---
>  fs/btrfs/ctree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 02fae7f..3d790b4 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1268,12 +1268,12 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>  		BUG_ON(!eb_rewin);
>  	}
>  
> -	extent_buffer_get(eb_rewin);
>  	btrfs_tree_read_unlock(eb);
>  	free_extent_buffer(eb);
>  
>  	extent_buffer_get(eb_rewin);
>  	btrfs_tree_read_lock(eb_rewin);
> +
>  	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
>  	WARN_ON(btrfs_header_nritems(eb_rewin) >
>  		BTRFS_NODEPTRS_PER_BLOCK(fs_info->tree_root));
> 
