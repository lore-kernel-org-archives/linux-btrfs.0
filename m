Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59250 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbaBFUUJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 15:20:09 -0500
Message-ID: <52F3EE74.9020403@fb.com>
Date: Thu, 6 Feb 2014 15:20:04 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Convert BUG() to BUG_ON(1)
References: <1391711648-7224-1-git-send-email-mitch.harder@sabayonlinux.org>
In-Reply-To: <1391711648-7224-1-git-send-email-mitch.harder@sabayonlinux.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/06/2014 01:34 PM, Mitch Harder wrote:
> Convert the instances of BUG() to BUG_ON(1) to provide information
> about the location of the abort.

If we're going to screw with our BUG()'s in any sort of big way like 
this I'd rather it be to swap us over to ASSERT() in the cases that it 
makes sense and return errors in those cases.

> Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
> ---
>   btrfs-debug-tree.c |  4 ++--
>   ctree.c            | 20 ++++++++++----------
>   ctree.h            |  2 +-
>   disk-io.c          |  4 ++--
>   extent-tree.c      |  6 +++---
>   extent_io.c        |  2 +-
>   file-item.c        |  4 ++--
>   print-tree.c       |  8 ++++----
>   volumes.c          |  4 ++--
>   9 files changed, 27 insertions(+), 27 deletions(-)
>
> diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
> index f37de9d..0180265 100644
> --- a/btrfs-debug-tree.c
> +++ b/btrfs-debug-tree.c
> @@ -68,10 +68,10 @@ static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
>   					     btrfs_node_ptr_generation(eb, i));
>   		if (btrfs_is_leaf(next) &&
>   		    btrfs_header_level(eb) != 1)
> -			BUG();
> +			BUG_ON(1);
>   		if (btrfs_header_level(next) !=
>   			btrfs_header_level(eb) - 1)
> -			BUG();
> +			BUG_ON(1);
>   		print_extents(root, next);
>   		free_extent_buffer(next);
>   	}
> diff --git a/ctree.c b/ctree.c
> index 9e5b30f..7aab3b1 100644
> --- a/ctree.c
> +++ b/ctree.c
> @@ -822,7 +822,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
>   	check_block(root, path, level);
>   	if (orig_ptr !=
>   	    btrfs_node_blockptr(path->nodes[level], path->slots[level]))
> -		BUG();
> +		BUG_ON(1);
>   enospc:
>   	if (right)
>   		free_extent_buffer(right);
> @@ -1425,9 +1425,9 @@ static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
>   	lower = path->nodes[level];
>   	nritems = btrfs_header_nritems(lower);
>   	if (slot > nritems)
> -		BUG();
> +		BUG_ON(1);
>   	if (nritems == BTRFS_NODEPTRS_PER_BLOCK(root))
> -		BUG();
> +		BUG_ON(1);

These are perfect cases for ASSERT()

