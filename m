Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13459 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752802AbeGEJd2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2018 05:33:28 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 2/4] btrfs-progs: transaction: Error out other than
 panic when committing transaction
Date: Thu, 5 Jul 2018 09:33:21 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A856C6AA@G08CNEXMBPEKD03.g08.fujitsu.local>
References: <20180705073731.18459-1-wqu@suse.com>
 <20180705073731.18459-3-wqu@suse.com>
In-Reply-To: <20180705073731.18459-3-wqu@suse.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: Thursday, July 05, 2018 3:37 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH 2/4] btrfs-progs: transaction: Error out other than panic when committing transaction
> 
> There are cases that btrfs_commit_transaction() itself can fail, mostly
> due to ENOSPC when allocating space.
> 
> Don't panic out in this case.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  transaction.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/transaction.c b/transaction.c
> index 9619265ef6e8..b82d346b52c8 100644
> --- a/transaction.c
> +++ b/transaction.c
> @@ -73,7 +73,8 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
>  		ret = btrfs_update_root(trans, tree_root,
>  					&root->root_key,
>  					&root->root_item);
> -		BUG_ON(ret);
> +		if (ret < 0)
> +			return ret;
>  		btrfs_write_dirty_block_groups(trans, root);
>  	}
>  	return 0;
> @@ -101,9 +102,11 @@ int commit_tree_roots(struct btrfs_trans_handle *trans,
>  		next = fs_info->dirty_cowonly_roots.next;
>  		list_del_init(next);
>  		root = list_entry(next, struct btrfs_root, dirty_list);
> -		update_cowonly_root(trans, root);
> +		ret = update_cowonly_root(trans, root);
>  		free_extent_buffer(root->commit_root);
>  		root->commit_root = NULL;
> +		if (ret < 0)
> +			return ret;
>  	}
> 
>  	return 0;
> @@ -162,12 +165,15 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  	root->root_item.level = btrfs_header_level(root->node);
>  	ret = btrfs_update_root(trans, root->fs_info->tree_root,
>  				&root->root_key, &root->root_item);
> -	BUG_ON(ret);
> +	if (ret < 0)
> +		goto out;
>  commit_tree:
>  	ret = commit_tree_roots(trans, fs_info);
> -	BUG_ON(ret);
> +	if (ret < 0)
> +		goto out;
>  	ret = __commit_transaction(trans, root);
> -	BUG_ON(ret);
> +	if (ret < 0)
> +		goto out;
>  	write_ctree_super(trans);
>  	btrfs_finish_extent_commit(trans, fs_info->extent_root,
>  			           &fs_info->pinned_extents);
> @@ -176,7 +182,8 @@ commit_tree:
>  	root->commit_root = NULL;
>  	fs_info->running_transaction = NULL;
>  	fs_info->last_trans_committed = transid;
> -	return 0;
> +out:
> +	return ret;
>  }
> 
>  void btrfs_abort_transaction(struct btrfs_trans_handle *trans, int error)
> --

Reviewed-by: Gu Jinxiang <gujx@cn.fujitsu.com>

> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
