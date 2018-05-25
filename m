Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54431 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935638AbeEYKHD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 May 2018 06:07:03 -0400
Subject: Re: [RFC PATCH v4 6/6] Btrfs: support swap files
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
References: <cover.1527197312.git.osandov@fb.com>
 <cafafebe2e9aa01251e761093199966499127fe0.1527197312.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bc13c9f8-34b0-3566-5d4d-a2cb5040e0fa@suse.com>
Date: Fri, 25 May 2018 13:07:00 +0300
MIME-Version: 1.0
In-Reply-To: <cafafebe2e9aa01251e761093199966499127fe0.1527197312.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.05.2018 00:41, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Implement the swap file a_ops on Btrfs. Activation needs to make sure
> that the file can be used as a swap file, which currently means it must
> be fully allocated as nocow with no compression on one device. It also
> sets up the swap extents directly with add_swap_extent(), so export it.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

What testing (apart form the xfstest patches you sent) have this code
seen? Have you run it with lockdep enabled (I'm asking because when I
picked up your v3 there was quite a bunch of deadlock warnings). Also
see some inline questions below.

> ---
>  fs/btrfs/inode.c | 220 +++++++++++++++++++++++++++++++++++++++++++++++
>  mm/swapfile.c    |   1 +
>  2 files changed, 221 insertions(+)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9228cb866115..6cca8529e307 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -10526,6 +10526,224 @@ void btrfs_set_range_writeback(void *private_data, u64 start, u64 end)
>  	}
>  }
>  
<snip>
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
> +	 * The inode is locked, so these flags won't change after we check them.
> +	 */
> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS) {
> +		btrfs_err(fs_info, "swapfile is compressed");
> +		return -EINVAL;
> +	}
> +	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW)) {
> +		btrfs_err(fs_info, "swapfile is copy-on-write");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Balance or device remove/replace/resize can move stuff around from
> +	 * under us. The EXCL_OP flag makes sure they aren't running/won't run
> +	 * concurrently while we are mapping the swap extents, and the fs_info
> +	 * nr_swapfiles counter prevents them from running while the swap file
> +	 * is active and moving the extents. Note that this also prevents a
> +	 * concurrent device add which isn't actually necessary, but it's not
> +	 * really worth the trouble to allow it.
> +	 */
> +	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
> +		return -EBUSY;
> +	atomic_inc(&fs_info->nr_swapfiles);
> +	/*
> +	 * Snapshots can create extents which require COW even if NODATACOW is
> +	 * set. We use this counter to prevent snapshots. We must increment it
> +	 * before walking the extents because we don't want a concurrent
> +	 * snapshot to run after we've already checked the extents.
> +	 */
> +	atomic_inc(&BTRFS_I(inode)->root->nr_swapfiles);
> +
> +	lock_extent_bits(io_tree, 0, isize - 1, &cached_state);
> +	start = 0;
> +	while (start < isize) {
> +		u64 end, logical_block_start, physical_block_start;
> +		u64 len = isize - start;
> +
> +		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, len, 0);
> +		if (IS_ERR(em)) {
> +			ret = PTR_ERR(em);
> +			goto out;
> +		}
> +		end = extent_map_end(em);
> +
> +		if (em->block_start == EXTENT_MAP_HOLE) {
> +			btrfs_err(fs_info, "swapfile has holes");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		if (em->block_start == EXTENT_MAP_INLINE) {
> +			/*
> +			 * It's unlikely we'll ever actually find ourselves
> +			 * here, as a file small enough to fit inline won't be
> +			 * big enough to store more than the swap header, but in
> +			 * case something changes in the future, let's catch it
> +			 * here rather than later.
> +			 */
> +			btrfs_err(fs_info, "swapfile is inline");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
> +			btrfs_err(fs_info, "swapfile is compressed");
> +			ret = -EINVAL;
> +			goto out;
> +		}

Isn't this implied by the earlier BTRFS_I(inode)->flags &
BTRFS_INODE_COMPRESS check ?
> +
> +		logical_block_start = em->block_start + (start - em->start);

So which offset are you calculating by doing the start - em->start
calculation? start is really the ending logical address of the previous
extent but isn't this always < em->start of the next extent ?

> +		len = min(len, em->len - (start - em->start));
> +		free_extent_map(em);
> +		em = NULL;
> +
> +		ret = can_nocow_extent(inode, start, &len, NULL, NULL, NULL);
> +		if (ret < 0) {
> +			goto out;
> +		} else if (ret) {
> +			ret = 0;
> +		} else {
> +			btrfs_err(fs_info, "swapfile is copy-on-write");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		em = btrfs_get_chunk_map(fs_info, logical_block_start, len);
> +		if (IS_ERR(em)) {
> +			ret = PTR_ERR(em);
> +			goto out;
> +		}
> +
> +		if (em->map_lookup->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
> +			btrfs_err(fs_info, "swapfile data profile is not single");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		if (device == NULL) {
> +			device = em->map_lookup->stripes[0].dev;
> +		} else if (device != em->map_lookup->stripes[0].dev) {
> +			btrfs_err(fs_info, "swapfile is on multiple devices");
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
<snip>
