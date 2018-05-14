Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41536 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752046AbeENLR5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:17:57 -0400
Subject: Re: [PATCH 2/3] btrfs-progs: lowmem: check symlinks with
 append/immutable flags
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
 <20180514102922.8840-3-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <bc0e3a76-8975-80fd-00f3-03f1bd5680aa@suse.com>
Date: Mon, 14 May 2018 14:17:55 +0300
MIME-Version: 1.0
In-Reply-To: <20180514102922.8840-3-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.05.2018 13:29, Su Yue wrote:
> Symlinks should never have append/immutable flags.
> While checking inodes, if found a symlink with append/immutable
> flags, report and record the fatal error.
> 
> This is for lowmem mode.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  check/mode-lowmem.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 9890180d1d3c..61c4e7f23d47 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -2274,6 +2274,7 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
>  	struct btrfs_key last_key;
>  	u64 inode_id;
>  	u32 mode;
> +	u64 flags;
>  	u64 nlink;
>  	u64 nbytes;
>  	u64 isize;
> @@ -2307,10 +2308,19 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
>  	isize = btrfs_inode_size(node, ii);
>  	nbytes = btrfs_inode_nbytes(node, ii);
>  	mode = btrfs_inode_mode(node, ii);
> +	flags = btrfs_inode_flags(node, ii);
>  	dir = imode_to_type(mode) == BTRFS_FT_DIR;
>  	nlink = btrfs_inode_nlink(node, ii);
>  	nodatasum = btrfs_inode_flags(node, ii) & BTRFS_INODE_NODATASUM;
>  
> +	if (mode & BTRFS_FT_SYMLINK &&
> +	    (flags & (BTRFS_INODE_IMMUTABLE | BTRFS_INODE_APPEND))) {
> +		err = FATAL_ERROR;
> +		error(
> +"symlinks shall never be with immutable/append, root %llu inode item [%llu] flags %llu may be corrupted",

How about: 

"symlinks must never have immutable/append flags set, root %llu ino %llu flag %llu may be corrupted". 

I think printing the ino number should suffice, no need for the "fancy" [] around the inode number. 
> +		      root->objectid, inode_id, flags);
> +	}
> +
>  	while (1) {
>  		btrfs_item_key_to_cpu(path->nodes[0], &last_key, path->slots[0]);
>  		ret = btrfs_next_item(root, path);
> 
