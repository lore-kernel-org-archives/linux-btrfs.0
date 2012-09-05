Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:56663 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab2IEQQ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Sep 2012 12:16:29 -0400
Date: Wed, 5 Sep 2012 18:16:19 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/7] Btrfs: use a slab for ordered extents allocation
Message-ID: <20120905161619.GM17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <503D96C2.7000802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <503D96C2.7000802@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 29, 2012 at 12:12:50PM +0800, Miao Xie wrote:
> The ordered extent allocation is in the fast path of the IO, so use a slab
> to improve the speed of the allocation.

Good. Size of the struct is 280, so this will fall into the size-512
bucket, giving 8 objects per page, while own slab will pack 14 objects
into a page.

Another benefit I see is to check for leaked objects when the
module is removed (and the cache destroy takes place).

> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/ordered-data.c |   23 +++++++++++++++++++++--
>  fs/btrfs/ordered-data.h |    2 ++
>  fs/btrfs/super.c        |    9 ++++++++-
>  3 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 2eb79cc..a07ae77 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -958,3 +960,20 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
>  	}
>  	spin_unlock(&root->fs_info->ordered_extent_lock);
>  }
> +
> +int __init ordered_data_init(void)
> +{
> +	ordered_extent_cache = kmem_cache_create("ordered_extent",

Please use the 'btrfs_' prefix, ie. 'btrfs_ordered_extent'

> +				sizeof(struct btrfs_ordered_extent), 0,
> +				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
> +				NULL);
> +	if (!ordered_extent_cache)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
