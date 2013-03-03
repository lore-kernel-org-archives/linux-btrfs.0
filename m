Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab3CCQ6b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Mar 2013 11:58:31 -0500
Date: Sun, 3 Mar 2013 17:58:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Simon Kirby <sim@hostway.ca>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Include the device in most error printk()s
Message-ID: <20130303165828.GZ27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130214124433.GJ12339@twin.jikos.cz>
 <E1U8IjD-0001td-Vm@peace.netnation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E1U8IjD-0001td-Vm@peace.netnation.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 15, 2013 at 05:12:37PM -0600, Simon Kirby wrote:
[...]
> Signed-off-by: Simon Kirby <sim@hostway.ca>

Thanks! 2 comments below.

Reviewed-by: David Sterba <dsterba@suse.cz>

> @@ -2919,8 +2923,9 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
>  	if (ret) {
>  		btrfs_delalloc_release_metadata(inode, inode->i_size);
>  #ifdef DEBUG
> -		printk(KERN_ERR "btrfs: failed to write free ino cache "
> -		       "for root %llu\n", root->root_key.objectid);
> +		btrfs_err(root->fs_info,
> +			"btrfs %s: failed to write free ino cache for root %llu",
> +			root->root_key.objectid);

 			"failed to write free ino cache for root %llu",

>  #endif
>  	}
>  
> @@ -2454,8 +2456,8 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
>  				ret = PTR_ERR(trans);
>  				goto out;
>  			}
> -			printk(KERN_ERR "auto deleting %Lu\n",
> -			       found_key.objectid);
> +			btrfs_err(root->fs_info, "auto deleting %Lu",
> +				found_key.objectid);

That's probably only a debugging message, so btrfs_debug would be more
appropriate here.

>  			ret = btrfs_del_orphan_item(trans, root,
>  						    found_key.objectid);
>  			BUG_ON(ret); /* -ENOMEM or corruption (JDM: Recheck) */
