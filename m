Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:49840 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932188AbeGDHhV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2018 03:37:21 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 2/5] btrfs: tree-checker: Detect invalid empty essential
 tree
Date: Wed, 4 Jul 2018 07:37:17 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8557C92@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-3-wqu@suse.com>
In-Reply-To: <20180703091009.16399-3-wqu@suse.com>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Qu Wenruo
> Sent: Tuesday, July 03, 2018 5:10 PM
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH 2/5] btrfs: tree-checker: Detect invalid empty essential tree
> 
> A crafted image has empty root tree block, which will cause later NULL
> pointer dereference.
> 
> The following trees should never be empty:
> 1) Tree root
>    Must contain at least root items for extent tree, device tree and fs
>    tree
> 
> 2) Chunk tree
>    Or we can't even bootstrap.
> 
> 3) Fs tree
>    At least inode item for top level inode (.).
> 
> 4) Device tree
>    Dev extents for chunks
> 
> 5) Extent tree
>    Must has corresponding extent for each chunk.
> 
> If any is empty, we are sure the fs is corrupted and no need to mount
> it.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199847
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 1cd735b099df..3a307efab46b 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -497,8 +497,20 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
>  	 * skip this check for relocation trees.
>  	 */
>  	if (nritems == 0 && !btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_RELOC)) {
> +		u64 owner = btrfs_header_owner(leaf);
>  		struct btrfs_root *check_root;
> 
> +		/* These trees should never be empty */
> +		if (owner == BTRFS_ROOT_TREE_OBJECTID ||
> +		    owner == BTRFS_CHUNK_TREE_OBJECTID ||
> +		    owner == BTRFS_EXTENT_TREE_OBJECTID ||
> +		    owner == BTRFS_DEV_TREE_OBJECTID ||
> +		    owner == BTRFS_FS_TREE_OBJECTID) {
> +			generic_err(fs_info, leaf, 0,
> +			"invalid root, root %llu should never be empty",
> +				    owner);
> +			return -EUCLEAN;
> +		}
>  		key.objectid = btrfs_header_owner(leaf);
>  		key.type = BTRFS_ROOT_ITEM_KEY;
>  		key.offset = (u64)-1;
> --

Tested-by: Gu Jinxiang <gujx@cn.fujitsu.com>

> 2.18.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
