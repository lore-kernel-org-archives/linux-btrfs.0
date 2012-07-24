Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:55607 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab2GXMLy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jul 2012 08:11:54 -0400
Date: Tue, 24 Jul 2012 14:11:50 +0200
From: David Sterba <dave@jikos.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/1] Btrfs: Check INCOMPAT flags on remount and add
 helper function
Message-ID: <20120724121150.GG17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1342822601-18340-1-git-send-email-mitch.harder@sabayonlinux.org>
 <1342822601-18340-2-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1342822601-18340-2-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need a helper for every incompatibility bit, let's do it in a
more generic way as suggested below [modulo syntax errors]:

On Fri, Jul 20, 2012 at 05:16:41PM -0500, Mitch Harder wrote:
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3103,6 +3103,19 @@ void __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
>  			       struct btrfs_root *root, const char *function,
>  			       unsigned int line, int errno);
>  
> +static inline void btrfs_chk_lzo_incompat(struct btrfs_root *root)
> +{

btrfs_set_fs_incompat(struct btrfs_fs_info *fs_info, u64 flag) {

> +	struct btrfs_super_block *disk_super;
> +	u64 features;
> +
> +	disk_super = root->fs_info->super_copy;

   	disk_super = fs_info->super_copy;

> +	features = btrfs_super_incompat_flags(disk_super);
> +	if (!(features & BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO)) {
> +		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;

	if (!(features & flag)) {
		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;

> +		btrfs_set_super_incompat_flags(disk_super, features);
> +	}
> +}
> +
>  #define btrfs_abort_transaction(trans, root, errno)		\
>  do {								\
>  	__btrfs_abort_transaction(trans, root, __func__,	\
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 17facea..d5fd69e 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1042,11 +1042,9 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  		      u64 newer_than, unsigned long max_to_defrag)
>  {
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	struct btrfs_super_block *disk_super;
>  	struct file_ra_state *ra = NULL;
>  	unsigned long last_index;
>  	u64 isize = i_size_read(inode);
> -	u64 features;
>  	u64 last_len = 0;
>  	u64 skip = 0;
>  	u64 defrag_end = 0;
> @@ -1233,11 +1231,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  		mutex_unlock(&inode->i_mutex);
>  	}
>  
> -	disk_super = root->fs_info->super_copy;
> -	features = btrfs_super_incompat_flags(disk_super);
>  	if (range->compress_type == BTRFS_COMPRESS_LZO) {
> -		features |= BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO;
> -		btrfs_set_super_incompat_flags(disk_super, features);
> +		btrfs_chk_lzo_incompat(root);

		btrfs_set_fs_incompat(fs_info, BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO);

>  	}
>  
>  	ret = defrag_count;
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 26da344..32c2bd9 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -401,6 +401,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  				compress_type = "lzo";
>  				info->compress_type = BTRFS_COMPRESS_LZO;
>  				btrfs_set_opt(info->mount_opt, COMPRESS);
> +				btrfs_chk_lzo_incompat(root);

				btrfs_set_fs_incompat(fs_info, BTRFS_FEATURE_INCOMPAT_COMPRESS_LZO);

>  			} else if (strncmp(args[0].from, "no", 2) == 0) {
>  				compress_type = "no";
>  				info->compress_type = BTRFS_COMPRESS_NONE;
