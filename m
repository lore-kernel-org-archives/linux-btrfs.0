Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:29202 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2JWPXg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 11:23:36 -0400
Message-ID: <5086B677.7050905@oracle.com>
Date: Tue, 23 Oct 2012 23:23:35 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/6] Btrfs: don't put removals from push_node_left into
 tree mod log twice
References: <1351000527-24952-1-git-send-email-list.btrfs@jan-o-sch.net> <1351000527-24952-2-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1351000527-24952-2-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/23/2012 09:55 PM, Jan Schmidt wrote:
> Independant of the check (push_items < src_items) tree_mod_log_eb_copy did
> log the removal of the old data entries from the source buffer. Therefore,
> we must not call tree_mod_log_eb_move if the check evaluates to true, as
> that would log the removal twice, finally resulting in (rewinded) buffers
> with wrong values for header_nritems.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Tested-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
liubo

> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/ctree.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index b334362..44a7e25 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1225,6 +1225,8 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>  	free_extent_buffer(eb);
>  
>  	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
> +	WARN_ON(btrfs_header_nritems(eb_rewin) >
> +		BTRFS_NODEPTRS_PER_BLOCK(fs_info->fs_root));
>  
>  	return eb_rewin;
>  }
> @@ -1280,6 +1282,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>  	else
>  		WARN_ON(btrfs_header_level(eb) != 0);
>  	extent_buffer_get(eb);
> +	WARN_ON(btrfs_header_nritems(eb) > BTRFS_NODEPTRS_PER_BLOCK(root));
>  
>  	return eb;
>  }
> @@ -2970,8 +2973,10 @@ static int push_node_left(struct btrfs_trans_handle *trans,
>  			   push_items * sizeof(struct btrfs_key_ptr));
>  
>  	if (push_items < src_nritems) {
> -		tree_mod_log_eb_move(root->fs_info, src, 0, push_items,
> -				     src_nritems - push_items);
> +		/*
> +		 * don't call tree_mod_log_eb_move here, key removal was already
> +		 * fully logged by tree_mod_log_eb_copy above.
> +		 */
>  		memmove_extent_buffer(src, btrfs_node_key_ptr_offset(0),
>  				      btrfs_node_key_ptr_offset(push_items),
>  				      (src_nritems - push_items) *
> 

