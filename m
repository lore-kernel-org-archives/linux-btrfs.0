Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53051 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751948AbdKGVOp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 16:14:45 -0500
Date: Tue, 7 Nov 2017 22:12:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, lakshmipathi.g@gmail.com,
        Filipe Manana <fdmanana@gmail.com>
Subject: Re: [PATCH] btrfs: tree-checker: Fix false panic for sanity test
Message-ID: <20171107211252.GG27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171106054717.18952-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171106054717.18952-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 01:47:17PM +0800, Qu Wenruo wrote:
> [BUG]
> If we run btrfs with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y, it will
> instantly cause kernel panic like:

Which patch causes that? The selftests used to catch various errors when
the original dir_item verification patches were merged. Plus some
fstests were failing. I burned a lot of time on that and don't want to
repeat that, so I expect that all tree-checker patches pass self-test
(incrementally, not just the whole series) and all relevant fstests.

> 
> ------
> ...
> assertion failed: 0, file: fs/btrfs/disk-io.c, line: 3853
> ...
> Call Trace:
>  btrfs_mark_buffer_dirty+0x187/0x1f0 [btrfs]
>  setup_items_for_insert+0x385/0x650 [btrfs]
>  __btrfs_drop_extents+0x129a/0x1870 [btrfs]
> ...
> -----
> 
> [Cause]
> Btrfs will call btrfs_check_leaf() in btrfs_mark_buffer_dirty() to check
> if the leaf is valid with CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y.
> 
> However quite some btrfs_mark_buffer_dirty() callers(*) don't really
> initialize its item data but only initialize its item pointers, leaving
> item data uninitialized.
> 
> This makes tree-checker catch uninitialized data as error, causing
> such panic.
> 
> *: These callers include but not limited to
> setup_items_for_insert()
> btrfs_split_item()
> btrfs_expand_item()
> 
> [Fix]
> Add a new parameter @check_item_data to btrfs_check_leaf().
> With @check_item_data set to false, item data check will be skipped and
> fallback to old btrfs_check_leaf() behavior.

So this looks like a patch ordering problem. The weaker version of
btrfs_check_leaf needs to come first and then the improved checks that
cause the crashes.

> So we can still get early warning if we screw up item pointers, and
> avoid false panic.
> 
> Cc: Filipe Manana <fdmanana@gmail.com>
> Reported-by: Lakshmipathi.G <lakshmipathi.g@gmail.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/disk-io.c      |  5 +++--
>  fs/btrfs/tree-checker.c | 16 +++++++++++-----
>  fs/btrfs/tree-checker.h |  3 ++-
>  3 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index efce9a2fa9be..c65b63d6df27 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -610,7 +610,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  	 * that we don't try and read the other copies of this block, just
>  	 * return -EIO.
>  	 */
> -	if (found_level == 0 && btrfs_check_leaf(root, eb)) {
> +	if (found_level == 0 && btrfs_check_leaf(root, eb, true)) {
>  		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
>  		ret = -EIO;
>  	}
> @@ -3848,7 +3848,8 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
>  					 buf->len,
>  					 fs_info->dirty_metadata_batch);
>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
> -	if (btrfs_header_level(buf) == 0 && btrfs_check_leaf(root, buf)) {
> +	if (btrfs_header_level(buf) == 0 &&
> +	    btrfs_check_leaf(root, buf, false)) {
>  		btrfs_print_leaf(buf);
>  		ASSERT(0);
>  	}
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 114fc5f0ecc5..a4c2517fa2a1 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -242,7 +242,8 @@ static int check_leaf_item(struct btrfs_root *root,
>  	return ret;
>  }
>  
> -int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
> +int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf,
> +		     bool check_item_data)

The bool arguments are usally not very descriptive, I suggest to add

static inline int btrfs_check_leaf_relaxed(struct btrfs_root *root, struct extent_buffer *leaf)
{
	return btrfs_check_leaf_root, leaf, false);
}

to tree-check.h and use where appropriate.
