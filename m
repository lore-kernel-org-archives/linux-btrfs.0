From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v1 3/6] scrub: print paths of corrupted files
Date: Thu, 16 Jun 2011 23:26:14 +0200
Message-ID: <20110616212614.GC12709@twin.jikos.cz>
References: <cover.1307991539.git.list.btrfs@jan-o-sch.net>
 <4dff2bfbba0f059cf91185c290d0c78bf9f6648d.1307991539.git.list.btrfs@jan-o-sch.net>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4dff2bfbba0f059cf91185c290d0c78bf9f6648d.1307991539.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 13, 2011 at 09:10:36PM +0200, Jan Schmidt wrote:
> While scrubbing, we may encounter various errors. Previously, a logical
> address was printed to the log only. Now, all paths belonging to that
> address are resolved and printed separately. That should work for hardlinks
> as well as reflinks.
> 
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  fs/btrfs/scrub.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 137 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 00e4e58..e294d76 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -27,6 +27,7 @@
>  #include "volumes.h"
>  #include "disk-io.h"
>  #include "ordered-data.h"
> +#include "backref.h"
>  
>  /*
>   * This is only the first step towards a full-features scrub. It reads all
> @@ -106,6 +107,19 @@ struct scrub_dev {
>  	spinlock_t		stat_lock;
>  };
>  
> +struct scrub_warning {
> +	struct btrfs_path	*path;
> +	u64			extent_item_size;
> +	char			*scratch_buf;
> +	char			*msg_buf;
> +	const char		*errstr;
> +	u64			sector;

better named 'physical', like in scrub_bio

> +	u64			logical;
> +	struct btrfs_device	*dev;
> +	int			msg_bufsize;
> +	int			scratch_bufsize;
> +};
> +
>  static void scrub_free_csums(struct scrub_dev *sdev)
>  {
>  	while (!list_empty(&sdev->csum_list)) {
> @@ -201,6 +215,121 @@ nomem:
>  	return ERR_PTR(-ENOMEM);
>  }
>  
> +static int scrub_print_warning_inode(u64 inum, loff_t offset, void *ctx)
> +{
> +	u64 isize;
> +	int ret;
> +	struct extent_buffer *eb_i;

'eb' for consistency with others

> +	struct btrfs_inode_item *ii;

inode_item is a commonly used name

> +	struct scrub_warning *swarn = ctx;
> +	struct btrfs_fs_info *fs_info = swarn->dev->dev_root->fs_info;
> +	struct inode_fs_paths ipath;
> +
> +	ret = inode_item_info(inum, 0, fs_info->fs_root, swarn->path);
> +	if (ret) {
> +err:
> +		printk(KERN_WARNING "btrfs: %s at logical %llu on dev "
> +			"%s, sector %llu, inode %llu, offset %llu: path "
> +			"resolving failed with ret=%d\n", swarn->errstr,
> +			swarn->logical, swarn->dev->name, swarn->sector, inum,
> +			offset, ret);
> +		return 0;

please move it to the end after the other printk

> +	}
> +	eb_i = swarn->path->nodes[0];
> +	ii = btrfs_item_ptr(eb_i, swarn->path->slots[0],
> +				struct btrfs_inode_item);
> +	btrfs_release_path(swarn->path);
> +
> +	isize = btrfs_inode_size(eb_i, ii);
> +
> +	ipath.left = swarn->msg_bufsize - 1;
> +	ipath.dest = swarn->msg_buf;
> +	ipath.path = swarn->path;
> +	ipath.scratch_buf = swarn->scratch_buf;
> +	ipath.scratch_bufsize = swarn->scratch_bufsize;
> +	ipath.fs_root = fs_info->fs_root;
> +	ipath.eb_i = eb_i;
> +
> +	ret = paths_from_inode(inum, &ipath);
> +	if (ret < 0)
> +		goto err;
> +
> +	printk(KERN_WARNING "btrfs: %s at logical %llu on dev "
> +		"%s, sector %llu, inode %llu, offset %llu, "
> +		"length %llu, links %u (path:%s)\n", swarn->errstr,
> +		swarn->logical, swarn->dev->name, swarn->sector, inum, offset,
> +		min(isize - offset, (u64)PAGE_SIZE),
> +		btrfs_inode_nlink(eb_i, ii), swarn->msg_buf);
> +
> +	return 0;
> +}
> +
> +static void scrub_print_warning(const char *errstr, struct scrub_bio *sbio,
> +				int ix)

please rename 'ix' to eg 'idx', more readable

> +{
> +	struct btrfs_device *dev = sbio->sdev->dev;
> +	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
> +	struct btrfs_path *path;
> +	struct btrfs_key found_key;
> +	struct extent_buffer *eb;
> +	struct btrfs_extent_item *ei;
> +	struct scrub_warning swarn;
> +	u32 item_size;
> +	int ret;
> +	u64 ref_root;

i'm not able to understand what a u64 value describing a root means, seeing it
here or in the printk message. it's returned as 

	*dest_root = btrfs_extent_inline_ref_offset(eb, eiref);

can you please explain it to me?

> +	u64 ref_level;

int is enough, as noted elsewhere

> +	unsigned long ptr = 0;
> +	static const int bufsize = 4096;

drop static, this would allocate a memory cell to hold the value 4096, while
without it, it's just a named constant and this will make the compiler happy

> +	loff_t extent_item_offset;

loff_t is a signed long long, do you really need it?

> +
> +	path = btrfs_alloc_path();
> +
> +	swarn.scratch_buf = kmalloc(bufsize, GFP_NOFS);
> +	swarn.msg_buf = kmalloc(bufsize, GFP_NOFS);
> +	swarn.sector = (sbio->physical + ix * PAGE_SIZE) >> 9;
> +	swarn.logical = sbio->logical + ix * PAGE_SIZE;
> +	swarn.errstr = errstr;
> +	swarn.dev = dev;
> +	swarn.msg_bufsize = bufsize;
> +	swarn.scratch_bufsize = bufsize;
> +
> +	if (!path || !swarn.scratch_buf || !swarn.msg_buf)
> +		goto out;
> +
> +	ret = data_extent_from_logical(fs_info->extent_root,
> +					swarn.logical, path, &found_key);
> +	if (ret < 0)
> +		goto out;
> +
> +	extent_item_offset = swarn.logical - found_key.objectid;
> +	swarn.extent_item_size = found_key.offset;
> +
> +	eb = path->nodes[0];
> +	ei = btrfs_item_ptr(eb, path->slots[0], struct btrfs_extent_item);
> +	item_size = btrfs_item_size_nr(eb, path->slots[0]);
> +
> +	btrfs_release_path(path);

is it safe to release the path here? it's used in the else branch below

> +
> +	if (ret) {
> +		ret = tree_backref_for_extent(&ptr, eb, ei, item_size,
> +						&ref_root, &ref_level);
> +		printk(KERN_WARNING "%s at logical %llu on dev %s, "
> +			"sector %llu: metadata %s (level %llu) in tree %llu\n",
> +			errstr, swarn.logical, dev->name, swarn.sector,
> +			ref_level ? "node" : "leaf", ret < 0 ? -1 : ref_level,
> +			ret < 0 ? -1 : ref_root);
> +	} else {
> +		swarn.path = path;
> +		iterate_extent_inodes(eb, ei, extent_item_offset, item_size,
> +					scrub_print_warning_inode, &swarn);
> +	}
> +
> +out:
> +	btrfs_free_path(path);
> +	kfree(swarn.scratch_buf);
> +	kfree(swarn.msg_buf);
> +}
> +
>  /*
>   * scrub_recheck_error gets called when either verification of the page
>   * failed or the bio failed to read, e.g. with EIO. In the latter case,
> @@ -218,6 +347,11 @@ static int scrub_recheck_error(struct scrub_bio *sbio, int ix)
>  			if (scrub_fixup_check(sbio, ix) == 0)
>  				return 0;
>  		}
> +		if (printk_ratelimit())

please don't use printk_ratelimit; as a simple printk_ratelimited is not
applicable here, we have to use __ratelimit: (include/linux/printk.h)

static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
	DEFAULT_RATELIMIT_BURST);

if (__ratelimit(&_rs))

> +			scrub_print_warning("i/o error", sbio, ix);
> +	} else {
> +		if (printk_ratelimit())

and the ratelimit context can be even shared

> +			scrub_print_warning("checksum error", sbio, ix);
>  	}
>  
>  	spin_lock(&sdev->stat_lock);
> @@ -333,7 +467,7 @@ static void scrub_fixup(struct scrub_bio *sbio, int ix)
>  	spin_unlock(&sdev->stat_lock);
>  
>  	if (printk_ratelimit())

(drop)

> -		printk(KERN_ERR "btrfs: fixed up at %llu\n",
> +		printk(KERN_ERR "btrfs: fixed up error at logical %llu\n",
>  		       (unsigned long long)logical);

                printk_ratelimited

seems that I forgot to convert this (and the one below) some time ago. although
changes should not be mixed within a patch, I guess this one is rather simple
and a good thing to do. 

>  	return;
>  
> @@ -344,8 +478,8 @@ uncorrectable:
>  	spin_unlock(&sdev->stat_lock);
>  
>  	if (printk_ratelimit())

(drop)

> -		printk(KERN_ERR "btrfs: unable to fixup at %llu\n",
> -			 (unsigned long long)logical);
> +		printk(KERN_ERR "btrfs: unable to fixup (regular) error at "
> +			"logical %llu\n", (unsigned long long)logical);

                printk_ratelimited

>  }
>  
>  static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
