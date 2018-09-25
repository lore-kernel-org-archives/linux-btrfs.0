Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56580 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbeIYLr5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 07:47:57 -0400
Subject: Re: [PATCH] Btrfs: get rid of btrfs_symlink_aops
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>
References: <0794275791ff92b445d78d3dd08c67a30a347bbb.1537827364.git.osandov@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <716a0b23-141f-7315-7152-3d3b1eee02f6@suse.com>
Date: Tue, 25 Sep 2018 08:42:02 +0300
MIME-Version: 1.0
In-Reply-To: <0794275791ff92b445d78d3dd08c67a30a347bbb.1537827364.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.09.2018 01:16, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The only aops we define for symlinks are identical to the aops for
> regular files. This has been the case since symlink support was added in
> commit 2b8d99a723a3 ("Btrfs: symlinks and hard links"). As far as I can
> tell, there wasn't a good reason to have separate aops then, and there
> isn't now, so let's just do what most other filesystems do and reuse the
> same structure.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

The only difference would be if for symlink it's required to not have
certain operations defined.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
> Based on v4.19-rc5.
> 
>  fs/btrfs/inode.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3ea5339603cf..590063b0b6dc 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -64,7 +64,6 @@ static const struct inode_operations btrfs_dir_ro_inode_operations;
>  static const struct inode_operations btrfs_special_inode_operations;
>  static const struct inode_operations btrfs_file_inode_operations;
>  static const struct address_space_operations btrfs_aops;
> -static const struct address_space_operations btrfs_symlink_aops;
>  static const struct file_operations btrfs_dir_file_operations;
>  static const struct extent_io_ops btrfs_extent_io_ops;
>  
> @@ -3738,7 +3737,7 @@ static int btrfs_read_locked_inode(struct inode *inode)
>  	case S_IFLNK:
>  		inode->i_op = &btrfs_symlink_inode_operations;
>  		inode_nohighmem(inode);
> -		inode->i_mapping->a_ops = &btrfs_symlink_aops;
> +		inode->i_mapping->a_ops = &btrfs_aops;
>  		break;
>  	default:
>  		inode->i_op = &btrfs_special_inode_operations;
> @@ -10191,7 +10190,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
>  
>  	inode->i_op = &btrfs_symlink_inode_operations;
>  	inode_nohighmem(inode);
> -	inode->i_mapping->a_ops = &btrfs_symlink_aops;
> +	inode->i_mapping->a_ops = &btrfs_aops;
>  	inode_set_bytes(inode, name_len);
>  	btrfs_i_size_write(BTRFS_I(inode), name_len);
>  	err = btrfs_update_inode(trans, root, inode);
> @@ -10567,13 +10566,6 @@ static const struct address_space_operations btrfs_aops = {
>  	.error_remove_page = generic_error_remove_page,
>  };
>  
> -static const struct address_space_operations btrfs_symlink_aops = {
> -	.readpage	= btrfs_readpage,
> -	.writepage	= btrfs_writepage,
> -	.invalidatepage = btrfs_invalidatepage,
> -	.releasepage	= btrfs_releasepage,
> -};
> -
>  static const struct inode_operations btrfs_file_inode_operations = {
>  	.getattr	= btrfs_getattr,
>  	.setattr	= btrfs_setattr,
> 