>   	if (slot != nritems) {
>   		memmove_extent_buffer(lower,
>   			      btrfs_node_key_ptr_offset(slot + 1),
> @@ -2213,7 +2213,7 @@ split:
>   	ret = 0;
>   	if (btrfs_leaf_free_space(root, leaf) < 0) {
>   		btrfs_print_leaf(root, leaf);
> -		BUG();
> +		BUG_ON(1);

For stuff like this we could add a ASSERT_LEAF() or something like that 
to do the btrfs_print_leaf first and then do the normal panic thing.
>   	}
>   	kfree(buf);
>   	return ret;
> @@ -2311,7 +2311,7 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
>   	ret = 0;
>   	if (btrfs_leaf_free_space(root, leaf) < 0) {
>   		btrfs_print_leaf(root, leaf);
> -		BUG();
> +		BUG_ON(1);
>   	}
>   	return ret;
>   }
> @@ -2337,7 +2337,7 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
>   
>   	if (btrfs_leaf_free_space(root, leaf) < data_size) {
>   		btrfs_print_leaf(root, leaf);
> -		BUG();
> +		BUG_ON(1);
>   	}
>   	slot = path->slots[0];
>   	old_data = btrfs_item_end_nr(leaf, slot);
> @@ -2374,7 +2374,7 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
>   	ret = 0;
>   	if (btrfs_leaf_free_space(root, leaf) < 0) {
>   		btrfs_print_leaf(root, leaf);
> -		BUG();
> +		BUG_ON(1);
>   	}
>   	return ret;
>   }
> @@ -2406,7 +2406,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
>   
>   	/* create a root if there isn't one */
>   	if (!root->node)
> -		BUG();
> +		BUG_ON(1);
>   
>   	total_size = total_data + nr * sizeof(struct btrfs_item);
>   	ret = btrfs_search_slot(trans, root, cpu_key, path, total_size, 1);
> @@ -2425,7 +2425,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
>   		btrfs_print_leaf(root, leaf);
>   		printk("not enough freespace need %u have %d\n",
>   		       total_size, btrfs_leaf_free_space(root, leaf));
> -		BUG();
> +		BUG_ON(1);
>   	}
>   
>   	slot = path->slots[0];
> @@ -2484,7 +2484,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
>   
>   	if (btrfs_leaf_free_space(root, leaf) < 0) {
>   		btrfs_print_leaf(root, leaf);
> -		BUG();
> +		BUG_ON(1);
>   	}
>   
>   out:
> diff --git a/ctree.h b/ctree.h
> index a9c67b2..101389b 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -1519,7 +1519,7 @@ static inline u32 btrfs_extent_inline_ref_size(int type)
>   	if (type == BTRFS_EXTENT_DATA_REF_KEY)
>   		return sizeof(struct btrfs_extent_data_ref) +
>   		       offsetof(struct btrfs_extent_inline_ref, offset);
> -	BUG();
> +	BUG_ON(1);
>   	return 0;
>   }
>   
> diff --git a/disk-io.c b/disk-io.c
> index e840177..2a6c68f 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -349,10 +349,10 @@ static int write_tree_block(struct btrfs_trans_handle *trans,
>   		     struct extent_buffer *eb)
>   {
>   	if (check_tree_block(root, eb))
> -		BUG();
> +		BUG_ON(1);
>   
>   	if (!btrfs_buffer_uptodate(eb, trans->transid))
> -		BUG();
> +		BUG_ON(1);
>   
>   	btrfs_set_header_flag(eb, BTRFS_HEADER_FLAG_WRITTEN);
>   	csum_tree_block(root, eb, 0);
> diff --git a/extent-tree.c b/extent-tree.c
> index 7860d1d..f1d724d 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -830,7 +830,7 @@ static noinline int remove_extent_data_ref(struct btrfs_trans_handle *trans,
>   		num_refs = btrfs_ref_count_v0(leaf, ref0);
>   #endif
>   	} else {
> -		BUG();
> +		BUG_ON(1);
>   	}
>   
>   	BUG_ON(num_refs < refs_to_drop);
> @@ -893,7 +893,7 @@ static noinline u32 extent_data_ref_count(struct btrfs_root *root,
>   		num_refs = btrfs_ref_count_v0(leaf, ref0);
>   #endif
>   	} else {
> -		BUG();
> +		BUG_ON(1);
>   	}
>   	return num_refs;
>   }
> @@ -1550,7 +1550,7 @@ again:
>   			/* FIXME: this isn't correct for data */
>   			extent_flags = BTRFS_BLOCK_FLAG_FULL_BACKREF;
>   #else
> -			BUG();
> +			BUG_ON(1);
>   #endif
>   	}
>   	item = btrfs_item_ptr(l, path->slots[0], struct btrfs_extent_item);
> diff --git a/extent_io.c b/extent_io.c
> index a127e54..d2d28f8 100644
> --- a/extent_io.c
> +++ b/extent_io.c
> @@ -573,7 +573,7 @@ static struct extent_buffer *__alloc_extent_buffer(struct extent_io_tree *tree,
>   
>   	eb = malloc(sizeof(struct extent_buffer) + blocksize);
>   	if (!eb) {
> -		BUG();
> +		BUG_ON(1);
>   		return NULL;
>   	}
>   	memset(eb, 0, sizeof(struct extent_buffer) + blocksize);
> diff --git a/file-item.c b/file-item.c
> index 6f3708b..0a73640 100644
> --- a/file-item.c
> +++ b/file-item.c
> @@ -242,7 +242,7 @@ int btrfs_csum_file_block(struct btrfs_trans_handle *trans,
>   	if (ret < 0)
>   		goto fail;
>   	if (ret == 0) {
> -		BUG();
> +		BUG_ON(1);
>   	}
>   	if (path->slots[0] == 0) {
>   		goto insert;
> @@ -370,7 +370,7 @@ static noinline int truncate_one_csum(struct btrfs_trans_handle *trans,
>   		ret = btrfs_set_item_key_safe(root, path, key);
>   		BUG_ON(ret);
>   	} else {
> -		BUG();
> +		BUG_ON(1);
>   	}
>   	return 0;
>   }
> diff --git a/print-tree.c b/print-tree.c
> index 9b90f9b..b56663a 100644
> --- a/print-tree.c
> +++ b/print-tree.c
> @@ -264,7 +264,7 @@ static void print_extent_item(struct extent_buffer *eb, int slot, int metadata)
>   		       btrfs_extent_refs_v0(eb, ei0));
>   		return;
>   #else
> -		BUG();
> +		BUG_ON(1);
>   #endif
>   	}
>   
> @@ -817,7 +817,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
>   #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
>   			print_extent_ref_v0(l, i);
>   #else
> -			BUG();
> +			BUG_ON(1);
>   #endif
>   			break;
>   		case BTRFS_CSUM_ITEM_KEY:
> @@ -985,10 +985,10 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
>   		}
>   		if (btrfs_is_leaf(next) &&
>   		    btrfs_header_level(eb) != 1)
> -			BUG();
> +			BUG_ON(1);
>   		if (btrfs_header_level(next) !=
>   			btrfs_header_level(eb) - 1)
> -			BUG();
> +			BUG_ON(1);
>   		btrfs_print_tree(root, next, 1);
>   		free_extent_buffer(next);
>   	}
> diff --git a/volumes.c b/volumes.c
> index 8c45851..7d71a97 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -1722,7 +1722,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
>   			num_stripes = btrfs_chunk_num_stripes(sb, chunk);
>   			len = btrfs_chunk_item_size(num_stripes);
>   		} else {
> -			BUG();
> +			BUG_ON(1);
>   		}
>   		ptr += len;
>   	}
> @@ -1848,7 +1848,7 @@ static void split_eb_for_raid56(struct btrfs_fs_info *info,
>   
>   		eb = malloc(sizeof(struct extent_buffer) + stripe_len);
>   		if (!eb)
> -			BUG();
> +			BUG_ON(1);

Stuff like this needs to be flipped over to returning an error. Thanks,

Josef
