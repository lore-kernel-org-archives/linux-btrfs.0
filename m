From: David Sterba <dave@jikos.cz>
Subject: Re: [patch 03/99] btrfs: Panic on bad rbtree operations
Date: Fri, 25 Nov 2011 00:41:51 +0100
Message-ID: <20111124234151.GG12759@twin.jikos.cz>
References: <20111124003533.395674389@suse.com> <20111124004220.164950979@suse.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111124004220.164950979@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2011 at 07:35:36PM -0500, Jeff Mahoney wrote:
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index a1c9404..5a53d94 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -59,6 +59,14 @@ static struct rb_node *tree_insert(struct rb_root *root, u64 file_offset,
>  	return NULL;
>  }
>  
> +NORET_TYPE static void ordered_data_tree_panic(struct inode *inode, int errno,
> +					       u64 offset)
> +{
> +	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb)->fs_info;
> +	btrfs_panic(fs_info, errno, "Inconsistency in ordered tree at offset "
> +		    "%llu\n", offset);
                     ^^^^
this will need a cast to (unsigned long long)

> +}
> +
>  /*
>   * look for a given offset in the tree, and if it can't be found return the
>   * first lesser offset
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -326,6 +326,19 @@ static struct rb_node *tree_search(struct rb_root *root, u64 bytenr)
>  	return NULL;
>  }
>  
> +NORET_TYPE static void backref_tree_panic(struct rb_node *rb_node, int errno,
> +					  u64 bytenr)
> +{
> +
> +	struct btrfs_fs_info *fs_info = NULL;
> +	struct backref_node *bnode = rb_entry(rb_node, struct backref_node,
> +					      rb_node);
> +	if (bnode->root)
> +		fs_info = bnode->root->fs_info;
> +	btrfs_panic(fs_info, errno, "Inconsistency in backref cache "
> +		    "found at offset %llu\n", bytenr);

same here

> +}
> +
