Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:44333 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752735AbeFKEzQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 00:55:16 -0400
Subject: Re: [PATCH 06/15] btrfs-progs: check: Drop trans/root arguments from
 free_extent_hook
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <1528462078-24490-7-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <2e649653-aa2d-c40a-139d-dbebfeb6f76d@gmx.com>
Date: Mon, 11 Jun 2018 12:55:04 +0800
MIME-Version: 1.0
In-Reply-To: <1528462078-24490-7-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月08日 20:47, Nikolay Borisov wrote:
> They are not really needed, what free_extent_hook wants is really a
> pointer to fs_info so give it to it directly. This is in preparation
> of delayed refs code.

Looks good, since free_extent_hook is only used by original mode and it
doesn't involve any tree operation at all, it's a valid modification.

Although I can't really see the relationship with delayed refs, hopes I
could find it out when reviewing the rest patches.

> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  check/main.c  | 5 ++---
>  ctree.h       | 3 +--
>  extent-tree.c | 4 ++--
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/check/main.c b/check/main.c
> index 9a1f238800b0..b84903acdb25 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -6234,8 +6234,7 @@ static int add_root_to_pending(struct extent_buffer *buf,
>   * we're tracking for repair.  This hook makes sure we
>   * remove any backrefs for blocks as we are fixing them.
>   */
> -static int free_extent_hook(struct btrfs_trans_handle *trans,
> -			    struct btrfs_root *root,
> +static int free_extent_hook(struct btrfs_fs_info *fs_info,
>  			    u64 bytenr, u64 num_bytes, u64 parent,
>  			    u64 root_objectid, u64 owner, u64 offset,
>  			    int refs_to_drop)
> @@ -6243,7 +6242,7 @@ static int free_extent_hook(struct btrfs_trans_handle *trans,
>  	struct extent_record *rec;
>  	struct cache_extent *cache;
>  	int is_data;
> -	struct cache_tree *extent_cache = root->fs_info->fsck_extent_cache;
> +	struct cache_tree *extent_cache = fs_info->fsck_extent_cache;
>  
>  	is_data = owner >= BTRFS_FIRST_FREE_OBJECTID;
>  	cache = lookup_cache_extent(extent_cache, bytenr, num_bytes);
> diff --git a/ctree.h b/ctree.h
> index 082726238b91..b30a946658ce 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -1143,8 +1143,7 @@ struct btrfs_fs_info {
>  
>  	int transaction_aborted;
>  
> -	int (*free_extent_hook)(struct btrfs_trans_handle *trans,
> -				struct btrfs_root *root,
> +	int (*free_extent_hook)(struct btrfs_fs_info *fs_info,
>  				u64 bytenr, u64 num_bytes, u64 parent,
>  				u64 root_objectid, u64 owner, u64 offset,
>  				int refs_to_drop);
> diff --git a/extent-tree.c b/extent-tree.c
> index 6e7a19323efc..9132cb3f8e15 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -2163,8 +2163,8 @@ static int __free_extent(struct btrfs_trans_handle *trans,
>  	int skinny_metadata =
>  		btrfs_fs_incompat(extent_root->fs_info, SKINNY_METADATA);
>  
> -	if (root->fs_info->free_extent_hook) {
> -		root->fs_info->free_extent_hook(trans, root, bytenr, num_bytes,
> +	if (trans->fs_info->free_extent_hook) {
> +		trans->fs_info->free_extent_hook(trans->fs_info, bytenr, num_bytes,
>  						parent, root_objectid, owner_objectid,
>  						owner_offset, refs_to_drop);
>  
> 
