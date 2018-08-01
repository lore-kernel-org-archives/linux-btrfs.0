Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8376 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725957AbeHAEbs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Aug 2018 00:31:48 -0400
Subject: Re: [PATCH v2 1/6] btrfs: Check each block group has corresponding
 chunk at mount time
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180801023721.32143-1-wqu@suse.com>
 <20180801023721.32143-2-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <b0c89abc-5977-fe4d-8352-402e869e483d@cn.fujitsu.com>
Date: Wed, 1 Aug 2018 10:54:58 +0800
MIME-Version: 1.0
In-Reply-To: <20180801023721.32143-2-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/01/2018 10:37 AM, Qu Wenruo wrote:
> A crafted btrfs with incorrect chunk<->block group mapping, it could leads
> to a lot of unexpected behavior.
> 
> Although the crafted image can be catched by block group item checker
> added in "[PATCH] btrfs: tree-checker: Verify block_group_item", if one
> crafted a valid enough block group item which can pass above check but
> still mismatch with existing chunk, it could cause a lot of undefined
> behavior.
> 
> This patch will add extra block group -> chunk mapping check, to ensure
> we have a completely matching (start, len, flags) chunk for each block
> group at mount time.
> 
> Here we reuse the original find_first_block_group(), which is already
> doing basic bg -> chunk check, adding more check on start/len and type
> flags.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199837
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

> ---
>   fs/btrfs/extent-tree.c | 29 ++++++++++++++++++++++++++++-
>   1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 3d9fe58c0080..63a6b5d36ac1 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9717,6 +9717,8 @@ static int find_first_block_group(struct btrfs_fs_info *fs_info,
>   	int ret = 0;
>   	struct btrfs_key found_key;
>   	struct extent_buffer *leaf;
> +	struct btrfs_block_group_item bg;
> +	u64 flags;
>   	int slot;
>   
>   	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
> @@ -9751,8 +9753,33 @@ static int find_first_block_group(struct btrfs_fs_info *fs_info,
>   			"logical %llu len %llu found bg but no related chunk",
>   					  found_key.objectid, found_key.offset);
>   				ret = -ENOENT;
> +			} else if (em->start != found_key.objectid ||
> +				   em->len != found_key.offset) {
> +				btrfs_err(fs_info,
> +		"block group %llu len %llu mismatch with chunk %llu len %llu",
> +					  found_key.objectid, found_key.offset,
> +					  em->start, em->len);
> +				ret = -EUCLEAN;
>   			} else {
> -				ret = 0;
> +				read_extent_buffer(leaf, &bg,
> +					btrfs_item_ptr_offset(leaf, slot),
> +					sizeof(bg));
> +				flags = btrfs_block_group_flags(&bg) &
> +					BTRFS_BLOCK_GROUP_TYPE_MASK;
> +
> +				if (flags != (em->map_lookup->type &
> +					      BTRFS_BLOCK_GROUP_TYPE_MASK)) {
> +					btrfs_err(fs_info,
> +"block group %llu len %llu type flags 0x%llx mismatch with chunk type flags 0x%llx",
> +						found_key.objectid,
> +						found_key.offset,
> +						flags,
> +						(BTRFS_BLOCK_GROUP_TYPE_MASK &
> +						 em->map_lookup->type));
> +					ret = -EUCLEAN;
> +				} else {
> +					ret = 0;
> +				}
>   			}
>   			free_extent_map(em);
>   			goto out;
> 


