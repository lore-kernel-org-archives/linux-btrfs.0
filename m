From: David Sterba <dave@jikos.cz>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Thu, 22 Sep 2011 01:10:55 +0200
Message-ID: <20110921231055.GN22205@twin.jikos.cz>
References: <20110921185350.GA6618@kashmir> <4E7A4695.9080106@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mathieu Chouquet-Stringer <mathieu@csetco.com>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E7A4695.9080106@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 21, 2011 at 04:18:29PM -0400, Josef Bacik wrote:
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b128fa0..66ba0a7 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -782,7 +782,12 @@ static noinline int cow_file_range(struct inode *inode,
>  	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
>  	int ret = 0;
> 
> -	BUG_ON(btrfs_is_free_space_inode(root, inode));
> +	if (btrfs_is_free_space_inode(root, inode)) {
> +		printk(KERN_ERR "trying to write to free space inode, "
> +		       "isize=%Lu, start=%Lu, end=%Lu\n", i_size_read(inode),
> +		       start, end);

please prefix printk messages with "btrfs: "

> +		BUG_ON(btrfs_is_free_space_inode(root, inode));
> +	}
>  	trans = btrfs_join_transaction(root);
>  	BUG_ON(IS_ERR(trans));
>  	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
