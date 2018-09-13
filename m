Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:43449 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbeINEyv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 00:54:51 -0400
Subject: Re: [PATCH v2 5/7] btrfs-progs: lowmem: continue to check item in
 last slot while checking inodes
To: damenly.su@gmail.com, linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
References: <20180912204924.10089-1-suy.fnst@cn.fujitsu.com>
 <20180912204924.10089-6-suy.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e415c063-772b-3dca-fdd1-ed88c90caf8b@gmx.com>
Date: Fri, 14 Sep 2018 07:43:01 +0800
MIME-Version: 1.0
In-Reply-To: <20180912204924.10089-6-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/13 上午4:49, damenly.su@gmail.com wrote:
> From: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> After call of check_inode_item(), path may point to the last unchecked
> slot of the leaf. The outer walk_up_tree() always treats the position
> as checked item then skips to next item.

So check_inode_item() always set its path to *unchecked* slot, while
walk_up_tree() always think its path is set to *checked* slot.

Then this is indeed a problem.

> 
> If the last item was an inode item, yes, it was unchecked.
> Then walk_up_tree() will think the leaf is checked and walk up to
> upper node, process_one_leaf() in walk_down_tree() would skip to
> check next inode item. Which means, the inode item won't be checked.
> 
> Solution:
> After check_inode_item returns, if found path point to the last item
> of a leaf,

Would you please explain more about why last item makes a difference here?

>From previous statement, it looks like it's the difference in how
walk_up_tree() and check_inode_item() handles the path.
Not really related to last item.

Or did I miss something?

Thanks,
Qu

> decrease path slot manually, so walk_up_tree() will stay
> on the leaf.
> 
> Fixes: 5e2dc770471b ("btrfs-progs: check: skip shared node or leaf check for low_memory mode")
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  check/mode-lowmem.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 8fc9edab1d66..b6b33786d02b 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -2612,6 +2612,18 @@ again:
>  	if (cur->start == cur_bytenr)
>  		goto again;
>  
> +	/*
> +	 * path may point at the last item(a inode item maybe) in a leaf.
> +	 * Without below lines, walk_up_tree() will skip the item which
> +	 * means all items related to the inode will never be checked.
> +	 * Decrease the slot manually, walk_up_tree won't skip to next node
> +	 * if it occurs.
> +	 */
> +	if (path->slots[0] + 1 >= btrfs_header_nritems(path->nodes[0])) {
> +		if (path->slots[0])
> +			path->slots[0]--;
> +	}
> +
>  	/*
>  	 * we have switched to another leaf, above nodes may
>  	 * have changed, here walk down the path, if a node
> 
