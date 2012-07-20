Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:39866 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab2GTRj5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 13:39:57 -0400
Date: Fri, 20 Jul 2012 13:39:54 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: Check INCOMPAT flags on remount with lzo
 compression
Message-ID: <20120720173954.GD2118@localhost.localdomain>
References: <1342805781-12162-1-git-send-email-mitch.harder@sabayonlinux.org>
 <1342805781-12162-2-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1342805781-12162-2-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2012 at 11:36:20AM -0600, Mitch Harder wrote:
> In support of the recently added capability to remount with lzo
> compression, check the compression INCOMPAT flags when remounting
> with lzo compression, and set the flags if necessary.
> 
> Signed-off-by: Mitch Harder <mitch.harder@sabayonlinux.org>
> ---
>  fs/btrfs/ctree.h |    1 +
>  fs/btrfs/super.c |   21 ++++++++++++++++++++-
>  2 files changed, 21 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index a0ee2f8..8bee032 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3094,6 +3094,7 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
>  
>  /* super.c */
>  int btrfs_parse_options(struct btrfs_root *root, char *options);
> +void btrfs_chk_lzo_incompat(struct btrfs_root *root);
>  int btrfs_sync_fs(struct super_block *sb, int wait);
>  void btrfs_printk(struct btrfs_fs_info *fs_info, const char *fmt, ...);
>  void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 26da344..4398fd2 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -401,11 +401,13 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  				compress_type = "lzo";
>  				info->compress_type = BTRFS_COMPRESS_LZO;
>  				btrfs_set_opt(info->mount_opt, COMPRESS);
> +				btrfs_chk_lzo_incompat(root);
>  			} else if (strncmp(args[0].from, "no", 2) == 0) {
>  				compress_type = "no";
>  				info->compress_type = BTRFS_COMPRESS_NONE;
>  				btrfs_clear_opt(info->mount_opt, COMPRESS);
> -				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
> +				btrfs_clear_opt(info->mount_opt,
> +						FORCE_COMPRESS);

Please don't include format changes that aren't related to the patch, I stared
at this for 5 seconds too long trying to figure out what you changed.  Thanks,

Josef
