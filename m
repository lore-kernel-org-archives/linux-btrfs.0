Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43669 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932858AbeFUQJl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 12:09:41 -0400
Subject: Re: [PATCH 2/2] [v2] btrfs: use timespec64 for i_otime
To: Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Cc: Omar Sandoval <osandov@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180621160420.139575-1-arnd@arndb.de>
 <20180621160420.139575-2-arnd@arndb.de>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <d5245617-046a-c261-fc8e-ae5908119899@suse.com>
Date: Thu, 21 Jun 2018 19:09:38 +0300
MIME-Version: 1.0
In-Reply-To: <20180621160420.139575-2-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21.06.2018 19:04, Arnd Bergmann wrote:
> While the regular inode timestamps all use timespec64 now, the
> i_otime field is btrfs specific and still needs to be converted
> to correctly represent times beyond 2038.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> v2: no changes
> ---
>  fs/btrfs/btrfs_inode.h | 2 +-
>  fs/btrfs/inode.c       | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 7e075343daa5..1343ac57b438 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -178,7 +178,7 @@ struct btrfs_inode {
>  	struct btrfs_delayed_node *delayed_node;
>  
>  	/* File creation time. */
> -	struct timespec i_otime;
> +	struct timespec64 i_otime;
>  
>  	/* Hook into fs_info->delayed_iputs */
>  	struct list_head delayed_iput;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e9482f0db9d0..22dcc8afd38f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5745,7 +5745,7 @@ static struct inode *new_simple_dir(struct super_block *s,
>  	inode->i_mtime = current_time(inode);
>  	inode->i_atime = inode->i_mtime;
>  	inode->i_ctime = inode->i_mtime;
> -	BTRFS_I(inode)->i_otime = timespec64_to_timespec(inode->i_mtime);
> +	BTRFS_I(inode)->i_otime = inode->i_mtime;
>  
>  	return inode;
>  }
> @@ -6349,7 +6349,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  	inode->i_mtime = current_time(inode);
>  	inode->i_atime = inode->i_mtime;
>  	inode->i_ctime = inode->i_mtime;
> -	BTRFS_I(inode)->i_otime = timespec64_to_timespec(inode->i_mtime);
> +	BTRFS_I(inode)->i_otime = inode->i_mtime;
>  
>  	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
>  				  struct btrfs_inode_item);
> 
