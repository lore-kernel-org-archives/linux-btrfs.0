From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 2/5] implement metadata_incore in btrfs
Date: Mon, 13 Dec 2010 16:45:31 -0800
Message-ID: <20101213164531.6da1a081.akpm@linux-foundation.org>
References: <1292224931.2323.451.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1292224931.2323.451.camel@sli10-conroe>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 13 Dec 2010 15:22:11 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> Implement btrfs specific .metadata_incore.
> In btrfs, all metadata pages are in a special btree_inode, we take pages from it.
> we only account updated and referenced pages here. Say we collect metadata info
> in one boot, do metadata readahead in next boot and we might collect metadata
> again. The readahead could read garbage data in as metadata could be changed
> from first run. If we only account updated pages, the metadata info collected
> by userspace will increase every run. Btrfs alloc_extent_buffer will do
> mark_page_accessed() for pages which will be used soon, so we could use
> referenced bit to filter some garbage pages.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> ---
>  fs/btrfs/super.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> Index: linux/fs/btrfs/super.c
> ===================================================================
> --- linux.orig/fs/btrfs/super.c	2010-12-07 10:10:20.000000000 +0800
> +++ linux/fs/btrfs/super.c	2010-12-07 13:25:20.000000000 +0800
> @@ -39,6 +39,7 @@
>  #include <linux/miscdevice.h>
>  #include <linux/magic.h>
>  #include <linux/slab.h>
> +#include <linux/pagevec.h>
>  #include "compat.h"
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -845,6 +846,52 @@ static int btrfs_unfreeze(struct super_b
>  	return 0;
>  }
>  
> +static int btrfs_metadata_incore(struct super_block *sb, loff_t *offset,
> +	ssize_t *size)
> +{
> +	struct btrfs_root *tree_root = btrfs_sb(sb);
> +	struct inode *btree_inode = tree_root->fs_info->btree_inode;
> +	struct pagevec pvec;
> +	loff_t index = (*offset) >> PAGE_CACHE_SHIFT;

pgoff_t would be a more appropriate type.

> +	int i, nr_pages;
> +
> +	*size = 0;
> +retry:
> +	pagevec_init(&pvec, 0);
> +	nr_pages = pagevec_lookup(&pvec, btree_inode->i_mapping, index,
> +		PAGEVEC_SIZE);
> +	if (nr_pages == 0)
> +		goto out;
> +	for (i = 0; i < nr_pages; i++) {
> +		struct page *page = pvec.pages[i];
> +
> +		/* Only take pages with 'referenced' bit set */

The comment describes the utterly obvious and doesn't explain the
utterly unobvious: "why?".

> +		if (PageUptodate(page) && PageReferenced(page)) {
> +			if (*size == 0) {
> +				*size += PAGE_CACHE_SIZE;
> +				*offset = page->index << PAGE_CACHE_SHIFT;
> +				continue;
> +			}
> +			if (page->index !=
> +			    (*offset + *size) >> PAGE_CACHE_SHIFT)
> +				break;
> +			*size += PAGE_CACHE_SIZE;
> +		} else if (*size > 0)
> +			break;
> +		else
> +			index = page->index + 1;
> +	}
> +	pagevec_release(&pvec);
> +
> +	if (nr_pages > 0 && *size == 0)
> +		goto retry;

I don't think I know why this retry loop exists.  A comment would be
nice.

> +out:
> +	if (*size > 0)
> +		return 0;
> +	else
> +		return -ENOENT;
> +}
> +
>  static const struct super_operations btrfs_super_ops = {
>  	.drop_inode	= btrfs_drop_inode,
>  	.evict_inode	= btrfs_evict_inode,
> @@ -859,6 +906,7 @@ static const struct super_operations btr
>  	.remount_fs	= btrfs_remount,
>  	.freeze_fs	= btrfs_freeze,
>  	.unfreeze_fs	= btrfs_unfreeze,
> +	.metadata_incore = btrfs_metadata_incore,
>  };
>  
>  static const struct file_operations btrfs_ctl_fops = {
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
