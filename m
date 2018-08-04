Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:45359 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbeHDOav (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 4 Aug 2018 10:30:51 -0400
Subject: Re: [PATCH] btrfs/extent_map: Remove unneeded variable "ret"
To: zhong jiang <zhongjiang@huawei.com>, clm@fb.com, jbacik@fb.com,
        dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Su Yue <suy.fnst@cn.fujitsu.com>
References: <1533381223-16734-1-git-send-email-zhongjiang@huawei.com>
From: Su Yue <Damenly_Su@gmx.com>
Message-ID: <05f5d38b-9569-6ec7-534f-9a3a5ecd5faa@gmx.com>
Date: Sat, 4 Aug 2018 20:29:49 +0800
MIME-Version: 1.0
In-Reply-To: <1533381223-16734-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/8/4 7:13 PM, zhong jiang wrote:
> The ret is not used after initalization, So just remove it.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>   fs/btrfs/extent_map.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
> index 6648d55..b48ab41 100644
> --- a/fs/btrfs/extent_map.c
> +++ b/fs/btrfs/extent_map.c
> @@ -276,7 +276,6 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
>   int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
>   		       u64 gen)
>   {
> -	int ret = 0;
>   	struct extent_map *em;
>   	bool prealloc = false;
>   
> @@ -308,7 +307,7 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
>   	free_extent_map(em);
>   out:
>   	write_unlock(&tree->lock);
> -	return ret;
> +	return 0;
>   
>   }
>   
> @@ -430,14 +429,13 @@ struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
>    */
>   int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
>   {
> -	int ret = 0;
> -
>   	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
>   	rb_erase(&em->rb_node, &tree->map);
>   	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
>   		list_del_init(&em->list);
>   	RB_CLEAR_NODE(&em->rb_node);
> -	return ret;
> +
> +	return 0;
>   }
>   
>   void replace_extent_mapping(struct extent_map_tree *tree,
> 
