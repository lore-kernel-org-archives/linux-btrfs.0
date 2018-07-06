Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:1971 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752681AbeGFIGb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jul 2018 04:06:31 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] btrfs: Check each block group has corresponding
 chunk at mount time
Date: Fri, 6 Jul 2018 08:06:25 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A2ABB2@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20180706053554.18476-1-wqu@suse.com>
In-Reply-To: <20180706053554.18476-1-wqu@suse.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: Friday, July 06, 2018 1:36 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH v2 1/2] btrfs: Check each block group has corresponding chunk at mount time
> 
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
> ---
> changelog:
> v2:
>   Reuse existing find_first_block_group() to do the verification,
>   pointed out by Gu.
> ---
>  fs/btrfs/extent-tree.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 3d9fe58c0080..63a6b5d36ac1 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9717,6 +9717,8 @@ static int find_first_block_group(struct btrfs_fs_info *fs_info,
>  	int ret = 0;
>  	struct btrfs_key found_key;
>  	struct extent_buffer *leaf;
> +	struct btrfs_block_group_item bg;
> +	u64 flags;
>  	int slot;
> 
>  	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
> @@ -9751,8 +9753,33 @@ static int find_first_block_group(struct btrfs_fs_info *fs_info,
>  			"logical %llu len %llu found bg but no related chunk",
>  					  found_key.objectid, found_key.offset);
>  				ret = -ENOENT;
> +			} else if (em->start != found_key.objectid ||
> +				   em->len != found_key.offset) {
> +				btrfs_err(fs_info,
> +		"block group %llu len %llu mismatch with chunk %llu len %llu",
> +					  found_key.objectid, found_key.offset,
> +					  em->start, em->len);
> +				ret = -EUCLEAN;
>  			} else {
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
>  			}
>  			free_extent_map(em);
>  			goto out;
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
