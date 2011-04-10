From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v5 3/8] btrfs: Factor out enumeration of chunks to a
 separate function
Date: Mon, 11 Apr 2011 00:11:25 +0200
Message-ID: <20110410221125.GF31675@twin.jikos.cz>
References: <1302469571-12605-1-git-send-email-hugo@carfax.org.uk>
 <1302469571-12605-4-git-send-email-hugo@carfax.org.uk>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, dave@jikos.cz, lizf@cn.fujitsu.com,
	linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302469571-12605-4-git-send-email-hugo@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 10, 2011 at 10:06:06PM +0100, Hugo Mills wrote:
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index cf019af..20c2772 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2029,6 +2029,97 @@ static u64 div_factor(u64 num, int factor)
> +static void balance_move_chunks(struct btrfs_root *chunk_root,
> +			 struct btrfs_balance_info *bal_info,
> +			 struct btrfs_path *path,
> +			 struct btrfs_key *key)
> +{
> +	int ret;
> +
> +	ret = btrfs_relocate_chunk(chunk_root,
> +				   chunk_root->root_key.objectid,
> +				   key->objectid,
> +				   key->offset);
> +	BUG_ON(ret && ret != -ENOSPC);
> +	spin_lock(&chunk_root->fs_info->balance_info_lock);
> +	bal_info->completed++;
> +	spin_unlock(&chunk_root->fs_info->balance_info_lock);
> +	printk(KERN_INFO "btrfs: balance: %llu/%llu block groups completed\n",
> +	       bal_info->completed, bal_info->expected);

as you've changed 'completed' and 'expected' members to 32bit, change
%llu to %u.

d/
