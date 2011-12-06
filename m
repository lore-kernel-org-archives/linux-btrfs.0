From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/2] Btrfs: fix deadlock on sb->s_umount when doing umount
Date: Tue, 6 Dec 2011 05:49:06 +0000
Message-ID: <20111206054906.GG2203@ZenIV.linux.org.uk>
References: <4EDDA9B3.60508@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4EDDA9B3.60508@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


> +void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
> +				  unsigned long nr_pages)
> +{
> +	struct super_block *sb = root->fs_info->sb;
> +
> +	if (writeback_in_progress(sb->s_bdi))
> +		return;
> +
> +	/*
> +	 * If we can not get s_umount, it means the fs is on remounting or
> +	 * umounting. At this time, we just sync all the delalloc file.
> +	 */
> +	if (down_read_trylock(&sb->s_umount)) {
> +		writeback_inodes_sb_nr(sb, nr_pages);
> +		up_read(&sb->s_umount);
> +	} else {
> +		btrfs_start_delalloc_inodes(root, 0);
> +		btrfs_wait_ordered_extents(root, 0, 0);
> +	}
> +}

If that can race with umount, what prevents sb, its ->s_bdi et.al. being freed
under you?
