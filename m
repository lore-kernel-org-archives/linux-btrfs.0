Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49792 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751170AbeFVH56 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 03:57:58 -0400
Subject: Re: [PATCH] btrfs: return EUCLEAN if extent_inline_ref type is
 invalid
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180622075349.17976-1-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4660b47f-aced-2206-1cf3-aa78e635bf20@suse.com>
Date: Fri, 22 Jun 2018 10:57:55 +0300
MIME-Version: 1.0
In-Reply-To: <20180622075349.17976-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.06.2018 10:53, Su Yue wrote:
> If type of extent_inline_ref found is not expected, filesystem may have
> been corrupted, should return EUCLEAN instead of EINVAL.
> No functional changes.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  fs/btrfs/relocation.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 3d9fe58c0080..05d50c3a594e 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -1727,7 +1727,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
>  		iref = (struct btrfs_extent_inline_ref *)ptr;
>  		type = btrfs_get_extent_inline_ref_type(leaf, iref, needed);
>  		if (type == BTRFS_REF_TYPE_INVALID) {
> -			err = -EINVAL;
> +			err = -EUCLEAN;
>  			goto out;
>  		}
>  
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 879b76fa881a..7c9855e8ae6f 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -3801,7 +3801,7 @@ int add_data_references(struct reloc_control *rc,
>  			ret = find_data_references(rc, extent_key,
>  						   eb, dref, blocks);
>  		} else {
> -			ret = -EINVAL;
> +			ret = -EUCLEAN;
>  			btrfs_err(rc->extent_root->fs_info,
>  		     "extent %llu slot %d has an invalid inline ref type",
>  			     eb->start, path->slots[0]);
> 
