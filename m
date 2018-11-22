Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B7AC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 11:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E276520685
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 11:48:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E276520685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391260AbeKVW14 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 17:27:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:36332 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726671AbeKVW14 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 17:27:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 20C55AEB2;
        Thu, 22 Nov 2018 11:48:51 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id A6F2C1E0A16; Thu, 22 Nov 2018 12:48:50 +0100 (CET)
Date:   Thu, 22 Nov 2018 12:48:50 +0100
From:   Jan Kara <jack@suse.cz>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     clm@fb.com, amir73il@gmail.com, viro@zeniv.linux.org.uk,
        jbacik@fb.com, dsterba@suse.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH v4 09/09] btrfs: use common file type conversion
Message-ID: <20181122114850.GL9840@quack2.suse.cz>
References: <20181121190706.GA7745@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121190706.GA7745@pathfinder>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed 21-11-18 19:07:06, Phillip Potter wrote:
> Deduplicate the btrfs file type conversion implementation - file systems
> that use the same file types as defined by POSIX do not need to define
> their own versions and can use the common helper functions decared in
> fs_types.h and implemented in fs_types.c
> 
> Acked-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/btrfs/btrfs_inode.h          |  2 --
>  fs/btrfs/delayed-inode.c        |  2 +-
>  fs/btrfs/inode.c                | 32 +++++++++++++++-----------------
>  include/uapi/linux/btrfs_tree.h |  2 ++
>  4 files changed, 18 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 97d91e55b70a..bb01c804485f 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -196,8 +196,6 @@ struct btrfs_inode {
>  	struct inode vfs_inode;
>  };
>  
> -extern unsigned char btrfs_filetype_table[];
> -
>  static inline struct btrfs_inode *BTRFS_I(const struct inode *inode)
>  {
>  	return container_of(inode, struct btrfs_inode, vfs_inode);
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index c669f250d4a0..e61947f5eb76 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1692,7 +1692,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
>  		name = (char *)(di + 1);
>  		name_len = btrfs_stack_dir_name_len(di);
>  
> -		d_type = btrfs_filetype_table[di->type];
> +		d_type = fs_ftype_to_dtype(di->type);
>  		btrfs_disk_key_to_cpu(&location, &di->location);
>  
>  		over = !dir_emit(ctx, name, name_len,
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 9ea4c6f0352f..8b7b1b29e2ad 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -72,17 +72,6 @@ struct kmem_cache *btrfs_trans_handle_cachep;
>  struct kmem_cache *btrfs_path_cachep;
>  struct kmem_cache *btrfs_free_space_cachep;
>  
> -#define S_SHIFT 12
> -static const unsigned char btrfs_type_by_mode[S_IFMT >> S_SHIFT] = {
> -	[S_IFREG >> S_SHIFT]	= BTRFS_FT_REG_FILE,
> -	[S_IFDIR >> S_SHIFT]	= BTRFS_FT_DIR,
> -	[S_IFCHR >> S_SHIFT]	= BTRFS_FT_CHRDEV,
> -	[S_IFBLK >> S_SHIFT]	= BTRFS_FT_BLKDEV,
> -	[S_IFIFO >> S_SHIFT]	= BTRFS_FT_FIFO,
> -	[S_IFSOCK >> S_SHIFT]	= BTRFS_FT_SOCK,
> -	[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
> -};
> -
>  static int btrfs_setsize(struct inode *inode, struct iattr *attr);
>  static int btrfs_truncate(struct inode *inode, bool skip_writeback);
>  static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
> @@ -5793,10 +5782,6 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
>  	return d_splice_alias(inode, dentry);
>  }
>  
> -unsigned char btrfs_filetype_table[] = {
> -	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
> -};
> -
>  /*
>   * All this infrastructure exists because dir_emit can fault, and we are holding
>   * the tree lock when doing readdir.  For now just allocate a buffer and copy
> @@ -5935,7 +5920,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
>  		name_ptr = (char *)(entry + 1);
>  		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
>  				   name_len);
> -		put_unaligned(btrfs_filetype_table[btrfs_dir_type(leaf, di)],
> +		put_unaligned(fs_ftype_to_dtype(btrfs_dir_type(leaf, di)),
>  				&entry->type);
>  		btrfs_dir_item_key_to_cpu(leaf, di, &location);
>  		put_unaligned(location.objectid, &entry->ino);
> @@ -6340,7 +6325,20 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  
>  static inline u8 btrfs_inode_type(struct inode *inode)
>  {
> -	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
> +	/*
> +	 * compile-time asserts that generic FT_x types still match
> +	 * BTRFS_FT_x types
> +	 */
> +	BUILD_BUG_ON(BTRFS_FT_UNKNOWN != FT_UNKNOWN);
> +	BUILD_BUG_ON(BTRFS_FT_REG_FILE != FT_REG_FILE);
> +	BUILD_BUG_ON(BTRFS_FT_DIR != FT_DIR);
> +	BUILD_BUG_ON(BTRFS_FT_CHRDEV != FT_CHRDEV);
> +	BUILD_BUG_ON(BTRFS_FT_BLKDEV != FT_BLKDEV);
> +	BUILD_BUG_ON(BTRFS_FT_FIFO != FT_FIFO);
> +	BUILD_BUG_ON(BTRFS_FT_SOCK != FT_SOCK);
> +	BUILD_BUG_ON(BTRFS_FT_SYMLINK != FT_SYMLINK);
> +
> +	return fs_umode_to_ftype(inode->i_mode);
>  }
>  
>  /*
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> index aff1356c2bb8..4126ed7ee89a 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -307,6 +307,8 @@
>   *
>   * Used by:
>   * struct btrfs_dir_item.type
> + *
> + * Values 0..7 must match common file type values in fs_types.h.
>   */
>  #define BTRFS_FT_UNKNOWN	0
>  #define BTRFS_FT_REG_FILE	1
> -- 
> 2.19.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
