Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34905 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726753AbeHDPCS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2018 11:02:18 -0400
Date: Sat, 4 Aug 2018 20:59:48 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: zhong jiang <zhongjiang@huawei.com>
CC: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs/extent_map: Remove unneeded variable "ret"
Message-ID: <20180804125947.GF2049@fnst.localdomain>
References: <1533381223-16734-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1533381223-16734-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 04, 2018 at 07:13:43PM +0800, zhong jiang wrote:
>The ret is not used after initalization, So just remove it.

So why not change these two functions to void function?

-- 
Thanks,
Lu

>
>Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>---
> fs/btrfs/extent_map.c | 8 +++-----
> 1 file changed, 3 insertions(+), 5 deletions(-)
>
>diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
>index 6648d55..b48ab41 100644
>--- a/fs/btrfs/extent_map.c
>+++ b/fs/btrfs/extent_map.c
>@@ -276,7 +276,6 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
> int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
> 		       u64 gen)
> {
>-	int ret = 0;
> 	struct extent_map *em;
> 	bool prealloc = false;
> 
>@@ -308,7 +307,7 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
> 	free_extent_map(em);
> out:
> 	write_unlock(&tree->lock);
>-	return ret;
>+	return 0;
> 
> }
> 
>@@ -430,14 +429,13 @@ struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
>  */
> int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map *em)
> {
>-	int ret = 0;
>-
> 	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
> 	rb_erase(&em->rb_node, &tree->map);
> 	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
> 		list_del_init(&em->list);
> 	RB_CLEAR_NODE(&em->rb_node);
>-	return ret;
>+
>+	return 0;
> }
> 
> void replace_extent_mapping(struct extent_map_tree *tree,
>-- 
>1.7.12.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


