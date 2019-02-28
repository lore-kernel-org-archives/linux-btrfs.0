Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F419C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 15:31:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AEAB20C01
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 15:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbfB1PbX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:31:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:35676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387485AbfB1PbW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 10:31:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D50D6AFF0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 15:31:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 52ECEDA944; Thu, 28 Feb 2019 16:32:41 +0100 (CET)
Date:   Thu, 28 Feb 2019 16:32:41 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Introduce extent_io_tree::owner to
 distinguish different io_trees
Message-ID: <20190228153241.GI31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190228100255.10953-1-wqu@suse.com>
 <20190228100255.10953-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228100255.10953-2-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 28, 2019 at 06:02:54PM +0800, Qu Wenruo wrote:
> Btrfs has the following different extent_io_trees used:
> - fs_info::free_extents[2]
> - btrfs_inode::io_tree
>   For both normal inodes and btree inode
> - btrfs_inode::io_failure_tree
> - btrfs_transaction::dirty_pages
> - btrfs_root::dirty_log_pages
> 
> If we want to trace bits change in those io_trees, it will be pretty
> hard to distinguish them.
> 
> Instead of using hard-to-read pointer address, this patch will introduc
> a new member extent_io_tree::owner, which uses the unpopulated bits of
> extent_io_tree::track_uptodate, to track who owns this extent_io_tree.
> 
> This modification needs all the callers of extent_io_tree_init() to
> accept a new parameter @owner.
> 
> This patch provides the basis for later ftrace events.

Nice.

> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c               | 12 ++++++++----
>  fs/btrfs/extent_io.c             |  3 ++-
>  fs/btrfs/extent_io.h             | 20 ++++++++++++++++++--
>  fs/btrfs/inode.c                 |  5 +++--
>  fs/btrfs/relocation.c            |  3 ++-
>  fs/btrfs/tests/btrfs-tests.c     |  6 ++++--
>  fs/btrfs/tests/extent-io-tests.c |  2 +-
>  fs/btrfs/transaction.c           |  2 +-
>  8 files changed, 39 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 6a2a2a951705..ab5b23be086c 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1205,7 +1205,8 @@ static void __setup_root(struct btrfs_root *root, struct btrfs_fs_info *fs_info,
>  	root->log_transid_committed = -1;
>  	root->last_log_commit = 0;
>  	if (!dummy)
> -		extent_io_tree_init(&root->dirty_log_pages, NULL);
> +		extent_io_tree_init(&root->dirty_log_pages,
> +				    IO_TREE_ROOT_DIRTY_LOG_PAGES, NULL);
>  
>  	memset(&root->root_key, 0, sizeof(root->root_key));
>  	memset(&root->root_item, 0, sizeof(root->root_item));
> @@ -2129,7 +2130,8 @@ static void btrfs_init_btree_inode(struct btrfs_fs_info *fs_info)
>  	inode->i_mapping->a_ops = &btree_aops;
>  
>  	RB_CLEAR_NODE(&BTRFS_I(inode)->rb_node);
> -	extent_io_tree_init(&BTRFS_I(inode)->io_tree, inode);
> +	extent_io_tree_init(&BTRFS_I(inode)->io_tree, IO_TREE_INODE_IO_TREE,
> +			    inode);
>  	BTRFS_I(inode)->io_tree.track_uptodate = 0;
>  	extent_map_tree_init(&BTRFS_I(inode)->extent_tree);
>  
> @@ -2739,8 +2741,10 @@ int open_ctree(struct super_block *sb,
>  	fs_info->block_group_cache_tree = RB_ROOT;
>  	fs_info->first_logical_byte = (u64)-1;
>  
> -	extent_io_tree_init(&fs_info->freed_extents[0], NULL);
> -	extent_io_tree_init(&fs_info->freed_extents[1], NULL);
> +	extent_io_tree_init(&fs_info->freed_extents[0],
> +			    IO_TREE_FS_INFO_FREED_EXTENTS0, NULL);
> +	extent_io_tree_init(&fs_info->freed_extents[1],
> +			    IO_TREE_FS_INFO_FREED_EXTENTS1, NULL);
>  	fs_info->pinned_extents = &fs_info->freed_extents[0];
>  	set_bit(BTRFS_FS_BARRIER, &fs_info->flags);
>  
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 52abe4082680..8b1d76261e53 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -200,7 +200,7 @@ void __cold extent_io_exit(void)
>  	bioset_exit(&btrfs_bioset);
>  }
>  
> -void extent_io_tree_init(struct extent_io_tree *tree,
> +void extent_io_tree_init(struct extent_io_tree *tree, unsigned int owner,
>  			 void *private_data)
>  {
>  	tree->state = RB_ROOT;
> @@ -208,6 +208,7 @@ void extent_io_tree_init(struct extent_io_tree *tree,
>  	tree->dirty_bytes = 0;
>  	spin_lock_init(&tree->lock);
>  	tree->private_data = private_data;
> +	tree->owner = owner;
>  }
>  
>  static struct extent_state *alloc_extent_state(gfp_t mask)
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 9673be3f3d1f..84654157ca92 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -107,11 +107,26 @@ struct extent_io_ops {
>  				    int mirror);
>  };
>  
> +enum {
> +	IO_TREE_FS_INFO_FREED_EXTENTS0,
> +	IO_TREE_FS_INFO_FREED_EXTENTS1,
> +	IO_TREE_INODE_IO_TREE,
> +	IO_TREE_INODE_IO_FAILURE_TREE,
> +	IO_TREE_RELOCATION_PROCESSED_BLOCKS,

That's 35 chars long, looks like you got some inspiration in the device
replace identifiers but it's not the example to follow.
IO_TREE_RELOC_BLOCKS. Others look ok.

> +	IO_TREE_TRANSACTION_DIRTY_PAGES,
> +	IO_TREE_ROOT_DIRTY_LOG_PAGES,
> +	IO_TREE_TMP,

That one is for tests so the name should reflect it.

> +};
> +
>  struct extent_io_tree {
>  	struct rb_root state;
>  	void *private_data;
>  	u64 dirty_bytes;
> -	int track_uptodate;
> +	unsigned int track_uptodate:1;
> +
> +	/* who owns this io tree, should be above IO_TREE_* enum */
> +	unsigned int owner:15;
> +
>  	spinlock_t lock;

Note that spinlocks next to bitfields is an unsafe construct that can
lead to corrupted locks if the bitfield update is not atomic. This
happens on some arches.

You can use bool for track_uptodate and char or u8 for the owner.

>  	const struct extent_io_ops *ops;
>  };
