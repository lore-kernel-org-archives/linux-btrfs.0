Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbcDDNit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 09:38:49 -0400
Date: Mon, 4 Apr 2016 15:35:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v3 01/22] btrfs-progs: convert: Introduce functions to
 read used space
Message-ID: <20160404133516.GA3412@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1454043812-7893-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454043812-7893-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 29, 2016 at 01:03:11PM +0800, Qu Wenruo wrote:
> Before we do real convert, we need to read and build up used space cache
> tree for later data/meta separate chunk layout.
> 
> This patch will iterate all used blocks in ext2 filesystem and record it
> into cctx->used cache tree, for later use.
> 
> This provides the very basic of later btrfs-convert rework.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  btrfs-convert.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 80 insertions(+)
> 
> diff --git a/btrfs-convert.c b/btrfs-convert.c
> index 4baa68e..65841bd 100644
> --- a/btrfs-convert.c
> +++ b/btrfs-convert.c
> @@ -81,6 +81,7 @@ struct btrfs_convert_context;
>  struct btrfs_convert_operations {
>  	const char *name;
>  	int (*open_fs)(struct btrfs_convert_context *cctx, const char *devname);
> +	int (*read_used_space)(struct btrfs_convert_context *cctx);
>  	int (*alloc_block)(struct btrfs_convert_context *cctx, u64 goal,
>  			   u64 *block_ret);
>  	int (*alloc_block_range)(struct btrfs_convert_context *cctx, u64 goal,
> @@ -230,6 +231,73 @@ fail:
>  	return -1;
>  }
>  
> +static int __ext2_add_one_block(ext2_filsys fs, char *bitmap,
> +				unsigned long group_nr, struct cache_tree *used)
> +{
> +	unsigned long offset;
> +	unsigned i;
> +	int ret = 0;
> +
> +	offset = fs->super->s_first_data_block;
> +	offset /= EXT2FS_CLUSTER_RATIO(fs);

This macro does not exist on my reference host for old distros. The
e2fsprogs version is 1.41.14 and I'd like to keep the compatibility at
least at that level.

The clustering has been added in 1.42 but can we add some compatibility
layer that will work on both version?
