Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57251 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751147AbdJKPlg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 11:41:36 -0400
Subject: Re: [PATCH v4 3/5] btrfs: tree-checker: Enhance output for
 btrfs_check_leaf
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171009015106.9711-1-quwenruo.btrfs@gmx.com>
 <20171009015106.9711-4-quwenruo.btrfs@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ddcf3b2b-5c56-055a-4a6d-6bc4ba76d4eb@suse.com>
Date: Wed, 11 Oct 2017 18:41:32 +0300
MIME-Version: 1.0
In-Reply-To: <20171009015106.9711-4-quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.10.2017 04:51, Qu Wenruo wrote:
> Enhance the output to print:
> 1) Reason
> 2) Bad value
>    If reason can't explain enough
> 3) Good value (range)
> 
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> ---
>  fs/btrfs/tree-checker.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index b4ced8d3ce2a..7bba195ecc8b 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -233,8 +233,9 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
>  			eb = btrfs_root_node(check_root);
>  			/* if leaf is the root, then it's fine */
>  			if (leaf != eb) {
> -				CORRUPT("non-root leaf's nritems is 0",
> -					leaf, check_root, 0);
> +				generic_err(check_root, leaf, 0,
> +					"invalid nritems, have %u shouldn't be 0 for non-root leaf",
> +					nritems);

I'm a bit confused by what this error messages wants to convey. Even
reading the previous version with CORRUPT() it still didn't make sense.
So what we want to say here is we shouldn't have empty leaf nodes. So
Something along the line of "Unexpected empty leaf".

Why would the (leaf != eb) check not trigger, given that we call
btrfs_check_leaf when we now that the item is a leaf (level is 0 )?


>  				free_extent_buffer(eb);
>  				return -EUCLEAN;
>  			}
> @@ -265,7 +266,11 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
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
> @@ -280,7 +285,10 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
>  			item_end_expected = btrfs_item_offset_nr(leaf,
>  								 slot - 1);
>  		if (btrfs_item_end_nr(leaf, slot) != item_end_expected) {
> -			CORRUPT("slot offset bad", leaf, root, slot);
> +			generic_err(root, leaf, slot,
> +				"discontinious item end, have %u expect %u",

s/discontinious/unexpected ?

> +				btrfs_item_end_nr(leaf, slot),
> +				item_end_expected);
>  			return -EUCLEAN;
>  		}
>  
> @@ -291,14 +299,21 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
>  		 */
>  		if (btrfs_item_end_nr(leaf, slot) >
>  		    BTRFS_LEAF_DATA_SIZE(fs_info)) {
> -			CORRUPT("slot end outside of leaf", leaf, root, slot);
> +			generic_err(root, leaf, slot,
> +				"slot end outside of leaf, have %u expect range [0, %u]",> +				btrfs_item_end_nr(leaf, slot),
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
