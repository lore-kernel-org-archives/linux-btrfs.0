Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbcFAWGf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 18:06:35 -0400
Date: Wed, 1 Jun 2016 15:06:34 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v10 08/21] btrfs: ordered-extent: Add support for dedupe
Message-ID: <20160601220633.GN7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-9-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459492512-31435-9-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 01, 2016 at 02:34:59PM +0800, Qu Wenruo wrote:
> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> 
> Add ordered-extent support for dedupe.
> 
> Note, current ordered-extent support only supports non-compressed source
> extent.
> Support for compressed source extent will be added later.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/ordered-data.c | 44 ++++++++++++++++++++++++++++++++++++++++----
>  fs/btrfs/ordered-data.h | 13 +++++++++++++
>  2 files changed, 53 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 0de7da5..ef24ad1 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -26,6 +26,7 @@
>  #include "extent_io.h"
>  #include "disk-io.h"
>  #include "compression.h"
> +#include "dedupe.h"
>  
>  static struct kmem_cache *btrfs_ordered_extent_cache;
>  
> @@ -184,7 +185,8 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
>   */
>  static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>  				      u64 start, u64 len, u64 disk_len,
> -				      int type, int dio, int compress_type)
> +				      int type, int dio, int compress_type,
> +				      struct btrfs_dedupe_hash *hash)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct btrfs_ordered_inode_tree *tree;
> @@ -204,6 +206,31 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>  	entry->inode = igrab(inode);
>  	entry->compress_type = compress_type;
>  	entry->truncated_len = (u64)-1;
> +	entry->hash = NULL;
> +	/*
> +	 * Hash hit must go through dedupe routine at all cost, even dedupe
> +	 * is disabled. As its delayed ref is already increased.
> +	 */

Initially, I had a hard time understanding this comment but I'm pretty sure
I know what you mean.

/*
 * A hash hit means we have already incremented the extents delayed ref.
 * We must handle this even if another process raced to turn off dedupe
 * otherwise we might leak a reference.
 */

might be better. Hope that helps.
	--Mark

--
Mark Fasheh
