Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54459 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750789AbcKNBWd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 20:22:33 -0500
Subject: Re: [PATCH 3/6] btrfs-progs: add OPEN_CTREE_INVALIDATE_FST flag
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1479064970.git.osandov@fb.com>
 <b22be9b08513c06ad7a091ea502aaa31ee03ca34.1479064970.git.osandov@fb.com>
CC: <kernel-team@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <0daf0321-5d0f-5820-2f11-05e69cfe471f@cn.fujitsu.com>
Date: Mon, 14 Nov 2016 09:22:22 +0800
MIME-Version: 1.0
In-Reply-To: <b22be9b08513c06ad7a091ea502aaa31ee03ca34.1479064970.git.osandov@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/14/2016 03:35 AM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> If this flag is passed to open_ctree(), we'll clear the
> FREE_SPACE_TREE_VALID compat_ro bit. The kernel will then reconstruct
> the free space tree the next time the filesystem is mounted.

This feature is really helpful.

Especially for users reporting failed to mount v2 space_cache fs.

Despite a small nit commented below, feel free to add my reviewed by tag.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  chunk-recover.c |  2 +-
>  disk-io.c       | 28 ++++++++++++++++++----------
>  disk-io.h       |  8 +++++++-
>  3 files changed, 26 insertions(+), 12 deletions(-)
>
> diff --git a/chunk-recover.c b/chunk-recover.c
> index e33ee8b..e6b26ac 100644
> --- a/chunk-recover.c
> +++ b/chunk-recover.c
> @@ -1477,7 +1477,7 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
>
>  	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
>
> -	ret = btrfs_check_fs_compatibility(disk_super, 1);
> +	ret = btrfs_check_fs_compatibility(disk_super, OPEN_CTREE_WRITES);
>  	if (ret)
>  		goto out_devices;
>
> diff --git a/disk-io.c b/disk-io.c
> index a576300..a55fcc1 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -904,7 +904,7 @@ free_all:
>  	return NULL;
>  }
>
> -int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable)
> +int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, unsigned flags)

IIRC kernel checkpatch will warn on single "unsigned", as it's 
recommended to use "unsigned int".

Thanks,
Qu

>  {
>  	u64 features;
>
> @@ -923,13 +923,22 @@ int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable)
>  		btrfs_set_super_incompat_flags(sb, features);
>  	}
>
> -	features = btrfs_super_compat_ro_flags(sb) &
> -		~BTRFS_FEATURE_COMPAT_RO_SUPP;
> -	if (writable && features) {
> -		printk("couldn't open RDWR because of unsupported "
> -		       "option features (%Lx).\n",
> -		       (unsigned long long)features);
> -		return -ENOTSUP;
> +	features = btrfs_super_compat_ro_flags(sb);
> +	if (flags & OPEN_CTREE_WRITES) {
> +		if (flags & OPEN_CTREE_INVALIDATE_FST) {
> +			/* Clear the FREE_SPACE_TREE_VALID bit on disk... */
> +			features &= ~BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID;
> +			btrfs_set_super_compat_ro_flags(sb, features);
> +			/* ... and ignore the free space tree bit. */
> +			features &= ~BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE;
> +		}
> +		if (features & ~BTRFS_FEATURE_COMPAT_RO_SUPP) {
> +			printk("couldn't open RDWR because of unsupported "
> +			       "option features (%Lx).\n",
> +			       (unsigned long long)features);
> +			return -ENOTSUP;
> +		}
> +
>  	}
>  	return 0;
>  }
> @@ -1320,8 +1329,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>
>  	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
>
> -	ret = btrfs_check_fs_compatibility(fs_info->super_copy,
> -					   flags & OPEN_CTREE_WRITES);
> +	ret = btrfs_check_fs_compatibility(fs_info->super_copy, flags);
>  	if (ret)
>  		goto out_devices;
>
> diff --git a/disk-io.h b/disk-io.h
> index 8ab36aa..5d4b281 100644
> --- a/disk-io.h
> +++ b/disk-io.h
> @@ -74,6 +74,12 @@ enum btrfs_open_ctree_flags {
>
>  	/* Allow to open a partially created filesystem */
>  	OPEN_CTREE_FS_PARTIAL = (1U << 12),
> +
> +	/*
> +	 * Invalidate the free space tree (i.e., clear the FREE_SPACE_TREE_VALID
> +	 * compat_ro bit).
> +	 */
> +	OPEN_CTREE_INVALIDATE_FST = (1U << 13),
>  };
>
>  /*
> @@ -128,7 +134,7 @@ int clean_tree_block(struct btrfs_trans_handle *trans,
>
>  void btrfs_free_fs_info(struct btrfs_fs_info *fs_info);
>  struct btrfs_fs_info *btrfs_new_fs_info(int writable, u64 sb_bytenr);
> -int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, int writable);
> +int btrfs_check_fs_compatibility(struct btrfs_super_block *sb, unsigned flags);
>  int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
>  			  unsigned flags);
>  void btrfs_release_all_roots(struct btrfs_fs_info *fs_info);
>


