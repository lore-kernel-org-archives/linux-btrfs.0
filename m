Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:24588 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab2JWPba (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 11:31:30 -0400
Message-ID: <5086B851.6020109@oracle.com>
Date: Tue, 23 Oct 2012 23:31:29 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/6] Btrfs: determine level of old roots
References: <1351000527-24952-1-git-send-email-list.btrfs@jan-o-sch.net> <1351000527-24952-5-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1351000527-24952-5-git-send-email-list.btrfs@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/23/2012 09:55 PM, Jan Schmidt wrote:
> In btrfs_find_all_roots' termination condition, we compare the level of the
> old buffer we got from btrfs_search_old_slot to the level of the current
> root node. We'd better compare it to the level of the rewinded root node.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Tested-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
liubo

> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/backref.c |    4 +---
>  fs/btrfs/ctree.c   |   17 +++++++++++++++++
>  fs/btrfs/ctree.h   |    1 +
>  3 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index f318793..65608fb 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -283,9 +283,7 @@ static int __resolve_indirect_ref(struct btrfs_fs_info *fs_info,
>  		goto out;
>  	}
>  
> -	rcu_read_lock();
> -	root_level = btrfs_header_level(root->node);
> -	rcu_read_unlock();
> +	root_level = btrfs_old_root_level(root, time_seq);
>  
>  	if (root_level + 1 == level)
>  		goto out;
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 1b60c56..7093ff5 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1292,6 +1292,23 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
>  	return eb;
>  }
>  
> +int btrfs_old_root_level(struct btrfs_root *root, u64 time_seq)
> +{
> +	struct tree_mod_elem *tm;
> +	int level;
> +
> +	tm = __tree_mod_log_oldest_root(root->fs_info, root, time_seq);
> +	if (tm && tm->op == MOD_LOG_ROOT_REPLACE) {
> +		level = tm->old_root.level;
> +	} else {
> +		rcu_read_lock();
> +		level = btrfs_header_level(root->node);
> +		rcu_read_unlock();
> +	}
> +
> +	return level;
> +}
> +
>  static inline int should_cow_block(struct btrfs_trans_handle *trans,
>  				   struct btrfs_root *root,
>  				   struct extent_buffer *buf)
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 1630be8..34c5a44 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3120,6 +3120,7 @@ static inline u64 btrfs_inc_tree_mod_seq(struct btrfs_fs_info *fs_info)
>  {
>  	return atomic_inc_return(&fs_info->tree_mod_seq);
>  }
> +int btrfs_old_root_level(struct btrfs_root *root, u64 time_seq);
>  
>  /* root-item.c */
>  int btrfs_find_root_ref(struct btrfs_root *tree_root,
> 

