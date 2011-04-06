From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs: don't kzalloc the ordered extents
Date: Wed, 06 Apr 2011 09:54:07 +0200
Message-ID: <4D9C1C1F.8090208@gmx.net>
References: <1302045649-1580-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302045649-1580-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06.04.2011 01:20, Josef Bacik wrote:
> We initialize almost all of the fields when we allocate an ordered extent, so
> use kmalloc instead of kzalloc and just initialize the other fields that we
> don't already initialize yet.  Thanks,

Is it really worth it? we have seen a few bugs in the past resulting
from uninitialized structure element, that even made it to disk.
Using kzalloc makes maintenance much easier.

-Arne

> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/ordered-data.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 083a554..2edc837 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -179,7 +179,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>  	struct btrfs_ordered_extent *entry;
>  
>  	tree = &BTRFS_I(inode)->ordered_tree;
> -	entry = kzalloc(sizeof(*entry), GFP_NOFS);
> +	entry = kmalloc(sizeof(*entry), GFP_NOFS);
>  	if (!entry)
>  		return -ENOMEM;
>  
> @@ -190,6 +190,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>  	entry->bytes_left = len;
>  	entry->inode = inode;
>  	entry->compress_type = compress_type;
> +	entry->flags = 0;
>  	if (type != BTRFS_ORDERED_IO_DONE && type != BTRFS_ORDERED_COMPLETE)
>  		set_bit(type, &entry->flags);
>  
> @@ -201,6 +202,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>  	init_waitqueue_head(&entry->wait);
>  	INIT_LIST_HEAD(&entry->list);
>  	INIT_LIST_HEAD(&entry->root_extent_list);
> +	RB_CLEAR_NODE(&entry->rb_node);
>  
>  	spin_lock(&tree->lock);
>  	node = tree_insert(&tree->tree, file_offset,

