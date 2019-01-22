Return-Path: <SRS0=kIOr=P6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E694EC282C3
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 16:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A86A921726
	for <linux-btrfs@archiver.kernel.org>; Tue, 22 Jan 2019 16:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfAVQ4g (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:56:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:48760 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729460AbfAVQ4g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Jan 2019 11:56:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17E8FB0B1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2019 16:56:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C0363DA84A; Tue, 22 Jan 2019 17:55:57 +0100 (CET)
Date:   Tue, 22 Jan 2019 17:55:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 5/7] btrfs: qgroup: Introduce per-root swapped blocks
 infrastructure
Message-ID: <20190122165554.GO2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190115081604.785-6-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115081604.785-6-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 15, 2019 at 04:16:02PM +0800, Qu Wenruo wrote:
> +/*
> + * Record swapped tree blocks of a file/subvolume tree for delayed subtree
> + * trace code. For detail check comment in fs/btrfs/qgroup.c.
> + */
> +struct btrfs_qgroup_swapped_blocks {
> +	spinlock_t lock;
> +	struct rb_root blocks[BTRFS_MAX_LEVEL];
> +	/* RM_EMPTY_ROOT() of above blocks[] */
> +	bool swapped;

Reordering 'swapped' after the lock will save at least 8 bytes of the
structure size due to padding.

> +};
> +
>  /*
>   * in ram representation of the tree.  extent_root is used for all allocations
>   * and for the extent tree extent_root root.
> @@ -1339,6 +1350,9 @@ struct btrfs_root {
>  	/* Number of active swapfiles */
>  	atomic_t nr_swapfiles;
>  
> +	/* Record pairs of swapped blocks for qgroup */
> +	struct btrfs_qgroup_swapped_blocks swapped_blocks;
> +
>  #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>  	u64 alloc_bytenr;
>  #endif
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index bfefa1de0455..31b2facdfc1e 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1219,6 +1219,7 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
>  	root->anon_dev = 0;
>  
>  	spin_lock_init(&root->root_item_lock);
> +	btrfs_qgroup_init_swapped_blocks(&root->swapped_blocks);
>  }
>  
>  static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info,
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 8fe6ebe9aef8..001830328960 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3797,3 +3797,133 @@ void btrfs_qgroup_check_reserved_leak(struct inode *inode)
>  	}
>  	extent_changeset_release(&changeset);
>  }
> +
> +/*
> + * Delete all swapped blocks record of @root.
> + * Every record here means we skipped a full subtree scan for qgroup.
> + *
> + * Get called when commit one transaction.
> + */
> +void btrfs_qgroup_clean_swapped_blocks(struct btrfs_root *root)
> +{
> +	struct btrfs_qgroup_swapped_blocks *swapped_blocks;
> +	int i;
> +
> +	swapped_blocks = &root->swapped_blocks;
> +
> +	spin_lock(&swapped_blocks->lock);
> +	if (!swapped_blocks->swapped)
> +		goto out;
> +	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
> +		struct rb_root *cur_root = &swapped_blocks->blocks[i];
> +		struct btrfs_qgroup_swapped_block *entry;
> +		struct btrfs_qgroup_swapped_block *next;
> +
> +		rbtree_postorder_for_each_entry_safe(entry, next, cur_root,
> +						     node)
> +			kfree(entry);
> +		swapped_blocks->blocks[i] = RB_ROOT;
> +	}
> +	swapped_blocks->swapped = false;
> +out:
> +	spin_unlock(&swapped_blocks->lock);
> +}
> +
> +/*
> + * Adding subtree roots record into @subv_root.
> + *
> + * @subv_root:		tree root of the subvolume tree get swapped
> + * @bg:			block group under balance
> + * @subv_parent/slot:	pointer to the subtree root in file tree
> + * @reloc_parent/slot:	pointer to the subtree root in reloc tree
> + *			BOTH POINTERS ARE BEFORE TREE SWAP
> + * @last_snapshot:	last snapshot generation of the file tree
> + */
> +int btrfs_qgroup_add_swapped_blocks(struct btrfs_trans_handle *trans,
> +		struct btrfs_root *subv_root,
> +		struct btrfs_block_group_cache *bg,
> +		struct extent_buffer *subv_parent, int subv_slot,
> +		struct extent_buffer *reloc_parent, int reloc_slot,
> +		u64 last_snapshot)
> +{
> +	int level = btrfs_header_level(subv_parent) - 1;
> +	struct btrfs_qgroup_swapped_blocks *blocks = &subv_root->swapped_blocks;
> +	struct btrfs_fs_info *fs_info = subv_root->fs_info;
> +	struct btrfs_qgroup_swapped_block *block;
> +	struct rb_node **p = &blocks->blocks[level].rb_node;

Please rename 'p' to somethign that's not single letter and move the
initialization before the block that uses it.

> +	struct rb_node *parent = NULL;
> +	int ret = 0;
> +
> +	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
> +		return 0;
> +
> +	if (btrfs_node_ptr_generation(subv_parent, subv_slot) >
> +		btrfs_node_ptr_generation(reloc_parent, reloc_slot)) {
> +		btrfs_err_rl(fs_info,
> +		"%s: bad parameter order, subv_gen=%llu reloc_gen=%llu",
> +			__func__,
> +			btrfs_node_ptr_generation(subv_parent, subv_slot),
> +			btrfs_node_ptr_generation(reloc_parent, reloc_slot));
> +		return -EUCLEAN;
> +	}
> +
> +	block = kmalloc(sizeof(*block), GFP_NOFS);
> +	if (!block) {
> +		ret = -ENOMEM;

This goes to 'out' that marks quota as inconsistent, is this
intentional? Ie. if this function does not succed for whatever reason,
the quotas are indeed inconsistent.

> +		goto out;
> +	}
> +
> +	/*
> +	 * @reloc_parent/slot is still *BEFORE* swap, while @block is going to
> +	 * record the bytenr *AFTER* swap, so we do the swap here.

You don't need to *EMPHASIZE* that much

> +	 */
> +	block->subv_bytenr = btrfs_node_blockptr(reloc_parent, reloc_slot);
> +	block->subv_generation = btrfs_node_ptr_generation(reloc_parent,
> +							   reloc_slot);
> +	block->reloc_bytenr = btrfs_node_blockptr(subv_parent, subv_slot);
> +	block->reloc_generation = btrfs_node_ptr_generation(subv_parent,
> +							    subv_slot);
> +	block->last_snapshot = last_snapshot;
> +	block->level = level;
> +	if (bg->flags & BTRFS_BLOCK_GROUP_DATA)
> +		block->trace_leaf = true;
> +	else
> +		block->trace_leaf = false;
> +	btrfs_node_key_to_cpu(reloc_parent, &block->first_key, reloc_slot);
> +
> +	/* Insert @block into @blocks */
> +	spin_lock(&blocks->lock);

The initialization of p would go here

> +	while (*p) {
> +		struct btrfs_qgroup_swapped_block *entry;
> +
> +		parent = *p;
> +		entry = rb_entry(parent, struct btrfs_qgroup_swapped_block,
> +				 node);
> +
> +		if (entry->subv_bytenr < block->subv_bytenr)
> +			p = &(*p)->rb_left;
> +		else if (entry->subv_bytenr > block->subv_bytenr)
> +			p = &(*p)->rb_right;
> +		else {

I've pointed out missing { } around if/else if/else statemtents in patch
1, would be good if you fix all patches.

> +			if (entry->subv_generation != block->subv_generation ||
> +			    entry->reloc_bytenr != block->reloc_bytenr ||
> +			    entry->reloc_generation !=
> +			    block->reloc_generation) {
> +				WARN_ON_ONCE(1);

This would need some explanation why you want to see the warning. _ONCE
is for the whole lifetime of the module but I think you'd be interested
on a per-filesystem basis. If this is meant for developers it should go
under DEBUG, but otherwise I don't see what would this warning bring to
the users.

> +				ret = -EEXIST;
> +			}
> +			kfree(block);
> +			goto out_unlock;
> +		}
> +	}
> +	rb_link_node(&block->node, parent, p);
> +	rb_insert_color(&block->node, &blocks->blocks[level]);
> +	blocks->swapped = true;
> +out_unlock:
> +	spin_unlock(&blocks->lock);
> +out:
> +	if (ret < 0)
> +		fs_info->qgroup_flags |=
> +			BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
> +	return ret;
> +}
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index 226956f0bd73..93d7f0998f03 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -6,6 +6,8 @@
>  #ifndef BTRFS_QGROUP_H
>  #define BTRFS_QGROUP_H
>  
> +#include <linux/spinlock.h>
> +#include <linux/rbtree.h>
>  #include "ulist.h"
>  #include "delayed-ref.h"
>  
> @@ -37,6 +39,66 @@
>   *    Normally at qgroup rescan and transaction commit time.
>   */
>  
> +/*
> + * Special performance hack for balance.

Is it really a hack? Hack sounds cool, but isn't it just an optimization?

> + *
> + * For balance, we need to swap subtree of file and reloc tree.
> + * In theory, we need to trace all subtree blocks of both file and reloc tree,
> + * since their owner has changed during such swap.
> + *
> + * However since balance has ensured that both subtrees are containing the
> + * same contents and have the same tree structures, such swap won't cause
> + * qgroup number change.
> + *
> + * But there is a race window between subtree swap and transaction commit,
> + * during that window, if we increase/decrease tree level or merge/split tree
> + * blocks, we still needs to trace original subtrees.
> + *
> + * So for balance, we use a delayed subtree trace, whose workflow is:
> + *
> + * 1) Record the subtree root block get swapped.
> + *
> + *    During subtree swap:
> + *    O = Old tree blocks
> + *    N = New tree blocks
> + *          reloc tree                         file tree X
> + *             Root                               Root
> + *            /    \                             /    \
> + *          NA     OB                          OA      OB
> + *        /  |     |  \                      /  |      |  \
> + *      NC  ND     OE  OF                   OC  OD     OE  OF
> + *
> + *   In these case, NA and OA is going to be swapped, record (NA, OA) into
> + *   file tree X.
> + *
> + * 2) After subtree swap.
> + *          reloc tree                         file tree X
> + *             Root                               Root
> + *            /    \                             /    \
> + *          OA     OB                          NA      OB
> + *        /  |     |  \                      /  |      |  \
> + *      OC  OD     OE  OF                   NC  ND     OE  OF
> + *
> + * 3a) CoW happens for OB
> + *     If we are going to CoW tree block OB, we check OB's bytenr against
> + *     tree X's swapped_blocks structure.
> + *     It doesn't fit any one, nothing will happen.
> + *
> + * 3b) CoW happens for NA
> + *     Check NA's bytenr against tree X's swapped_blocks, and get a hit.
> + *     Then we do subtree scan on both subtree OA and NA.
> + *     Resulting 6 tree blocks to be scanned (OA, OC, OD, NA, NC, ND).
> + *
> + *     Then no matter what we do to file tree X, qgroup numbers will
> + *     still be correct.
> + *     Then NA's record get removed from X's swapped_blocks.
> + *
> + * 4)  Transaction commit
> + *     Any record in X's swapped_blocks get removed, since there is no
> + *     modification to swapped subtrees, no need to trigger heavy qgroup
> + *     subtree rescan for them.
> + */
> +
>  /*
>   * Record a dirty extent, and info qgroup to update quota on it
>   * TODO: Use kmem cache to alloc it.
> @@ -59,6 +121,24 @@ struct btrfs_qgroup_extent_record {
>  	struct ulist *old_roots;
>  };
>  
> +struct btrfs_qgroup_swapped_block {
> +	struct rb_node node;
> +
> +	bool trace_leaf;
> +	int level;

Please reorder that so int goes before bool, othewise this adds
unnecessary padding.

> +
> +	/* bytenr/generation of the tree block in subvolume tree after swap */
> +	u64 subv_bytenr;
> +	u64 subv_generation;
> +
> +	/* bytenr/generation of the tree block in reloc tree after swap */
> +	u64 reloc_bytenr;
> +	u64 reloc_generation;
> +
> +	u64 last_snapshot;
> +	struct btrfs_key first_key;
> +};
> +
>  /*
>   * Qgroup reservation types:
>   *
> @@ -301,4 +381,23 @@ void btrfs_qgroup_convert_reserved_meta(struct btrfs_root *root, int num_bytes);
>  
>  void btrfs_qgroup_check_reserved_leak(struct inode *inode);
>  
> +/* btrfs_qgroup_swapped_blocks related functions */
> +static inline void btrfs_qgroup_init_swapped_blocks(

'inline' is not needed for a function that's called infrequently and
only from one location, an normal exported function would be ok.

> +		struct btrfs_qgroup_swapped_blocks *swapped_blocks)
> +{
> +	int i;
> +
> +	spin_lock_init(&swapped_blocks->lock);
> +	for (i = 0; i < BTRFS_MAX_LEVEL; i++)
> +		swapped_blocks->blocks[i] = RB_ROOT;
> +	swapped_blocks->swapped = false;
> +}
> +
> +void btrfs_qgroup_clean_swapped_blocks(struct btrfs_root *root);
> +int btrfs_qgroup_add_swapped_blocks(struct btrfs_trans_handle *trans,
> +		struct btrfs_root *subv_root,
> +		struct btrfs_block_group_cache *bg,
> +		struct extent_buffer *subv_parent, int subv_slot,
> +		struct extent_buffer *reloc_parent, int reloc_slot,
> +		u64 last_snapshot);

Please keep an empty line before the final #endif

>  #endif
