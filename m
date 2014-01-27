Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbaA0QjV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 11:39:21 -0500
Date: Mon, 27 Jan 2014 17:39:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: allocate ulist with a slab allocator
Message-ID: <20140127163920.GX6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390816789-3901-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1390816789-3901-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390816789-3901-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 27, 2014 at 05:59:49PM +0800, Wang Shilong wrote:
> --- a/fs/btrfs/ulist.c
> +++ b/fs/btrfs/ulist.c
> @@ -156,6 +157,23 @@ static int ulist_rbtree_insert(struct ulist *ulist, struct ulist_node *ins)
>  	return 0;
>  }
>  
> +int __init btrfs_ulist_init(void)
> +{
> +	btrfs_ulist_cache = kmem_cache_create("btrfs_ulist_cache",

Please use the cache name that matches the structure name if possible,
or with the btrfs_ prefix, ie. b

	btrfs_ulist_cache = kmem_cache_create("btrfs_ulist_node",

> +					sizeof(struct ulist_node), 0,
> +					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
> +					NULL);
