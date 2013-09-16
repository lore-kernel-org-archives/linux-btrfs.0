Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212Ab3IPIzV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 04:55:21 -0400
Date: Mon, 16 Sep 2013 10:55:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, jeff.liu@oracle.com
Subject: Re: [PATCH v2] Btrfs: export btrfs space shared info to userspace
Message-ID: <20130916085517.GQ6810@suse.cz>
Reply-To: dsterba@suse.cz
References: <1379319504-20941-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379319504-20941-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 16, 2013 at 04:18:24PM +0800, Liu Bo wrote:
> @@ -4122,7 +4136,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  		last = found_key.offset;
>  		last_for_get_extent = last + 1;
>  	}
> -	btrfs_free_path(path);
> +	btrfs_release_path(path);
>  
>  	/*
>  	 * we might have some extents allocated but more delalloc past those
> @@ -4192,7 +4206,24 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  			flags |= (FIEMAP_EXTENT_DELALLOC |
>  				  FIEMAP_EXTENT_UNKNOWN);
>  		} else {
> +			unsigned long ref_cnt = 0;
> +
>  			disko = em->block_start + offset_in_extent;
> +
> +			/*
> +			 * As btrfs supports shared space, this information
> +			 * can be exported to userspace tools via
> +			 * flag FIEMAP_EXTENT_SHARED.
> +			 */
> +			ret = iterate_inodes_from_logical(
> +					em->block_start,
> +					BTRFS_I(inode)->root->fs_info,
> +					path, count_ext_ref, &ref_cnt);
> +			if (ret < 0)
> +				goto out_free;
> +
> +			if (ref_cnt > 1)
> +				flags |= FIEMAP_EXTENT_SHARED;
>  		}
>  		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
>  			flags |= FIEMAP_EXTENT_ENCODED;
> @@ -4226,6 +4257,7 @@ out_free:
>  out:
>  	unlock_extent_cached(&BTRFS_I(inode)->io_tree, start, start + len - 1,
>  			     &cached_state, GFP_NOFS);
> +	btrfs_free_path(path);

I think this free_path should go before unlock_extent_cached, it's not
needed for unlock_extent_cached itself and will delay unlocking the
path unnecessarily (it's set to leave_spinning = 1).

>  	return ret;
>  }
