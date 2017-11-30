Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41177 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdK3Vzg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 16:55:36 -0500
Subject: Re: [PATCH 1/4] btrfs: compression: add helper for type to string
 conversion
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1512058075.git.dsterba@suse.com>
 <a82165fb386d2abba1e7366689e3aefada14ed26.1512058075.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <4fb8aaa3-e79c-e3f1-d834-3da44bde58f9@oracle.com>
Date: Fri, 1 Dec 2017 05:55:56 +0800
MIME-Version: 1.0
In-Reply-To: <a82165fb386d2abba1e7366689e3aefada14ed26.1512058075.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/01/2017 12:09 AM, David Sterba wrote:
> There are several places opencoding this conversion, add a helper now
> that we have 3 compression algorithms.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/compression.c | 15 +++++++++++++++
>   fs/btrfs/compression.h |  2 ++
>   2 files changed, 17 insertions(+)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 5982c8a71f02..a1a5958ff328 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -45,6 +45,21 @@
>   #include "extent_io.h"
>   #include "extent_map.h"
>   
> +static const char* const btrfs_compress_types[] = { "", "lzo", "zlib", "zstd" };

This is wrong order.

compression.h:	BTRFS_COMPRESS_NONE  = 0,
compression.h:	BTRFS_COMPRESS_ZLIB  = 1,
compression.h:	BTRFS_COMPRESS_LZO   = 2,
compression.h:	BTRFS_COMPRESS_ZSTD  = 3,
compression.h:	BTRFS_COMPRESS_TYPES = 3,

Thanks, Anand


> +const char* btrfs_compress_type2str(enum btrfs_compression_type type)
> +{
> +	switch (type) {
> +	case BTRFS_COMPRESS_LZO:
> +	case BTRFS_COMPRESS_ZLIB:
> +	case BTRFS_COMPRESS_ZSTD:
> +	case BTRFS_COMPRESS_NONE:
> +		return btrfs_compress_types[type];
> +	}
> +
> +	return NULL;
> +}
> +
>   static int btrfs_decompress_bio(struct compressed_bio *cb);
>   
>   static inline int compressed_bio_size(struct btrfs_fs_info *fs_info,
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index 6b692903a23c..677fa4aa0bd7 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -137,6 +137,8 @@ extern const struct btrfs_compress_op btrfs_zlib_compress;
>   extern const struct btrfs_compress_op btrfs_lzo_compress;
>   extern const struct btrfs_compress_op btrfs_zstd_compress;
>   
> +const char* btrfs_compress_type2str(enum btrfs_compression_type type);
> +
>   int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end);
>   
>   #endif
> 
