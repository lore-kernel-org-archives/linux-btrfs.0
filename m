Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:52472 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab3GaJH0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 05:07:26 -0400
Message-ID: <51F8D3CD.5040604@jan-o-sch.net>
Date: Wed, 31 Jul 2013 11:07:25 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: add missing error check to find_parent_nodes
References: <1375210462-17820-1-git-send-email-fdmanana@gmail.com> <1375226795-7671-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1375226795-7671-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, July 31, 2013 at 01:26 (+0200), Filipe David Borba Manana wrote:
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
> 
> V2: Ensure extent buffer is freed on error.
> 
>  fs/btrfs/backref.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 8bc5e8c..980e85a 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -935,8 +935,10 @@ again:
>  				}
>  				ret = find_extent_in_eb(eb, bytenr,
>  							*extent_item_pos, &eie);
> -				ref->inode_list = eie;
>  				free_extent_buffer(eb);
> +				if (ret < 0)
> +					goto out;
> +				ref->inode_list = eie;
>  			}
>  			ret = ulist_add_merge(refs, ref->parent,
>  					      (uintptr_t)ref->inode_list,
> 

The only ret < 0 I'm seeing is ENOMEM, so that should be safe.

Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>

Thanks,
-Jan
