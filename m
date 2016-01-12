Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761275AbcALKTp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jan 2016 05:19:45 -0500
Date: Tue, 12 Jan 2016 11:17:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 17/25] btrfs-progs: extent-tree: Enhance
 btrfs_record_file_extent
Message-ID: <20160112101720.GK4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1448953905-28673-18-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448953905-28673-18-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 01, 2015 at 03:11:37PM +0800, Qu Wenruo wrote:
> --- a/extent-tree.c
> +++ b/extent-tree.c
> +static int __btrfs_record_file_extent(struct btrfs_trans_handle *trans,
> +				      struct btrfs_root *root, u64 objectid,
> +				      struct btrfs_inode_item *inode,
> +				      u64 file_pos, u64 disk_bytenr,
> +				      u64 *ret_num_bytes)
>  {
>  	int ret;
>  	struct btrfs_fs_info *info = root->fs_info;
...
> @@ -3999,25 +4003,80 @@ int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
>  		return ret;
>  	}
>  
> -	btrfs_init_path(&path);
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
...
>  fail:
> -	btrfs_release_path(&path);
> +	btrfs_release_path(path);
> +	return ret;

Coverity correctly complains that path leaks here.
