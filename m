Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54391 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934863AbdCJNPn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Mar 2017 08:15:43 -0500
Date: Fri, 10 Mar 2017 14:15:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 8/9] btrfs-progs: convert: Introduce function to check
 if convert image is able to be rolled back
Message-ID: <20170310131505.GK14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170224055232.4140-1-quwenruo@cn.fujitsu.com>
 <20170224055232.4140-9-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170224055232.4140-9-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 24, 2017 at 01:52:31PM +0800, Qu Wenruo wrote:
> +static int check_image_file_extents(struct btrfs_root *image_root, u64 ino,
> +				    u64 total_size, char *reserved_ranges[])
> +{
> +	struct btrfs_key key;
> +	struct btrfs_path path;
> +	struct btrfs_fs_info *fs_info = image_root->fs_info;
> +	u64 checked_bytes = 0;
> +	int ret;
> +
> +	key.objectid = ino;
> +	key.offset = 0;
> +	key.type = BTRFS_EXTENT_DATA_KEY;
> +
> +	btrfs_init_path(&path);
> +	ret = btrfs_search_slot(NULL, image_root, &key, &path, 0, 0);
> +	/*
> +	 * It's possible that some fs doesn't store any(including sb)
> +	 * data into 0~1M range, and NO_HOLES is enabled.
> +	 *
> +	 * So only needs to check ret < 0 case
> +	 */
> +	if (ret < 0) {
> +		error("failed to iterate file extents at offset 0: %s",
> +			strerror(-ret));
> +		btrfs_release_path(&path);
> +		return ret;
> +	}
> +
> +	/* Loop from the first file extents */
> +	while (1) {
> +		struct btrfs_file_extent_item *fi;
> +		struct extent_buffer *leaf = path.nodes[0];
> +		u64 disk_bytenr;
> +		u64 file_offset;
> +		u64 ram_bytes;
> +		int slot = path.slots[0];
> +
> +		if (slot >= btrfs_header_nritems(leaf))
> +			goto next;
> +		btrfs_item_key_to_cpu(leaf, &key, slot);
> +
> +		/*
> +		 * Iteration is done, exit normally, we have extra check out of
> +		 * the loop
> +		 */
> +		if (key.objectid != ino || key.type != BTRFS_EXTENT_DATA_KEY) {
> +			ret = 0;
> +			break;
> +		}
> +		file_offset = key.offset;
> +		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
> +		if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG) {
> +			ret = -EINVAL;
> +			error(
> +		"ino %llu offset %llu doesn't have a regular file extent",
> +				ino, file_offset);
> +			break;
> +		}
> +		if (btrfs_file_extent_compression(leaf, fi) ||
> +		    btrfs_file_extent_encryption(leaf, fi) ||
> +		    btrfs_file_extent_other_encoding(leaf, fi)) {
> +			ret = -EINVAL;
> +			error(
> +			"ino %llu offset %llu doesn't have a plain file extent",
> +				ino, file_offset);
> +			break;
> +		}
> +
> +		disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
> +		ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
> +
> +		checked_bytes += ram_bytes;
> +		/* Skip hole */
> +		if (disk_bytenr == 0)
> +			goto next;
> +
> +		/*
> +		 * Most file extent must be 1:1 mapped, which means 2 things:
> +		 * 1) File extent file offset == disk_bytenr
> +		 * 2) That data chunk's logical == chunk's physical
> +		 *
> +		 * So file extent's file offset == physical position on disk.
> +		 * 
> +		 * And after rolling back btrfs reserved range, other part
> +		 * remains what old fs used to be.
> +		 */
> +		if (file_offset != disk_bytenr ||
> +		    !is_chunk_direct_mapped(fs_info, disk_bytenr)) {
> +			/*
> +			 * Only file extent in btrfs reserved ranges are allow
> +			 * non-1:1 mapped
> +			 */
> +			if (!is_subset_of_reserved_ranges(file_offset,
> +							ram_bytes)) {
> +				ret = -EINVAL;
> +				error(
> +		"ino %llu offset %llu file extent should not be relocated",
> +					ino, file_offset);
> +				break;
> +			}
> +		}
> +next:
> +		ret = btrfs_next_item(image_root, &path);
> +		if (ret) {
> +			if (ret > 0)
> +				ret = 0;
> +			break;
> +		}
> +	}
> +	btrfs_release_path(&path);
> +	/*
> +	 * For HOLES mode (without NO_HOLES), we must ensure file extents
> +	 * cover the whole range of the image
> +	 */
> +	if (!ret && !btrfs_fs_incompat(fs_info, NO_HOLES)) {
> +		if (checked_bytes != total_size) {
> +			ret = -EINVAL;
> +			error("inode %llu has some file extents not checked",
> +				ino);

Coverity complains that ret is set but not used, and it looks like the
code is not supposed to continue, ie. missing goto or return.

> +		}
> +	}
> +
> +	/* So far so good, read out old data located in btrfs reserved ranges */
> +	ret = read_reserved_ranges(image_root, ino, total_size,
> +				   reserved_ranges);
> +	return ret;
> +}
> +
>  static int do_rollback(const char *devname)
>  {
>  	int fd = -1;
> -- 
> 2.11.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
