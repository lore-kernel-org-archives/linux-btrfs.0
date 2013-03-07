Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694Ab3CGTuo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Mar 2013 14:50:44 -0500
Date: Thu, 7 Mar 2013 11:50:42 -0800
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add a incompatible format change for smaller
 metadata extent refs
Message-ID: <20130307195042.GI3565@lenny.home.zabbo.net>
References: <1362684477-19402-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362684477-19402-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> +static inline int btrfs_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag)
> +{
> +	struct btrfs_super_block *disk_super;
> +	disk_super = fs_info->super_copy;
> +	return (btrfs_super_incompat_flags(disk_super) & flag);
> +}

That'll fail if there are ever flag bits that don't fit in an int.  The
sneakest fix is wrapping the conditional in the obscure !!().  Making it
a bool and really returning true and false would probably be easier on
the brain.


>  	ret = btrfs_search_slot(trans, root, &key, path, extra_size, 1);
>  	if (ret < 0) {
>  		err = ret;
>  		goto out;
>  	}
> +
> +	/*
> +	 * We may be a newly converted file system which still has the old fat
> +	 * extent entries for metadata, so try and see if we have one of those.
> +	 */
> +	if (ret > 0 && skinny_metadata) {
> +		skinny_metadata = false;
> +		if (path->slots[0]) {
> +			path->slots[0]--;
> +			btrfs_item_key_to_cpu(path->nodes[0], &key,
> +					      path->slots[0]);
> +			if (key.objectid == bytenr &&
> +			    key.type == BTRFS_EXTENT_ITEM_KEY &&
> +			    key.offset == num_bytes)
> +				ret = 0;
> +		}
> +		if (ret) {
> +			key.type = BTRFS_EXTENT_ITEM_KEY;
> +			key.offset = num_bytes;
> +			btrfs_release_path(path);
> +			goto again;
> +		}
> +	}
> +

>  			ret = btrfs_search_slot(trans, extent_root,
>  						&key, path, -1, 1);
> +			if (ret > 0 && skinny_metadata && path->slots[0]) {
> +				/*
> +				 * Couldn't find our skinny metadata item,
> +				 * see if we have ye olde extent item.
> +				 */
> +				path->slots[0]--;
> +				btrfs_item_key_to_cpu(path->nodes[0], &key,
> +						      path->slots[0]);
> +				if (key.objectid == bytenr &&
> +				    key.type == BTRFS_EXTENT_ITEM_KEY &&
> +				    key.offset == num_bytes)
> +					ret = 0;
> +			}
> +
> +			if (ret > 0 && skinny_metadata) {
> +				skinny_metadata = false;
> +				key.type = BTRFS_EXTENT_ITEM_KEY;
> +				key.offset = num_bytes;
> +				btrfs_release_path(path);
> +				ret = btrfs_search_slot(trans, extent_root,
> +							&key, path, -1, 1);
> +			}
> +

These blobs of similar code sure look like they should be in a function.

- z
