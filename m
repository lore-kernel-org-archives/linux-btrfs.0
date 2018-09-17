Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54491 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbeIQSVJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 14:21:09 -0400
Subject: Re: [PATCH v3 5/7] btrfs-progs: lowmem: do missing check of last item
 after check_inode_item()
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
 <20180917072852.25831-6-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e4ec3fbd-71c3-c59c-1915-0419f06a6c26@gmx.com>
Date: Mon, 17 Sep 2018 20:53:48 +0800
MIME-Version: 1.0
In-Reply-To: <20180917072852.25831-6-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/17 下午3:28, Su Yue wrote:
> After call of check_inode_item(), path may point to the last unchecked
> slot of the leaf. The outer walk_up_tree() always treats the position
> as checked slot then skips to the next. The last item will never be
> checked.
> 
> While checking backrefs, path passed to walk_up_tree() always
> points to a checked slot.
> While checking fs trees, path passed to walk_up_tree() always
> points to an unchecked slot.

Can we unify this behavior?

E.g, always points to an unchecked slot.

It would make things easier and no need for the extra parameter.

Thanks,
Qu

> 
> Solution:
> Add an argument @is_checked to walk_up_tree() to decide whether
> to skip current slot.
> 
> Fixes: 5e2dc770471b ("btrfs-progs: check: skip shared node or leaf check for low_memory mode")
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  check/mode-lowmem.c | 37 +++++++++++++++++++++++++++++++++----
>  1 file changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index db44456fd85b..612e5e28e45b 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -4597,22 +4597,38 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
>  	return err;
>  }
>  
> +/*
> + * Walk up throuh the path. Make path point to next slot to be checked.
> + * walk_down_tree() should be called after this function.
> + *
> + * @root:	root of the tree
> + * @path:	will point to next slot to check for walk_down_tree()
> + * @level:	returns with level of next node to be checked
> + * @is_checked:	means is the current node checked or not
> + *		if false, the slot is unchecked, do not increase the slot
> + *		if true, means increase the slot of the current node
> + *
> + * Returns 0 means success.
> + * Returns >0 means the whole loop of walk up/down should be broken.
> + */
>  static int walk_up_tree(struct btrfs_root *root, struct btrfs_path *path,
> -			int *level)
> +			int *level, bool is_checked)
>  {
>  	int i;
>  	struct extent_buffer *leaf;
> +	int skip_cur = is_checked ? 1 : 0;
>  
>  	for (i = *level; i < BTRFS_MAX_LEVEL - 1 && path->nodes[i]; i++) {
>  		leaf = path->nodes[i];
> -		if (path->slots[i] + 1 < btrfs_header_nritems(leaf)) {
> -			path->slots[i]++;
> +		if (path->slots[i] + skip_cur < btrfs_header_nritems(leaf)) {
> +			path->slots[i] += skip_cur;
>  			*level = i;
>  			return 0;
>  		}
>  		free_extent_buffer(path->nodes[*level]);
>  		path->nodes[*level] = NULL;
>  		*level = i + 1;
> +		skip_cur = 1;
>  	}
>  	return 1;
>  }
> @@ -4815,7 +4831,20 @@ static int check_btrfs_root(struct btrfs_root *root, int check_all)
>  			break;
>  		}
>  
> -		ret = walk_up_tree(root, &path, &level);
> +		/*
> +		 * The logical of walk trees are shared between backrefs
> +		 * check and fs trees check.
> +		 * In checking backrefs(check_all is true), after
> +		 * check_leaf_items() returns, path points to
> +		 * last checked item.
> +		 * In checking fs roots(check_all is false), after
> +		 * process_one_leaf() returns, path points to unchecked item.
> +		 *
> +		 * walk_up_tree() is reponsible to make path point to next
> +		 * slot to be checked, above case is handled in
> +		 * walk_up_tree().
> +		 */
> +		ret = walk_up_tree(root, &path, &level, check_all);
>  		if (ret != 0) {
>  			/* Normal exit, reset ret to err */
>  			ret = err;
> 
