Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758992Ab3EOOtP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 10:49:15 -0400
Date: Wed, 15 May 2013 16:49:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: fix missing recow roots when making btrfs
 filesystem
Message-ID: <20130515144912.GZ16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <51922504.4020505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51922504.4020505@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 14, 2013 at 07:50:28PM +0800, Wang Shilong wrote:
> When making btrfs filesystem. we firstly write root leaf to
> specified filed, and then we recow the root. If we don't recow,
> some trees are not in the correct block group.
> 
> Steps to reproduce:
> 	dd if=/dev/zero of=test.img bs=1M count=100
> 	mkfs.btrfs -f test.img
> 	btrfs-debug-tree test.img

Very simple reproducer, I guess that it gets fixed with first update of
the misplaced blocks.

> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -151,37 +151,55 @@ static int recow_roots(struct btrfs_trans_handle *trans,
>  	int ret;
>  	struct extent_buffer *tmp;
>  	struct btrfs_fs_info *info = root->fs_info;
> +	u64 generation;
>  
> -	ret = __btrfs_cow_block(trans, info->fs_root, info->fs_root->node,
> -				NULL, 0, &tmp, 0, 0);
> -	BUG_ON(ret);
> -	free_extent_buffer(tmp);
> +	generation = btrfs_root_generation(&info->fs_root->root_item);
> +	if (generation != trans->transid) {
> +		ret = __btrfs_cow_block(trans, info->fs_root,
> +				info->fs_root->node, NULL, 0, &tmp, 0, 0);
> +		BUG_ON(ret);
> +		free_extent_buffer(tmp);
> +	}

This gets repeated, please use wrapper for that.

david
