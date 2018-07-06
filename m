Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:64052 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753852AbeGFDWy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2018 23:22:54 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 3/4] btrfs-progs: check/original: Avoid infinite loop
 when failed to repair inode
Date: Fri, 6 Jul 2018 03:22:49 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A29974@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20180705073731.18459-1-wqu@suse.com>
 <20180705073731.18459-4-wqu@suse.com>
In-Reply-To: <20180705073731.18459-4-wqu@suse.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: Thursday, July 05, 2018 3:38 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH 3/4] btrfs-progs: check/original: Avoid infinite loop when failed to repair inode
> 
> Exposed by fuzz-tests/003-multi-check-unmounted/ on fuzzed image
> bko-161811.raw.xz.
> 
> It's caused by the fact when check_fs_roots() finds tree root is
> modified, it re-search tree root by goto again: tag.
> However again: tag will also reset root objectid to 0.
> If we failed to repair one fs root but still modified tree root, we will
> go into such infinite loop.
> 
> Fix it by record which root we should skip for repair mode.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  check/main.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/check/main.c b/check/main.c
> index c8c347236543..2b5abb2d025b 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -3380,6 +3380,7 @@ static int check_fs_roots(struct btrfs_fs_info *fs_info,
>  	struct extent_buffer *leaf, *tree_node;
>  	struct btrfs_root *tmp_root;
>  	struct btrfs_root *tree_root = fs_info->tree_root;
> +	u64 skip_root = 0;
>  	int ret;
>  	int err = 0;
> 
> @@ -3400,7 +3401,10 @@ static int check_fs_roots(struct btrfs_fs_info *fs_info,
> 
>  again:
>  	key.offset = 0;
> -	key.objectid = 0;
> +	if (skip_root)
> +		key.objectid = skip_root + 1;
> +	else
> +		key.objectid = 0;
>  	key.type = BTRFS_ROOT_ITEM_KEY;
>  	ret = btrfs_search_slot(NULL, tree_root, &key, &path, 0, 0);
>  	if (ret < 0) {
> @@ -3409,6 +3413,7 @@ again:
>  	}
>  	tree_node = tree_root->node;
>  	while (1) {
> +
>  		if (tree_node != tree_root->node) {
>  			free_root_recs_tree(root_cache);
>  			btrfs_release_path(&path);
> @@ -3445,8 +3450,18 @@ again:
>  				btrfs_release_path(&path);
>  				goto again;
>  			}
> -			if (ret)
> +			if (ret) {
>  				err = 1;
> +
> +				/*
> +				 * We failed to repair this root but modified tree
> +				 * root, after again: tag we will still hit this
> +				 * root and fail to repair, must skip this root to
> +				 * avoid infinite loop
> +				 */
> +				if (repair)
> +					skip_root = key.objectid;
> +			}
>  			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
>  				btrfs_free_fs_root(tmp_root);
>  		} else if (key.type == BTRFS_ROOT_REF_KEY ||
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
