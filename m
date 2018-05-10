Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753486AbeEJGeZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 02:34:25 -0400
Subject: Re: [PATCH v2 1/8] btrfs: rename btrfs_update_iflags to reflect which
 flags it touches
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: misono.tomohiro@jp.fujitsu.com
References: <cover.1525873677.git.dsterba@suse.com>
 <56697064041956d0bc084593a287136b799b97b7.1525873677.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <950593c7-258a-db06-14a9-710ec7f1d2a5@suse.com>
Date: Thu, 10 May 2018 09:34:21 +0300
MIME-Version: 1.0
In-Reply-To: <56697064041956d0bc084593a287136b799b97b7.1525873677.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.05.2018 16:54, David Sterba wrote:
> The btrfs inode flag flavour is now simply called 'inode flags' and the
> vfs inode are i_flags. Also rename the internal variable to something
> less confusing than 'ip'.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/ctree.h | 2 +-
>  fs/btrfs/inode.c | 4 ++--
>  fs/btrfs/ioctl.c | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2771cc56a622..d738eaa1d6e1 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3260,7 +3260,7 @@ void btrfs_test_inode_set_ops(struct inode *inode);
>  long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
>  long btrfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
>  int btrfs_ioctl_get_supported_features(void __user *arg);
> -void btrfs_update_iflags(struct inode *inode);
> +void btrfs_sync_inode_flags_to_i_flags(struct inode *inode);
>  int btrfs_is_empty_uuid(u8 *uuid);
>  int btrfs_defrag_file(struct inode *inode, struct file *file,
>  		      struct btrfs_ioctl_defrag_range_args *range,
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index d241285a0d2a..c30afabcb6b0 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3924,7 +3924,7 @@ static int btrfs_read_locked_inode(struct inode *inode)
>  		break;
>  	}
>  
> -	btrfs_update_iflags(inode);
> +	btrfs_sync_inode_flags_to_i_flags(inode);
>  	return 0;
>  
>  make_bad:
> @@ -6263,7 +6263,7 @@ static void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
>  	}
>  
> -	btrfs_update_iflags(inode);
> +	btrfs_sync_inode_flags_to_i_flags(inode);
>  }
>  
>  static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 632e26d6f7ce..11edbdf3df7d 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -136,7 +136,7 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
>  /*
>   * Update inode->i_flags based on the btrfs internal flags.
>   */
> -void btrfs_update_iflags(struct inode *inode)
> +void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
>  {

nit: imho that name is too verbose, I think btrfs_sync_inode_flags
should suffice alongside the one line comment at the top of the
function. As a matter of fact what necessitates duplicating those flags
in both the btrfs-specific data structure and the generic vfs inode?

So looking at how btrfs_update_iflags is used, we have:

btrfs_ioctl_setflags - we gain nothing by having those flags duplicated
since in case of failure the revert procedure is the same - we have to
set i_oldflags to both btrfs_inode and vfs_inode

btrfs_read_locked_inode - so here we read the flags from the on-disk
inode and then use btrfs_update_iflags to set the generic vfs flags to
the vfs_inode

btrfs_inherit_iflags - the call to btrfs_update_iflags is not even
necessary since none of the flags which is being inherited:
BTRFS_INODE_NOCOMPRESS/BTRFS_INODE_COMPRESS/BTRFS_INODE_NODATACOW
is supported by btrfs_update_iflags.

Given this I'd be more inclined to rename the function to something
like: btrfs_init_i_flags/btrfs_set_iflags or some such.

And to go a bit further imho those flags which are generic should always
be set in the vfs_inode and when we are about to persist an inode item
on-disk then we should get the necessary flags from the vfs_inode and
put in the inode item.

>  	struct btrfs_inode *ip = BTRFS_I(inode);
>  	unsigned int new_fl = 0;
> @@ -317,7 +317,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>  		goto out_drop;
>  	}
>  
> -	btrfs_update_iflags(inode);
> +	btrfs_sync_inode_flags_to_i_flags(inode);
>  	inode_inc_iversion(inode);
>  	inode->i_ctime = current_time(inode);
>  	ret = btrfs_update_inode(trans, root, inode);
> 
