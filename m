Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11500 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750786AbbIKA1U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 20:27:20 -0400
Subject: Re: [PATCH] btrfs-progs: fix cross stripe boundary check
To: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1441897376-5572-1-git-send-email-dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55F21FE5.2030008@cn.fujitsu.com>
Date: Fri, 11 Sep 2015 08:27:17 +0800
MIME-Version: 1.0
In-Reply-To: <1441897376-5572-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/09/10 17:02 +0200:
> Commit 854437ca3c228d8ab3eb24d2efc1c21b5d56a635 ("btrfs-progs:
> extent-tree: avoid allocating tree block that crosses stripe boundary")
> does not work for 64k nodesize. Due to an off-by-one error, all queries
> to check_crossing_stripes will return that all extents cross a stripe
> and this will lead to a false ENOSPC. This crashes later
>
> $ ./mkfs.btrfs -n 64k image
>
> ./mkfs.btrfs(btrfs_reserve_extent+0xb77)[0x417f38]
> ./mkfs.btrfs(btrfs_alloc_free_block+0x57)[0x417fe0]
> ./mkfs.btrfs(__btrfs_cow_block+0x163)[0x408eb7]
> ./mkfs.btrfs(btrfs_cow_block+0xd0)[0x4097c4]
> ./mkfs.btrfs(btrfs_search_slot+0x16f)[0x40be4d]
> ./mkfs.btrfs(btrfs_insert_empty_items+0xc0)[0x40d5f9]
> ./mkfs.btrfs(btrfs_insert_item+0x99)[0x40da5f]
> ./mkfs.btrfs(btrfs_make_block_group+0x4d)[0x41705c]
> ./mkfs.btrfs(main+0xeef)[0x434b56]
>
> CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
Nice one, yep, my fault.

BTW, any idea to add mkfs test?

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
> ---
>   volumes.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/volumes.h b/volumes.h
> index f7761311e8ce..4ecb99314a0c 100644
> --- a/volumes.h
> +++ b/volumes.h
> @@ -156,7 +156,7 @@ struct map_lookup {
>   static inline int check_crossing_stripes(u64 start, u64 len)
>   {
>   	return (start / BTRFS_STRIPE_LEN) !=
> -	       ((start + len) / BTRFS_STRIPE_LEN);
> +	       ((start + len - 1) / BTRFS_STRIPE_LEN);
>   }
>
>   int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
>
