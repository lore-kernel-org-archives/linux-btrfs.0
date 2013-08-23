Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab3HWJIh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 05:08:37 -0400
Message-ID: <52172553.4000304@cn.fujitsu.com>
Date: Fri, 23 Aug 2013 17:03:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix for patch "cleanup: don't check the same
 thing twice"
References: <1377246883-28772-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1377246883-28772-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 23 Aug 2013 10:34:42 +0200, Stefan Behrens wrote:
> Mitch Harder noticed that the patch 3c64a1a mentioned in the subject
> line was causing a kernel BUG() on snapshot deletion.
> 
> The patch was wrong. It did not handle cached roots correctly. The
> check for root_refs == 0 was removed everywhere where
> btrfs_read_fs_root_no_name() had been used to retrieve the root,
> because this check was already dealt with in
> btrfs_read_fs_root_no_name(). But in the case when the root was
> found in the cache, there was no such check.
> 
> This patch adds the missing check in the case where the root is
> found in the cache.
> 
> Reported-by: Mitch Harder <mitch.harder@sabayonlinux.org>
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  fs/btrfs/disk-io.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 43ec3c6..7078554 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1583,8 +1583,11 @@ struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
>  					    ERR_PTR(-ENOENT);
>  again:
>  	root = btrfs_lookup_fs_root(fs_info, location->objectid);
> -	if (root)
> +	if (root) {
> +		if (btrfs_root_refs(&root->root_item) == 0)
> +			return ERR_PTR(-ENOENT);
>  		return root;
> +	}

It seems good to me. 

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

>  
>  	root = btrfs_read_fs_root(fs_info->tree_root, location);
>  	if (IS_ERR(root))
> 

