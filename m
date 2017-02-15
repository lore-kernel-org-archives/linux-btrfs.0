Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39239 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbdBOVdY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:33:24 -0500
Date: Wed, 15 Feb 2017 13:32:30 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 23/29] btrfs: remove unused parameter from
 __add_inline_refs
Message-ID: <20170215213230.GL19427@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1486977711.git.dsterba@suse.com>
 <1b43e704d3dc38175012931ceea4268a7affb0d5.1486977712.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1b43e704d3dc38175012931ceea4268a7affb0d5.1486977712.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:34:31AM +0100, David Sterba wrote:
> Never used.
> 
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/backref.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index db706595e631..7699e16784d3 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -956,8 +956,7 @@ static int __add_delayed_refs(struct btrfs_delayed_ref_head *head, u64 seq,
>  /*
>   * add all inline backrefs for bytenr to the list
>   */
> -static int __add_inline_refs(struct btrfs_fs_info *fs_info,
> -			     struct btrfs_path *path, u64 bytenr,
> +static int __add_inline_refs(struct btrfs_path *path, u64 bytenr,
>  			     int *info_level, struct list_head *prefs,
>  			     struct ref_root *ref_tree,
>  			     u64 *total_refs, u64 inum)
> @@ -1354,7 +1353,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
>  		if (key.objectid == bytenr &&
>  		    (key.type == BTRFS_EXTENT_ITEM_KEY ||
>  		     key.type == BTRFS_METADATA_ITEM_KEY)) {
> -			ret = __add_inline_refs(fs_info, path, bytenr,
> +			ret = __add_inline_refs(path, bytenr,
>  						&info_level, &prefs,
>  						ref_tree, &total_refs,
>  						inum);
> -- 
> 2.10.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
