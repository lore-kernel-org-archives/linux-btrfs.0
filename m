Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49494 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726128AbeITXAO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 19:00:14 -0400
Date: Thu, 20 Sep 2018 19:15:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v8 6/6] Btrfs: support swap files
Message-ID: <20180920171541.GD5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1537419652.git.osandov@fb.com>
 <0a585197abaedd39d0f6caec59ce3976f4654752.1537419652.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0a585197abaedd39d0f6caec59ce3976f4654752.1537419652.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2018 at 10:02:17PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Btrfs has not allowed swap files since commit 35054394c4b3 ("Btrfs: stop
> providing a bmap operation to avoid swapfile corruptions"). However, now
> that the proper restrictions are in place, Btrfs can support swap files
> through the swap file a_ops, similar to iomap in commit 67482129cdab
> ("iomap: add a swapfile activation function").
> 
> For Btrfs, activation needs to make sure that the file can be used as a
> swap file, which currently means that it must be fully allocated as
> nocow with no compression on one device. It must also do the proper
> tracking so that ioctls will not interfere with the swap file.
> Deactivation clears this tracking.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/inode.c | 317 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 317 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3ea5339603cf..0586285b1d9f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -27,6 +27,7 @@
>  #include <linux/uio.h>
>  #include <linux/magic.h>
>  #include <linux/iversion.h>
> +#include <linux/swap.h>
>  #include <asm/unaligned.h>
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -10488,6 +10489,320 @@ void btrfs_set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
>  	}
>  }
>  
> +/*
> + * Add an entry indicating a block group or device which is pinned by a
> + * swapfile. Returns 0 on success, 1 if there is already an entry for it, or a
> + * negative errno on failure.
> + */
> +static int btrfs_add_swapfile_pin(struct inode *inode, void *ptr,
> +				  bool is_block_group)
> +{
> +	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
> +	struct btrfs_swapfile_pin *sp, *entry;
> +	struct rb_node **p;
> +	struct rb_node *parent = NULL;
> +
> +	sp = kmalloc(sizeof(*sp), GFP_NOFS);
> +	if (!sp)
> +		return -ENOMEM;
> +	sp->ptr = ptr;
> +	sp->inode = inode;
> +	sp->is_block_group = is_block_group;
> +
> +	spin_lock(&fs_info->swapfile_pins_lock);
> +	p = &fs_info->swapfile_pins.rb_node;
> +	while (*p) {
> +		parent = *p;
> +		entry = rb_entry(parent, struct btrfs_swapfile_pin, node);
> +		if (sp->ptr < entry->ptr ||
> +		    (sp->ptr == entry->ptr && sp->inode < entry->inode)) {
> +			p = &(*p)->rb_left;
> +		} else if (sp->ptr > entry->ptr ||
> +			   (sp->ptr == entry->ptr && sp->inode > entry->inode)) {
> +			p = &(*p)->rb_right;
> +		} else {
> +			spin_unlock(&fs_info->swapfile_pins_lock);
> +			kfree(sp);
> +			return 1;
> +		}
> +	}
> +	rb_link_node(&sp->node, parent, p);
> +	rb_insert_color(&sp->node, &fs_info->swapfile_pins);
> +	spin_unlock(&fs_info->swapfile_pins_lock);
> +	return 0;
> +}
> +
> +/* Free all of the entries pinned by this swapfile. */
> +static void btrfs_free_swapfile_pins(struct inode *inode)
> +{
> +	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
> +	struct btrfs_swapfile_pin *sp;
> +	struct rb_node *node, *next;
> +
> +	spin_lock(&fs_info->swapfile_pins_lock);
> +	node = rb_first(&fs_info->swapfile_pins);
> +	while (node) {
> +		next = rb_next(node);
> +		sp = rb_entry(node, struct btrfs_swapfile_pin, node);
> +		if (sp->inode == inode) {
> +			rb_erase(&sp->node, &fs_info->swapfile_pins);
> +			if (sp->is_block_group)
> +				btrfs_put_block_group(sp->ptr);
> +			kfree(sp);
> +		}
> +		node = next;
> +	}
> +	spin_unlock(&fs_info->swapfile_pins_lock);
> +}
> +
> +struct btrfs_swap_info {
> +	u64 start;
> +	u64 block_start;
> +	u64 block_len;
> +	u64 lowest_ppage;
> +	u64 highest_ppage;
> +	unsigned long nr_pages;
> +	int nr_extents;
> +};
> +
> +static int btrfs_add_swap_extent(struct swap_info_struct *sis,
> +				 struct btrfs_swap_info *bsi)
> +{
> +	unsigned long nr_pages;
> +	u64 first_ppage, first_ppage_reported, next_ppage;
> +	int ret;
> +
> +	first_ppage = ALIGN(bsi->block_start, PAGE_SIZE) >> PAGE_SHIFT;
> +	next_ppage = ALIGN_DOWN(bsi->block_start + bsi->block_len,
> +				PAGE_SIZE) >> PAGE_SHIFT;
> +
> +	if (first_ppage >= next_ppage)
> +		return 0;
> +	nr_pages = next_ppage - first_ppage;
> +
> +	first_ppage_reported = first_ppage;
> +	if (bsi->start == 0)
> +		first_ppage_reported++;
> +	if (bsi->lowest_ppage > first_ppage_reported)
> +		bsi->lowest_ppage = first_ppage_reported;
> +	if (bsi->highest_ppage < (next_ppage - 1))
> +		bsi->highest_ppage = next_ppage - 1;
> +
> +	ret = add_swap_extent(sis, bsi->nr_pages, nr_pages, first_ppage);
> +	if (ret < 0)
> +		return ret;
> +	bsi->nr_extents += ret;
> +	bsi->nr_pages += nr_pages;
> +	return 0;
> +}
> +
> +static void btrfs_swap_deactivate(struct file *file)
> +{
> +	struct inode *inode = file_inode(file);
> +
> +	btrfs_free_swapfile_pins(inode);
> +	atomic_dec(&BTRFS_I(inode)->root->nr_swapfiles);
> +}
> +
> +static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
> +			       sector_t *span)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
> +	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
> +	struct extent_state *cached_state = NULL;
> +	struct extent_map *em = NULL;
> +	struct btrfs_device *device = NULL;
> +	struct btrfs_swap_info bsi = {
> +		.lowest_ppage = (sector_t)-1ULL,
> +	};
> +	int ret = 0;
> +	u64 isize = inode->i_size;
> +	u64 start;
> +
> +	/*
> +	 * If the swap file was just created, make sure delalloc is done. If the
> +	 * file changes again after this, the user is doing something stupid and
> +	 * we don't really care.
> +	 */
> +	ret = btrfs_wait_ordered_range(inode, 0, (u64)-1);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * The inode is locked, so these flags won't change after we check them.
> +	 */
> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS) {
> +		btrfs_info(fs_info, "swapfile must not be compressed");
> +		return -EINVAL;
> +	}
> +	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW)) {
> +		btrfs_info(fs_info, "swapfile must not be copy-on-write");
> +		return -EINVAL;
> +	}

I wonder if we should also explicitly check for the checkums flag, ie.
that NODATASUM is present. Right now it's bound to NODATACOW, but as
with other sanity checks, it does not hurt to have it here.

> +
> +	/*
> +	 * Balance or device remove/replace/resize can move stuff around from
> +	 * under us. The EXCL_OP flag makes sure they aren't running/won't run
> +	 * concurrently while we are mapping the swap extents, and
> +	 * fs_info->swapfile_pins prevents them from running while the swap file
> +	 * is active and moving the extents. Note that this also prevents a
> +	 * concurrent device add which isn't actually necessary, but it's not
> +	 * really worth the trouble to allow it.
> +	 */
> +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
> +		return -EBUSY;

This could be also accompanied by a message, "why does not my swapfile
activate?" -> "there's an exclusive operation running". I've checked if
there are similar messages for the other exclusive ops. There are.
