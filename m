Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58092 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaLPCBR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 21:01:17 -0500
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 354243EE0C5
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 11:01:16 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 38131AC0367
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 11:01:15 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id D9C02E08001
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 11:01:14 +0900 (JST)
Message-ID: <548F8E66.2050809@jp.fujitsu.com>
Date: Tue, 16 Dec 2014 10:44:06 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: correctly get tree level in tree_backref_for_extent
References: <1418659482-11734-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1418659482-11734-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/12/16 1:04), Filipe Manana wrote:
> If we are using skinny metadata, the block's tree level is in the offset
> of the key and not in a btrfs_tree_block_info structure following the
> extent item (it doesn't exist). Therefore fix it.

Yes, this key type is introduced by commit 3173a18.

fs/btrfs/ctree.h
======================
/*
 * The same as the BTRFS_EXTENT_ITEM_KEY, except it's metadata we already know
 * the length, so we save the level in key->offset instead of the length.
 */
#define BTRFS_METADATA_ITEM_KEY        169
======================

> 
> Besides returning the correct level in the tree, this also prevents reading
> past the leaf's end in the case where the extent item is the last item in
> the leaf (eb) and it has only 1 inline reference - this is because
> sizeof(struct btrfs_tree_block_info) is greater than
> sizeof(struct btrfs_extent_inline_ref).
> 
> Got it while running a scrub which produced the following warning:
> 
>      BTRFS: checksum error at logical 42123264 on dev /dev/sde, sector 15840: metadata node (level 24) in tree 5
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

In addition, build v3.18 + this patch succeeded without any warning.

Thanks,
Satoru

> ---
>   fs/btrfs/backref.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index 2d3e32e..8729cf6 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -1552,7 +1552,6 @@ int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
>   {
>   	int ret;
>   	int type;
> -	struct btrfs_tree_block_info *info;
>   	struct btrfs_extent_inline_ref *eiref;
>   
>   	if (*ptr == (unsigned long)-1)
> @@ -1573,9 +1572,17 @@ int tree_backref_for_extent(unsigned long *ptr, struct extent_buffer *eb,
>   	}
>   
>   	/* we can treat both ref types equally here */
> -	info = (struct btrfs_tree_block_info *)(ei + 1);
>   	*out_root = btrfs_extent_inline_ref_offset(eb, eiref);
> -	*out_level = btrfs_tree_block_level(eb, info);
> +
> +	if (key->type == BTRFS_EXTENT_ITEM_KEY) {
> +		struct btrfs_tree_block_info *info;
> +
> +		info = (struct btrfs_tree_block_info *)(ei + 1);
> +		*out_level = btrfs_tree_block_level(eb, info);
> +	} else {
> +		ASSERT(key->type == BTRFS_METADATA_ITEM_KEY);
> +		*out_level = (u8)key->offset;
> +	}
>   
>   	if (ret == 1)
>   		*ptr = (unsigned long)-1;
> 

