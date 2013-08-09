Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:21529 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S967071Ab3HIFqZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 01:46:25 -0400
Message-ID: <5204826C.3060902@cn.fujitsu.com>
Date: Fri, 09 Aug 2013 13:47:24 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: set default max_inline to 8KiB instead of 8MiB
References: <1375998348-20639-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1375998348-20639-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 8 Aug 2013 22:45:48 +0100, Filipe David Borba Manana wrote:
> 8MiB is way too large and likely set by mistake. This is not
> a significant issue as in practice the max amount of data
> added to an inline extent is also limited by the page cache
> and btree leaf sizes.

I don't think 8KB is a reasonable value of the default max inline size
because it makes no sense on the machine whose page size is 4KB.

I think 4KB is a reasonable value, because we may mount the fs on
the machines with the different page size in the future, in order to
avoid the compatible problem, we should use the min page size as
the max inline size.

Thanks
Miao

> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/disk-io.c |    2 +-
>  fs/btrfs/disk-io.h |    2 ++
>  fs/btrfs/super.c   |    2 +-
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5de9ad7..aff37bd 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2189,7 +2189,7 @@ int open_ctree(struct super_block *sb,
>  	atomic_set(&fs_info->defrag_running, 0);
>  	atomic64_set(&fs_info->tree_mod_seq, 0);
>  	fs_info->sb = sb;
> -	fs_info->max_inline = 8192 * 1024;
> +	fs_info->max_inline = BTRFS_DEFAULT_MAX_INLINE;
>  	fs_info->metadata_ratio = 0;
>  	fs_info->defrag_inodes = RB_ROOT;
>  	fs_info->free_chunk_space = 0;
> diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
> index b71acd6e..e76c1a2 100644
> --- a/fs/btrfs/disk-io.h
> +++ b/fs/btrfs/disk-io.h
> @@ -25,6 +25,8 @@
>  #define BTRFS_SUPER_MIRROR_MAX	 3
>  #define BTRFS_SUPER_MIRROR_SHIFT 12
>  
> +#define BTRFS_DEFAULT_MAX_INLINE 8192
> +
>  enum {
>  	BTRFS_WQ_ENDIO_DATA = 0,
>  	BTRFS_WQ_ENDIO_METADATA = 1,
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 1967903..7359a9e 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -941,7 +941,7 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
>  		seq_puts(seq, ",nodatacow");
>  	if (btrfs_test_opt(root, NOBARRIER))
>  		seq_puts(seq, ",nobarrier");
> -	if (info->max_inline != 8192 * 1024)
> +	if (info->max_inline != BTRFS_DEFAULT_MAX_INLINE)
>  		seq_printf(seq, ",max_inline=%llu",
>  			   (unsigned long long)info->max_inline);
>  	if (info->alloc_start != 0)
> 

