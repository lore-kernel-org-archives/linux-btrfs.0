Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56608 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751114AbeEVLRF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 07:17:05 -0400
Date: Tue, 22 May 2018 13:14:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Fix to use original error code of
 btrfs_read_fs_root_no_name()
Message-ID: <20180522111421.GE6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1526878216.git.misono.tomohiro@jp.fujitsu.com>
 <f73cd334-4ff3-9f56-941a-eaba6c528ba2@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f73cd334-4ff3-9f56-941a-eaba6c528ba2@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 21, 2018 at 01:57:27PM +0900, Misono Tomohiro wrote:
> btrfs_read_fs_root_no_name() may return ERR_PTR(-ENOENT) or
> ERR_PTR(-ENOMEM) and therefore search_ioctl() and
> btrfs_search_path_in_tree() should use PTR_ERR() instead of -ENOENT,
> which all other callers of btrfs_read_fs_root_no_name() does.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>  fs/btrfs/ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 8f7c1b9a2db7..0f90e68ca512 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2155,7 +2155,7 @@ static noinline int search_ioctl(struct inode *inode,
>  		root = btrfs_read_fs_root_no_name(info, &key);
>  		if (IS_ERR(root)) {
>  			btrfs_free_path(path);
> -			return -ENOENT;
> +			return PTR_ERR(root);
>  		}
>  	}
>  
> @@ -2290,7 +2290,7 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
>  	root = btrfs_read_fs_root_no_name(info, &key);
>  	if (IS_ERR(root)) {
>  		btrfs_err(info, "could not find root %llu", tree_id);

We should probably drop this message too, as there are now 2 errors and
"not found" after ENOMEM does not make sense.

Otherwise ok

Reviewed-by: David Sterba <dsterba@suse.com>
