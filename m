Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35103 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932868AbcKYQuY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 11:50:24 -0500
Date: Fri, 25 Nov 2016 17:50:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 1/2] Btrfs: add more valid checks for superblock
Message-ID: <20161125165019.GZ12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464980715-6442-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464980715-6442-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 03, 2016 at 12:05:14PM -0700, Liu Bo wrote:
> @@ -6648,6 +6648,7 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
>  	struct btrfs_key found_key;
>  	int ret;
>  	int slot;
> +	u64 total_dev = 0;
>  
>  	root = root->fs_info->chunk_root;
>  
> @@ -6689,6 +6690,7 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
>  			ret = read_one_dev(root, leaf, dev_item);
>  			if (ret)
>  				goto error;
> +			total_dev++;
>  		} else if (found_key.type == BTRFS_CHUNK_ITEM_KEY) {
>  			struct btrfs_chunk *chunk;
>  			chunk = btrfs_item_ptr(leaf, slot, struct btrfs_chunk);
> @@ -6698,6 +6700,28 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
>  		}
>  		path->slots[0]++;
>  	}
> +
> +	/*
> +	 * After loading chunk tree, we've got all device information,
> +	 * do another round of validation check.
> +	 */
> +	if (total_dev != root->fs_info->fs_devices->total_devices) {
> +		btrfs_err(root->fs_info,
> +	   "super_num_devices(%llu) mismatch with num_devices(%llu) found here",
> +			  btrfs_super_num_devices(root->fs_info->super_copy),
> +			  total_dev);
> +		ret = -EINVAL;

Turns out this check is too strict in combination with an intermediate
state and a bug in device deletion.

We've had several reports where a filesystem becomes unmountable due to
the above check, where the wrong value is just stored in the superblock
and is fixable by simply setting it to the right value. The right value
is number of dev items found in the dev tree, which is exactly the
total_dev that we read here.

The intermediate state can be caused by removing the device item in
btrfs_rm_device (see comment before btrfs_rm_dev_item call). This
apparently happens, when the device deletion is not finished, ie. the
superblock is not overwritten with a new copy.

So: do you agree to make it just a warning, and fixup the superblock
num_devices here? A userspace fix is also possible, but when this
happens and the filesystem is not mountable, a fix from outside of the
filesystem might be hard.

> +		goto error;
> +	}
> +	if (btrfs_super_total_bytes(root->fs_info->super_copy) <
> +	    root->fs_info->fs_devices->total_rw_bytes) {
> +		btrfs_err(root->fs_info,
> +	"super_total_bytes(%llu) mismatch with fs_devices total_rw_bytes(%llu)",
> +			  btrfs_super_total_bytes(root->fs_info->super_copy),
> +			  root->fs_info->fs_devices->total_rw_bytes);
> +		ret = -EINVAL;
> +		goto error;
> +	}
>  	ret = 0;
>  error:
>  	unlock_chunks(root);
