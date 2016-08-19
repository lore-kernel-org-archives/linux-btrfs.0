Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34971 "EHLO
        mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754466AbcHSRb4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 13:31:56 -0400
Received: by mail-pa0-f42.google.com with SMTP id i5so17969476pat.2
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 10:31:55 -0700 (PDT)
Date: Fri, 19 Aug 2016 10:31:53 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix em leak in find_first_block_group
Message-ID: <20160819173153.GA6679@vader.DHCP.thefacebook.com>
References: <1471548606-1433-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1471548606-1433-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 18, 2016 at 03:30:06PM -0400, Josef Bacik wrote:
> We need to call free_extent_map() on the em we look up.Btrfs: fix em leak in
> find_first_block_group

Something weird happened with your patch here ^^^

> We need to call free_extent_map() on the em we look up.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> ---
>  fs/btrfs/extent-tree.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 61b494e..20f9fa6 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9906,6 +9906,7 @@ static int find_first_block_group(struct btrfs_root *root,
>  			} else {
>  				ret = 0;
>  			}
> +			free_extent_map(em);
>  			goto out;
>  		}
>  		path->slots[0]++;
> -- 
> 1.8.3.1

-- 
Omar
