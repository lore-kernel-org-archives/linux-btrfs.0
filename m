Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38929 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391350AbeIVBlE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 21:41:04 -0400
Received: by mail-pf1-f195.google.com with SMTP id j8-v6so6419458pff.6
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 12:50:42 -0700 (PDT)
Date: Fri, 21 Sep 2018 12:50:40 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/6] btrfs-progs: Add support for freespace tree in
 btrfs_read_fs_root
Message-ID: <20180921195040.GB31081@vader>
References: <1529060762-4372-1-git-send-email-nborisov@suse.com>
 <1529060762-4372-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529060762-4372-2-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 15, 2018 at 02:05:57PM +0300, Nikolay Borisov wrote:
> For completeness sake add code to btrfs_read_fs_root so that it can
> handle the freespace tree.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  disk-io.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 8da6e3ce5fc8..9ad826b83b3e 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -664,6 +664,9 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
>  	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
>  		return fs_info->quota_enabled ? fs_info->quota_root :
>  				ERR_PTR(-ENOENT);
> +	if (location->objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
> +        return fs_info->free_space_root ? fs_info->free_space_root :
> +                                                  ERR_PTR(-ENOENT);
>  
>  	BUG_ON(location->objectid == BTRFS_TREE_RELOC_OBJECTID ||
>  	       location->offset != (u64)-1);
> -- 
> 2.7.4
> 
