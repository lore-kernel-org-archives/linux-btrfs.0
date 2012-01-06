From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] Btrfs: make btrfs_truncate_inode_items() more readable
Date: Fri, 06 Jan 2012 09:35:59 +0800
Message-ID: <4F064FFF.9060404@cn.fujitsu.com>
References: <4F056029.2080306@cn.fujitsu.com> <20120105151142.GB1843@localhost.localdomain>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120105151142.GB1843@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 5 Jan 2012 10:11:43 -0500, Josef Bacik wrote:
>> +	extent_start = btrfs_file_extent_disk_bytenr(leaf, fi);
>> +	if (offset < new_size) {
>> +		/*
>> +		 * If the new size is in the extent:
>> +		 *   +--------------------------+
>> +		 *   |				|
>> +		 *   +--------------------------+
>> +		 *   			^ new size
>> +		 * so this extent should be truncated, not be dropped directly.
>> +		 */
>> +		orig_nbytes = btrfs_file_extent_num_bytes(leaf, fi);
>> +		new_nbytes = round_up(new_size - offset, root->sectorsize);
>> +
>> +		btrfs_set_file_extent_num_bytes(leaf, fi, new_nbytes);
>> +
>> +		if (extent_start != 0 && root->ref_cows)
>> +			inode_sub_bytes(inode, orig_nbytes - new_nbytes);
>> +
>> +		btrfs_mark_buffer_dirty(leaf);
>> +		return 0;
> 
> Use ret = 0 here, and then further down...
> 
>> +	} else {
>> +		/*
>> +		 * If the new size is in the font of the extent:
>> +		 *   +--------------------------+
>> +		 *   |				|
>> +		 *   +--------------------------+
>> +		 *  ^ new size
>> +		 * so this extent should be dropped.
>> +		 */
>> +
>> +		/*
>> +		 * It is a dummy extent, or it is in log tree, we needn't do
>> +		 * anything, just drop it.
>> +		 */
>> +		if (extent_start == 0 ||
>> +		    !(root->ref_cows || root == root->fs_info->tree_root))
>> +			return 1;
>> +
>> +		/* If this file is not a free space management file... */
>> +		/* FIXME blocksize != 4096 */
>> +		if (root != root->fs_info->tree_root) {
>> +			orig_nbytes = btrfs_file_extent_num_bytes(leaf, fi);
>> +			inode_sub_bytes(inode, orig_nbytes);
>> +		}
>> +
>> +		orig_nbytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
>> +		extent_offset = offset - btrfs_file_extent_offset(leaf, fi);
>> +		btrfs_set_path_blocking(path);
>> +		ret = btrfs_free_extent(trans, root, extent_start,
>> +					orig_nbytes, 0,
>> +					btrfs_header_owner(leaf),
>> +					ino, extent_offset);
>> +		BUG_ON(ret);
>> +		btrfs_clear_path_blocking(path, NULL, 0);
>> +
>> +		return 1;
> 
> ret = 1
>> +	}
> 
> return ret;

OK, I'll modify it. Thanks for your review.

Miao
