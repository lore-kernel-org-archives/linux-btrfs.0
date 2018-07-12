Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:34593 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387690AbeGMAAr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 20:00:47 -0400
Message-ID: <6e333f11e847e8e7dbb9a169a56e1169b52dffe3.camel@scientia.net>
Subject: Re: [PATCH v2 1/2] btrfs-progs: Rename OPEN_CTREE_FS_PARTIAL to
 OPEN_CTREE_TEMPORARY_SUPER
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Date: Fri, 13 Jul 2018 01:48:50 +0200
In-Reply-To: <20180411072936.12915-1-wqu@suse.com>
References: <20180411072936.12915-1-wqu@suse.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey.

Better late than never ;-)

Just to confirm: At least since 4.16.1, I could btrfs-restore from the
broken fs image again (that I've described in "spurious full btrfs
corruption" from around mid March).

So the regression in btrfsprogs has in fact been fixed by these
patches, it seems.


Thanks,
Chris.

On Wed, 2018-04-11 at 15:29 +0800, Qu Wenruo wrote:
> The old flag OPEN_CTREE_FS_PARTIAL is in fact quite easy to be
> confused
> with OPEN_CTREE_PARTIAL, which allow btrfs-progs to open damaged
> filesystem (like corrupted extent/csum tree).
> 
> However OPEN_CTREE_FS_PARTIAL, unlike its name, is just allowing
> btrfs-progs to open fs with temporary superblocks (which only has 6
> basic trees on SINGLE meta/sys chunks).
> 
> The usage of FS_PARTIAL is really confusing here.
> 
> So rename OPEN_CTREE_FS_PARTIAL to OPEN_CTREE_TEMPORARY_SUPER, and
> add
> extra comment for its behavior.
> Also rename BTRFS_MAGIC_PARTIAL to BTRFS_MAGIC_TEMPORARY to keep the
> naming consistent.
> 
> And with above comment, the usage of FS_PARTIAL in dump-tree is
> obviously incorrect, fix it.
> 
> Fixes: 8698a2b9ba89 ("btrfs-progs: Allow inspect dump-tree to show
> specified tree block even some tree roots are corrupted")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> changelog:
> v2:
>   New patch
> ---
>  cmds-inspect-dump-tree.c |  2 +-
>  convert/main.c           |  4 ++--
>  ctree.h                  |  8 +++++---
>  disk-io.c                | 12 ++++++------
>  disk-io.h                | 10 +++++++---
>  mkfs/main.c              |  2 +-
>  6 files changed, 22 insertions(+), 16 deletions(-)
> 
> diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
> index 0802b31e9596..e6510851e8f4 100644
> --- a/cmds-inspect-dump-tree.c
> +++ b/cmds-inspect-dump-tree.c
> @@ -220,7 +220,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>  	int uuid_tree_only = 0;
>  	int roots_only = 0;
>  	int root_backups = 0;
> -	unsigned open_ctree_flags = OPEN_CTREE_FS_PARTIAL;
> +	unsigned open_ctree_flags = OPEN_CTREE_PARTIAL;
>  	u64 block_only = 0;
>  	struct btrfs_root *tree_root_scan;
>  	u64 tree_id = 0;
> diff --git a/convert/main.c b/convert/main.c
> index 6bdfab40d0b0..80f3bed84c84 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -1140,7 +1140,7 @@ static int do_convert(const char *devname, u32
> convert_flags, u32 nodesize,
>  	}
>  
>  	root = open_ctree_fd(fd, devname, mkfs_cfg.super_bytenr,
> -			     OPEN_CTREE_WRITES |
> OPEN_CTREE_FS_PARTIAL);
> +			     OPEN_CTREE_WRITES |
> OPEN_CTREE_TEMPORARY_SUPER);
>  	if (!root) {
>  		error("unable to open ctree");
>  		goto fail;
> @@ -1230,7 +1230,7 @@ static int do_convert(const char *devname, u32
> convert_flags, u32 nodesize,
>  	}
>  
>  	root = open_ctree_fd(fd, devname, 0,
> -			OPEN_CTREE_WRITES | OPEN_CTREE_FS_PARTIAL);
> +			     OPEN_CTREE_WRITES |
> OPEN_CTREE_TEMPORARY_SUPER);
>  	if (!root) {
>  		error("unable to open ctree for finalization");
>  		goto fail;
> diff --git a/ctree.h b/ctree.h
> index fa861ba0b4c3..80d4e59a66ce 100644
> --- a/ctree.h
> +++ b/ctree.h
> @@ -45,10 +45,12 @@ struct btrfs_free_space_ctl;
>  #define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null
> */
>  
>  /*
> - * Fake signature for an unfinalized filesystem, structures might be
> partially
> - * created or missing.
> + * Fake signature for an unfinalized filesystem, which only has
> barebone tree
> + * structures (normally 6 near empty trees, on SINGLE meta/sys
> temporary chunks)
> + *
> + * ascii !BHRfS_M, no null
>   */
> -#define BTRFS_MAGIC_PARTIAL 0x4D5F536652484221ULL /* ascii !BHRfS_M,
> no null */
> +#define BTRFS_MAGIC_TEMPORARY 0x4D5F536652484221ULL
>  
>  #define BTRFS_MAX_MIRRORS 3
>  
> diff --git a/disk-io.c b/disk-io.c
> index 58eae709e0e8..9e8b1e9d295c 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1117,14 +1117,14 @@ static struct btrfs_fs_info
> *__open_ctree_fd(int fp, const char *path,
>  		fs_info->ignore_chunk_tree_error = 1;
>  
>  	if ((flags & OPEN_CTREE_RECOVER_SUPER)
> -	     && (flags & OPEN_CTREE_FS_PARTIAL)) {
> +	     && (flags & OPEN_CTREE_TEMPORARY_SUPER)) {
>  		fprintf(stderr,
> -		    "cannot open a partially created filesystem for
> recovery");
> +	"cannot open a filesystem with temporary super block for
> recovery");
>  		goto out;
>  	}
>  
> -	if (flags & OPEN_CTREE_FS_PARTIAL)
> -		sbflags = SBREAD_PARTIAL;
> +	if (flags & OPEN_CTREE_TEMPORARY_SUPER)
> +		sbflags = SBREAD_TEMPORARY;
>  
>  	ret = btrfs_scan_fs_devices(fp, path, &fs_devices,
> sb_bytenr, sbflags,
>  			(flags & OPEN_CTREE_NO_DEVICES));
> @@ -1285,8 +1285,8 @@ static int check_super(struct btrfs_super_block
> *sb, unsigned sbflags)
>  	int csum_size;
>  
>  	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
> -		if (btrfs_super_magic(sb) == BTRFS_MAGIC_PARTIAL) {
> -			if (!(sbflags & SBREAD_PARTIAL)) {
> +		if (btrfs_super_magic(sb) == BTRFS_MAGIC_TEMPORARY)
> {
> +			if (!(sbflags & SBREAD_TEMPORARY)) {
>  				error("superblock magic doesn't
> match");
>  				return -EIO;
>  			}
> diff --git a/disk-io.h b/disk-io.h
> index f6a422f2a773..c4496155771f 100644
> --- a/disk-io.h
> +++ b/disk-io.h
> @@ -73,8 +73,12 @@ enum btrfs_open_ctree_flags {
>  	 */
>  	OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR = (1U << 11),
>  
> -	/* Allow to open a partially created filesystem */
> -	OPEN_CTREE_FS_PARTIAL = (1U << 12),
> +	/*
> +	 * Allow to open fs with temporary superblock
> (BTRFS_MAGIC_PARTIAL),
> +	 * such fs contains very basic tree layout, just able to be
> opened.
> +	 * Such temporary super is used for mkfs or convert.
> +	 */
> +	OPEN_CTREE_TEMPORARY_SUPER = (1U << 12),
>  
>  	/*
>  	 * Invalidate the free space tree (i.e., clear the
> FREE_SPACE_TREE_VALID
> @@ -95,7 +99,7 @@ enum btrfs_read_sb_flags {
>  	 * Read superblock with the fake signature, cannot be used
> with
>  	 * SBREAD_RECOVER
>  	 */
> -	SBREAD_PARTIAL		= (1 << 1),
> +	SBREAD_TEMPORARY = (1 << 1),
>  };
>  
>  /*
> diff --git a/mkfs/main.c b/mkfs/main.c
> index b65b18ddf2f3..7ac587b77383 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -1099,7 +1099,7 @@ int main(int argc, char **argv)
>  	}
>  
>  	fs_info = open_ctree_fs_info(file, 0, 0, 0,
> -			OPEN_CTREE_WRITES | OPEN_CTREE_FS_PARTIAL);
> +			OPEN_CTREE_WRITES |
> OPEN_CTREE_TEMPORARY_SUPER);
>  	if (!fs_info) {
>  		error("open ctree failed");
>  		goto error;
