Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C58C004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 10:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 971E62064A
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 10:11:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 971E62064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbeJXSjG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 14:39:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:49416 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726301AbeJXSjG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 14:39:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39752AEAF;
        Wed, 24 Oct 2018 10:11:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6D404DABAA; Wed, 24 Oct 2018 12:11:28 +0200 (CEST)
Date:   Wed, 24 Oct 2018 12:11:28 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     clm@fb.com, linux-kernel@vger.kernel.org, amir73il@gmail.com,
        viro@zeniv.linux.org.uk, jbacik@fb.com, dsterba@suse.com,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH v2 10/10] btrfs: use common file type conversion
Message-ID: <20181024101128.GS16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Phillip Potter <phil@philpotter.co.uk>,
        clm@fb.com, linux-kernel@vger.kernel.org, amir73il@gmail.com,
        viro@zeniv.linux.org.uk, jbacik@fb.com, dsterba@suse.com,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20181023201952.GA15676@pathfinder>
 <20181023211728.GA16584@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181023211728.GA16584@pathfinder>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 23, 2018 at 10:17:28PM +0100, Phillip Potter wrote:
> Deduplicate the btrfs file type conversion implementation.

The per-filesystem changelogs need a brief explanation why this is done,
like "Filesystems that use the same filetypes as defined by POSIX do not
need to define their own versions and use the common defines in
file_type.h", rephrase at you like.

> Original patch by Amir Goldstein.
> 
> v2:
> - Rebased against Linux 4.19 by Phillip Potter
> - Compile-time checks added by Phillip Potter to make
>   sure the BTRFS_FT_x enum values stay same as FT_x values
> 
> v1:
> - Initial implementation
> 
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> ---
>  fs/btrfs/btrfs_inode.h          |  2 --
>  fs/btrfs/delayed-inode.c        |  2 +-
>  fs/btrfs/inode.c                | 35 +++++++++++++++++----------------
>  include/uapi/linux/btrfs_tree.h |  2 ++
>  4 files changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 1343ac57b438..c7c6db6b4a35 100644
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
> index f51b509f2d9b..c1da34e3a775 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1691,7 +1691,7 @@ int btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
>  		name = (char *)(di + 1);
>  		name_len = btrfs_stack_dir_name_len(di);
>  
> -		d_type = btrfs_filetype_table[di->type];
> +		d_type = fs_dtype(di->type);
>  		btrfs_disk_key_to_cpu(&location, &di->location);
>  
>  		over = !dir_emit(ctx, name, name_len,
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3ea5339603cf..4cbdcba4799a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -73,17 +73,6 @@ struct kmem_cache *btrfs_trans_handle_cachep;
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
> @@ -5803,10 +5792,6 @@ static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
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
> @@ -5945,7 +5930,23 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
>  		name_ptr = (char *)(entry + 1);
>  		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
>  				   name_len);
> -		put_unaligned(btrfs_filetype_table[btrfs_dir_type(leaf, di)],
> +
> +		/*
> +		 * compile-time asserts that generic FT_x types
> +		 * still match BTRFS_FT_x types - no need to list
> +		 * in other functions as well as build will
> +		 * fail either way
> +		 */

Please format comments to 80 columns.

> +		BUILD_BUG_ON(BTRFS_FT_UNKNOWN != FT_UNKNOWN);
> +		BUILD_BUG_ON(BTRFS_FT_REG_FILE != FT_REG_FILE);
> +		BUILD_BUG_ON(BTRFS_FT_DIR != FT_DIR);
> +		BUILD_BUG_ON(BTRFS_FT_CHRDEV != FT_CHRDEV);
> +		BUILD_BUG_ON(BTRFS_FT_BLKDEV != FT_BLKDEV);
> +		BUILD_BUG_ON(BTRFS_FT_FIFO != FT_FIFO);
> +		BUILD_BUG_ON(BTRFS_FT_SOCK != FT_SOCK);
> +		BUILD_BUG_ON(BTRFS_FT_SYMLINK != FT_SYMLINK);
> +
> +		put_unaligned(fs_dtype(btrfs_dir_type(leaf, di)),
>  				&entry->type);
>  		btrfs_dir_item_key_to_cpu(leaf, di, &location);
>  		put_unaligned(location.objectid, &entry->ino);
> @@ -6350,7 +6351,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>  
>  static inline u8 btrfs_inode_type(struct inode *inode)
>  {
> -	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
> +	return fs_umode_to_ftype(inode->i_mode);
>  }
>  
>  /*
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> index aff1356c2bb8..5747cffa09fa 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -307,6 +307,8 @@
>   *
>   * Used by:
>   * struct btrfs_dir_item.type
> + *
> + * Values 0..7 should match common file type values in file_type.h.

I think it's rather 'must' than 'should' as there are the compile-time
checks.
