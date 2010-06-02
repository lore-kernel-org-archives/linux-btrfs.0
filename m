From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 01/10] btrfs: add a return value for readahead_tree_block()
Date: Wed, 02 Jun 2010 11:07:38 +0800
Message-ID: <4C05CAFA.9000700@cn.fujitsu.com>
References: <4BF4E12F.6010103@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BF4E12F.6010103@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Chris

Could you review this patchset for us? 

Regards
Miao


on 2010-5-20 15:13, Miao Xie wrote:
> From: Liu Bo <liubo2009@cn.fujitsu.com>
> 
> Fix return value to get from read_extent_buffer_pages().
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/disk-io.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 6632e5c..35916d5 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -794,7 +794,7 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
>  	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
>  	if (!buf)
>  		return 0;
> -	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
> +	ret = read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
>  				 buf, 0, 0, btree_get_extent, 0);
>  	free_extent_buffer(buf);
>  	return ret;


