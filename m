Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18268 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750774AbdBTIHb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 03:07:31 -0500
Subject: Re: [PATCH 3/5] btrfs: export compression buffer limits in a header
To: David Sterba <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1487354456.git.dsterba@suse.com>
 <7b0a1e010fc4bf6e22dce274aa9400d942459e14.1487354456.git.dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f78cab96-d27a-5e6a-7d9b-476285eb1abe@cn.fujitsu.com>
Date: Mon, 20 Feb 2017 16:07:27 +0800
MIME-Version: 1.0
In-Reply-To: <7b0a1e010fc4bf6e22dce274aa9400d942459e14.1487354456.git.dsterba@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/18/2017 02:05 AM, David Sterba wrote:
> Move the buffer limit definitions out of compress_file_range.
>

Nice one.
No longer need to dig the codes to know the 128K limit now.

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks,
Qu
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/compression.h | 15 +++++++++++++++
>  fs/btrfs/inode.c       | 10 ----------
>  2 files changed, 15 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index e453f42b3bbf..c9d7e552cfa8 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -19,6 +19,21 @@
>  #ifndef __BTRFS_COMPRESSION_
>  #define __BTRFS_COMPRESSION_
>
> +/*
> + * We want to make sure that amount of RAM required to uncompress an extent is
> + * reasonable, so we limit the total size in ram of a compressed extent to
> + * 128k.  This is a crucial number because it also controls how easily we can
> + * spread reads across cpus for decompression.
> + *
> + * We also want to make sure the amount of IO required to do a random read is
> + * reasonably small, so we limit the size of a compressed extent to 128k.
> + */
> +
> +/* Maximum length of compressed data stored on disk */
> +#define BTRFS_MAX_COMPRESSED		(SZ_128K)
> +/* Maximum size of data before compression */
> +#define BTRFS_MAX_UNCOMPRESSED		(SZ_128K)
> +
>  void btrfs_init_compress(void);
>  void btrfs_exit_compress(void);
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 801d1b3fd9d7..bc547608ff1a 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -470,16 +470,6 @@ static noinline void compress_file_range(struct inode *inode,
>  	   (start > 0 || end + 1 < BTRFS_I(inode)->disk_i_size))
>  		goto cleanup_and_bail_uncompressed;
>
> -	/* we want to make sure that amount of ram required to uncompress
> -	 * an extent is reasonable, so we limit the total size in ram
> -	 * of a compressed extent to 128k.  This is a crucial number
> -	 * because it also controls how easily we can spread reads across
> -	 * cpus for decompression.
> -	 *
> -	 * We also want to make sure the amount of IO required to do
> -	 * a random read is reasonably small, so we limit the size of
> -	 * a compressed extent to 128k.
> -	 */
>  	total_compressed = min(total_compressed, max_uncompressed);
>  	num_bytes = ALIGN(end - start + 1, blocksize);
>  	num_bytes = max(blocksize,  num_bytes);
>


