Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58710 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750929AbdI1GBd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 02:01:33 -0400
Subject: Re: [PATCH 3/5] btrfs: tree-checker: Enhance output for
 btrfs_check_leaf
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20170928033610.16882-1-quwenruo.btrfs@gmx.com>
 <20170928033610.16882-4-quwenruo.btrfs@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bdb98087-48ce-db51-0afd-b9063b5c3386@suse.com>
Date: Thu, 28 Sep 2017 09:01:31 +0300
MIME-Version: 1.0
In-Reply-To: <20170928033610.16882-4-quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.09.2017 06:36, Qu Wenruo wrote:
> Enhance the output to print:
> 1) Reason
> 2) Bad value
>    If reason can't explain enough
> 3) Good value (range)
> 
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> ---
>  fs/btrfs/tree-checker.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 4b615beb0ca9..4f847955fdc6 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -216,8 +216,8 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
>  			eb = btrfs_root_node(check_root);
>  			/* if leaf is the root, then it's fine */
>  			if (leaf != eb) {
> -				CORRUPT("non-root leaf's nritems is 0",
> -					leaf, check_root, 0);
> +				generic_err(check_root, leaf, 0,
> +					    "non-root leaf's nritems is 0");
>  				free_extent_buffer(eb);
>  				return -EUCLEAN;
>  			}
> @@ -248,7 +248,11 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
>  
>  		/* Make sure the keys are in the right order */
>  		if (btrfs_comp_cpu_keys(&prev_key, &key) >= 0) {
> -			CORRUPT("bad key order", leaf, root, slot);
> +			generic_err(root, leaf, slot,
> +				"bad key order, prev key (%llu %u %llu) current key (%llu %u %llu)",
> +				prev_key.objectid, prev_key.type,
> +				prev_key.offset, key.objectid, key.type,
> +				key.offset);
>  			return -EUCLEAN;
>  		}
>  
> @@ -263,7 +267,10 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
>  			item_end_expected = btrfs_item_offset_nr(leaf,
>  								 slot - 1);
>  		if (btrfs_item_end_nr(leaf, slot) != item_end_expected) {
> -			CORRUPT("slot offset bad", leaf, root, slot);
> +			generic_err(root, leaf, slot,
> +				"uncontinuous item end, have %u expect %u",
nit: s/uncontinious/discontinious
> +				btrfs_item_end_nr(leaf, slot),
> +				item_end_expected);
>  			return -EUCLEAN;
>  		}
>  
> @@ -274,14 +281,21 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
>  		 */
>  		if (btrfs_item_end_nr(leaf, slot) >
>  		    BTRFS_LEAF_DATA_SIZE(fs_info)) {
> -			CORRUPT("slot end outside of leaf", leaf, root, slot);
> +			generic_err(root, leaf, slot,
> +				"slot end outside of leaf, have %u expect range [0, %u]",
> +				btrfs_item_end_nr(leaf, slot),
> +				BTRFS_LEAF_DATA_SIZE(fs_info));
>  			return -EUCLEAN;
>  		}
>  
>  		/* Also check if the item pointer overlaps with btrfs item. */
>  		if (btrfs_item_nr_offset(slot) + sizeof(struct btrfs_item) >
>  		    btrfs_item_ptr_offset(leaf, slot)) {
> -			CORRUPT("slot overlap with its data", leaf, root, slot);
> +			generic_err(root, leaf, slot,
> +				"slot overlap with its data, item end %lu data start %lu",
> +				btrfs_item_nr_offset(slot) +
> +				sizeof(struct btrfs_item),
> +				btrfs_item_ptr_offset(leaf, slot));
>  			return -EUCLEAN;
>  		}
>  
> 
